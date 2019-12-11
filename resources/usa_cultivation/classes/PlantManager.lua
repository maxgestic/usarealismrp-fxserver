PlantManager = {}

PlantManager.WATER_MAX = 100.0
PlantManager.FOOD_MAX = 100.0
PlantManager.WATER_REPLENISH_AMOUNT = 50.0
PlantManager.FOOD_REPLENISH_AMOUNT = 50.0

PlantManager.newPlant = function(char, type, coords, cb)
    local product = PRODUCTS[type]
    local model = product.stages[1].objectModels[math.random(#(product.stages[1].objectModels))] -- random object model from first stage
    local newPlant = {
        type = type,
        owner = {
            id = char.get("_id"),
            steam = GetPlayerIdentifiers(char.get("source"))[1],
            name = char.get("name")
        },
        coords = coords,
        plantedAt = os.time(),
        stage = PRODUCTS[type].stages[1],
        waterLevel = {
            val = 100.0,
            asString = "~g~Not Thirsty~w~"
        },
        foodLevel = {
            val = 100.0,
            asString = "~g~Full~w~"
        }
    }
    TriggerEvent("es:exposeDBFunctions", function(db)
        db.createDocument("cultivation", newPlant, function(docID)
            print("plant created in DB!")
            newPlant._id = docID
            table.insert(PLANTED, newPlant)
            cb(newPlant)
        end)
    end)
end

PlantManager.getNumberOfHoursSincePlanted = function(plant) 
    return exports.globals:GetHoursFromTime(plant.plantedAt)
end

PlantManager.tick = function(plant)
    local didGrowthUpdate = false
    local didSustenanceUpdate = false
    plant, didSustenanceUpdate = PlantManager.sustanenceTick(plant)
    plant, didGrowthUpdate = PlantManager.stageTick(plant)
    return plant, didGrowthUpdate, didSustenanceUpdate
end

PlantManager.stageTick = function(plant)
    if plant.stage.name ~= "dead" then
        local hoursSincePlanted = PlantManager.getNumberOfHoursSincePlanted(plant)
        for j = 1, #PRODUCTS[plant.type].stages do
            local stage = PRODUCTS[plant.type].stages[j]
            if hoursSincePlanted >= stage.lengthInHours then
                local isAtThisStageAlready = plant.stage.name == PRODUCTS[plant.type].stages[j+1].name
                if j + 1 <= #(PRODUCTS[plant.type].stages) and not isAtThisStageAlready then
                    plant.stage = PRODUCTS[plant.type].stages[j+1]
                    return plant, true
                end
            end
        end
    end
    return plant, false
end

PlantManager.sustanenceTick = function(plant)
    local didUpdate = false
    if plant.stage.name ~= "dead" then
        -- water / food values --
        plant.waterLevel.val = plant.waterLevel.val - WATER_DECREMENT_VAL
        plant.foodLevel.val = plant.foodLevel.val - FOOD_DECREMENT_VAL
        -- water string --
        if plant.waterLevel.val <= HIGH_THRESHOLD and plant.waterLevel.asString ~= "~r~Very Thirsty~w~" then
            plant.waterLevel.asString = "~r~Very Thirsty~w~"
            didUpdate = true
        elseif plant.waterLevel.val <= MED_THRESHOLD and plant.waterLevel.asString ~= "~y~Thirsty~w~" then
            plant.waterLevel.asString = "~y~Thirsty~w~"
            didUpdate = true
        elseif plant.waterLevel.val <= LOW_THRESHOLD and plant.waterLevel.asString ~= "~g~A little Thirsty~w~" then
            plant.waterLevel.asString = "~g~A little Thirsty~w~"
            didUpdate = true
        end
        -- food string --
        if plant.foodLevel.val <= LOW_THRESHOLD and plant.foodLevel.asString ~= "~g~Slighty Hungry~w~" then
            plant.foodLevel.asString = "~g~Slighty Hungry~w~"
            didUpdate = true
        elseif plant.foodLevel.val <= MED_THRESHOLD and plant.foodLevel.asString ~= "~y~Hungry~w~" then
            plant.foodLevel.asString = "~y~Hungry~w~"
            didUpdate = true
        elseif plant.foodLevel.val <= HIGH_THRESHOLD and plant.foodLevel.asString ~= "~r~Needs Food~w~" then
            plant.foodLevel.asString = "~r~Needs Food~w~"
            didUpdate = true
        end
        -- check for death --
        if plant.foodLevel.val < DIE_THRESHOLD or plant.waterLevel.val < DIE_THRESHOLD and plant.stage.name ~= "dead" then
            plant.stage = { name = "dead", objectModels = {} }
            didUpdate = true
        end
    end
    return plant, didUpdate
end

PlantManager.waterPlant = function(i)
    local newVal = PLANTED[i].waterLevel.val + PlantManager.WATER_REPLENISH_AMOUNT
    if newVal <= PlantManager.WATER_MAX then
        PLANTED[i].waterLevel.val = newVal
    else
        PLANTED[i].waterLevel.val = PlantManager.WATER_MAX
    end
    PlantManager.updateWaterAndFoodStrings(i)
end

PlantManager.feedPlant = function(i)
    local newVal = PLANTED[i].foodLevel.val + PlantManager.FOOD_REPLENISH_AMOUNT
    if newVal <= PlantManager.FOOD_MAX then
        PLANTED[i].foodLevel.val = newVal
    else
        PLANTED[i].foodLevel.val = PlantManager.FOOD_MAX
    end
    PlantManager.updateWaterAndFoodStrings(i)
end

PlantManager.harvestPlant = function(i)
    local plant = PLANTED[i]
    local rewardQuantity = math.random(PRODUCTS[plant.type].rewardQuantity.min, PRODUCTS[plant.type].rewardQuantity.max)
    local rewardItem = PRODUCTS[plant.type].harvestItem
    rewardItem.quantity = rewardQuantity
    rewardItem.coords = plant.coords
    return rewardItem
end

PlantManager.updateWaterAndFoodStrings = function(i)
    -- water string --
    if PLANTED[i].waterLevel.val <= HIGH_THRESHOLD and PLANTED[i].waterLevel.asString ~= "~r~Very Thirsty~w~" then
        PLANTED[i].waterLevel.asString = "~r~Very Thirsty~w~"
    elseif PLANTED[i].waterLevel.val <= MED_THRESHOLD and PLANTED[i].waterLevel.asString ~= "~y~Thirsty~w~" then
        PLANTED[i].waterLevel.asString = "~y~Thirsty~w~"
    elseif PLANTED[i].waterLevel.val <= LOW_THRESHOLD and PLANTED[i].waterLevel.asString ~= "~g~A little Thirsty~w~" then
        PLANTED[i].waterLevel.asString = "~g~A little Thirsty~w~"
    elseif PLANTED[i].waterLevel.asString ~= "~g~Not Thirsty~w~" then
        PLANTED[i].waterLevel.asString = "~g~Not Thirsty~w~"
    end
    -- food string --
    if PLANTED[i].foodLevel.val <= LOW_THRESHOLD and PLANTED[i].foodLevel.asString ~= "~g~Slighty Hungry~w~" then
        PLANTED[i].foodLevel.asString = "~g~Slighty Hungry~w~"
    elseif PLANTED[i].foodLevel.val <= MED_THRESHOLD and PLANTED[i].foodLevel.asString ~= "~y~Hungry~w~" then
        PLANTED[i].foodLevel.asString = "~y~Hungry~w~"
    elseif PLANTED[i].foodLevel.val <= HIGH_THRESHOLD and PLANTED[i].foodLevel.asString ~= "~r~Needs Food~w~" then
        PLANTED[i].foodLevel.asString = "~r~Needs Food~w~"
    elseif PLANTED[i].foodLevel.asString ~= "~g~Not Hungry~w~" then
        PLANTED[i].foodLevel.asString = "~g~Not Hungry~w~"
    end
    -- check for death --
    if PLANTED[i].foodLevel.val < DIE_THRESHOLD or PLANTED[i].waterLevel.val < DIE_THRESHOLD and PLANTED[i].stage.name ~= "dead" then
        PLANTED[i].stage = { name = "dead", objectModels = {} }
    end
end

PlantManager.removePlant = function(i)
    if PLANTED[i] then
        TriggerEvent("es:exposeDBFunctions", function(db)
            db.deleteDocument("cultivation", PLANTED[i]._id, function(ok)
                table.remove(PLANTED, i)
            end)
        end)
    end
end
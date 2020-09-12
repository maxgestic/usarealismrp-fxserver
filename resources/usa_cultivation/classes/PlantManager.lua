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
            PLANTED[docID] = newPlant
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
    if not plant.isDead then
        local hoursSincePlanted = PlantManager.getNumberOfHoursSincePlanted(plant)
        for j = #PRODUCTS[plant.type].stages, 1, -1 do
            local stage = PRODUCTS[plant.type].stages[j]
            if hoursSincePlanted >= stage.lengthInHours then
                local isAtThisStageAlready = plant.stage.name == stage.name
                if not isAtThisStageAlready then
                    plant.stage = stage
                    return plant, true
                else
                    return plant, false
                end
            end
        end
    end
    return plant, false
end

PlantManager.sustanenceTick = function(plant)
    local didUpdate = false
    if not plant.isDead then
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
        if plant.foodLevel.val <= LOW_THRESHOLD and plant.foodLevel.asString ~= "~g~Slightly Hungry~w~" then
            plant.foodLevel.asString = "~g~Slightly Hungry~w~"
            didUpdate = true
        elseif plant.foodLevel.val <= MED_THRESHOLD and plant.foodLevel.asString ~= "~y~Hungry~w~" then
            plant.foodLevel.asString = "~y~Hungry~w~"
            didUpdate = true
        elseif plant.foodLevel.val <= HIGH_THRESHOLD and plant.foodLevel.asString ~= "~r~Needs Food~w~" then
            plant.foodLevel.asString = "~r~Needs Food~w~"
            didUpdate = true
        end
        -- check for death --
        if plant.foodLevel.val < DIE_THRESHOLD or plant.waterLevel.val < DIE_THRESHOLD and not plant.isDead then
            plant.isDead = true
            plant.deathTimestamp = os.time()
            didUpdate = true
        end
    else
        if not plant.deathTimestamp then -- needed for plants that were _already_ dead but did not have a death timestamp
            plant.deathTimestamp = os.time()
        end
    end
    return plant, didUpdate
end

PlantManager.waterPlant = function(id)
    local newVal = PLANTED[id].waterLevel.val + PlantManager.WATER_REPLENISH_AMOUNT
    if newVal <= PlantManager.WATER_MAX then
        PLANTED[id].waterLevel.val = newVal
    else
        PLANTED[id].waterLevel.val = PlantManager.WATER_MAX
    end
    PlantManager.updateWaterAndFoodStrings(id)
end

PlantManager.feedPlant = function(id)
    local newVal = PLANTED[id].foodLevel.val + PlantManager.FOOD_REPLENISH_AMOUNT
    if newVal <= PlantManager.FOOD_MAX then
        PLANTED[id].foodLevel.val = newVal
    else
        PLANTED[id].foodLevel.val = PlantManager.FOOD_MAX
    end
    PlantManager.updateWaterAndFoodStrings(id)
end

PlantManager.harvestPlant = function(id)
    local plant = PLANTED[id]
    local rewardQuantity = math.random(PRODUCTS[plant.type].rewardQuantity.min, PRODUCTS[plant.type].rewardQuantity.max)
    local rewardItem = PRODUCTS[plant.type].harvestItem
    rewardItem.quantity = rewardQuantity
    rewardItem.coords = plant.coords
    return rewardItem
end

PlantManager.updateWaterAndFoodStrings = function(id)
    -- water string --
    if PLANTED[id].waterLevel.val <= HIGH_THRESHOLD and PLANTED[id].waterLevel.asString ~= "~r~Very Thirsty~w~" then
        PLANTED[id].waterLevel.asString = "~r~Very Thirsty~w~"
    elseif PLANTED[id].waterLevel.val <= MED_THRESHOLD and PLANTED[id].waterLevel.asString ~= "~y~Thirsty~w~" then
        PLANTED[id].waterLevel.asString = "~y~Thirsty~w~"
    elseif PLANTED[id].waterLevel.val <= LOW_THRESHOLD and PLANTED[id].waterLevel.asString ~= "~g~A little Thirsty~w~" then
        PLANTED[id].waterLevel.asString = "~g~A little Thirsty~w~"
    elseif PLANTED[id].waterLevel.asString ~= "~g~Not Thirsty~w~" then
        PLANTED[id].waterLevel.asString = "~g~Not Thirsty~w~"
    end
    -- food string --
    if PLANTED[id].foodLevel.val <= LOW_THRESHOLD and PLANTED[id].foodLevel.asString ~= "~g~Slightly Hungry~w~" then
        PLANTED[id].foodLevel.asString = "~g~Slightly Hungry~w~"
    elseif PLANTED[id].foodLevel.val <= MED_THRESHOLD and PLANTED[id].foodLevel.asString ~= "~y~Hungry~w~" then
        PLANTED[id].foodLevel.asString = "~y~Hungry~w~"
    elseif PLANTED[id].foodLevel.val <= HIGH_THRESHOLD and PLANTED[id].foodLevel.asString ~= "~r~Needs Food~w~" then
        PLANTED[id].foodLevel.asString = "~r~Needs Food~w~"
    elseif PLANTED[id].foodLevel.asString ~= "~g~Not Hungry~w~" then
        PLANTED[id].foodLevel.asString = "~g~Not Hungry~w~"
    end
    -- check for death --
    if PLANTED[id].foodLevel.val < DIE_THRESHOLD or PLANTED[id].waterLevel.val < DIE_THRESHOLD and not PLANTED[id].isDead then
        PLANTED[id].isDead = true
    end
end

PlantManager.removePlant = function(id)
    if PLANTED[id] then
        TriggerEvent("es:exposeDBFunctions", function(db)
            db.deleteDocument("cultivation", PLANTED[id]._id, function(ok)
                PLANTED[id] = nil
            end)
        end)
    end
end

PlantManager.hasBeenDeadLongEnoughToDelete = function(id)
    if PLANTED[id].isDead and PLANTED[id].deathTimestamp then
        local daysSinceDead = math.floor(exports.globals:GetHoursFromTime(PLANTED[id].deathTimestamp) / 24)
        if daysSinceDead >= DAYS_DEAD_BEFORE_DELETE then
            return true
        end
    end
    return false
end
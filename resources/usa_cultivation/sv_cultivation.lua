function loadPlants()
	PerformHttpRequest("http://127.0.0.1:5984/cultivation/_all_docs?include_docs=true", function(err, text, headers)
		local response = json.decode(text)
        if response.rows then
            print("loaded " .. #(response.rows) .. " plants")
            for i = 1, #(response.rows) do
                if not response.rows[i].doc._id:find("design") then
                    table.insert(PLANTED, response.rows[i].doc)
                end
			end
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

exports["globals"]:PerformDBCheck("usa_cultivation", "cultivation", loadPlants)

-- buy new plant --
RegisterServerEvent("cultivation:buy")
AddEventHandler("cultivation:buy", function(productName)
    if not PRODUCTS[productName] then
        print("USA_CULTIVATION: tried to buy invalid seed item: " .. productName)
        return
    end
    local product = PRODUCTS[productName]
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.get("money") >= product.cost then
        if char.canHoldItem(product.item) then
            char.giveItem(product.item)
            char.removeMoney(product.cost)
            TriggerClientEvent("usa:notify", source, "You've purchased an immature " .. productName .. " plant for $" .. exports.globals:comma_value(product.cost))
        else
            TriggerClientEvent("usa:notify", source, "Inventory full!")
        end
    else 
        TriggerClientEvent("usa:notify", source, "Not enough cash! Need $" .. exports.globals:comma_value(product.cost))
    end
end)

-- register new plant as planted --
RegisterServerEvent("cultivation:plant")
AddEventHandler("cultivation:plant", function(productName, itemName, coords)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.removeItem(itemName, 1)
    PlantManager.newPlant(char, productName, coords, function(newPlant)
        TriggerClientEvent("cultivation:clientNewPlant", -1, newPlant)
    end)
end)

RegisterServerEvent("cultivation:water")
AddEventHandler("cultivation:water", function(i)
    if not PLANTED[i].isDead then
        PlantManager.waterPlant(i)
        TriggerClientEvent("cultivation:update", -1, i, "waterLevel", PLANTED[i].waterLevel)
        TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
    else 
        TriggerClientEvent("usa:notify", source, "Plant is dead")
    end
end)

RegisterServerEvent("cultivation:feed")
AddEventHandler("cultivation:feed", function(i)
    if not PLANTED[i].isDead then
        local char = exports["usa-characters"]:GetCharacter(source)
        local fertilizer = char.getItem("Fertilizer")
        if fertilizer then
            PlantManager.feedPlant(i)
            TriggerClientEvent("cultivation:update", -1, i, "foodLevel", PLANTED[i].foodLevel)
            TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
            char.removeItem("Fertilizer", 1)
        end
    else 
        TriggerClientEvent("usa:notify", source, "Plant is dead")
    end
end)

RegisterServerEvent("cultivation:harvest")
AddEventHandler("cultivation:harvest", function(i)
    if PLANTED[i].stage.name == "harvest" then
        TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
        local reward = PlantManager.harvestPlant(i)
        local char = exports["usa-characters"]:GetCharacter(source)
        if not char.canHoldItem(reward) then
            TriggerEvent("interaction:dropMultipleOfItem", reward, PLANTED[i].coords) -- drop items on ground
        else
            char.giveItem(reward)
        end
        PlantManager.removePlant(i)
        TriggerClientEvent("cultivation:remove", -1, i)
        TriggerClientEvent("usa:notify", source, "Plant ~g~harvested~w~!")
    else 
        TriggerClientEvent("usa:notify", source, "Plant not ready for harvest")
    end
end)

RegisterServerEvent("cultivation:shovel")
AddEventHandler("cultivation:shovel", function(i)
    local plant = PLANTED[i]
    if plant.isDead then
        TriggerClientEvent("cultivation:remove", -1, i)
        PlantManager.removePlant(i)
        TriggerClientEvent("usa:notify", source, "Plant removed!")
    else
        TriggerClientEvent("usa:notify", source, "Plant not dead!")
    end
end)

RegisterServerEvent("cultivation:remove")
AddEventHandler("cultivation:remove", function(i)
    TriggerClientEvent("cultivation:remove", -1, i)
    PlantManager.removePlant(i)
    TriggerClientEvent("usa:notify", source, "Plant removed!")
end)

TriggerEvent('es:addCommand', 'removeplant', function(source, args, char)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    local job = char.get("job")
    local group = user.getGroup()
    if job == "sheriff" or job == "corrections" or job == "ems" or group == "mod" or group == "admin" or group == "superadmin" or group == "owner" then
        TriggerClientEvent("cultivation:attemptToRemoveNearest", source)
    end
end, {
    help = "Remove nearest plant"
})

-- Stage / Food Level / Water Level Updates --
Citizen.CreateThread(function()
    while true do
        for i = 1, #PLANTED do
            if PLANTED[i] then
                PLANTED[i], didStageUpdate, didSustenanceUpdate = PlantManager.tick(PLANTED[i])
                if didStageUpdate then
                    print("did stage update! new stage: " .. PLANTED[i].stage.name)
                    TriggerClientEvent("cultivation:updatePlantStage", -1, i, PLANTED[i].stage) -- advance to next stage (if there is a next stage)
                end
                if didSustenanceUpdate then
                    TriggerClientEvent("cultivation:updateSustenance", -1, i, PLANTED[i].foodLevel, PLANTED[i].waterLevel, (PLANTED[i].isDead or false))
                end
                Wait(1000)
            end
        end
        Wait(STAGE_CHECK_INTERVAL_MINUTES * 60 * 1000)
    end
end)

function saveCallback(ok)
    -- nothing for now
end

Citizen.CreateThread(function()
    TriggerEvent("es:exposeDBFunctions", function(db)
        while true do
            for i = 1, #PLANTED do
                local plant = PLANTED[i]
                db.updateDocument("cultivation", plant._id, { foodLevel = plant.foodLevel, waterLevel = plant.waterLevel, stage = plant.stage, isDead = plant.isDead }, saveCallback)
                Wait(2000)
            end
            Wait(SAVE_INTERVAL_MINUTES * 60 * 1000)
        end
    end)
end)
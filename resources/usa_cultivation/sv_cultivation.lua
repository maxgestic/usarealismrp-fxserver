function loadPlants()
    -- get all plant docs
	PerformHttpRequest("http://127.0.0.1:5984/cultivation/_all_docs?include_docs=true", function(err, text, headers)
		local response = json.decode(text)
        if response.rows then
            print("loaded " .. #(response.rows) - 1 .. " plants")
            -- load into memory
            for i = 1, #(response.rows) do
                if not response.rows[i].doc._id:find("design") then
                    PLANTED[response.rows[i].doc._id] = response.rows[i].doc
                end
			end
            -- set plant stage + sustenance levels
            for id, plant in pairs(PLANTED) do
                if plant.isDead and PlantManager.hasBeenDeadLongEnoughToDelete(id) then
                    print("removing dead plant: " .. id)
                    TriggerEvent("cultivation:remove", id)
                else 
                    PlantManager.setPlantStage(plant) -- set growth stage object models for client
                    PlantManager.setSustenenaceLevels(plant) -- set sustenance levels
                end
            end
		end
	end, "GET", "", {["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
    -- also compact DB so we don't lag while auto compacting some time down the line
    print("beginning compacting")
    PerformHttpRequest("http://127.0.0.1:5984/cultivation/_compact", function(err)
        print("done compacting plant docs! err: " .. err)
    end, "POST", "", {["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

local function nroot(root, num)
	return num^(1/root)
end

local function getCoordDistance(coords1, coords2)
    xdistance =  math.abs(coords1.x - coords2.x)
	ydistance = math.abs(coords1.y - coords2.y)
	zdistance = math.abs(coords1.z - coords2.z)
	return nroot(3, (xdistance ^ 3 + ydistance ^ 3 + zdistance ^ 3))
end

exports["globals"]:PerformDBCheck("usa_cultivation", "cultivation", loadPlants)

RegisterServerEvent("cultivation:loadProducts")
AddEventHandler("cultivation:loadProducts", function()
    TriggerClientEvent("cultivation:loadProducts", source, PRODUCTS)
end)

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
    PlantManager.newPlant(char, productName, coords, function(plant)
        local players = GetPlayers()
        for i = 1, #players do
            local playerCoords = GetEntityCoords(GetPlayerPed(players[i]))
            if exports.globals:getCoordDistance(playerCoords, coords) < NEARBY_DISTANCE then
                PlantManager.setPlantStage(plant) -- set growth stage object models for client
                PlantManager.setSustenenaceLevels(plant) -- set sustenance levels
                TriggerClientEvent("cultivation:clientNewPlant", players[i], plant)
            end
        end
    end)
end)

RegisterServerEvent("cultivation:water")
AddEventHandler("cultivation:water", function(id)
    if not PLANTED[id].isDead then
        PlantManager.waterPlant(id)
    else 
        TriggerClientEvent("usa:notify", source, "Plant is dead")
    end
end)

RegisterServerEvent("cultivation:feed")
AddEventHandler("cultivation:feed", function(id)
    if not PLANTED[id].isDead then
        local char = exports["usa-characters"]:GetCharacter(source)
        local fertilizer = char.getItem("Fertilizer")
        if fertilizer then
            PlantManager.feedPlant(id)
            char.removeItem("Fertilizer", 1)
        end
    else 
        TriggerClientEvent("usa:notify", source, "Plant is dead")
    end
end)

RegisterServerEvent("cultivation:harvest")
AddEventHandler("cultivation:harvest", function(id)
    if PLANTED[id] then
        if PLANTED[id].stage.name == "harvest" then
            TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 2)
            local reward = PlantManager.harvestPlant(id)
            local char = exports["usa-characters"]:GetCharacter(source)
            if not char.canHoldItem(reward) then
                TriggerEvent("interaction:dropMultipleOfItem", reward, PLANTED[id].coords) -- drop items on ground
            else
                char.giveItem(reward)
            end
            PlantManager.removePlant(id)
            TriggerClientEvent("cultivation:remove", -1, id)
            TriggerClientEvent("usa:notify", source, "Plant ~g~harvested~w~!")
        else 
            TriggerClientEvent("usa:notify", source, "Plant not ready for harvest")
        end
    else
        print("[cultivation/cultivation:harvest] PLANTED[id] was nil! id: " .. id)
    end
end)

RegisterServerEvent("cultivation:shovel")
AddEventHandler("cultivation:shovel", function(id)
    local plant = PLANTED[id]
    if plant.isDead then
        TriggerClientEvent("cultivation:remove", -1, id)
        PlantManager.removePlant(id)
        TriggerClientEvent("usa:notify", source, "Plant removed!")
    else
        TriggerClientEvent("usa:notify", source, "Plant not dead!")
    end
end)

RegisterServerEvent("cultivation:remove")
AddEventHandler("cultivation:remove", function(id)
    TriggerClientEvent("cultivation:remove", -1, id)
    PlantManager.removePlant(id)
    if source then
        TriggerClientEvent("usa:notify", source, "Plant removed!")
    end
end)

RegisterServerEvent("cultivation:loadNearbyPlants")
AddEventHandler("cultivation:loadNearbyPlants", function(coords)
    local nearby = {}
    for id, plant in pairs(PLANTED) do
        if getCoordDistance(plant.coords, coords) < NEARBY_DISTANCE then
            nearby[id] = plant
        end
    end
    TriggerClientEvent("cultivation:loadNearbyPlants", source, nearby)
end)

RegisterServerEvent("cultivation:saveAllPlants")
AddEventHandler("cultivation:saveAllPlants", function()
    saveAllPlants()
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

Citizen.CreateThread(function()
    local lastCheckTime = os.time()
    while true do
        local now = os.time()
        if os.difftime(now, lastCheckTime) >= PLANT_CHECK_INTERVAL_MINUTES * 60 then
            lastCheckTime = now
            for id, plant in pairs(PLANTED) do
                if not plant.isDead then
                    PlantManager.setPlantStage(plant) -- set growth stage object models for client
                    PlantManager.setSustenenaceLevels(plant) -- set sustenance levels
                elseif PlantManager.hasBeenDeadLongEnoughToDelete(id) then
                    print("removing dead plant: " .. id)
                    TriggerEvent("cultivation:remove", id)
                end
            end
        end
        Wait(1)
    end
end)

function saveCallback(doc, err)
    -- nothing for now
end

function saveAllPlants()
    TriggerEvent("es:exposeDBFunctions", function(db)
        for id, plant in pairs(PLANTED) do
            if not PLANTED[id].isDead then
                PLANTED[id]._rev = nil
                PLANTED[id].last_save_time = os.date('%m-%d-%Y %H:%M:%S', os.time())
                db.updateDocument("cultivation", id, PLANTED[id], saveCallback)
            end
            Wait(5)
        end
    end)
end
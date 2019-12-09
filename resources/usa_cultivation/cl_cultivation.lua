local PRODUCTS = {}
local PLANTED = {}
local CLOSEST_PLANTED = {}

RegisterNetEvent("cultivation:load")
AddEventHandler("cultivation:load", function(products, planted)
    PRODUCTS = products
    PLANTED = planted
    if PLANTED then
        for i = 1, #PLANTED do
            local plant = PLANTED[i]
            local prop = CreateObject(GetHashKey(plant.stage.objectModels[1]), plant.coords.x, plant.coords.y, plant.coords.z, 0, 0, 0)
            PLANTED[i].objectHandle = prop
            --PlaceObjectOnGroundProperly(prop)
            SetEntityAsMissionEntity(plantObj, 1, 1)
        end
    end
end)

TriggerServerEvent("cultivation:load")

local me = {
    ped = nil,
    coords = nil
}

local MENU_RADIUS = 1.5
local MENU_TEXT_RADIUS = 40
local PLANT_TEXT_RADIUS = 5.0

local ANIMATION_TIME_SECONDS = 10

local CLOSEST_PLANTS_BUFFER_INTERVAL_SECONDS = 5
local CLOSEST_PLANTS_BUFFER_DIST = 20.0

local KEYS = {
    E = 38
}

Citizen.CreateThread(function()
    while true do
        me.ped = PlayerPedId()
        me.coords = GetEntityCoords(me.ped)
        if PRODUCTS then
            for name, info in pairs(PRODUCTS) do
                local seedBuyLocation = info.buyLocation
                local distance = Vdist(me.coords.x, me.coords.y, me.coords.z, seedBuyLocation.x, seedBuyLocation.y, seedBuyLocation.z)
                if distance < MENU_TEXT_RADIUS then
                    DrawText3D(seedBuyLocation.x, seedBuyLocation.y, seedBuyLocation.z, "[E] - Buy Cannabis Plant")
                end
                if distance < MENU_RADIUS then
                    if IsControlJustPressed(0, KEYS.E) then
                        TriggerServerEvent("cultivation:buy", name)
                        Wait(500)
                    end
                end
            end
        end
        Wait(1)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

-- returns plant index and distance of closest plant --
function GetClosestPlant()
    if not me.ped then
        return
    end
    local closest = {
        index = -1,
        dist = 9999999999
    }
    if PLANTED then
        for i = 1, #PLANTED do
            local plant = PLANTED[i]
            local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
            if dist < closest.dist and dist < 5.0 then
                closest.index = i 
                closest.dist = dist
            end
        end
    end
    return closest
end

function DisablePlayerControls()
    DisableControlAction(0, 86, true)
    DisableControlAction(0, 244, true)
    DisableControlAction(0, 245, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 79, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 311, true)
end

RegisterNetEvent("cultivation:plant")
AddEventHandler("cultivation:plant", function(type, itemName)
    if not IsPedInAnyVehicle(me.ped, true) then
        local plantCoords = { x = me.coords.x + 0.5, y = me.coords.y + 0.5, z = me.coords.z + 1.0 }
        local unkBool, groundZ = GetGroundZCoordWithOffsets(plantCoords.x, plantCoords.y, plantCoords.z)
        plantCoords.z = groundZ
        -- trigger server event to keep track of new plant
        TriggerServerEvent("cultivation:plant", type, itemName, plantCoords)
    end
end)

RegisterNetEvent("cultivation:clientNewPlant")
AddEventHandler("cultivation:clientNewPlant", function(newPlant)
    -- create plant object
    if not HasModelLoaded(newPlant.stage.objectModels[1]) then
        RequestModel(newPlant.stage.objectModels[1])
    end
	while not HasModelLoaded(newPlant.stage.objectModels[1]) do
		Wait(10)
    end
    newPlant.objectHandle = CreateObject(GetHashKey(newPlant.stage.objectModels[1]), newPlant.coords.x, newPlant.coords.y, newPlant.coords.z, 0, 0, 0)
    --PlaceObjectOnGroundProperly(newPlant.objectHandle)
    SetEntityAsMissionEntity(newPlant.objectHandle, 1, 1)
    table.insert(PLANTED, newPlant)
end)

-- update's plant object model on stage update --
RegisterNetEvent("cultivation:updatePlantStage")
AddEventHandler("cultivation:updatePlantStage", function(i, stage)
    local obj = PLANTED[i].objectHandle
    DeleteObject(obj)
    PLANTED[i].stage = stage
    local plant = PLANTED[i]
    local nextStageObjs = plant.stage.objectModels
    obj = CreateObject(GetHashKey(nextStageObjs[math.random(#nextStageObjs)]), plant.coords.x, plant.coords.y, plant.coords.z, 0, 0, 0)
    --PlaceObjectOnGroundProperly(obj)
    SetEntityAsMissionEntity(obj, 1, 1)
    PLANTED[i].objectHandle = obj
end)

RegisterNetEvent("cultivation:updateSustenance")
AddEventHandler("cultivation:updateSustenance", function(i, foodLevel, waterLevel, deathStage)
    PLANTED[i].foodLevel = foodLevel
    PLANTED[i].waterLevel = waterLevel
    if deathStage then
        PLANTED[i].stage = deathStage
    end
end)

RegisterNetEvent("cultivation:water")
AddEventHandler("cultivation:water", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        local start = GetGameTimer()
        while GetGameTimer() - start < ANIMATION_TIME_SECONDS * 1000 do
            exports.globals:DrawTimerBar(start, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'WATERING')
            DisablePlayerControls()
            if not IsEntityPlayingAnim(me.ped, "anim@move_m@trash", "pickup", 3) then
                TaskPlayAnim(me.ped, "anim@move_m@trash", "pickup", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            Wait(1)
        end
        ClearPedTasks(me.ped)
        TriggerServerEvent("cultivation:water", closest.index)
    else
        exports.globals:notify("No plant found!")
    end
end)

RegisterNetEvent("cultivation:feed")
AddEventHandler("cultivation:feed", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        local start = GetGameTimer()
        while GetGameTimer() - start < ANIMATION_TIME_SECONDS * 1000 do
            exports.globals:DrawTimerBar(start, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'FEEDING')
            DisablePlayerControls()
            if not IsEntityPlayingAnim(me.ped, "anim@move_m@trash", "pickup", 3) then
                TaskPlayAnim(me.ped, "anim@move_m@trash", "pickup", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            Wait(1)
        end
        ClearPedTasks(me.ped)
        TriggerServerEvent("cultivation:feed", closest.index)
    else
        exports.globals:notify("No plant found!")
    end
end)

RegisterNetEvent("cultivation:update")
AddEventHandler("cultivation:update", function(i, field, val)
    PLANTED[i][field] = val
end)

RegisterNetEvent("cultivation:harvest")
AddEventHandler("cultivation:harvest", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        local start = GetGameTimer()
        while GetGameTimer() - start < ANIMATION_TIME_SECONDS * 1000 do
            exports.globals:DrawTimerBar(start, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'HARVESTING')
            DisablePlayerControls()
            if not IsEntityPlayingAnim(me.ped, "anim@move_m@trash", "pickup", 3) then
                TaskPlayAnim(me.ped, "anim@move_m@trash", "pickup", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            Wait(1)
        end
        ClearPedTasks(me.ped)
        TriggerServerEvent("cultivation:harvest", closest.index)
    else
        exports.globals:notify("No plant found!")
    end
end)

RegisterNetEvent("cultivation:remove")
AddEventHandler("cultivation:remove", function(i, msg)
    DeleteObject(PLANTED[i].objectHandle)
    table.remove(PLANTED, i)
    if msg then 
        exports.globals:notify(msg)
    end
end)

RegisterNetEvent("cultivation:shovel")
AddEventHandler("cultivation:shovel", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        local start = GetGameTimer()
        while GetGameTimer() - start < ANIMATION_TIME_SECONDS * 1000 do
            exports.globals:DrawTimerBar(start, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'SHOVELING')
            DisablePlayerControls()
            if not IsEntityPlayingAnim(me.ped, "anim@move_m@trash", "pickup", 3) then
                TaskPlayAnim(me.ped, "anim@move_m@trash", "pickup", 8.0, 1.0, -1, 11, 1.0, false, false, false)
            end
            Wait(1)
        end
        ClearPedTasks(me.ped)
        TriggerServerEvent("cultivation:shovel", closest.index)
    else
        exports.globals:notify("No plant found!")
    end
end)

RegisterNetEvent("cultivation:attemptToRemoveNearest")
AddEventHandler("cultivation:attemptToRemoveNearest", function()
    local closest = GetClosestPlant()
    TriggerServerEvent("cultivation:remove", closest.index)
end)

-- Used to optimize drawing of 3D text (only look for nearby plants every x seconds instead of every frame)
local lastCheckTime = GetGameTimer()
Citizen.CreateThread(function()
    while true do
        local isTimeForNextCheck = GetGameTimer() - lastCheckTime >= CLOSEST_PLANTS_BUFFER_INTERVAL_SECONDS * 1000
        if PLANTED and me.coords and isTimeForNextCheck then
            lastCheckTime = GetGameTimer()
            for i = 1, #PLANTED do
                local plant = PLANTED[i]
                local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
                if dist <= CLOSEST_PLANTS_BUFFER_DIST then
                    CLOSEST_PLANTED[i] = plant
                else
                    CLOSEST_PLANTED[i] = nil
                end
            end
        end
        Wait(1)
    end
end)

-- Draw 3D text for all plants within CLOSEST_PLANTS_BUFFER_DIST distance --
Citizen.CreateThread(function()
    while true do
        if CLOSEST_PLANTED and me.coords then
            for index, plant in pairs(CLOSEST_PLANTED) do
                local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
                if dist < PLANT_TEXT_RADIUS then
                    local water = plant.waterLevel.asString
                    local food = plant.foodLevel.asString
                    if plant.stage.name ~= "dead" then
                        DrawText3D(plant.coords.x, plant.coords.y, plant.coords.z, plant.type .. " Plant | " .. water .. " | " .. food)
                    else
                        DrawText3D(plant.coords.x, plant.coords.y, plant.coords.z, plant.type .. " Plant | ~r~Dead~w~")
                    end
                end
            end
        end
        Wait(1)
    end
end)
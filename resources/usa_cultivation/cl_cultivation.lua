local PRODUCTS = {}
local PLANTED = {}
local CLOSEST_PLANTED = {}

local me = {
    ped = nil,
    coords = nil
}

local MENU_RADIUS = 1.5
local MENU_TEXT_RADIUS = 40
local PLANT_TEXT_RADIUS = 5.0

local ANIMATION_TIME_SECONDS = 10
local HARVEST_TIME_SECONDS = 60

local CLOSEST_PLANTS_BUFFER_INTERVAL_SECONDS = 3
local OBJECT_CULLING_DIST = 300.0

local KEYS = {
    E = 38
}

RegisterNetEvent("cultivation:load")
AddEventHandler("cultivation:load", function(products, planted)
    PRODUCTS = products
    PLANTED = planted
    if PLANTED then
        local mycoords = GetEntityCoords(PlayerPedId())
        for i = 1, #PLANTED do
            local plant = PLANTED[i]
            if Vdist(mycoords.x, mycoords.y, mycoords.z, plant.coords.x, plant.coords.y, plant.coords.z) <= OBJECT_CULLING_DIST then
                local objectModel = plant.stage.objectModels[1]
                if objectModel then
                    local zCoordAdjustment = doAdjustZCoord(objectModel)
                    if zCoordAdjustment then
                        PLANTED[i].objectHandle = CreateObject(GetHashKey(objectModel), plant.coords.x, plant.coords.y, plant.coords.z + zCoordAdjustment, 0, 0, 0)
                    else
                        PLANTED[i].objectHandle = CreateObject(GetHashKey(objectModel), plant.coords.x, plant.coords.y, plant.coords.z, 0, 0, 0)
                    end
                    SetEntityAsMissionEntity(PLANTED[i].objectHandle, 1, 1)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    TriggerServerEvent("cultivation:load")
end)

Citizen.CreateThread(function()
    while true do
        me.ped = PlayerPedId()
        me.coords = GetEntityCoords(me.ped)
        if PRODUCTS then
            for name, info in pairs(PRODUCTS) do
                local seedBuyLocation = info.buyLocation
                local distance = Vdist(me.coords.x, me.coords.y, me.coords.z, seedBuyLocation.x, seedBuyLocation.y, seedBuyLocation.z)
                if distance < MENU_TEXT_RADIUS then
                    DrawText3D(seedBuyLocation.x, seedBuyLocation.y, seedBuyLocation.z, "[E] - Buy Cannabis Plant | [Hold E] - Help")
                end
                if distance < MENU_RADIUS then
                    if IsControlJustPressed(0, KEYS.E) then
                        Wait(500)
                        if IsControlPressed(0, KEYS.E) then
                            ShowHelp()
                        else
                            TriggerServerEvent("cultivation:buy", name)
                        end
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

function doAdjustZCoord(objName)
    local zCoordAdjustmenTable = {}
    zCoordAdjustmenTable["bkr_prop_weed_med_01a"] = -2.5
    zCoordAdjustmenTable["bkr_prop_weed_med_01b"] = -2.5
    zCoordAdjustmenTable["bkr_prop_weed_lrg_01b"] = -2.5

    if zCoordAdjustmenTable[objName] then
        return zCoordAdjustmenTable[objName]
    else
        return nil
    end
end

function ShowHelp()
    local msg = "'Use' the plant in your inventory to plant it. It will take about 7 whole days to enter its final stage at which point it becomes harvestable by 'using' large scisossors near it. Make sure you buy a watering can from the 24/7 and fertilizer from the hardware store and 'use' them near your plants to keep them alive! After harvesting, you can take the buds to that big barn off Senora Freeway just North East of the car dealership in Harmony to process them for sale."
    TriggerEvent("chatMessage", "", {}, "^3INFO: ^0" .. msg)
end

function LoadPlantModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
    end
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

function CreatePlantObject(i)
    if PLANTED[i] and not PLANTED[i].objectHandle then
        local plant = PLANTED[i]
        local objectModel = plant.stage.objectModels[1]
        if plant.stage.objectModels[1] then
            LoadPlantModel(plant.stage.objectModels[1])
            local zCoordAdjustment = doAdjustZCoord(objectModel)
            if zCoordAdjustment then
                plant.objectHandle = CreateObject(GetHashKey(objectModel), plant.coords.x, plant.coords.y, plant.coords.z + zCoordAdjustment, 0, 0, 0)
            else
                plant.objectHandle = CreateObject(GetHashKey(objectModel), plant.coords.x, plant.coords.y, plant.coords.z, 0, 0, 0)
            end
            SetEntityAsMissionEntity(plant.objectHandle, 1, 1)
            PLANTED[i].objectHandle = plant.objectHandle
        end
    end
end

function DeletePlantObject(i)
    if PLANTED[i] and PLANTED[i].objectHandle then
        DeleteObject(PLANTED[i].objectHandle)
        PLANTED[i].objectHandle = nil
    end
end

RegisterNetEvent("cultivation:plant")
AddEventHandler("cultivation:plant", function(type, itemName)
    if not IsPedInAnyVehicle(me.ped, true) then
        local plantCoords = { x = me.coords.x + 0.5, y = me.coords.y + 0.5, z = me.coords.z + 1.0 }
        if not IsPointOnRoad(plantCoords.x, plantCoords.y, plantCoords.z, vehicle) then
            local unkBool, groundZ = GetGroundZCoordWithOffsets(plantCoords.x, plantCoords.y, plantCoords.z)
            plantCoords.z = groundZ
            -- trigger server event to keep track of new plant
            TriggerServerEvent("cultivation:plant", type, itemName, plantCoords)
        else 
            exports.globals:notify("Can't place on road!")
        end
    end
end)

RegisterNetEvent("cultivation:clientNewPlant")
AddEventHandler("cultivation:clientNewPlant", function(newPlant)
    if me.coords ~= nil then
        if Vdist(me.coords.x, me.coords.y, me.coords.z, newPlant.coords.x, newPlant.coords.y, newPlant.coords.z) < OBJECT_CULLING_DIST then -- create plant object
            local objectModel = newPlant.stage.objectModels[1]
            LoadPlantModel(objectModel)
            local zCoordAdjustment = doAdjustZCoord(objectModel)
            if zCoordAdjustment then
                newPlant.objectHandle = CreateObject(GetHashKey(objectModel), newPlant.coords.x, newPlant.coords.y, newPlant.coords.z + zCoordAdjustment, 0, 0, 0)
            else
                newPlant.objectHandle = CreateObject(GetHashKey(objectModel), newPlant.coords.x, newPlant.coords.y, newPlant.coords.z, 0, 0, 0)
            end
            SetEntityAsMissionEntity(newPlant.objectHandle, 1, 1)
        end
    end
    table.insert(PLANTED, newPlant)
end)

-- update's plant object model on stage update --
RegisterNetEvent("cultivation:updatePlantStage")
AddEventHandler("cultivation:updatePlantStage", function(i, stage)
    if PLANTED[i] then
        PLANTED[i].stage = stage
        if PLANTED[i].objectHandle then -- plant object exists for client
            local obj = PLANTED[i].objectHandle
            DeleteObject(obj)
            local plant = PLANTED[i]
            local nextStageObj = plant.stage.objectModels[math.random(#(plant.stage.objectModels))]
            local zCoordAdjustment = doAdjustZCoord(nextStageObj)
            if zCoordAdjustment then
                obj = CreateObject(GetHashKey(nextStageObj), plant.coords.x, plant.coords.y, plant.coords.z + zCoordAdjustment, 0, 0, 0)
            else 
                obj = CreateObject(GetHashKey(nextStageObj), plant.coords.x, plant.coords.y, plant.coords.z, 0, 0, 0)
            end
            SetEntityAsMissionEntity(obj, 1, 1)
            PLANTED[i].objectHandle = obj
        end
    end
end)

RegisterNetEvent("cultivation:updateSustenance")
AddEventHandler("cultivation:updateSustenance", function(i, foodLevel, waterLevel, isDead)
    if PLANTED[i] then
        PLANTED[i].foodLevel = foodLevel
        PLANTED[i].waterLevel = waterLevel
        if isDead then
            PLANTED[i].isDead = isDead
        end
    end
end)

RegisterNetEvent("cultivation:water")
AddEventHandler("cultivation:water", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        if not HasAnimDictLoaded("anim@move_m@trash") then
            exports.globals:loadAnimDict("anim@move_m@trash")
        end
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
        if not HasAnimDictLoaded("anim@move_m@trash") then
            exports.globals:loadAnimDict("anim@move_m@trash")
        end
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
    if PLANTED[i] then
        PLANTED[i][field] = val
    else 
        print("cultivation:update failed. Plant at index " .. i .. " not valid!")
    end
end)

RegisterNetEvent("cultivation:harvest")
AddEventHandler("cultivation:harvest", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        if not HasAnimDictLoaded("anim@move_m@trash") then
            exports.globals:loadAnimDict("anim@move_m@trash")
        end
        local start = GetGameTimer()
        while GetGameTimer() - start < HARVEST_TIME_SECONDS * 1000 do
            exports.globals:DrawTimerBar(start, HARVEST_TIME_SECONDS * 1000, 1.42, 1.475, 'HARVESTING')
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
    if PLANTED[i] then
        if PLANTED[i].objectHandle then
            DeleteObject(PLANTED[i].objectHandle)
        end
        table.remove(PLANTED, i)
        if msg then 
            exports.globals:notify(msg)
        end
    end
end)

RegisterNetEvent("cultivation:shovel")
AddEventHandler("cultivation:shovel", function()
    -- find nearest plant
    local closest = GetClosestPlant()
    if closest.index ~= -1 then
        if not HasAnimDictLoaded("anim@move_m@trash") then
            exports.globals:loadAnimDict("anim@move_m@trash")
        end
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
                if plant and plant.coords then
                    local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
                    if dist <= OBJECT_CULLING_DIST then
                        if not CLOSEST_PLANTED[i] then
                            CLOSEST_PLANTED[i] = plant
                            CreatePlantObject(i)
                        end
                    else
                        if CLOSEST_PLANTED[i] then
                            CLOSEST_PLANTED[i] = nil
                            DeletePlantObject(i)
                        end
                    end
                else
                    print("cultivation: found bad plant, id: " .. (plant._id or "NO ID"))
                end
            end
        end
        Wait(1)
    end
end)

-- Draw 3D text for all plants within PLANT_TEXT_RADIUS distance --
Citizen.CreateThread(function()
    while true do
        if CLOSEST_PLANTED and me.coords then
            for i, plant in pairs(CLOSEST_PLANTED) do
                if PLANTED[i] then
                    local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
                    if dist < PLANT_TEXT_RADIUS then
                        local water = plant.waterLevel.asString
                        local food = plant.foodLevel.asString
                        if not plant.isDead then
                            DrawText3D(plant.coords.x, plant.coords.y, plant.coords.z, plant.type .. " Plant | " .. water .. " | " .. food)
                        else
                            DrawText3D(plant.coords.x, plant.coords.y, plant.coords.z, plant.type .. " Plant | ~r~Dead~w~")
                        end
                    end
                else 
                    CLOSEST_PLANTED[i] = nil
                end
            end
        end
        Wait(1)
    end
end)

--[[
RegisterCommand("cultdebug", function()
    print("# PLANTED: " .. #PLANTED)
    for i, plant in pairs(CLOSEST_PLANTED) do
        local dist = Vdist(me.coords.x, me.coords.y, me.coords.z, plant.coords.x, plant.coords.y, plant.coords.z)
        print("closest plant at " .. i .. ", dist: " .. dist)
    end
end, false) 
--]]
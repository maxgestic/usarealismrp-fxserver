local myped = {
    handle = nil,
    coords = nil
}

local OBJECTS = {
    {
        MODEL = "prop_gazebo_02",
        HASH = GetHashKey("prop_gazebo_02"),
        COORDS = vector3(-72.350448608398, -1834.5893554688, 25.941486358643),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-42.320083618164, -1831.2911376953, 25.2815990448),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-51.475910186768, -1823.3765869141, 25.632989883423),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-52.694862365723, -1825.3082275391, 25.71061706543),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-51.434955596924, -1824.9613037109, 25.657135009766),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-43.836948394775, -1831.2666015625, 25.337362289429),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-43.981876373291, -1832.7474365234, 25.332061767578),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-72.320175170898, -1836.9780273438, 25.964714050293),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-64.99422454834, -1812.8948974609, 26.36576461792),
        handle = nil
    },
    {
        MODEL = "prop_offroad_tyres02",
        HASH = GetHashKey("prop_offroad_tyres02"),
        COORDS = vector3(-62.140472412109, -1815.3975830078, 26.217790603638),
        handle = nil
    }
}

local PEDS = {
    {
        MODEL = "a_m_y_eastsa_02",
        HASH = GetHashKey("a_m_y_eastsa_02"),
        COORDS = vector3(-72.96459197998, -1833.9136962891, 26.942174911499),
        HEADING = 235.0,
        SCENARIO = "WORLD_HUMAN_STAND_MOBILE",
        handle = nil
    },
    {
        MODEL = "a_m_y_indian_01",
        HASH = GetHashKey("a_m_y_indian_01"),
        COORDS = vector3(-72.204467773438, -1834.9881591797, 26.941446304321),
        HEADING = 340.0,
        SCENARIO = "WORLD_HUMAN_HANG_OUT_STREET",
        handle = nil
    }
}

local DISPLAY_VEHICLES = {} -- loaded from server

local SHOP_VISIBLE_DISTANCE = 500
local SHOP_SPAWN_CHECK_DELAY = 3000

local PURCHASE_KEY = nil
local HOLD_TIME_BUY = 5000

local KART_SPAWN = {
    COORDS = vector3(-66.132225036621, -1839.6000976563, 26.777814865112),
    HEADING = 320.0
}

local OPEN_AFTER = 6 -- 7 AM
local CLOSED_AT = 21 -- 9 PM

RegisterNetEvent("gokarts:loadKarts")
AddEventHandler("gokarts:loadKarts", function(VEHICLES)
    DISPLAY_VEHICLES = VEHICLES
end)

TriggerServerEvent("gokarts:loadKarts")

RegisterNetEvent("gokarts:spawn")
AddEventHandler("gokarts:spawn", function(kart)
    spawnVehicle(kart, false)
end)

function spawnObject(object)
    local handle = CreateObject(object.HASH, object.COORDS.x, object.COORDS.y, object.COORDS.z, false, false, true)
    SetEntityCollision(handle, true, true)
    SetEntityAsMissionEntity(handle, true, true)
    FreezeEntityPosition(handle, true)
    --SetEntityRotation(cellDoorHandle, 0.0, 0.0, (door.customDoor.rot or -90.0), true)
    return handle
end

function spawnPed(ped)
    RequestModel(ped.HASH)
    while not HasModelLoaded(ped.HASH) do
        Wait(1)
    end
    local handle = CreatePed(0, ped.HASH, ped.COORDS.x, ped.COORDS.y, ped.COORDS.z, 0.1, false, false)
    SetEntityCanBeDamaged(handle, false)
    SetPedCanRagdollFromPlayerImpact(handle, false)
    SetBlockingOfNonTemporaryEvents(handle, true)
    SetPedFleeAttributes(handle, 0, 0)
    SetPedCombatAttributes(handle, 17, 1)
    SetPedRandomComponentVariation(handle, false)
    if ped.HEADING then
        SetEntityHeading(handle, ped.HEADING)
    end
    if ped.SCENARIO then
        TaskStartScenarioInPlace(handle, ped.SCENARIO, 0, true)
    end
    return handle
end

function spawnVehicle(veh, forDisplay)
    RequestModel(veh.HASH)
    while not HasModelLoaded(veh.HASH) do
        Wait(100)
    end
    local handle = nil
    if forDisplay then
        handle = CreateVehicle(veh.HASH, veh.COORDS.x, veh.COORDS.y, veh.COORDS.z, (veh.HEADING or 0.0) --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        FreezeEntityPosition(handle, true)
        SetVehicleDoorsLocked(handle, 10)
        SetVehicleExplodesOnHighExplosionDamage(handle, false)
    else
        PlaySoundFrontend(-1,"Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
        handle = CreateVehicle(veh.HASH, KART_SPAWN.COORDS.x, KART_SPAWN.COORDS.y, KART_SPAWN.COORDS.z, (KART_SPAWN.HEADING or 0.0) --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
    end
    SetVehicleOnGroundProperly(handle)
    SetEntityAsMissionEntity(handle, true, true)
    if veh.plate then
        SetVehicleNumberPlateText(handle, veh.plate)
    end
    return handle
end

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
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
end

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

-- async thread to load key table from globals resource --
Citizen.CreateThread(function()
    while not exports.globals:GetKeys() do
        Wait(1000)
    end
    PURCHASE_KEY = exports.globals:GetKeys().E
end)

-- handle purchasing / 3D text --
Citizen.CreateThread(function()
    while true do
        if GetClockHours() > OPEN_AFTER and GetClockHours() < CLOSED_AT then
            if myped.handle then
                for i = 1, #DISPLAY_VEHICLES do
                    local dist = GetDistanceBetweenCoords(DISPLAY_VEHICLES[i].COORDS, myped.coords, false)
                    if dist <= 10 then
                        -- draw 3d text when close enough to any vehicle
                        local text = "UNDEFINED"
                        if not DISPLAY_VEHICLES[i].startBuyTime then
                            text = "[Hold E] - Buy " .. DISPLAY_VEHICLES[i].MODEL .. " | $" .. comma_value(DISPLAY_VEHICLES[i].PRICE)
                        else 
                            local timeleft = math.floor((HOLD_TIME_BUY / 1000) - ((GetGameTimer() - DISPLAY_VEHICLES[i].startBuyTime) / 1000))
                            text = "Buying in " .. timeleft .. " second(s)"
                        end
                        if DISPLAY_VEHICLES[i].MODEL == "kart" then
                            DrawText3D(DISPLAY_VEHICLES[i].COORDS.x, DISPLAY_VEHICLES[i].COORDS.y, DISPLAY_VEHICLES[i].COORDS.z + 1.5, text)
                        else 
                            DrawText3D(DISPLAY_VEHICLES[i].COORDS.x, DISPLAY_VEHICLES[i].COORDS.y, DISPLAY_VEHICLES[i].COORDS.z + 1.0, text)
                        end
                        if dist <= 1.2 then
                            -- listen for holding e to buy it:
                            if IsControlJustPressed(0, PURCHASE_KEY) and GetLastInputMethod(0) then
                                DISPLAY_VEHICLES[i].startBuyTime = GetGameTimer()
                                Citizen.CreateThread(function()
                                    while GetLastInputMethod(0) and IsControlPressed(0, PURCHASE_KEY) and GetGameTimer() - DISPLAY_VEHICLES[i].startBuyTime < HOLD_TIME_BUY do
                                        Wait(0)
                                    end
                                    if IsControlPressed(0, PURCHASE_KEY) and GetLastInputMethod(0) then
                                        TriggerServerEvent("gokarts:buy", i)
                                    end
                                    DISPLAY_VEHICLES[i].startBuyTime = nil
                                end)
                            end
                        end
                    end
                end
            end
        else
            if myped.handle then
                local dist = Vdist(myped.coords, OBJECTS[1].COORDS)
                if dist < 15.0 then
                    local text = "Go-Kart Shop | CLOSED (opens @ 7 AM)"
                    DrawText3D(OBJECTS[1].COORDS.x, OBJECTS[1].COORDS.y, OBJECTS[1].COORDS.z + 1.0, text)
                end
            end
        end
        Wait(1)
    end
end)

-- thread to update local ped handle and coords --
Citizen.CreateThread(function()
    while true do
        myped.handle = PlayerPedId()
        myped.coords = GetEntityCoords(myped.handle)
        Wait(1)
    end
end)

-- thread to manage shop scenery objects --
Citizen.CreateThread(function()
    while true do
        if myped.handle then
            for i = 1, #OBJECTS do
                local dist = Vdist(myped.coords, OBJECTS[i].COORDS)
                if dist < SHOP_VISIBLE_DISTANCE then
                    local obj = GetClosestObjectOfType(OBJECTS[i].COORDS.x, OBJECTS[i].COORDS.y, OBJECTS[i].COORDS.z, 0.5, OBJECTS[i].HASH, false, false, false)
                    if not DoesEntityExist(obj) then
                        OBJECTS[i].handle = spawnObject(OBJECTS[i])
                    end
                else
                    if OBJECTS[i].handle and DoesEntityExist(OBJECTS[i].handle) then
                        DeleteObject(OBJECTS[i].handle)
                    end
                    OBJECTS[i].handle = nil
                end
            end
        end
        Wait(SHOP_SPAWN_CHECK_DELAY)
    end
end)

-- thread to manage shop peds --
Citizen.CreateThread(function()
    while true do
        if GetClockHours() > OPEN_AFTER and GetClockHours() < CLOSED_AT then
            if myped.handle then
                for i = 1, #PEDS do
                    local dist = Vdist(myped.coords, PEDS[i].COORDS)
                    if dist < SHOP_VISIBLE_DISTANCE then
                        if not PEDS[i].handle then
                            PEDS[i].handle = spawnPed(PEDS[i])
                        end
                    else
                        if PEDS[i].handle then
                            DeletePed(PEDS[i].handle)
                            PEDS[i].handle = nil
                        end
                    end
                end
            end
        end
        Wait(SHOP_SPAWN_CHECK_DELAY)
    end
end)

-- thread to manage shop display vehicles --
Citizen.CreateThread(function()
    while true do
        if GetClockHours() > OPEN_AFTER and GetClockHours() < CLOSED_AT then
            if myped.handle then
                for i = 1, #DISPLAY_VEHICLES do
                    local dist = Vdist(myped.coords, DISPLAY_VEHICLES[i].COORDS)
                    if dist < SHOP_VISIBLE_DISTANCE then
                        if not DISPLAY_VEHICLES[i].handle then
                            DISPLAY_VEHICLES[i].handle = spawnVehicle(DISPLAY_VEHICLES[i], true)
                        end
                    else
                        if DISPLAY_VEHICLES[i].handle then
                            DeleteVehicle(DISPLAY_VEHICLES[i].handle)
                            DISPLAY_VEHICLES[i].handle = nil
                        end
                    end
                end
            end
        else 
            for i = 1, #DISPLAY_VEHICLES do
                if DISPLAY_VEHICLES[i].handle then
                    DeleteVehicle(DISPLAY_VEHICLES[i].handle)
                    DISPLAY_VEHICLES[i].handle = nil
                end
            end
        end
        Wait(SHOP_SPAWN_CHECK_DELAY)
    end
end)
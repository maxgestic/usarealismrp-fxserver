local targetVehicle, targetPed
local civEngineOverheatThreshold, copEngineOverheatThreshold = 967.0, 935.0 -- non-severe accidents (busted radiator)
local engineDisabledThreshold = 935.0

Citizen.CreateThread(function()
    local vehicleEngineHealth
    while true do
        Wait(1)
        targetPed = GetPlayerPed(-1)
        targetVehicle = GetVehiclePedIsIn(targetPed, 1)
        vehicleEngineHealth = GetVehicleEngineHealth(targetVehicle)
        if targetVehicle and targetPed then
            if vehicleEngineHealth < engineDisabledThreshold then -- severe vehicle damage
                DrawSpecialTextTimed("Your vehicle was ~r~disabled~w~!", 5)
                SetVehicleUndriveable(targetVehicle, 1) -- disable car
                SetVehicleEngineHealth(targetVehicle, 0.0) -- engine health to 0
            elseif vehicleEngineHealth >= engineDisabledThreshold and vehicleEngineHealth < civEngineOverheatThreshold and not IsPedInAnyPoliceVehicle(targetPed) then -- less severe vehicle damage, non police
                overheatVehicle(targetVehicle)
            elseif vehicleEngineHealth >= engineDisabledThreshold and vehicleEngineHealth < copEngineOverheatThreshold and IsPedInAnyPoliceVehicle(targetPed) then -- less severe vehicle damage, police
                overheatVehicle(targetVehicle)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if IsControlJustPressed(1,38) then -- "E"
            local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
            local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
            local targetVehicle = getVehicleInDirection(coordA, coordB)
            if targetVehicle ~= 0 then
                if (GetVehicleEngineHealth(targetVehicle) < 1000 or not IsVehicleDriveable(targetVehicle, 0)) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                    TriggerServerEvent("carDamage:checkForRepairKit", targetVehicle)
                    --targetVehicle = nil
                end
            end
        end
    end
end)

RegisterNetEvent("carDamage:repairVehicle")
AddEventHandler("carDamage:repairVehicle", function(vehicle)
    print("inside of carDamage:repairVehicle with vehicle param = " .. vehicle)
    Citizen.CreateThread(function()
        ped = GetPlayerPed(-1)
        DrawCoolLookingNotification("~y~Reparing!")
        TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
        Citizen.Wait(25000)
        ClearPedTasks(ped)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineHealth(vehicle, 1000.0)
        DrawCoolLookingNotification("Your car was ~g~repaired~w~!")
    end)

end)

RegisterNetEvent("carDamage:notifyNoRepairKit")
AddEventHandler("carDamage:notifyNoRepairKit", function()
    DrawCoolLookingNotification("You have ~r~no~w~ repair kit!")
end)

RegisterNetEvent("carDamage:notifiyCarRepairFailed")
AddEventHandler("carDamage:notifiyCarRepairFailed", function()
    Citizen.CreateThread(function()
        ped = GetPlayerPed(-1)
        DrawCoolLookingNotification("~y~Reparing!")
        TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
        Citizen.Wait(25000)
        ClearPedTasks(ped)
        DrawCoolLookingNotification("Repair kit ~r~failed~w~ to repair your vehicle!")
    end)
end)

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end

--[[ usage:
local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
local targetVehicle = getVehicleInDirection(coordA, coordB)
]]

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

-- time should be sent in seconds
function DrawSpecialTextTimed(text, time)

    local msgTimer = time * 1000
    -- notify person
    while msgTimer > 0 do
        DrawSpecialText(text)
        msgTimer = msgTimer - 10
    end

end
-- slowly disables a player's vehicle
function overheatVehicle(targetVehicle)

    local timer = 10000 -- 10 seconds
    local engineHealth = 100

    while timer > 0 do
        Citizen.Wait(0)
        DrawSpecialText("You car is ~r~overheating~w~!")
        timer = timer - 10
        engineHealth = engineHealth - 10
        SetVehicleEngineHealth(targetVehicle, engineHealth) -- engine health slowly drop to 0
    end

    -- disable vehicle
    SetVehicleUndriveable(targetVehicle, 1) -- disable car

    --reset variables
    timer = 10000
    engineHealth = 100

end

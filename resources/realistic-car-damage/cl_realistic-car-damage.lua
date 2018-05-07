--# made by: minipunch
--# some more realistic feautres added to vehicles like engine damage to overheat and disable, also keep cars running until turned off with key

local targetVehicle, targetPed
local civEngineOverheatThreshold, copEngineOverheatThreshold = 960.0, 955.0 -- non-severe accidents (busted radiator)
local engineDisabledThreshold = 945.0
--local bodyOverheatThreshold = 255.0
local engineIsOn, savedVehicle

local policeVehicles = {
    1171614426, -- ambulance
    1127131465, -- fbi
    -1647941228, -- fbi2
    1938952078, -- firetruck
    2046537925, -- police
    -1627000575, -- police2
    1912215274, -- police3
    -1973172295, -- police4
    0x9C32EB57, -- Police5
    0xB2FF98F0, -- police 6
    0xC4B53C5B, -- police 7
    0xD0AF544F, -- police 8
    -34623805, -- policeb
    741586030, -- pranger
    -1205689942, -- riot
	-672516475, -- unmarked9
	-1960928017, -- unmarked8
	-59441254, -- unmarked7 (slicktop)
	-1663942570, -- unmarked6
	1109330673, -- unmarked4
	-1285460620, -- unmarked3
	1383443358 -- unmarked1

}

----------------------------------------
-- KEEP VEHICLES ON UNTIL KEY IS USED --
----------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1)
        local userPed = GetPlayerPed(-1)
        --Citizen.Trace("GetVehiclePedIsIn(targetPed, 1) = " .. GetVehiclePedIsIn(userPed, 0))
        --Citizen.Trace("IsVehicleEngineOn(lastVehicle, false) = " .. tostring(IsVehicleEngineOn(lastVehicle, false)))
        if IsPedInAnyVehicle(userPed) then -- ped is in a vehicle
            --Citizen.Trace("ped is in a vehicle")
            savedVehicle = GetVehiclePedIsIn(userPed)
            if IsVehicleEngineOn(GetVehiclePedIsIn(userPed), false) then -- engine is running
                --Citizen.Trace("setting engineIsOn to true with vehicle = " .. GetVehiclePedIsIn(userPed))
                if not engineIsOn then engineIsOn = true end
            end
        else
           --Citizen.Trace("ped not in vehicle")
            if engineIsOn and not IsVehicleEngineOn(savedVehicle, false) then
                --Citizen.Trace("engine should be on.. turning last vehicle engine on")
                --for i = 1, #policeVehicles do
                    --if IsVehicleModel(savedVehicle, policeVehicles[i]) then
                        SetVehicleEngineOn(savedVehicle, true, true, true)
                    --end
              --  end
            end
        end
     end
end)

RegisterNetEvent("vehicle:setEngineStatus")
AddEventHandler("vehicle:setEngineStatus", function(on)
  --print("setting engineIsOn to " .. tostring(on))
  engineIsOn = on
  if engineIsOn then
    local vehicleEngineHealth = GetVehicleEngineHealth(savedVehicle)
    if vehicleEngineHealth > 850 then
        SetVehicleEngineOn(savedVehicle, true, false, false)
        SetVehicleUndriveable(savedVehicle, false)
    else
        TriggerEvent("usa:notify", "Your vehicle is disabled! Can't turn the engine on.")
    end
  end
end)

--------------------
----- HOTWIRE ------
--------------------
RegisterNetEvent("vehicle:hotwire")
AddEventHandler("vehicle:hotwire", function()
  local hotwire_time = 15000
  local me = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(me)
  if IsPedInAnyVehicle(me) and not IsVehicleEngineOn(veh, false) then
    local random = math.random(100)
    --[[
    local anim = {
      dict = "veh@golfcaddy@ds@base",
      name = "pov_hotwire"
    }
    TriggerEvent("usa:playAnimation", anim.name, anim.dict, 10)
    --]]
    TriggerEvent("usa:notify", "Attempting to hotwire vehicle!")
    local start = GetGameTimer()
    while GetGameTimer() < start + hotwire_time do
      Wait(1)
      DrawSpecialText("~y~Hotwiring ~w~[" .. math.ceil((start + hotwire_time - GetGameTimer()) / 1000) .. "s]")
    end
    if random < 30 then
      if IsPedInAnyVehicle(me) and not IsVehicleEngineOn(veh, false) then
        SetVehicleNeedsToBeHotwired(veh, true)
      else
        TriggerEvent("usa:notify", "Not in vehicle!")
      end
    else
      TriggerEvent("usa:notify", "You failed to hotwire the vehicle!")
    end
  else

  end
end)

-- TODO: disable on high body damage! USE: GetVehicleBodyHealth(veh)
Citizen.CreateThread(function()
    local vehicleEngineHealth, vehicleBodyHealth
    while true do
        Wait(1)
        targetPed = GetPlayerPed(-1)
        targetVehicle = GetVehiclePedIsIn(targetPed, 1)
        vehicleEngineHealth = GetVehicleEngineHealth(targetVehicle)
        vehicleBodyHealth = GetVehicleBodyHealth(targetVehicle)
        --print("vehicle body HP: " .. vehicleBodyHealth)
        if targetVehicle and targetPed  and IsPedSittingInVehicle(targetPed, targetVehicle) then
            --if vehicleBodyHealth < bodyOverheatThreshold then
                --print("body health is overheating the vehicle!!")
                --overheatVehicle(targetVehicle)
            if vehicleEngineHealth < engineDisabledThreshold then -- severe vehicle damage
                --print("engine health is overheating the vehicle!!")
                --DrawSpecialTextTimed("Your vehicle was ~r~disabled~w~!", 5)
                SetVehicleUndriveable(targetVehicle, 1) -- disable car
                SetVehicleEngineHealth(targetVehicle, 0.0) -- engine health to 0
            elseif vehicleEngineHealth >= engineDisabledThreshold and vehicleEngineHealth < civEngineOverheatThreshold and not IsPedInAnyPoliceVehicle(targetPed) then -- less severe vehicle damage, non police
                --print("body health is overheating the vehicle!!")
                overheatVehicle(targetVehicle)
            elseif vehicleEngineHealth >= engineDisabledThreshold and vehicleEngineHealth < copEngineOverheatThreshold and IsPedInAnyPoliceVehicle(targetPed) then -- less severe vehicle damage, police
                --print("body health is overheating the vehicle!!")
                overheatVehicle(targetVehicle)
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
        --DrawSpecialText("You car is ~r~overheating~w~!")
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

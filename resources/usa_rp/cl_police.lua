local spawnedCones = {}

RegisterNetEvent("dispatch:setWaypoint")
AddEventHandler("dispatch:setWaypoint", function(targetServerId)
    local targetPed = GetPlayerFromServerId(targetServerId)
    Citizen.Trace("targetPed = " .. targetPed)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(targetPed), false))
    Citizen.Trace("x = " .. x .. ", y = " .. y .. ", z = " .. z)
    ClearGpsPlayerWaypoint()
    SetNewWaypoint(x,y)
    Citizen.Trace("waypoint set!")
end)


-- barrier
RegisterNetEvent('c_setCone')
AddEventHandler('c_setCone', function()
    SetConeOnGround()
end)

RegisterNetEvent('c_removeCones')
AddEventHandler('c_removeCones', function()
    removeCones()
end)

function SetConeOnGround()
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    barrier = GetHashKey("prop_mp_cone_01")
    RequestModel(barrier)
    while not HasModelLoaded(barrier) do
      Citizen.Wait(1)
    end
    local object = CreateObject(barrier, x, y+1, z-1.9, true, true, false) -- x+1
    PlaceObjectOnGroundProperly(object)
    table.insert(spawnedCones, object)
end

function removeCones()
    for i = 1, #spawnedCones do
        local cone = spawnedCones[i]
        SetEntityAsMissionEntity(cone, true, true)
        DeleteObject(cone)
    end
    spawnedCones = {}
end

-- /ticket [id] [amount] [infractions]
RegisterNetEvent("police:ticket")
AddEventHandler("police:ticket", function(amount, reason, fromPlayerId)
    local responded = false
    Citizen.Trace("amount = " .. amount)
    Citizen.Trace("reason = " .. reason)
    DrawTicketNotification(tostring(amount), reason)
    Citizen.CreateThread(function()
        while not responded do
            Citizen.Wait(0)
            DrawSpecialText("Pay ticket of $" .. amount .. "? ~g~Y~w~/~r~N" )
        	if IsControlJustPressed(1, 246) then -- Y key
                Citizen.Trace("player wants to pay ticket!")
                responded = true
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, reason, true) -- remove money & notify officer of signature
            elseif IsControlJustPressed(1, 249) then -- N key
                Citizen.Trace("player does not want to pay ticket!")
                responded = true
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, reason, false) -- notify officer of denial to sign
            end
        end
    end)
end)

RegisterNetEvent("police:notify")
AddEventHandler("police:notify", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end)

RegisterNetEvent("police:getMoneyInput")
AddEventHandler("police:getMoneyInput", function()
    Citizen.CreateThread( function()
            DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
            while true do
                if ( UpdateOnscreenKeyboard() == 1 ) then
                    local input_amount = GetOnscreenKeyboardResult()
                    if ( string.len( input_amount ) > 0 ) then
                        local amount = tonumber( input_amount )
                        if ( amount > 0 ) then
                            -- todo: prevent decimals
                            -- trigger server event to remove money
                            amount = round(amount, 0)
                            TriggerServerEvent("police:seizeCash", amount)
                        end
                        break
                    else
                        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
                    end
                elseif ( UpdateOnscreenKeyboard() == 2 ) then
                    break
                end
            Citizen.Wait( 0 )
        end
    end )
end)

local grabbed_weapons = {}
-- storing / retrieving police weapons from their vehicles
RegisterNetEvent("police:grabWeapon")
AddEventHandler("police:grabWeapon", function(wep_name)
  local weapon = {hash = 0}
  local target_veh = getVehicleInFrontOfUser()
  if isPoliceVehicle(target_veh) and not grabbed_weapons[wep_name] then
    if string.lower(wep_name) == "ar" then
      weapon.hash = -2084633992
    elseif string.lower(wep_name) == "shotgun" then
      weapon.hash = 487013001
    end
    if weapon.hash ~= 0 then
      grabbed_weapons[wep_name] = target_veh
      TriggerEvent("usa:equipWeapon", weapon)
      -- give flashlight:
      GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0x7BC4CDDC)
      GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0xC164F53)
    end
  else
    --print("not a police vehicle!")
    TriggerEvent("usa:notify", "Not a police vehicle or did not store grabbed weapon!")
  end
end)

RegisterNetEvent("police:storeWeapon")
AddEventHandler("police:storeWeapon", function(wep_name)
  local me = GetPlayerPed(-1)
  local weapon = {hash = 0}
  if isPoliceVehicle(getVehicleInFrontOfUser()) then
    if string.lower(wep_name) == "ar" then
      weapon.hash = -2084633992
    elseif string.lower(wep_name) == "shotgun" then
      weapon.hash = 487013001
    end
    if GetSelectedPedWeapon(me) == weapon.hash or HasPedGotWeapon(me, weapon.hash, false) then
      RemoveWeaponFromPed(me, weapon.hash)
      grabbed_weapons[wep_name] = nil
    end
  else
    print("not a police vehicle!")
  end
end)

function isPoliceVehicle(veh_handle)
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
      -1205689942 -- riot
  }
  for i = 1, #policeVehicles do
    if IsVehicleModel(veh_handle, policeVehicles[i]) then
      return true
    end
  end
  return false
end

function getVehicleInFrontOfUser()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 2.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function DrawTicketNotification(amount, reason)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("~y~TICKET: ~w~$" .. amount .. "\n~y~REASON: ~w~" .. reason .. "\nPay? ~g~Y~w~/~r~N")
	DrawNotification(0,1)
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

---------------------------------------------------------------------
-- BAITCAR SCRIPT --
---------------------------------------------------------------------
local isInBaitCar = false
RegisterNetEvent("simp:baitCarDisable")
AddEventHandler("simp:baitCarDisable", function()
	local ped_l = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	if IsPedInAnyVehicle(ped_l, false) then
		print("locking the doors!")
			SetVehicleDoorShut(veh, 0, true)
			SetVehicleDoorShut(veh, 1, true)
			SetVehicleDoorShut(veh, 2, true)
			SetVehicleDoorShut(veh, 3, true)
			SetVehicleDoorShut(veh, 4, true)
			SetVehicleDoorShut(veh, 5, true)
			TaskVehicleTempAction(ped_l, veh, 27, 5000)
			PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
			isInBaitCar = true
			SetVehicleEngineHealth(veh, 0)
			SetVehicleEngineOn(veh, false)
			SetVehicleDoorsLocked(veh, 4)
			SetNotificationTextEntry("STRING")
			AddTextComponentString('~r~WARNING:~s~~n~You are currently inside of a Bait Car, You will be placed under arrest shortly.')
			DrawNotification(true, true)
	end
end)

RegisterNetEvent("simp:baitCarunlock")
AddEventHandler("simp:baitCarunlock", function()
	local ped_l = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	if IsPedInAnyVehicle(ped_l, false) then
			isInBaitCar = false;
			SetVehicleEngineHealth(veh, 150.0)
			SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
			SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1)), 2)
			SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1)), 1)
			SetNotificationTextEntry("STRING")
			AddTextComponentString('~y~Info:~s~~n~Step out of the Vehicle and follow the instructions you are given.')
			DrawNotification(true, true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------
-- BAITCAR SCRIPT CREATED BY TONI MORTON FOR THE FIVEM COMMUNITY, PLEASE GIVE CREDITS TO ME IF YOU USE THIS SCRIPT IN YOUR SERVER.  --
-----------------------------------------------------------------------------------------------------------------------

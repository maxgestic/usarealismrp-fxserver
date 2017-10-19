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

--[[
-- spike strip
RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    SetSpikesOnGround()
end)

function SetSpikesOnGround()
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    spike = GetHashKey("P_ld_stinger_s")
    RequestModel(spike)
    while not HasModelLoaded(spike) do
      Citizen.Wait(1)
    end
    local object = CreateObject(spike, x, y, z-2, true, true, false) -- x+1
    PlaceObjectOnGroundProperly(object)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local vehCoord = GetEntityCoords(veh)
    if IsPedInAnyVehicle(ped, false) then
      if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
         SetVehicleTyreBurst(veh, 0, true, 1000.0)
         SetVehicleTyreBurst(veh, 1, true, 1000.0)
         SetVehicleTyreBurst(veh, 2, true, 1000.0)
         SetVehicleTyreBurst(veh, 3, true, 1000.0)
         SetVehicleTyreBurst(veh, 4, true, 1000.0)
         SetVehicleTyreBurst(veh, 5, true, 1000.0)
         SetVehicleTyreBurst(veh, 6, true, 1000.0)
         SetVehicleTyreBurst(veh, 7, true, 1000.0)
         RemoveSpike()
       end
     end
   end
end)

function RemoveSpike()
   local ped = GetPlayerPed(-1)
   local veh = GetVehiclePedIsIn(ped, false)
   local vehCoord = GetEntityCoords(veh)
   if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
      spike = GetClosestObjectOfType(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), false, false, false)
      SetEntityAsMissionEntity(spike, true, true)
      DeleteObject(spike)
   end
end
--]]

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
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, true) -- remove money & notify officer of signature
            elseif IsControlJustPressed(1, 249) then -- N key
                Citizen.Trace("player does not want to pay ticket!")
                responded = true
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, false) -- notify officer of denial to sign
            end
        end
    end)
end)

RegisterNetEvent('Radio')
AddEventHandler('Radio', function()
local ped = GetPlayerPed( -1 )
if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
Citizen.CreateThread( function()
	RequestAnimDict( "random@arrests" )
	   while ( not HasAnimDictLoaded( "random@arrests" ) ) do
                Citizen.Wait( 100 )
            end
				if IsEntityPlayingAnim(ped, "random@arrests", "generic_radio_chatter", 3) then
				ClearPedSecondaryTask(ped)
				SetCurrentPedWeapon(ped, GetHashKey("GENERIC_RADIO_CHATTER"), true)
				else
				TaskPlayAnim(ped, "random@arrests", "generic_radio_chatter", 8.0, 2.5, -1, 49, 0, 0, 0, 0 )
				SetCurrentPedWeapon(ped, GetHashKey("GENERIC_RADIO_CHATTER"), true)
            end
        end )
    end
end )

RegisterNetEvent("police:notify")
AddEventHandler("police:notify", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end)

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

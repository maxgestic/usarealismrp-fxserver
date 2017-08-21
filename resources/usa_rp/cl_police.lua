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

-- /ticket
RegisterNetEvent("police:ticket")
AddEventHandler("police:ticket", function(amount, reason, fromPlayerId)
    local responded = false
    Citizen.Trace("amount = " .. amount)
    Citizen.Trace("reason = " .. reason)
    DrawTicketNotification(tostring(amount), reason)
    Citizen.CreateThread(function()
        while not responded do
            Citizen.Wait(1)
            DrawSpecialText("Pay ticket of $" .. amount .. "? ~g~Y~w~/~r~N" )
        	if IsControlJustPressed(1, 246) then -- Y key
                Citizen.Trace("player wants to pay ticket!")
                responded = not responded
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, true) -- remove money & notify officer of signature
            elseif IsControlJustPressed(1, 249) then -- N key
                Citizen.Trace("player does not want to pay ticket!")
                responded = not responded
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, false) -- notify officer of denial to sign
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

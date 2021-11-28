local STINGER_MODEL_HASH = GetHashKey("P_ld_stinger_s")

local placedStrips = {}

Citizen.CreateThread(function()
  while true do
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local myVehCoords = GetEntityCoords(veh)
    local didPop = false
    for i = #placedStrips, 1, -1 do
      local dist = Vdist(myVehCoords, placedStrips[i].x, placedStrips[i].y, placedStrips[i].z)
      if dist < 2.0 then
        local numTiresToPop = math.random(1, 4)
        for j = 1, numTiresToPop do
          local randomTireToPop = math.random(1, 7)
          if not IsVehicleTyreBurst(veh, randomTireToPop, false) then
            SetVehicleTyreBurst(veh, randomTireToPop, false, 1000.0)
            didPop = true
          end
        end
      end
    end
    if didPop then
      Wait(5000)
    else
      Wait(5)
    end
  end
end)

RegisterNetEvent("spikestrips:updateStrips")
AddEventHandler("spikestrips:updateStrips", function(placedStripsFromServer)
  placedStrips = {}
  placedStrips = placedStripsFromServer
end)

TriggerServerEvent("spikestrips:requestUpdate") -- load on join
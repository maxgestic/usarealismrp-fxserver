local STINGER_MODEL_HASH = GetHashKey("P_ld_stinger_s")

Citizen.CreateThread(function()
  while true do
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and DoesEntityExist(veh) then
      local vehCoord = GetEntityCoords(veh)
      if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 1.2, STINGER_MODEL_HASH, true) then
        for i = 1, 7 do
          if not IsVehicleTyreBurst(veh, i, false) then
            SetVehicleTyreBurst(veh, i, false, 1000.0)
          end
        end
      end
    end
    Wait(5)
  end
end)
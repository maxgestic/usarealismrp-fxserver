RegisterServerEvent("warp:checkJob")
AddEventHandler("warp:checkJob", function(locationCoords)
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_job = user.getActiveCharacterData("job")
    if user_job == "sheriff" or user_job == "ems" or user_job == "fire" then
      TriggerClientEvent("warp:warpToPoint", userSource, locationCoords)
    else
      TriggerClientEvent("usa:notify", userSource, "That area is prohibited!")
      print("user tried to enter prohibited area! job was: " .. user_job)
    end
  end)
end)

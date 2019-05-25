RegisterServerEvent("warp:checkJob")
AddEventHandler("warp:checkJob", function(locationCoords, locationHeading, jobAccess)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if jobAccess == 'emergency' then
    if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "doctor" then
    	local x, y, z = table.unpack(locationCoords)
      TriggerClientEvent("warp:warpToPoint", userSource, x, y, z, locationHeading)
      return
    end
  elseif jobAccess == 'da' then
    local da_rank = user.getActiveCharacterData('daRank')
    if da_rank and da_rank > 0 then
      local x, y, z = table.unpack(locationCoords)
      TriggerClientEvent("warp:warpToPoint", userSource, x, y, z, locationHeading)
      return
    end
  end
  TriggerClientEvent("usa:notify", userSource, "That area is prohibited!")
  print("user tried to enter prohibited area! job was: " .. user_job)
end)

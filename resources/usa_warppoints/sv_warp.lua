RegisterServerEvent("warp:checkJob")
AddEventHandler("warp:checkJob", function(locationCoords, locationHeading, jobAccess)
  local char = exports["usa-characters"]:GetCharacter(source)
  local job = char.get("job")
  if jobAccess == 'emergency' then
    if job == "sasp" or job == "ems" or job == "fire" or job == "doctor" or job == "corrections" or job == "bcso" then
    	local x, y, z = table.unpack(locationCoords)
      TriggerClientEvent("warp:warpToPoint", source, x, y, z, locationHeading)
      return
    end
  elseif jobAccess == 'da' then
    local da_rank = char.get('daRank')
    if da_rank and da_rank > 0 then
      local x, y, z = table.unpack(locationCoords)
      TriggerClientEvent("warp:warpToPoint", source, x, y, z, locationHeading)
      return
    end
  end
  TriggerClientEvent("usa:notify", source, "That area is prohibited!")
end)

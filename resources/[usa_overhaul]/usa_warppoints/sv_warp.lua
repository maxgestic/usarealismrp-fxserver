RegisterServerEvent("warp:checkJob")
AddEventHandler("warp:checkJob", function(locationCoords, locationHeading)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "doctor" then
  	local x, y, z = table.unpack(locationCoords)
    TriggerClientEvent("warp:warpToPoint", userSource, x, y, z, locationHeading)
  else
    TriggerClientEvent("usa:notify", userSource, "That area is prohibited!")
    print("user tried to enter prohibited area! job was: " .. user_job)
  end
end)

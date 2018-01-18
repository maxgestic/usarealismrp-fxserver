TriggerEvent('es:addCommand', 'place', function(source, args, user)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local user_job = user.getActiveCharacterData("job")
    if user_job == "sheriff" or user_job == "ems" or user_job == "fire" then
      local tPID = tonumber(args[2])
      TriggerClientEvent("place", tPID)
    else
      TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "place")
    end
  end)
end)

RegisterServerEvent("place:placePerson")
AddEventHandler("place:placePerson", function(targetId)
    TriggerClientEvent("place", targetId)
end)

RegisterServerEvent("place:unseatPerson")
AddEventHandler("place:unseatPerson", function(targetId)
    TriggerClientEvent("place:unseat", targetId, source)
end)

-- unseat
TriggerEvent('es:addCommand', 'unseat', function(source, args, user)
  local user_job = user.getActiveCharacterData("job")
    if user_job == "sheriff" or user_job == "cop" or user_job == "ems" or user_job == "fire" then
        local targetPlayer = args[2]
	    TriggerClientEvent("place:unseat", targetPlayer, source)
    else
      if targetPlayer ~= source then
        TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "unseat")
      end
    end
end)

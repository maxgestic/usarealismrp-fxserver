TriggerEvent('es:addCommand', 'place', function(source, args, user)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if user.getJob() == "sheriff" or user.getJob() == "ems" or user.getJob() == "fire" then
             local tPID = tonumber(args[2])
             TriggerClientEvent("place", tPID)
        else
            TriggerClientEvent("place:invalidCommand", source, "Only ^3law enforcement/EMS ^0can use /place!")
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
    if user.getJob() == "sheriff" or user.getJob() == "cop" or user.getJob() == "ems" or user.getJob() == "fire" then
        local targetPlayer = args[2]
	    TriggerClientEvent("place:unseat", targetPlayer, source)
    end
end)

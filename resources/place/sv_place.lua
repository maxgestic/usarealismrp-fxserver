TriggerEvent('es:addCommand', 'place', function(source, args, user, location)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_job = user.getActiveCharacterData("job")
		if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
			local tPID = tonumber(args[2])
			TriggerClientEvent("place", tPID)
			TriggerClientEvent('chatMessageLocation', -1, "", {255, 0, 0}, " ^6" .. user.getActiveCharacterData("fullName") .. " places person in vehicle.", location)
		else
			TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "place")
		end
	end)
end, {
	help = "Place tied or handcuffed player in a car",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

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
	if user_job == "sheriff" or user_job == "cop" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
		local targetPlayer = args[2]
		TriggerClientEvent("place:unseat", targetPlayer, source)
	else
		if targetPlayer ~= source then
			TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "unseat")
		end
	end
end, {
	help = "Take a tied up or handcuffed player out of a car",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

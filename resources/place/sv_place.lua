TriggerEvent('es:addCommand', 'place', function(source, args, user, location)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
		local tPID = tonumber(args[2])
		if draggedPlayers[usource] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source)
		end
		TriggerClientEvent("place", tPID)
		TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source)
		local msg = "Places person in vehicle."
		exports["globals"]:sendLocalActionMessage(usource, msg)
	else
		if draggedPlayers[usource] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source)
		end
		TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "place")
	end
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
		local msg = "Removes from vehicle."
		exports["globals"]:sendLocalActionMessage(source, msg)
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

draggedPlayers = {}
local awaitingUpdates = false

TriggerEvent('es:addCommand', 'place', function(source, args, user, location)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
		local tPID = tonumber(args[2])
		awaitingUpdates = true
		TriggerEvent('drag:passTable', 'place:updateDragTable', function()
			while awaitingUpdates do
				Citizen.Wait(100)
			end
			if draggedPlayers[usource] == tonumber(args[2]) then
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource, true)
				TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), usource, true)
				draggedPlayers[usource] = nil
				TriggerEvent('place:returnUpdatedTable', draggedPlayers)
			end
			TriggerClientEvent("place", tPID)
			local msg = "places person in vehicle"
			exports["globals"]:sendLocalActionMessage(usource, msg)
		end)
	else
		if draggedPlayers[usource] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), usource, true)
			draggedPlayers[usource] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "place")
	end
end, {
	help = "Place tied or handcuffed player in a car",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addJobCommand', 'placef', {'sheriff', 'police', 'ems', 'fire', 'corrections'}, function(source, args, user, location)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local tPID = tonumber(args[2])
	awaitingUpdates = true
	TriggerEvent('drag:passTable', 'place:updateDragTable', function()
		while awaitingUpdates do
			Citizen.Wait(100)
		end
		if draggedPlayers[usource] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), usource, true)
			draggedPlayers[usource] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("place", tPID, true)
		local msg = "places person in vehicle"
		exports["globals"]:sendLocalActionMessage(usource, msg)
	end)
end, {
	help = "Place handcuffed player in a car front seat",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addCommand', 'placet', function(source, args, user, location)
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local tPID = tonumber(args[2])
	awaitingUpdates = true
	TriggerEvent('drag:passTable', 'place:updateDragTable', function()
		while awaitingUpdates do
			Citizen.Wait(100)
		end
		if draggedPlayers[usource] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), usource, true)
			draggedPlayers[usource] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("crim:areHandsTied", tonumber(args[2]), source, tonumber(args[2]), "placet")
		local msg = "places person in trunk"
		exports["globals"]:sendLocalActionMessage(usource, msg)
	end)
end, {
	help = "Place tied up player in a car trunk",
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
		local msg = "removes from vehicle"
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

RegisterServerEvent('place:updateDragTable')
AddEventHandler('place:updateDragTable', function(table)
	draggedPlayers = table
	awaitingUpdates = false
end)
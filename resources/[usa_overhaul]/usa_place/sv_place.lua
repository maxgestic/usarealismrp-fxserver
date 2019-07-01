draggedPlayers = {}
local awaitingUpdates = false

TriggerEvent('es:addCommand', 'place', function(source, args, char, location)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "corrections" or user_job == "dai" then
		local tPID = tonumber(args[2])
		awaitingUpdates = true
		TriggerEvent('drag:passTable', 'place:updateDragTable', function()
			while awaitingUpdates do
				Citizen.Wait(100)
			end
			if draggedPlayers[source] == tonumber(args[2]) then
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source, true)
				TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), source, true)
				draggedPlayers[source] = nil
				TriggerEvent('place:returnUpdatedTable', draggedPlayers)
			end
			TriggerClientEvent("place", tPID)
			local msg = "places person in vehicle"
			exports["globals"]:sendLocalActionMessage(source, msg)
		end)
	else
		if draggedPlayers[source] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), source, true)
			draggedPlayers[source] = nil
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

TriggerEvent('es:addJobCommand', 'placef', {'sheriff', 'police', 'ems', 'fire', 'corrections', 'dai'}, function(source, args, char, location)
	local tPID = tonumber(args[2])
	awaitingUpdates = true
	TriggerEvent('drag:passTable', 'place:updateDragTable', function()
		while awaitingUpdates do
			Citizen.Wait(100)
		end
		if draggedPlayers[source] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), source, true)
			draggedPlayers[source] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("place", tPID, true)
		local msg = "places person in vehicle"
		exports["globals"]:sendLocalActionMessage(source, msg)
	end)
end, {
	help = "Place handcuffed player in a car front seat",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addCommand', 'placet', function(source, args, char, location)
	if args[2] and tonumber(args[2]) then
		local tPID = tonumber(args[2])
		awaitingUpdates = true
		TriggerEvent('drag:passTable', 'place:updateDragTable', function()
			while awaitingUpdates do
				Citizen.Wait(100)
			end
			if draggedPlayers[source] == tPID then
				TriggerClientEvent('drag:dragPlayer', tPID, source, true)
				TriggerClientEvent('drag:carryPlayer', tPID, source, true)
				draggedPlayers[source] = nil
				TriggerEvent('place:returnUpdatedTable', draggedPlayers)
			end
			TriggerClientEvent("crim:areHandsTied", tPID, source, tPID, "placet")
			local msg = "places person in trunk"
			exports["globals"]:sendLocalActionMessage(source, msg)
		end)
	end
end, {
	help = "Place tied up player in a car trunk",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

RegisterServerEvent("place:placePerson")
AddEventHandler("place:placePerson", function(targetId)
	awaitingUpdates = true
	TriggerEvent('drag:passTable', 'place:updateDragTable', function()
		while awaitingUpdates do
			Wait(100)
		end
		if draggedPlayers[source] == targetId then
			TriggerClientEvent('drag:dragPlayer', targetId, source, true)
			TriggerClientEvent('drag:carryPlayer', targetId, source, true)
			draggedPlayers[source] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("place", targetId)
	end)
end)

RegisterServerEvent("place:unseatPerson")
AddEventHandler("place:unseatPerson", function(targetId)
	TriggerClientEvent("place:unseat", targetId, source)
end)

-- unseat
TriggerEvent('es:addCommand', 'unseat', function(source, args, char)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "cop" or user_job == "ems" or user_job == "fire" or user_job == "corrections" or user_job == "dai" then
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

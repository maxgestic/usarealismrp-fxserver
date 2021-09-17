draggedPlayers = {}

TriggerEvent('es:addCommand', 'place', function(src, args, char, location)
	local user_job = char.get("job")
	local tPID = tonumber(args[2])
	TriggerEvent('drag:getTable', function(table)
		draggedPlayers = table
		if draggedPlayers[src] == tPID then
			TriggerClientEvent('drag:dragPlayer', tPID, src, true)
			TriggerClientEvent('drag:carryPlayer', tPID, src, true)
			draggedPlayers[src] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		if user_job == "sheriff" or user_job == "ems" or user_job == "corrections" then
			TriggerClientEvent("place:place", tPID, "any", true, src)
		else
			TriggerClientEvent("place:place", tPID, "any", false, src)
		end
	end)
end, {
	help = "Place tied or handcuffed player in a car",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addJobCommand', 'placef', {'sheriff', 'ems', 'fire', 'corrections'}, function(src, args, char, location)
	local tPID = tonumber(args[2])
	TriggerEvent('drag:getTable', function(table)
		draggedPlayers = table
		if draggedPlayers[src] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), src, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), src, true)
			draggedPlayers[src] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("place:place", tPID, "front", true, src)
		local msg = "places person in vehicle"
		exports["globals"]:sendLocalActionMessage(src, msg)
	end)
end, {
	help = "Place handcuffed player in a car front seat",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addJobCommand', 'placeb', {'sheriff', 'ems', 'fire', 'corrections'}, function(src, args, char, location)
	local tPID = tonumber(args[2])
	TriggerEvent('drag:getTable', function(table)
		draggedPlayers = table
		if draggedPlayers[src] == tonumber(args[2]) then
			TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), src, true)
			TriggerClientEvent('drag:carryPlayer', tonumber(args[2]), src, true)
			draggedPlayers[src] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		TriggerClientEvent("place:place", tPID, "back", true, src)
		local msg = "places person in vehicle"
		exports["globals"]:sendLocalActionMessage(src, msg)
	end)
end, {
	help = "Place handcuffed player in a car's back seat",
	params = {
		{ name = "id", help = "Players ID" }
	}
})

TriggerEvent('es:addCommand', 'placet', function(source, args, char, location) -- todo
	if args[2] and tonumber(args[2]) then
		local tPID = tonumber(args[2])
		TriggerEvent('drag:getTable', function(table)
			draggedPlayers = table
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

RegisterServerEvent("place:notifyPlacer")
AddEventHandler("place:notifyPlacer", function(placerID, msg)
	TriggerClientEvent("usa:notify", placerID, msg)
end)

RegisterServerEvent("place:placePerson")
AddEventHandler("place:placePerson", function(targetId)
	local src = source
	TriggerEvent('drag:getTable', function(table)
		draggedPlayers = table
		if draggedPlayers[src] == targetId then
			TriggerClientEvent('drag:dragPlayer', targetId, src, true)
			TriggerClientEvent('drag:carryPlayer', targetId, src, true)
			draggedPlayers[src] = nil
			TriggerEvent('place:returnUpdatedTable', draggedPlayers)
		end
		local c = exports["usa-characters"]:GetCharacter(source)
		local cJob = c.get("job")
		if cJob == "ems" or cJob == "sheriff" or cJob == "corrections" then
			TriggerClientEvent("place:place", targetId, "any", true, src)
		else 
			TriggerClientEvent("place:place", targetId, "any", false, src)
		end
	end)
end)

RegisterServerEvent("place:unseatPerson")
AddEventHandler("place:unseatPerson", function(targetId)
	local c = exports["usa-characters"]:GetCharacter(source)
	local cJob = c.get("job")
	if cJob == "sheriff" or cJob == "corrections" or cJob == "ems" then
		TriggerClientEvent("place:unseat", targetId, source, true)
	else
		TriggerClientEvent("place:unseat", targetId, source, false)
	end
end)

-- unseat
TriggerEvent('es:addCommand', 'unseat', function(source, args, char)
	local user_job = char.get("job")
	local targetPlayer = args[2]
	if targetPlayer ~= source then
		if user_job == "sheriff" or user_job == "ems" or user_job == "corrections" then
			TriggerClientEvent("place:unseat", targetPlayer, source, true)
			local msg = "removes from vehicle"
			exports["globals"]:sendLocalActionMessage(source, msg)
		else
			TriggerClientEvent("place:unseat", targetPlayer, source, false)
		end
	end
end, {
	help = "Take a tied up or handcuffed player out of a car",
	params = {
		{ name = "id", help = "Players ID" }
	}
})
AddEventHandler("search:searchPlayer", function(source, playerId)
	TriggerEvent('es:getPlayerFromId', tonumber(playerId), function(user)
		if not user then
			TriggerClientEvent("search:notifyNoExist", source, playerId) -- player does not exist
			return
		end
		local items = {}
		local licenses = user.getLicenses()
		for index = 1, #licenses do
			if licenses[index].name == "Driver's License" then
				table.insert(items, licenses[index])
			end
		end
		local playerInventory = user.getInventory()
		for i = 1, #playerInventory do
			table.insert(items, playerInventory[i])
		end
		local playerWeapons = user.getWeapons()
		for j = 1, #playerWeapons do
			table.insert(items, playerWeapons[j])
		end
			TriggerClientEvent("chatMessage", source, "SYSTEM", {255,136,0}, "SEARCH OF " .. GetPlayerName(playerId) .. ":")
			for i = 1, #items do
				local name = items[i].name
				local quantity = items[i].quantity
				local legality = items[i].legality
				if legality == "illegal" then
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1(x" .. quantity .. ") " .. name) -- print inventory (red text)
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "(x" .. quantity .. ") " .. name) -- print inventory
				end
			end
	end)
end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'search', function(source, args, user)
	local argument = args[2] -- player id to search
	if argument == nil or type(tonumber(argument)) == nil then
		TriggerClientEvent("search:help", source)
	elseif user.getJob() ~= "cop" and user.getJob() ~= "sheriff" and user.getJob() ~= "highwaypatrol" then
		TriggerClientEvent("search:failureNotJurisdiction", source)
	else -- player is a cop, so allow search and perform search with argument = player id to search
		TriggerEvent("search:searchPlayer", source, argument)
	end
end)

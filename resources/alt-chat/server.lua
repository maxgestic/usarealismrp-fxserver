TriggerEvent('es:addCommand', 'ooc', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "[OOC] - " .. GetPlayerName(source), {88, 193, 221}, message)
end)

TriggerEvent('es:addCommand', 'OOC', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "[OOC] - " .. GetPlayerName(source), {88, 193, 221}, message)
end)

TriggerEvent('es:addCommand', 'ad', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. GetPlayerName(source), {171, 67, 227}, message)
end)

TriggerEvent('es:addCommand', 'AD', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. GetPlayerName(source), {171, 67, 227}, message)
end)

TriggerEvent('es:addCommand', 'showid', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
	TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
end)

TriggerEvent('es:addCommand', 'SHOWID', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
	TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
end)

TriggerEvent('es:addCommand', '911', function(source, args, user)
	local userSource = source
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				local job = user.getJob()
				if (job == "sheriff" or job == "ems" or job == "fire" and k ~= userSource) then
					TriggerClientEvent('chatMessage', k, "[Caller (" .. userSource .. "): " .. GetPlayerName(userSource) .. "]", {255, 24, 25}, message)
				end
			end)
		end
	end)
end)

TriggerEvent('es:addCommand', 'dispatch', function(source, args, user)
	TriggerClientEvent('chatMessage', args[2], "[DISPATCH]", {255, 24, 25}, message)
end)

TriggerEvent('es:addCommand', 'me', function(source, args, user)
	table.remove(args,1)
    TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " " .. table.concat(args, " "))
end)

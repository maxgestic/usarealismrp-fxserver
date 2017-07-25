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

TriggerEvent('es:addCommand', 'me', function(source, args, user)
	table.remove(args,1)
    TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " " .. table.concat(args, " "))
end)

-- 911 DISPATCH
TriggerEvent('es:addCommand', 'dispatch', function(source, args, user)
	local userSource = source
	local target = args[2]
	table.remove(args,1)
	table.remove(args,1)
	TriggerClientEvent('chatMessage', target, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
	TriggerClientEvent('chatMessage', userSource, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
end)

-- 911 CALL
TriggerEvent('es:addCommand', '911', function(source, args, user)
	local userSource = source
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', userSource, "911 (Caller: " .. userSource .. ")", {255, 20, 10}, table.concat(args, " "))
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getJob() == "sheriff" or player.getJob() == "ems" then
				TriggerClientEvent('chatMessage', playerSource, "911 (Caller: " .. userSource .. ")", {255, 20, 10}, table.concat(args, " "))
			end
		end
	end)
end)

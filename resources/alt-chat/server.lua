local function power(a, b)
	return a ^ b
	end

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(power(x1 - x2, 2) + power(y1 - y2, 2) + power(z1 - z2, 2))
end

RegisterNetEvent('altchat:localChatMessage')
AddEventHandler('altchat:localChatMessage', function(source, msg)
	--print(GetPlayerName(source))
	--local msg = table.concat(args, " ")
	--local sender = GetPlayerName(source)
	if msg then
		TriggerEvent('es:getPlayerFromId', source, function(user)
			if user then
				local mPos = user.getCoords()
				TriggerEvent('es:getPlayers', function(users)
					for k,v in pairs(users)do
						local tPos = v.getCoords()

						if get3DDistance(tPos.x, tPos.y, tPos.z, mPos.x, mPos.y, mPos.z) < 20.0 then
						TriggerClientEvent('chatMessage', k, "", {0, 0, 0}, msg)

						end
					end
				end)
			end
		end)
	end
end)

TriggerEvent('es:addCommand', 'o', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "[OOC] - " .. GetPlayerName(source), {88, 193, 221}, message)
end)

RegisterNetEvent('altchat:chatMessageEntered')
AddEventHandler('altchat:chatMessageEntered', function(name, color, message)
	--print(GetPlayerName(source))
	--local msg = table.concat(args, " ")
	--local sender = GetPlayerName(source)
	TriggerClientEvent('chatMessage', -1, "[OOC] - " .. name, {88, 193, 221}, message)
end)


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
	--TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
	--TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
	TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " shows ID.")
	TriggerEvent('altchat:localChatMessage', source, "^6[ID] ^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
end)

TriggerEvent('es:addCommand', 'SHOWID', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	--TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
	--TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
	TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " shows ID.")
	TriggerEvent('altchat:localChatMessage', source, "^6[ID] ^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
end)

TriggerEvent('es:addCommand', 'showbadge', function(source, args, user)
	table.remove(args, 1)
	message = table.concat(args, " ")
	--TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
	--TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
	TriggerEvent("es:getPlayerFromId", tonumber(source), function(user)
		if(user)then
			if user.getPoliceRank() > 0 then
				local policeRanks = {
					"Probationary Officer" ,
					"Police Officer 1" ,
					"Police Officer 2" ,
					"Sergaent" ,
					"Lieutenant" ,
					"Captain" ,
					"Deputy Chief" ,
					"Chief of Police"
				}
				TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " shows Badge.")
				TriggerEvent('altchat:localChatMessage', source, "^6[ID] ^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2Rank: ^4" .. policeRanks[user.getPoliceRank()])
				--user.setEMSRank(1)
				--RconPrint("DEBUG: " .. playerId .. " whitelisted as EMS")
				--TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "You have been whitelist as EMS")
			else
				TriggerClientEvent('chatMessage', tonumber(source), "", {0, 0, 0}, "^3You're not whitelisted to use the command.")
			end
		end
	end)


end)

TriggerEvent('es:addCommand', 'me', function(source, args, user)
	table.remove(args,1)
    --TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " " .. table.concat(args, " "))
	--print(GetPlayerName(source))
	TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " " .. table.concat(args, " "))
end)

-- 911 CALL
TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {0, 0, 0}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
	--[[
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
	--]]
end)

-- /tweet
TriggerEvent('es:addCommand', 'tweet', function(source, args, user)
	table.remove(args,1)
    TriggerClientEvent('chatMessage', -1, "[TWEET] - " .. GetPlayerName(source), {29,161,242}, table.concat(args, " "))
	--print(GetPlayerName(source))
end)

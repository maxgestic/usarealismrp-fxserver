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

RegisterNetEvent('altchat:chatMessageEntered')
AddEventHandler('altchat:chatMessageEntered', function(name, color, message)
	--print(GetPlayerName(source))
	--local msg = table.concat(args, " ")
	--local sender = GetPlayerName(source)
	TriggerClientEvent('chatMessage', -1, "[OOC] - " .. name .. "(#" .. source .. ")", {88, 193, 221}, message)
end)

-- 911 CALL
TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {0, 0, 0}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
end)

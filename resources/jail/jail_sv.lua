function table_copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

-- V2
TriggerEvent('es:addCommand', 'jail', function(source, args, user)
	if user.getJob() == "sheriff" or user.getJob() == "cop" then
		TriggerClientEvent("jail:openMenu", tonumber(source))
	else
		TriggerClientEvent("jail:notify", tonumber(source), "You have ~y~" .. user.getJailtime() .. " month(s) ~w~left in your jail sentence.")
	end
end)

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	local userSource = tonumber(source)
	print("jailing player...")
	print("data.sentence = " .. data.sentence)
	print("data.charges = " .. data.charges)
	print("data.id = " .. data.id)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		if user.getJob() == "sheriff" or user.getJob() == "cop" then
			local arrestingOfficerName = GetPlayerName(userSource)
			jailPlayer(data, arrestingOfficerName)
		end
	end)
end)

function jailPlayer(data, officerName)
	local targetPlayer = tonumber(data.id)
	if not targetPlayer then TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0You did not enter a player to jail!") return end
	local sentence = tonumber(data.sentence)
	local reason = data.charges
	if sentence == nil then
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0YOU FORGOT TO ADD THE JAIL TIME SILLY GOOSE!!")
		CancelEvent()
		return
	end
	TriggerEvent("es:getPlayerFromId", targetPlayer, function(user)
		-- jail player
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, GetPlayerName(targetPlayer) .. " has been jailed for ^3" .. sentence .. "^0 month(s).")
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, "Charges: " .. reason)
		TriggerClientEvent("jail:jail", targetPlayer)
		-- remove items from player
		TriggerClientEvent("jail:removeWeapons", targetPlayer) -- take from ped
		user.setWeapons({})
		user.setInventory({})
		user.setJailtime(sentence)
		-- add to criminal history
		local playerCriminalHistory = user.getCriminalHistory()
		local record = {
			sentence = sentence,
			charges = reason,
			arrestingOfficer = officerName,
			timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
		}
		table.insert(playerCriminalHistory, record)
		user.setCriminalHistory(playerCriminalHistory)
		-- give inmate clothing
		TriggerClientEvent("jail:changeClothes", targetPlayer)
		-- send to discord #jail-logs
		local url = 'https://discordapp.com/api/webhooks/343037167821389825/yDdmSBi-ODYPcAbTzb0DaPjWPnVOhh232N78lwrQvlhbrvN8mV5TBfNOmnxwMZfQnttl'
		PerformHttpRequest(url, function(err, text, headers)
			if text then
				print(text)
			end
		end, "POST", json.encode({
			embeds = {
				{
					description = "**Name:** " ..GetPlayerName(targetPlayer).. " \n**Sentence:** " .. sentence .. " months" .. " \n**Charges:** " ..reason.. "\n**Arresting Officer:** " ..officerName.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
					color = 263172,
					author = {
						name = "LS Correctional Facility"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json' })
	end)
end

function jailStatusLoop()
	SetTimeout(60000, function()
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					if player then
						if player.getJailtime() == 0 then
							-- do nothing?
						else
							if player.getJailtime() > 1 then
								player.setJailtime(player.getJailtime() - 1)
							else
								player.setJailtime(player.getJailtime() - 1)
								print("player jail time was 0!! release this player!!")
								TriggerClientEvent("jail:release", tonumber(id), player.getCharacters())
							end
						end
					end
				end
			end
		end)
		print("calling jail status loop again!")
		jailStatusLoop()
	end)
end

jailStatusLoop()

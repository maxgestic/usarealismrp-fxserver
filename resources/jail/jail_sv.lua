function table_copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

-- V2
TriggerEvent('es:addCommand', 'jail', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	local user_jailtime = user.getActiveCharacterData("jailtime")
	if user_job == "sheriff" or user_job == "cop" then
		TriggerClientEvent("jail:openMenu", tonumber(source))
	else
		TriggerClientEvent("jail:notify", tonumber(source), "You have ~y~" .. user_jailtime .. " month(s) ~w~left in your jail sentence.")
	end
end, {
	help = "See how much time you have left in jail / jail a player (police)."
})

RegisterServerEvent("jail:jailPlayerFromMenu")
AddEventHandler("jail:jailPlayerFromMenu", function(data)
	local userSource = tonumber(source)
	print("jailing player...")
	print("data.sentence: " .. data.sentence)
	print("data.charges: " .. data.charges)
	print("data.id: " .. data.id)
	print("data.fine: " .. data.fine)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user_job = user.getActiveCharacterData("job")
		local player_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		if user_job == "sheriff" or user_job == "cop" then
			local arrestingOfficerName = player_name
			jailPlayer(data, arrestingOfficerName)
		end
	end)
end)

function jailPlayer(data, officerName)
	local targetPlayer = tonumber(data.id)
	if not targetPlayer then TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0You did not enter a player to jail!") return end
	local sentence = tonumber(data.sentence)
	local reason = data.charges
	local fine = data.fine
	if sentence == nil then
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0YOU FORGOT TO ADD THE JAIL TIME SILLY GOOSE!!")
		CancelEvent()
		return
	elseif not tonumber(fine) then
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1Error: ^0Invalid input for fine!")
		CancelEvent()
		return
	end
	if tonumber(fine) then
		fine = tonumber(fine)
		fine = round(fine, 0)
		print("after rounding, fine: " .. fine)
	end
	TriggerEvent("es:getPlayerFromId", targetPlayer, function(user)
		-- jail player
		local inmate_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, inmate_name .. " has been jailed for ^3" .. sentence .. "^0 month(s).")
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, "Charges: " .. reason)
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255,180,0}, "Fine: $" .. fine)
		TriggerClientEvent("jail:jail", targetPlayer)
		-- remove items from player
		TriggerClientEvent("jail:removeWeapons", targetPlayer) -- take from ped
		user.setActiveCharacterData("weapons", {})
		user.setActiveCharacterData("jailtime", sentence)
		-- fine the player using amount supplied from the form
		local user_bank = user.getActiveCharacterData("bank")
		local bank_after_fine = user_bank - fine
		if  bank_after_fine >= 0 then
			user.setActiveCharacterData("bank", user_bank - fine)
		else
			user.setActiveCharacterData("bank", 0)
		end
		-- notify of fine:
		TriggerClientEvent("usa:notify", targetPlayer, "You have been fined: $" .. fine)
		-- add to criminal history
		local playerCriminalHistory = user.getActiveCharacterData("criminalHistory")
		local record = {
			sentence = sentence,
			charges = reason,
			arrestingOfficer = officerName,
			timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
		}
		table.insert(playerCriminalHistory, record)
		user.setActiveCharacterData("criminalHistory", playerCriminalHistory)
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
					description = "**Name:** " .. inmate_name .. " \n**Sentence:** " .. sentence .. " months" .. " \n**Charges:** " ..reason.. "\n**Fine:** $" .. fine .. "\n**Arresting Officer:** " ..officerName.."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
					color = 263172,
					author = {
						name = "LS Correctional Facility"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json' })
		-- remove any active warrants:
		TriggerEvent("warrants:removeAnyActiveWarrants", inmate_name)
	end)
end

function jailStatusLoop()
	SetTimeout(60000, function()
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					if player then
					local player_jailtime = player.getActiveCharacterData("jailtime")
					if not player_jailtime then
						player_jailtime = 0
					end
						if player_jailtime == 0 then
							-- do nothing?
						else
							if player_jailtime > 1 then
								player.setActiveCharacterData("jailtime", player_jailtime - 1)
							else
								player.setActiveCharacterData("jailtime", player_jailtime - 1)
								print("player jail time was 0!! release this player!!")
								local chars = player.getCharacters()
								for i = 1, #chars do
									if chars[i].active == true then
										print("found an active char to release with...")
										TriggerClientEvent("jail:release", tonumber(id), chars[i].appearance) -- need to test
										break
									end
								end
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

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

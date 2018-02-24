RegisterServerEvent('HOSPITAL:released')

AddEventHandler('HOSPITAL:released', function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {200,0,0}, name .. " has been given a new life.")
	end)
end)

RegisterServerEvent('HOSPITAL:reminder')

AddEventHandler('HOSPITAL:reminder', function(from, seconds)
	TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0}, "You have "..tostring(seconds).." more seconds before you are released from the morgue.")
end)


local usageStringHospital = "Usage: /dos *id* *seconds* *reason*"

TriggerEvent('es:addJobCommand', 'dos', { "ems", "fire", "police", "sheriff" }, function(source, args, user)
	local coroner_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")

	local usageString = usageStringHospital
	local ER = false

	if (args[2] == nil or args[3] == nil or args[4] == nil or (ER and args[5] == nil)) then
		TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0}, usageString)
		return
	end

	local playerID = tonumber(args[2])

	if(playerID == nil or GetPlayerName(playerID) == nil) then
		-- Invalid player ID
		TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0} , "Invalid PlayerID")
		return
	end

	local userName = GetPlayerName(playerID)
	local hospitalTime = 0
	local hospitalIdentifier = 0

	hospitalTime = tonumber(args[3])

	if(hospitalTime == nil) then
		TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0} , usageString)
		return
	end

	if (hospitalTime > 600) then
		hospitalTime = 600
	end

	local hospitalReason = ""
	hospitalReason = table.concat(args, " ", 4)

	if playerID then
		-- revive if dead
		TriggerClientEvent("RPD:revivePerson", playerID)
		-- remove blindfolds/tied hands
		TriggerClientEvent("crim:untieHands", playerID, playerID)
		TriggerClientEvent("crim:blindfold", playerID, false, true)
		-- admit player ped to morgue
		TriggerClientEvent('HOSPITAL:hospitalize', playerID, hospitalTime * 60, hospitalIdentifier)
		-- remove all things and money from player
		TriggerEvent("es:getPlayerFromId", playerID, function(targetPlayer)
			-- remove player weapons
			print("removing weapons!")
			targetPlayer.setActiveCharacterData("weapons", {})
			-- remove player inventory items (except phone -- since it's a pain to redo contacts)
			print("removing all items except cell phone!")
			local target_inventory = targetPlayer.getActiveCharacterData("inventory")
			for i = #target_inventory, 1, -1 do
				local item = target_inventory[i]
				if item == nil or not string.find(item.name, "Cell Phone") then
					table.remove(target_inventory, i)
				end
			end
			targetPlayer.setActiveCharacterData("inventory", target_inventory)
			-- remove player licenses
			print("removing licenses!")
			targetPlayer.setActiveCharacterData("licenses", {})
			-- remove player insurance
			print("removing insurance!")
			targetPlayer.setActiveCharacterData("insurance", {})
			-- remove player money on hand
			print("DISABLED: removing money!")
			--targetPlayer.setActiveCharacterData("money", 0)
			-- send to discord #jail-logs
			local admitted_name = targetPlayer.getActiveCharacterData("firstName") .. " " .. targetPlayer.getActiveCharacterData("lastName")
			local url = 'https://discordapp.com/api/webhooks/392414345826664451/XW4zn4dM99OiD7JuyeCvYG0gIgjpOIhfnv8uDZEQpl4xjzdjv-J2_NQayhrSyXm1f1eT'
			PerformHttpRequest(url, function(err, text, headers)
				if text then
					print(text)
				end
			end, "POST", json.encode({
				embeds = {
					{
						description = "**Name:** " .. admitted_name .. " \n**Length:** " .. hospitalTime .. " hour(s)" .. " \n**COD:** " .. hospitalReason .. "\n**Signature:** " .. coroner_name .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
						color = 263172,
						author = {
							name = "Blaine County Morgue"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json' })
			-- sent global chat message
			local eventMessage = admitted_name .. " has been sent to the morgue for " .. tostring(hospitalReason) .. "."
			TriggerClientEvent('chatMessage', -1, "SYSTEM", {100,0,0}, eventMessage)
			-- REMOVE WARRANTS (if any)
			TriggerEvent("warrants:removeAnyActiveWarrants", admitted_name)
		end)
	end
end, {
	help = "Send someone to the mourge to be NLR'd.",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "min", help = "Time in minutes" },
		{ name = "reason", help = "Reason" }
	}
})


-- String splits by the separator.
function stringsplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

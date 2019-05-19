TriggerEvent('es:addJobCommand', 'morgue', { "ems", "fire", "police", "sheriff" }, function(source, args, user)
	local coroner_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")

	if (args[2] == nil or args[3] == nil) then
		TriggerClientEvent('usa:notify', source, 'USAGE: /morgue id reason')
		return
	end

	local playerID = tonumber(args[2])

	if(playerID == nil or GetPlayerName(playerID) == nil) then
		-- Invalid player ID
		TriggerClientEvent('usa:notify', source, 'Player not found!')
		return
	end

	local userName = GetPlayerName(playerID)

	local hospitalReason = table.concat(args, " ", 3)

	if playerID then
		-- revive if dead
		TriggerClientEvent("death:allowRevive", playerID)
		-- remove blindfolds/tied hands
		TriggerClientEvent("crim:untieHands", playerID, playerID)
		TriggerClientEvent("crim:blindfold", playerID, false, true)
		-- admit player ped to morgue
		TriggerClientEvent('morgue:toeTag', playerID)
		-- remove all things and money from player
		local targetPlayer = exports["essentialmode"]:getPlayerFromId(playerID)
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
			local toeTag = {
				name = 'Toe Tag',
				weight = 1,
				amount = 1,
				notDroppable = true,
				type = 'misc'
			}
			table.insert(target_inventory, toeTag)
			targetPlayer.setActiveCharacterData("inventory", target_inventory)
			-- remove player licenses
			print("removing licenses!")
			targetPlayer.setActiveCharacterData("licenses", {})
			-- remove player insurance
			print("removing insurance!")
			targetPlayer.setActiveCharacterData("insurance", {})
			-- remove player crim historyr
			targetPlayer.setActiveCharacterData("criminalHistory", {})
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
						description = "**Name:** " .. admitted_name .. "\n**COD:** " .. hospitalReason .. "\n**Signature:** " .. coroner_name .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
						color = 263172,
						author = {
							name = "Davis Morgue Autopsy Report"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json' })
			-- sent global chat message
			local eventMessage = "^8^*[MORGUE]^0^r " ..admitted_name .. " has been admitted to the morgue. (" .. tostring(hospitalReason) .. ")"
			TriggerClientEvent('chatMessage', -1, "", {100,0,0}, eventMessage)
			-- REMOVE WARRANTS (if any)
			TriggerEvent("warrants:removeAnyActiveWarrants", admitted_name)
	end
end, {
	help = "Send someone to the mourge.",
	params = {
		{ name = "id", help = "the player id" },
		{ name = "reason", help = "reason" }
	}
})

TriggerEvent('es:addGroupCommand', 'unmorgue', "mod", function(source, args, user)
	local target_source = tonumber(args[2])
	if GetPlayerName(target_source) then
		local target = exports['essentialmode']:getPlayerFromId(target_source)
		local target_inventory = target.getActiveCharacterData('inventory')
		for i = 1, #target_inventory do
			local item = target_inventory[i]
			if item.name == 'Toe Tag' then
				print('removing toe tag from player, is being unmorged: '..target_source..'!')
				table.remove(target_inventory, i)
				target.setActiveCharacterData('inventory', target_inventory)
				TriggerClientEvent('morgue:release', target_source)
				TriggerEvent("usa:notifyStaff", '^1^*[STAFF]^r^0 Player ^1'..GetPlayerName(source)..' ['..source..'] ^0 has unmorgued ^1'..GetPlayerName(target_source)..' ['..target_source..']^0.')
				return
			end
		end
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Unmorgue a player if accidentally admitted.",
	params = {
		{ name = 'id', help = 'the player id' }
	}
})

RegisterServerEvent('morgue:checkToeTag')
AddEventHandler('morgue:checkToeTag', function(source)
  print("checking if character is morgued!")
  _source = source
  local user = exports["essentialmode"]:getPlayerFromId(_source)
  local user_inventory = user.getActiveCharacterData('inventory')
  for i = 1, #user_inventory do
  	local item = user_inventory[i]
  	if item.name == 'Toe Tag' then
  		TriggerClientEvent("morgue:toeTag", _source)
  		print('player\'s character is morgued!')
  		return
  	end
  end
end)


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

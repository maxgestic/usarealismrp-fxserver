TriggerEvent('es:addJobCommand', 'morgue', { "ems", "corrections", "sheriff", "doctor" }, function(source, args, char)
	local coroner_name = char.getFullName()

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

	if hospitalReason:len() >= 2000 then 
		TriggerClientEvent("usa:notify", source, "Please enter a morgue message less than 2,000 characters in length.", "^0Please enter a morgue message less than 2,000 characters in length. You can press ^3T^0 and then ^3UP ARROW^0 to retrieve your last message.")
		return
	end

	if playerID then
		TriggerClientEvent("death:allowRevive", playerID)
		TriggerClientEvent("crim:untieHands", playerID, playerID)
		TriggerClientEvent("crim:blindfold", playerID, false, true)
		TriggerClientEvent('morgue:toeTag', playerID, true)
		local target = exports["usa-characters"]:GetCharacter(playerID)
		target.removeAllItems()
		local toeTag = {
			name = 'Toe Tag',
			weight = 1,
			amount = 1,
			notDroppable = true,
			type = 'misc'
		}
		target.giveItem(toeTag, 1)
		local admitted_name = target.getFullName()
		local url = GetConvar("morgue-log-webhook")
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
		}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
		local eventMessage = "^8^*[MORGUE]^0^r " ..admitted_name .. " has been admitted to the morgue. (" .. tostring(hospitalReason) .. ")"
		TriggerClientEvent('chatMessage', -1, "", {100,0,0}, eventMessage)
		TriggerEvent("warrants:removeAnyActiveWarrants", target.get("name"), target.get("dateOfBirth"))
	end
end, {
	help = "Send someone to the morgue",
	params = {
		{ name = "id", help = "the player id" },
		{ name = "reason", help = "reason" }
	}
})

TriggerEvent('es:addGroupCommand', 'unmorgue', "mod", function(source, args, user)
	local target_source = tonumber(args[2])
	if target_source and GetPlayerName(target_source) then
		local target = exports['usa-characters']:GetCharacter(target_source)
		if target.hasItem('Toe Tag') then
			target.removeItem('Toe Tag', 1)
			TriggerClientEvent('morgue:release', target_source)
			TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has unmorgued ^2'..GetPlayerName(target_source)..' ['..target_source..']^0.')
		else
			TriggerClientEvent("usa:notify", source, "Player is not morgued!")
		end
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Unmorgue a player if accidentally admitted",
	params = {
		{ name = 'id', help = 'the player id' }
	}
})

RegisterServerEvent('morgue:checkToeTag')
AddEventHandler('morgue:checkToeTag', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem('Toe Tag') then
  	TriggerClientEvent("morgue:toeTag", source, true)
  else
  	TriggerClientEvent('morgue:toeTag', source, false)
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

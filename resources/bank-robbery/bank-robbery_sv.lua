local isBusy = "no"

local closed = false

function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY : " .. source)
		return false
	end
	print("INSIDE getPlayerIdEasyMode about to retrun playerIdentifier = " .. playerIdentifier)
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

local abletorob = true
RegisterServerEvent("bank:isBusy")
AddEventHandler("bank:isBusy", function()

	print("INSIDE isBusy with source = " .. source)
	local busyStatus = isBusy

    if not closed then
        print("BANK WAS NOT CLOSED")
        if not abletorob then
            TriggerClientEvent('chatMessage', source, 'SYSTEM', { 0, 141, 155 }, "^3The bank has already been robbed!")
        elseif busyStatus == "no" then

            TriggerClientEvent('chatMessage', source, 'SYSTEM', { 0, 141, 155 }, "^3You are robbing the bank!")
            TriggerClientEvent('chatMessage', source, 'SYSTEM', { 0, 141, 155 }, "^3Wait ^21 minute^3 to get all the money!")
			TriggerClientEvent("bank-robbery:notify", source, "~r~Alarm activated!")

            TriggerEvent("bank:beginRobbery", source)
            abletorob = false

            -- 1.5 hr cooldown
            SetTimeout(5400000 , function()
                abletorob = true
            end)

        else
			TriggerClientEvent("bank-robbery:notify", source, "Someone is already robbing the bank!")
        end
    else
		TriggerClientEvent("bank-robbery:notify", source, "The bank has been ~r~closed~w~ by admins.")
    end

end)

RegisterServerEvent("bank:beginRobbery")
AddEventHandler("bank:beginRobbery", function(source)

	print("INSIDE beginRobbery with source = " .. source)

	-- make npc busy so only one at a time can rob bank
    isBusy = "yes"

	TriggerEvent("es:getPlayers", function(pl)
		for k, v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				local userJob = user.getActiveCharacterData("job")
					if userJob == "cop" or userJob == "sheriff" or userJob == "highwaypatrol" or userJob == "ems" or userJob == "fire" then
						TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "Alarm activated at ^3Blaine County Savings Bank^0 on Cascabel Ave.")
					end
			end)
		end
	end)
	--TriggerClientEvent('chatMessage', -1, 'NEWS', { 255, 180, 0 }, '^0Someone is robbing the bank!')

	-- wait 1.5 min seconds to get money
	SetTimeout(90000, function()

		-- need to check player distance from bank point
		-- if in range: give bag of loot
		-- if not in rage: cancel robbery
		TriggerClientEvent("bank:checkRange", source, source)
		-- make npc not busy so it can be used again
        isBusy = "no"

	end)

end)

RegisterServerEvent("bank:inRange")
AddEventHandler("bank:inRange", function()
	local userSource = tonumber(source)
	rewardMoney = math.random(20000, 60000)
	isBusy = "no"
	local msg = "You stole ~g~$" .. comma_value(rewardMoney) .. "~w~!"
	TriggerClientEvent("bank-robbery:notify", source, msg)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user then
			local user_money = user.getActiveCharacterData("money")
			local new_money = user_money + rewardMoney
			user.setActiveCharacterData("money", new_money)
			print("player " .. GetPlayerName(userSource) .. " successfully robbed the bank and now has: " .. new_money)
		end
	end)
end)

RegisterServerEvent("bank:outOfRange")
AddEventHandler("bank:outOfRange", function()
	TriggerClientEvent("bank-robbery:notify", source, "~y~Out of range! No money was taken.")
    isBusy = "no"
    abletorob = true
end)

TriggerEvent('es:addCommand', 'closebank', function(source, args, user)

	local group = user.getGroup()

    if group == "owner" or group == "admin" or group == "superadmin" or group == "mod" then
        closed = true
		TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~r~CLOSED")
    end

end)

TriggerEvent('es:addCommand', 'openbank', function(source, args, user)

	local group = user.getGroup()

    if group == "owner" or group == "admin" or group == "superadmin" or group == "mod" then
        closed = false
        TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~g~OPEN")
    end

end)

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "closebank" then
		closed = true
		RconPrint("You have closed the bank! Nobody should be able to rob it!")
		CancelEvent()
		return
	elseif commandName == "openbank" then
		closed = false
		RconPrint("You have opened the bank!")
		CancelEvent()
		return
	end
end)

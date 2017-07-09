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

            -- 1 hr cooldown
            SetTimeout(3600000 , function()
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

	TriggerClientEvent('chatMessage', -1, 'NEWS', { 255, 180, 0 }, '^0Someone is robbing the bank!')

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
	rewardMoney = math.random(20000, 70000)
	isBusy = "no"
	local msg = "You have been given ~g~$" .. comma_value(rewardMoney) .. "~w~ in dirty money!"
	TriggerClientEvent("bank-robbery:notify", source, msg)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user then
			local oldMoney = user.getMoney()
			local newMoney = oldMoney + rewardMoney
			user.addMoney(newMoney)
			user.setMoney(newMoney)
			print("user money set to $" .. newMoney)
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

    if tonumber(user.permission_level) > 0 then
        closed = true
		TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~r~CLOSED")
    end

end)

TriggerEvent('es:addCommand', 'openbank', function(source, args, user)

    if tonumber(user.permission_level) > 0 then
        closed = false
        TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~g~CLOSED")
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

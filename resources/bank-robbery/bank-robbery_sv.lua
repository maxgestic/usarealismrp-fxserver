local isBusy = "no"

local closed = false

local COPS_NEEDED_TO_ROB = 3

RegisterServerEvent("bank:setBusy")
AddEventHandler("bank:setBusy", function(busy)
	isBusy = busy
end)

local abletorob = true
RegisterServerEvent("bank:isBusy")
AddEventHandler("bank:isBusy", function()
	local userSource = tonumber(source)

	print("INSIDE isBusy with source = " .. userSource)
	local busyStatus = isBusy

	local count = 0
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
						count = count + 1
					end
				end
			end
			print("cop count: " .. count)
			print("cops needed: " .. COPS_NEEDED_TO_ROB)
			if count >= COPS_NEEDED_TO_ROB then
				if not closed then
					print("BANK WAS NOT CLOSED")
					if not abletorob then
						TriggerClientEvent('chatMessage', userSource, 'SYSTEM', { 0, 141, 155 }, "^3The bank has already been robbed!")
					elseif busyStatus == "no" then

						TriggerEvent("usa:getPlayerItem", userSource, "Cell Phone", function(item)
							if not item then
								print("player did not have cell phone to hack the bank!")
								TriggerClientEvent("bank-robbery:notify", userSource, "You need a cell phone to rob the bank!")
								return
							else
								TriggerClientEvent('chatMessage', userSource, 'SYSTEM', { 0, 141, 155 }, "^3You are robbing the bank! Hack the system to get the money!")
								TriggerClientEvent("bank-robbery:notify", userSource, "~r~Alarm activated!")
								TriggerEvent("bank:beginRobbery", userSource)
								abletorob = false
								-- 3 hr cooldown
								SetTimeout(10800000, function()
									abletorob = true
								end)
							end
						end)

					else
						TriggerClientEvent("bank-robbery:notify", userSource, "Someone is already robbing the bank!")
					end
				else
					TriggerClientEvent("bank-robbery:notify", userSource, "The bank has been ~r~closed~w~ by admins.")
				end
			else
				TriggerClientEvent("bank-robbery:notify", userSource, "You are not able to access the bank lock!")
			end
		end
	end)

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

	print("calling startHacking!! source: " .. source)
	TriggerClientEvent("usa:playScenario", tonumber(source), "WORLD_HUMAN_STAND_MOBILE")
	TriggerClientEvent("bank-robbery:startHacking", tonumber(source))

end)

RegisterServerEvent("bank:inRange")
AddEventHandler("bank:inRange", function()
	local userSource = tonumber(source)
	rewardMoney = math.random(70000, 230000)
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

TriggerEvent('es:addGroupCommand', 'closebank', 'mod', function(source, args, user)
	closed = true
	TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~r~CLOSED")
end, {
	help = "Open the bank to be robbed"
})

TriggerEvent('es:addGroupCommand', 'openbank', 'mod', function(source, args, user)
		closed = false
		TriggerClientEvent("bank-robbery:notify", source, "BANK IS NOW ~g~OPEN")
end, {
	help = "Open the bank to be robbed"
})

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

local bankRobbable = true
local bankClosed = false
local COPS_NEEDED_TO_ROB = 4

RegisterServerEvent("bank:beginRobbery")
AddEventHandler("bank:beginRobbery", function()
	local userSource = tonumber(source)
	print("INSIDE bank:beginRobbery with source = " .. userSource)
	if bankRobbable and (not bankClosed) and (GetPoliceOnline() >= COPS_NEEDED_TO_ROB) then
		TriggerEvent("usa:getPlayerItem", userSource, "Cell Phone", function(item)
			if not item then
				print("player did not have cell phone to hack the bank!")
				TriggerClientEvent("usa:notify", userSource, "You need a cell phone to hack into the vault!")
				return
			else
				bankRobbable = false
				TriggerClientEvent('usa:notify', userSource, 'You are now robbing the bank, hack into the system to get the money!')
				TriggerClientEvent("usa:playScenario", userSource, "WORLD_HUMAN_STAND_MOBILE")
				TriggerClientEvent("bank:startHacking", userSource)
				SetTimeout(10800000, function()
					bankRobbable = true
				end)
			end
		end)
	else
		TriggerClientEvent('usa:notify', userSource, 'You cannot access the security system!')
	end
end)

RegisterServerEvent("bank:hackComplete")
AddEventHandler("bank:hackComplete", function()
	local userSource = source
	local rewardMoney = math.random(5000, 10000)
	TriggerClientEvent("usa:notify", source, "You have received ~g~$" .. comma_value(rewardMoney) .. "~w~!")
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user then
		local user_money = user.getActiveCharacterData("money")
		local new_money = user_money + rewardMoney
		user.setActiveCharacterData("money", new_money)
		print("player " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] successfully robbed the bank and now has: " .. new_money .. " with reward ".. rewardMoney)
	end
end)

RegisterServerEvent("bank:clerkTip")
AddEventHandler("bank:clerkTip", function()
	if bankRobbable and (not bankClosed) and (GetPoliceOnline() >= COPS_NEEDED_TO_ROB) then
		TriggerClientEvent('usa:notify', source, "Our branch is currently open for business...")
	else
		TriggerClientEvent('usa:notify', source, "Our branch is closed, the vault has been recently cleared.")
	end
end)

TriggerEvent('es:addGroupCommand', 'closebank', 'admin', function(source, args, user)
	bankClosed = true
	TriggerEvent("usa:notify", source, "The bank is now closed!")
	TriggerEvent("usa:notifyStaff", '^1^*[STAFF]^r^0 Player ^1'..GetPlayerName(source)..' ['..source..'] ^0 has closed the bank^0.')
end, {
	help = "Close the bank from being robbed."
})

TriggerEvent('es:addGroupCommand', 'openbank', 'admin', function(source, args, user)
	bankClosed = false
	TriggerEvent("usa:notifyStaff", '^1^*[STAFF]^r^0 Player ^1'..GetPlayerName(source)..' ['..source..'] ^0 has opened the bank^0.')
	TriggerClientEvent("usa:notify", source, "The bank is now open!")
end, {
	help = "Open the bank to be robbed."
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

function GetPoliceOnline()
	local policeOnline = 0
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
						policeOnline = policeOnline + 1
					end
				end
			end
		end
	end)
	return policeOnline
end
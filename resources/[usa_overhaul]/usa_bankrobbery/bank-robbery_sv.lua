local bankRobbable = true
local bankClosed = false
local COPS_NEEDED_TO_ROB = 4
local sourceRobbing = -1

local BANK_ROBBERY_TIMEOUT = 10800000

RegisterServerEvent("bank:beginRobbery")
AddEventHandler("bank:beginRobbery", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if bankRobbable and (not bankClosed) and (exports["usa-characters"]:GetNumCharactersWithJob("sheriff") >= COPS_NEEDED_TO_ROB) then
		if char.hasItem("Cell Phone") then
			bankRobbable = false
			sourceRobbing = source
			TriggerClientEvent('usa:notify', source, 'You are now robbing the bank, hack into the system to get the money!')
			TriggerClientEvent("bank:startHacking", source)
			SetTimeout(BANK_ROBBERY_TIMEOUT, function()
				bankRobbable = true
			end)
		else
			TriggerClientEvent("usa:notify", source, "You need a cell phone to hack into the vault!")
		end
	else
		TriggerClientEvent('usa:notify', source, 'You cannot access the security system!')
	end
end)

RegisterServerEvent("bank:hackComplete")
AddEventHandler("bank:hackComplete", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if sourceRobbing == source then
		local rewardMoney = math.random(15000, 120000)
		char.giveMoney(rewardMoney)
		TriggerClientEvent("usa:notify", source, "You have received ~g~$" .. comma_value(rewardMoney) .. "~w~!")
		print("BANKROBBERY: Player " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] successfully robbed the bank and was given a reward of [$".. rewardMoney .. "]!")
		sourceRobbing = -1
	end
end)

RegisterServerEvent("bank:clerkTip")
AddEventHandler("bank:clerkTip", function()
	if bankRobbable and (not bankClosed) and (exports["usa-characters"]:GetNumCharactersWithJob("sheriff") >= COPS_NEEDED_TO_ROB) then
		TriggerClientEvent('usa:notify', source, "Our branch is currently open for business...")
	else
		TriggerClientEvent('usa:notify', source, "Our branch is closed, the vault has been recently cleared.")
	end
end)

TriggerEvent('es:addGroupCommand', 'closebank', 'admin', function(source, args, char)
	bankClosed = true
	TriggerEvent("usa:notify", source, "The bank is now closed!")
	TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has closed the bank^0.')
end, {
	help = "Close the bank from being robbed."
})

TriggerEvent('es:addGroupCommand', 'openbank', 'admin', function(source, args, char)
	bankClosed = false
	TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has opened the bank^0.')
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

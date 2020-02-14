local bankRobbable = true
local bankClosed = false
local COPS_NEEDED_TO_ROB = 4
local sourceRobbing = -1

local BANK_ROBBERY_TIMEOUT = 10800000

RegisterServerEvent("bank:beginRobbery")
AddEventHandler("bank:beginRobbery", function(bank)
	local usource = source
	exports.globals:getNumCops(function(numCops)
		if numCops >= COPS_NEEDED_TO_ROB and bankRobbable and not bankClosed then
			local char = exports["usa-characters"]:GetCharacter(usource)
			if char.hasItem("Cell Phone") then
				bankRobbable = false
				sourceRobbing = usource
				TriggerClientEvent('usa:notify', usource, 'You are now robbing the bank, hack into the system to get the money!')
				TriggerClientEvent("bank:startHacking", usource, bank)
				SetTimeout(BANK_ROBBERY_TIMEOUT, function()
				bankRobbable = true
			end)
			else
				TriggerClientEvent("usa:notify", usource, "You need a cell phone to hack into the vault!")
			end
		else 
			TriggerClientEvent('usa:notify', usource, 'You cannot access the security system!')
		end
	end)
end)

RegisterServerEvent("bank:hackComplete")
AddEventHandler("bank:hackComplete", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if sourceRobbing == source then
		local rewardMoney = math.random(15000, 120000)
		char.giveMoney(rewardMoney)
		TriggerClientEvent("usa:notify", source, "You have received ~g~$" .. exports.globals:comma_value(rewardMoney) .. "~w~!")
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
local bankRobbable = true
local bankClosed = false
local COPS_NEEDED_TO_ROB = 5
local sourceRobbing = -1
local BANK_ROBBERY_TIMEOUT = math.random(3600000, 10800000)

local drilling_spots = {
	{x = 263.53, y = 216.6, z = 101.68, drilled = false},
	{x = 264.84, y = 216.05, z = 101.68, drilled = false},
	{x = 266.11, y = 215.69, z = 101.68, drilled = false},
	{x = 266.41, y = 214.54, z = 101.68, drilled = false},
	{x = 266.03, y = 213.3, z = 101.68, drilled = false},
	{x = 265.63, y = 212.2, z = 101.68, drilled = false},
	{x = 264.62, y = 211.9, z = 101.68, drilled = false},
	{x = 263.47, y = 212.36, z = 101.68, drilled = false},
	{x = 262.2, y = 212.79, z = 101.68, drilled = false},
}


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
					resetBankHeist()
				end)
			else
				TriggerClientEvent("usa:notify", usource, "You need a cell phone to hack into the vault!")
			end
		else 
			TriggerClientEvent('usa:notify', usource, 'You cannot access the security system!')
		end
	end)
end)

RegisterServerEvent('bank:vaultDoorHacked')
AddEventHandler('bank:vaultDoorHacked', function()
	if sourceRobbing == source then
		TriggerClientEvent('bank:openVaultDoor', -1)
	end
end)

RegisterServerEvent("bank:hackComplete")
AddEventHandler("bank:hackComplete", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if sourceRobbing == source then
		local rewardMoney
		rewardMoney = math.random(85000, 110000)
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

RegisterServerEvent('bank:loadDrillingSpots')
AddEventHandler('bank:loadDrillingSpots', function()
	TriggerClientEvent('bank:loadDrillingSpots', source, drilling_spots)
end)

RegisterServerEvent('bank:doesUserHaveDrill')
AddEventHandler('bank:doesUserHaveDrill', function(box)
	local src = source
	local char = exports["usa-characters"]:GetCharacter(source)

	if char.hasItem('Drill') then
		attemptDrilling(box, src)
	else
		TriggerClientEvent("usa:notify", src, 'How can you drill locks with no drill?!')
	end
end)


function attemptDrilling(depositBoxIndex, source)
	if drilling_spots[depositBoxIndex].drilled then
		TriggerClientEvent("usa:notify", source, "This box has already been drilled")
	else
		drilling_spots[depositBoxIndex].drilled =  true
		TriggerClientEvent('bank:startDrilling', source, depositBoxIndex)
		--Wait(600000) -- Wait 10 mins and then set the timeout
	end
end

function resetBankHeist()
	for i = 1, #drilling_spots do
		if drilling_spots[i].drilled then
			drilling_spots[i].drilled = false
		end
	end
	bankRobbable = true
	TriggerClientEvent('bank:resetVault', -1)
end

RegisterServerEvent('bank:drilledGoods')
AddEventHandler('bank:drilledGoods', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local cash = math.random(1750, 12350)
	char.giveMoney(cash)
	TriggerClientEvent("usa:notify", source, "You stole $".. cash .. ' from the deposit box!')
end)
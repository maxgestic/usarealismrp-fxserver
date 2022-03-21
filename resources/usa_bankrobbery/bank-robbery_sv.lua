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
	{x = 260.30868530273, y = 217.57815551758, z = 101.6834564209, drilled = false},
	{x = 259.44546508789, y = 214.01387023926, z = 101.6834564209, drilled = false}
}

local cash_carts = {
	{x = 262.35241699219, y = 213.45327758789, z = 100.68346405029, rotation = 0.360, stolen = false},
	{x = 263.09124755859, y = 215.66879272461, z = 100.68346405029, rotation = 0.0, stolen = false}
}

local safes = {
	{x = 259.68206787109, y = 204.56143188477, z = 109.28755187988, stolenX = 259.71075439453, stolenY = 204.67768859863, rotation = 0.52, text3dX = 260.39909790039, text3dY = 204.25059204102, stolen = false, busy = false},
	{x = 265.7557434082, y = 214.46087646484, z = 109.28744506836, stolenX = 265.8495605469, stolenY = 214.0133666992, rotation = 0.144, stolen = false, busy = false}
}

local alarmedTriggered = false

local hasGuardSpawned = false

local hasDoorBeenThermited = false

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
AddEventHandler('bank:vaultDoorHacked', function(securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
	TriggerClientEvent('bank:openVaultDoor', -1)
end)

RegisterServerEvent("bank:hackComplete")
AddEventHandler("bank:hackComplete", function(securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
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
	local src = source
	exports.globals:getNumCops(function(numCops)
		if bankRobbable and (not bankClosed) and numCops >= COPS_NEEDED_TO_ROB then
			TriggerClientEvent('usa:notify', src, "Our branch is currently open for business...")
		else
			TriggerClientEvent('usa:notify', src, "Our branch is closed, the vault has been recently cleared.")
		end
	end)
end)

RegisterServerEvent('bank:loadDrillingSpots')
AddEventHandler('bank:loadDrillingSpots', function()
	TriggerClientEvent('bank:loadDrillingSpots', source, drilling_spots)
end)

RegisterServerEvent('bank:doesUserHaveDrill')
AddEventHandler('bank:doesUserHaveDrill', function(box, securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
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
	for i = 1, #safes do
		safes[i].stolen = false
		safes[i].busy = false
	end
	for i = 1, #cash_carts do
		cash_carts[i].stolen = false
		cash_carts[i].busy = false
	end
	bankRobbable = true
	alarmedTriggered = false
	TriggerClientEvent('bank:resetVault', -1)
	hasGuardSpawned = false
	exports.usa_doormanager:toggleDoorLockByName("Pacific Standard Bank", true)
	hasDoorBeenThermited = false
end

function addAnimInfoToDoorObj(door)
	if door.name == "Pacific Standard Bank / Door 2" then
		door.thermitefx = vector3(256.86588745117, 221.55991821289, 106.28588867188)
		door.anim = { x = 256.88510131836, y = 220.04508972168, z = 106.28633117676, h = 336.52, extra = 0}
	elseif door.name == "Pacific Standard Bank / Door 1" then
		door.thermitefx = vector3(261.57, 222.89, 106.33)
		door.anim = { x = 261.3061328125, y = 222.19805908203, z = 106.2833480835, h = 251.08, extra = 0}
	elseif door.name == "Pacific Standard Bank / Vault Door 1" then
		door.thermitefx = vector3(252.985, 221.70, 101.72)
		door.anim = { x = 252.95, y = 220.70, z = 101.76, h = 160.08, extra = 0}
	elseif door.name == "Pacific Standard Bank / Vault Door 2" then
		door.thermitefx = vector3(261.68, 216.63, 101.75)
		door.anim = { x = 261.65, y = 215.60, z = 101.76, h = 252.08, extra = 0}
	end
	return door
end

RegisterServerEvent('bank:drilledGoods')
AddEventHandler('bank:drilledGoods', function(securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
	local char = exports["usa-characters"]:GetCharacter(source)
	local cash = math.random(1750, 12350)
	char.giveMoney(cash)
	TriggerClientEvent("usa:notify", source, "You stole $".. cash .. ' from the deposit box!')
end)

RegisterServerEvent("bank:useThermite")
AddEventHandler("bank:useThermite", function()
	local nearestDoor = exports.usa_doormanager:getNearestDoor(source)
	if nearestDoor.name:find("Pacific Standard Bank / ") and nearestDoor.locked then
		TriggerClientEvent("bank:makeGuardsAggressive", -1)
		nearestDoor = addAnimInfoToDoorObj(nearestDoor)
		local success = TriggerClientCallback {
			source = source,
			eventName = "bank:useThermite",
			args = { nearestDoor }
		}
		if success then
			exports.usa_doormanager:toggleDoorLock(nearestDoor.index)
			local char = exports["usa-characters"]:GetCharacter(source)
			char.removeItem("Thermite", 1)
			if not alarmedTriggered then
				alarmedTriggered = true
				TriggerClientEvent("bank:toggleAlarm", -1, true)
			end
			hasDoorBeenThermited = true
		end
	end
end)

RegisterServerEvent("pacificBankRobbery:server:thermiteEffect")
AddEventHandler("pacificBankRobbery:server:thermiteEffect", function(door)
	TriggerClientEvent("pacificBankRobbery:client:thermiteEffect", -1, door)
end)

RegisterServerEvent("bank:toggleAlarm")
AddEventHandler("bank:toggleAlarm", function(doPlay)
	TriggerClientEvent("bank:toggleAlarm", -1, doPlay)
end)

RegisterServerCallback {
	eventName = "bank:spawnGuardIfNotSpawned",
	eventCallback = function()
		if not hasGuardSpawned then
			hasGuardSpawned = true
			return false
		else
			return true
		end
	end
}

RegisterServerEvent("bank:getCashCartData")
AddEventHandler("bank:getCashCartData", function()
	TriggerClientEvent("bank:gotCashCartData", source, cash_carts)
end)

RegisterServerCallback {
	eventName = "bank:isCartLooted",
	eventCallback = function(source, cartData, doMarkAsLooted)
		for i = 1, #cash_carts do
			if cartData.x == cash_carts[i].x and cartData.y == cash_carts[i].y then
				if cash_carts[i].stolen then
					return true
				else
					if doMarkAsLooted then
						cash_carts[i].stolen = true
					end
					return false
				end
			end
		end
	end
}

RegisterServerEvent("bank:cartLooted")
AddEventHandler("bank:cartLooted", function(cartData, securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
	for i = 1, #cash_carts do
		if cartData.x == cash_carts[i].x and cartData.y == cash_carts[i].y then
			cash_carts[i].stolen = true
			local char = exports["usa-characters"]:GetCharacter(source)
			local reward = math.random(10000, 50000)
			char.giveMoney(reward)
			TriggerClientEvent("usa:notify", source, "Stole: $" .. exports.globals:comma_value(reward))
			TriggerClientEvent("bank:swapCartModel", -1, cartData)
		end
	end
end)

RegisterServerEvent("bank:getSafeData")
AddEventHandler("bank:getSafeData", function()
	TriggerClientEvent("bank:gotSafeData", source, safes)
end)

RegisterServerCallback {
	eventName = "bank:isSafeBusy",
	eventCallback = function(source, safeIndex, doMarkAsBusy)
		if safes[safeIndex].busy then
			return true
		else
			if doMarkAsBusy then
				safes[safeIndex].busy = true
			end
			return false
		end
	end
}

RegisterServerEvent("bank:safeLooted")
AddEventHandler("bank:safeLooted", function(safeIndex, securityToken)
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
	safes[safeIndex].stolen = true
	TriggerClientEvent("bank:safeLooted", -1, safeIndex)
	local char = exports["usa-characters"]:GetCharacter(source)
	local reward = math.random(10000, 50000)
	char.giveMoney(reward)
	TriggerClientEvent("usa:notify", source, "Stole: $" .. exports.globals:comma_value(reward))
end)

RegisterServerEvent("bank:setSafeBusy")
AddEventHandler("bank:setSafeBusy", function(safeIndex, status)
	safes[safeIndex].busy = status
end)

RegisterServerCallback {
	eventName = "bank:hasDoorBeenThermited",
	eventCallback = function()
		return hasDoorBeenThermited
	end
}
RegisterServerEvent('fuel:returnFuelAmount')
RegisterServerEvent('fuel:setFuelAmount')
RegisterServerEvent('fuel:purchaseFuel')
local gasPrices = {
		['Aircraft'] = 25,
		['Watercraft'] = 10,
		['Electric'] = 3,
		['Gasoline'] = 2
	}

local vehicleGas = {}

AddEventHandler('fuel:returnFuelAmount', function(vehiclePlate)
	if vehicleGas[vehiclePlate] then
		TriggerClientEvent('fuel:updateFuelAmount', source, vehicleGas[vehiclePlate])
	else
		local generatedAmount = (math.random() * 100)
		if generatedAmount < 10.0 then
			generatedAmount = generatedAmount + 10
		end
		vehicleGas[vehiclePlate] = generatedAmount
		--print('FUEL: Generating a random fuel amount for vehicle: '..generatedAmount)
		TriggerClientEvent('fuel:updateFuelAmount', source, vehicleGas[vehiclePlate])
	end
end)

AddEventHandler('fuel:setFuelAmount', function(vehiclePlate, fuelAmount)
	vehicleGas[vehiclePlate] = fuelAmount
end)

AddEventHandler('fuel:purchaseFuel', function(amount, type)
	local price = gasPrices[type]

	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")

	if job == "sheriff" or job == "ems" or job == "fire" or job == "corrections" then
		TriggerClientEvent("fuel:refuelAmount", source, amount)
	else
		local money = char.get("money")
		local toPay = (amount or 1) * price
		if toPay >= money then
			TriggerClientEvent("usa:notify", source, "You cannot afford this purchase! ~y~($"..toPay..')')
		else
			char.removeMoney(toPay)
			TriggerClientEvent("fuel:refuelAmount", source, amount)
		end
	end
end)

RegisterServerEvent("fuel:refuelWithJerryCan")
AddEventHandler("fuel:refuelWithJerryCan", function(plate)
	local new_amount = 75
	local _source = source
	if plate then
		if vehicleGas[plate] then
			if vehicleGas[plate] < new_amount then
				vehicleGas[plate] = new_amount -- set to 75% of a full tank
				TriggerClientEvent("usa:notify", _source, "Refuel complete!")
			else
				TriggerClientEvent("usa:notify", _source, "Tank already filled!")
			end
		else
			vehicleGas[plate] = new_amount
			TriggerClientEvent("usa:notify", _source, "Refuel complete!")
		end
	end
end)

RegisterServerEvent('fuel:purchaseJerryCan')
AddEventHandler('fuel:purchaseJerryCan', function()
	local cost = gasPrices["Gasoline"] * 75
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("money") >= cost then
		local jerryCan = {
			name = "Jerry Can",
			quantity = 1,
			legality = "legal",
			type = "weapon",
			hash = 883325847,
			weight = 10.0
		}
		if char.canHoldItem(jerryCan) then
			char.removeMoney(cost)
			char.giveItem(jerryCan)
			TriggerClientEvent("interaction:equipWeapon", source, jerryCan, true, 1000)
			TriggerClientEvent("usa:notify", source, "You have purchased a jerry can for $" .. cost)
		else
			TriggerClientEvent("usa:notify", source, "Inventory full!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Not enough money! Need $" .. cost)
	end
end)

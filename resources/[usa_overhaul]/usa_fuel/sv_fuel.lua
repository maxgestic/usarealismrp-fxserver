RegisterServerEvent('fuel:returnFuelAmount')
RegisterServerEvent('fuel:setFuelAmount')
RegisterServerEvent('fuel:purchaseFuel')
local gasPrices = {
		['Aircraft'] = 25,
		['Watercraft'] = 10,
		['Electric'] = 3,
		['Gasoline'] = 5
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
		print('FUEL: Generating a random fuel amount for vehicle: '..generatedAmount)
		TriggerClientEvent('fuel:updateFuelAmount', source, vehicleGas[vehiclePlate])
	end
end)

AddEventHandler('fuel:setFuelAmount', function(vehiclePlate, fuelAmount)
	vehicleGas[vehiclePlate] = fuelAmount
end)

AddEventHandler('fuel:purchaseFuel', function(amount, type)
	local userSource = source
	local price = gasPrices[type]

	local user = exports["essentialmode"]:getPlayerFromId(userSource)

	local userJob = user.getActiveCharacterData("job")
	if userJob == "sheriff" or userJob == "ems" or userJob == "fire" or userJob == "corrections" then
		TriggerClientEvent("fuel:refuelAmount", userSource, amount)
	else
		local userMoney = user.getActiveCharacterData("money")
		local toPay = amount * price
		if toPay >= userMoney then
			TriggerClientEvent("usa:notify", userSource, "You cannot afford this purchase! ~y~($"..toPay..')')
		else
			user.setActiveCharacterData("money", userMoney - toPay)
			print("user.getJob() was not sheriff/ems/fire: " .. userJob)
			TriggerClientEvent("fuel:refuelAmount", userSource, amount)
		end
	end
end)
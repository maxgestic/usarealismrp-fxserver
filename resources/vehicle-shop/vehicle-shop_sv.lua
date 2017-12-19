local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 6

function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
	end
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

function stringSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function getPlayersLicense(source) -- TODO: UPDATE THIS FUNCTION TO CORRECLATE TO UPDATED DB DOCUMENT STRUCTURE
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local licenses = user.getActiveCharacterData("license")
		for i = 1, #licenses do
			if licenses[i].name == "Driver's License" then
				license = licenses[i]
				return license
			end
		end
		return nil
	end)
end

function alreadyHasVehicle(source, vehName)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			if vehicles[i].model == vehName then
				return true
			end
		end
		return false
	end)
end

function alreadyHasAnyVehicle(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local cars = user.getActiveCharacterData("vehicles")
		if #cars > 0 then
			return true
		else
			return false
		end
	end)
end

RegisterServerEvent("vehShop:buyInsurance")
AddEventHandler("vehShop:buyInsurance", function(userSource)
	print("user source = " .. userSource)
	local INSURANCE_COVERAGE_MONTHLY_COST = 7500
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local insurance = user.getActiveCharacterData("insurance")
		local user_money = user.getActiveCharacterData("money")
		if user_money >= INSURANCE_COVERAGE_MONTHLY_COST then
			local insurancePlan = {
				planName = "T. Ends Auto Insurance",
				type = "auto",
				valid = true,
				purchaseDate = os.date('%m-%d-%Y %H:%M:%S', os.time()),
				purchaseTime = os.time()
			}
			user.setActiveCharacterData("insurance", insurancePlan)
			print("taking $" .. INSURANCE_COVERAGE_MONTHLY_COST .. " from player for auto insurance!")
			user.setActiveCharacterData("money", user_money - INSURANCE_COVERAGE_MONTHLY_COST)
			TriggerClientEvent("vehShop:notify", userSource, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires in ~y~31~w~ days.")
		else
			print("player did not have enough money to buy insurance")
			TriggerClientEvent("vehShop:notify", userSource, "You ~r~don't have enough money~w~ to buy auto insurance coverage!")
		end
	end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end

RegisterServerEvent("vehShop:checkPlayerInsurance")
AddEventHandler("vehShop:checkPlayerInsurance", function()
	print("checking for auto insurance!")
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local playerInsurance = user.getActiveCharacterData("insurance")
		if playerInsurance.type == "auto" then
			print("found player auto insurance!")
			if playerHasValidAutoInsurance(playerInsurance) then
				TriggerClientEvent("chatMessage", userSource, "T. ENDS INSURANCE", {255, 78, 0}, "You are already insured!")
			else
				print("renewing auto insurance!")
				TriggerClientEvent("chatMessage", userSource, "T. ENDS INSURANCE", {255, 78, 0}, "Your auto insurance coverage was ~r~expired~w~! Renewing...")
				TriggerEvent("vehShop:buyInsurance", userSource)
			end
		else
			print("no auto insurance found!")
			TriggerEvent("vehShop:buyInsurance", userSource)
		end
	end)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle)
	local playerIdentifier = getPlayerIdentifierEasyMode(source)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local allLicenses = user.getActiveCharacterData("licenses")
		local license = nil
		local vehicles = user.getActiveCharacterData("vehicles")
		local user_money = user.getActiveCharacterData("money")
		local owner_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		if #vehicles <= MAX_PLAYER_VEHICLES then
			for i = 1, #allLicenses do
				if allLicenses[i].name == "Driver's License" then
					license = allLicenses[i]
					break
				end
			end
			if license ~= nil then
				if license.status == "valid" then
					hash = vehicle.hash
					price = vehicle.price
		            if not alreadyHasVehicle(userSource, vehicleName) then
		    			if tonumber(price) <= user_money then
							plate = tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
								if vehicles then
									user.setActiveCharacterData("money", user_money - tonumber(price))
									local vehicle = {
										owner = owner_name,
										make = vehicle.make,
										model = vehicle.model,
										hash = hash,
										plate = plate,
										stored = false,
										price = price
									}
									local vehicle_key = {
										name = "Key -- " .. plate,
										quantity = 1,
										owner = owner_name,
										make = vehicle.make,
										model = vehicle.model,
										plate = plate
									}
									--  prevent gui menu from breaking i believe (i think 16 is max # of menu items possible)
									print("buying vehicle")
									table.insert(vehicles, vehicle)
									user.setActiveCharacterData("vehicles", vehicles)
									print("vehicle purchased!")
									print("vehicle.owner = " .. vehicle.owner)
									print("vehicle.model = " .. vehicle.model)
									print("vehicle.plate = " .. vehicle.plate)
									print("vehicle.stored = " .. tostring(vehicle.stored))
									-- give player the key to the whip
									local inv = user.getActiveCharacterData("inventory")
									table.insert(inv, vehicle_key)
									user.setActiveCharacterData("inventory", inv)
									-- add vehicle plate to locking resource list:
									TriggerEvent("lock:addPlate", vehicle.plate)
									--TriggerEvent("sway:updateDB", userSource)
									TriggerClientEvent("usa:notify", userSource, "Here are the keys! Thanks for your business!")
									TriggerClientEvent("vehShop:spawnPlayersVehicle", userSource, hash, plate)
								end
		    			else
		    				TriggerClientEvent("mini:insufficientFunds", userSource, price, "vehicle")
		    			end
		            else
		                TriggerClientEvent("vehShop:alreadyOwnVehicle", userSource)
		           	end
				else
					TriggerClientEvent("mini:invalidLicense", userSource)
				end
			else
				TriggerClientEvent("mini:noLicense", userSource)
			end
		else
			print("NOT buying vehicle...")
			TriggerClientEvent("vehShop:notify", userSource, "Sorry, you can't own more than " .. MAX_PLAYER_VEHICLES .. " vehicles at this time!")
		end
	end)
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if vehicle then
				local sellPrice = round(vehicle.price * .5,0)
				vehicles[i].sellPrice = sellPrice
			end
		end
		print("vehicles loaded! # = " .. #vehicles)
		TriggerClientEvent("vehShop:displayVehiclesToSell", userSource, vehicles)
	end)
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if vehicle.model == toSellVehicle.model and vehicle.plate == toSellVehicle.plate then
				table.remove(vehicles, i)
				local oldMoney = user.getActiveCharacterData("money")
				local newMoney = round(oldMoney + (vehicle.price * .50),0)
				user.setActiveCharacterData("money", newMoney)
				user.setActiveCharacterData("vehicles", vehicles)
				print("vehicle " .. vehicle.model .. " sold for $" .. newMoney)
				return
			end
		end
	end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function playerHasValidAutoInsurance(playerInsurance)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			local reference = playerInsurance.purchaseTime
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			print(wholedays) -- today it prints "1"
			if wholedays < 32 then
				return true -- valid insurance, it was purchased 31 or less days ago
			else
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

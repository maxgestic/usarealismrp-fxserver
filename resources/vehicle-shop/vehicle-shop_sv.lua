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
		local licenses = user.getLicenses()
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
		local vehicles = user.getVehicles()
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
		local cars = user.getVehicles()
		if #cars > 0 then
			return true
		else
			return false
		end
	end)
end

function renewInsurance(source)
	local userSource = tonumber(source)
	print("player " .. GetPlayerName(source) .. " is buying auto insurance!")
	local EXPIRATION_TIME_IN_MONTHS = 1
	local INSURANCE_COVERAGE_MONTHLY_COST = 15000
	local timestamp = os.date("*t", os.time())
	local expireMonth, expireYear
	if timestamp.month < 12 then
		if timestamp.day > 10 then
			expireMonth = timestamp.month + EXPIRATION_TIME_IN_MONTHS + 1
		else
			expireMonth = timestamp.month + EXPIRATION_TIME_IN_MONTHS
		end
		expireYear = timestamp.year
	else
		expireMonth = 1
		expireYear = timestamp.year + 1
	end
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local insurance = user.getInsurance()
		if user.getMoney() >= INSURANCE_COVERAGE_MONTHLY_COST then
			local insurancePlan = {
				planName = "T. Ends Auto Insurance",
				type = "auto",
				valid = true,
				expireMonth = expireMonth,
				expireYear = expireYear
			}
			user.setInsurance(insurancePlan)
			print("taking $15,000 from player for auto insurance!")
			user.setMoney(user.getMoney() - INSURANCE_COVERAGE_MONTHLY_COST)
			TriggerClientEvent("vehShop:notify", userSource, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires on ~y~" .. padzero(expireMonth, 2) .. "/" .. expireYear .. "~w~.")
		else
			print("player did not have enough money to buy insurance")
			TriggerClientEvent("vehShop:notify", userSource, "You ~r~don't have enough money~w~ to buy auto insurance coverage!")
		end
	end)
end

RegisterServerEvent("vehShop:buyInsurance")
AddEventHandler("vehShop:buyInsurance", function()
	local userSource = tonumber(source)
	print("player " .. GetPlayerName(source) .. " is buying auto insurance!")
	local EXPIRATION_TIME_IN_MONTHS = 1
	local INSURANCE_COVERAGE_MONTHLY_COST = 15000
	local timestamp = os.date("*t", os.time())
	local expireMonth, expireYear
	if timestamp.month < 12 then
		if timestamp.day > 10 then
			expireMonth = timestamp.month + EXPIRATION_TIME_IN_MONTHS + 1
		else
			expireMonth = timestamp.month + EXPIRATION_TIME_IN_MONTHS
		end
		expireYear = timestamp.year
	else
		expireMonth = 1
		expireYear = timestamp.year + 1
	end
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local insurance = user.getInsurance()
		if user.getMoney() >= INSURANCE_COVERAGE_MONTHLY_COST then
			local insurancePlan = {
				planName = "T. Ends Auto Insurance",
				type = "auto",
				valid = true,
				expireMonth = expireMonth,
				expireYear = expireYear
			}
			user.setInsurance(insurancePlan)
			print("taking $15,000 from player for auto insurance!")
			user.setMoney(user.getMoney() - INSURANCE_COVERAGE_MONTHLY_COST)
			TriggerClientEvent("vehShop:notify", userSource, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires on ~y~" .. padzero(expireMonth, 2) .. "/" .. expireYear .. "~w~.")
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
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local playerInsurance = user.getInsurance()
		if playerInsurance.type == "auto" then
			TriggerClientEvent("chatMessage", userSource, "T. ENDS INSURANCE", {255, 78, 0}, "You are already insured! Your coverage will expire on ^3" .. padzero(playerInsurance.expireMonth, 2) .. "/" .. playerInsurance.expireYear .. "^0.")
			renewInsurance(userSource)
			return
		end
		TriggerClientEvent("vehShop:insuranceOptionMenu", userSource)
	end)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(params)
	local playerIdentifier = getPlayerIdentifierEasyMode(source)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local playerIdentifier = getPlayerIdentifierEasyMode(userSource)
		local allLicenses = user.getLicenses()
		local license = nil
		local vehicles = user.getVehicles()
		if #vehicles <= MAX_PLAYER_VEHICLES then
			for i = 1, #allLicenses do
				if allLicenses[i].name == "Driver's License" then
					license = allLicenses[i]
					break
				end
			end
			if license ~= nil then
				if license.status == "valid" then
					local splitStr = stringSplit(params,":")
					hash = splitStr[1]
					price = splitStr[2]
					vehicleName = splitStr[3]
		            if not alreadyHasVehicle(userSource, vehicleName) then
		    			if tonumber(price) <= user.getMoney() then
							plate = tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
		    				--TriggerClientEvent("mini:spawnVehicleAtShop", source, hash, vehicleName, tostring(plate)) -- spawn it
							TriggerEvent('es:getPlayerFromId', userSource, function(user)
								local vehicles = user.getVehicles()
								if vehicles then
									user.setMoney(user.getMoney() - tonumber(price)) -- subtract price from user's money and store resulting amount
									local vehicle = {
										owner = GetPlayerName(userSource),
										model = vehicleName,
										hash = hash,
										plate = plate,
										stored = false,
										price = price
									}
									--  prevent gui menu from breaking i believe (i think 16 is max # of menu items possible)
									print("#vehicles: " .. #vehicles)
									print("buying vehicle")
									table.insert(vehicles, vehicle)
									user.setVehicles(vehicles)
									print("vehicle purchased!")
									print("vehicle.owner = " .. vehicle.owner)
									print("vehicle.model = " .. vehicle.model)
									print("vehicle.plate = " .. vehicle.plate)
									print("vehicle.stored = " .. tostring(vehicle.stored))
									TriggerEvent("sway:updateDB", userSource)
									TriggerClientEvent("vehShop:spawnPlayersVehicle", userSource, hash, plate)
								end
							end)
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
		local vehicles = user.getVehicles()
		TriggerClientEvent("vehShop:displayVehiclesToSell", userSource, vehicles)
	end)
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local vehicles = user.getVehicles()
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if vehicle.model == toSellVehicle.model then
				table.remove(vehicles, i)
				local oldMoney = user.getMoney()
				local newMoney = round(oldMoney + (vehicle.price * .50),0)
				user.setMoney(newMoney)
				user.setVehicles(vehicles)
				print("vehicle " .. vehicle.model .. " sold for $" .. newMoney)
				return
			end
		end
	end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

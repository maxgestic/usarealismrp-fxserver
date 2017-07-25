local price, vehicleName, hash, plate

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
		local cars = user.vehicles
		if #cars > 0 then
			return true
		else
			return false
		end
	end)
end

RegisterServerEvent("vehShop:buyInsurance")
AddEventHandler("vehShop:buyInsurance", function()
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
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local insurance = user.getInsurance()
		if user.getMoney() >= INSURANCE_COVERAGE_MONTHLY_COST then
			local insurancePlan = {
				planName = "T. Ends Auto Insurance",
				type = "auto",
				valid = true,
				expireMonth = expireMonth,
				expireYear = expireYear
			}
			table.insert(insurance, insurancePlan)
			user.setInsurance(insurance)
			print("taking $15,000 from player for auto insurance!")
			user.removeMoney(INSURANCE_COVERAGE_MONTHLY_COST)
			TriggerClientEvent("vehShop:notify", source, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires on ~y~" .. padzero(expireMonth, 2) .. "/" .. expireYear .. "~w~.")
		else
			print("player did not have enough money to buy insurance")
			TriggerClientEvent("vehShop:notify", source, "You ~r~don't have enough money~w~ to buy auto insurance coverage!")
		end
	end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end

RegisterServerEvent("vehShop:checkPlayerInsurance")
AddEventHandler("vehShop:checkPlayerInsurance", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local playerInsurance = user.getInsurance()
		for i = 1, #playerInsurance do
			if playerInsurance[i].type == "auto" then
				TriggerClientEvent("chatMessage", source, "T. ENDS INSURANCE", {255, 78, 0}, "You are already insured! Your coverage will expire on ^3" .. padzero(playerInsurance[i].expireMonth, 2) .. "/" .. playerInsurance[i].expireYear .. "^0.")
				return
			end
		end
		TriggerClientEvent("vehShop:insuranceOptionMenu", source)
	end)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(params)
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local license = nil
		local licenses = user.getLicenses()
		local vehicles = user.getVehicles()
		for i = 1, #licenses do
			if licenses[i].name == "Driver's License" then
				license = licenses[i]
			end
		end
		if license then
			if license.status == "valid" then
				local splitStr = stringSplit(params,":")
				hash = splitStr[1]
				price = splitStr[2]
				vehicleName = splitStr[3]
	            if not alreadyHasVehicle(userSource, vehicleName) then
	    			if tonumber(price) <= user.getMoney() then
						print("player had enough money, spawning vehicle " .. vehicleName)
						plate = tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
	    				TriggerClientEvent("mini:spawnVehicleAtShop", userSource, hash, vehicleName, tostring(plate)) -- spawn it
						user.removeMoney(tonumber(price))
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
	end)
end)

-- saves vehicle to DMV / PLAYER
RegisterServerEvent("vehShop:setHandle")
AddEventHandler("vehShop:setHandle", function(vehicleHandle)
    local userSource = source
    TriggerEvent('es:exposeDBFunctions', function(GetDoc)
    	TriggerEvent('es:getPlayerFromId', userSource, function(user)
            print("inside of setHandle")
            print("model = " .. vehicleName)
    		local vehicles = user.getVehicles()
    		if vehicles then
    			local vehicle = {
    				owner = GetPlayerName(userSource),
    				model = vehicleName,
    				hash = hash,
    				plate = plate,
    				handle = vehicleHandle,
    				stored = false,
                    impounded = false,
                    stolen = false
    			}
    			if #vehicles > 0 then
    				table.remove(vehicles) -- overwrite previous vehicle (temp)
    			end
    			table.insert(vehicles, vehicle)
    			user.setVehicles(vehicles)
    			print("vehicle added:")
    			print("vehicle.owner = " .. vehicle.owner)
    			print("vehicle.model = " .. vehicle.model)
    			print("vehicle.plate = " .. vehicle.plate)
    			print("vehicle.handle = " .. vehicle.handle)
    			print("vehicle.stored = " .. tostring(vehicle.stored))
                -- update DB
                print("inside of exposed db functions event")
    			GetDoc.createDocument("dmv", vehicle, function() -- add vehicle object to dmv DB
    				print("Vehicle has been added to the database!")
                    print("owner: " .. vehicle.owner)
                    print("make/model: " .. vehicle.model)
    			end)
		    end
	   end)
   end)
end)

RegisterServerEvent("garage:giveKey")
AddEventHandler("garage:giveKey", function(key)
	local already_has_key = false
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local inv = user.getActiveCharacterData("inventory")
		for i = 1, #inv do
			local item = inv[i]
			if item then
				if string.find(item.name, "Key") then
					if string.find(key.plate, item.plate) then
						already_has_key = true
					end
				end
			end
		end
		if not already_has_key then
			table.insert(inv, key)
			user.setActiveCharacterData("inventory", inv)
		end
		-- add to server side list of plates being tracked for locking resource:
		TriggerEvent("lock:addPlate", key.plate)
		return
end)

RegisterServerEvent("garage:storeKey")
AddEventHandler("garage:storeKey", function(plate)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local inv = user.getActiveCharacterData("inventory")
		if inv then
			for i = 1, #inv do
				local item = inv[i]
				if item then
					if string.find(item.name, "Key") then
						if plate then
							if string.find(plate, item.plate) then
								table.remove(inv, i)
								user.setActiveCharacterData("inventory", inv)
								-- remove key from lock resource toggle list:
								TriggerEvent("lock:removePlate", item.plate)
								return
							end
						end
					end
				end
			end
		end
end)

RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText, required_jobs)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if required_job then
		local userJob = user.getActiveCharacterData("job")
		for i = 1, #required_jobs do
			if required_jobs[i] == userJob then
				local userVehicles = user.getActiveCharacterData("vehicles")
				for i = 1, #userVehicles do
					local vehicle = userVehicles[i]
					if numberPlateText and vehicle then
						if string.match(numberPlateText,tostring(vehicle.plate)) or numberPlateText == vehicle.plate then -- player actually owns car that is being stored
							userVehicles[i].stored = true
							user.setActiveCharacterData("vehicles", userVehicles)
							TriggerClientEvent("garage:storeVehicle", source)
							return
						end
					end
				end
				TriggerClientEvent("garage:notify", source, "~r~You do not own that vehicle!")
				return
			end
		end
		TriggerClientEvent("usa:notify", source, "Garage prohibited!")
	else
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			if numberPlateText and vehicle then
				if string.match(numberPlateText,tostring(vehicle.plate)) or numberPlateText == vehicle.plate then -- player actually owns car that is being stored
					userVehicles[i].stored = true
					user.setActiveCharacterData("vehicles", userVehicles)
					TriggerClientEvent("garage:storeVehicle", source)
					return
				end
			end
		end
		TriggerClientEvent("garage:notify", source, "~r~You do not own that vehicle!")
	end
end)

function playerHasValidAutoInsurance(playerInsurance, source)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			local reference = playerInsurance.purchaseTime
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			print(wholedays) -- today it prints "1"
			if wholedays < 32 then
				return true -- valid insurance, it was purchased 31 or less days ago
			else
				TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry! Your insurance coverage expired. We won't be able to help you.")
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

RegisterServerEvent("garage:checkVehicleStatus")
AddEventHandler("garage:checkVehicleStatus", function(vehicle, property)
	print("inside checkVehicleStatus with vehicle = " .. vehicle.model)
	local userSource = tonumber(source)
	local withdraw_fee = 0
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local userVehicles = user.getActiveCharacterData("vehicles")
		local playerInsurance = user.getActiveCharacterData("insurance")
		local user_money = user.getActiveCharacterData("money")
		if vehicle.impounded == true then
			withdraw_fee = 2000
			if user_money >= withdraw_fee then
				TriggerClientEvent("garage:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				user.setActiveCharacterData("money", user_money - withdraw_fee)
				-- give money to garage owner --
				if property then
					TriggerEvent("properties:addMoney", property.name, round(0.15 * withdraw_fee, 0))
				end
				--vehicle.impounded = false
				for i = 1, #userVehicles do
					local thisVeh = userVehicles[i]
					if thisVeh.plate == vehicle.plate then
						userVehicles[i].impounded = false
						user.setActiveCharacterData("vehicles", userVehicles)
					end
				end
			else
				TriggerClientEvent("garage:notify", userSource, "~r~BC IMPOUND: ~w~Your car is impounded and can be retrieved for $2,000!")
			end
			return
		end
		if vehicle.stored == false then
			--[[
			if playerHasValidAutoInsurance(playerInsurance, userSource) then
				withdraw_fee = 900
				--TriggerClientEvent("garage:notify", userSource, "~g~T. ENDS INSURANCE: ~w~Here's your vehicle! ~y~You will now need to renew your insurance.")
				TriggerClientEvent("garage:notify", userSource, "~g~T. ENDS INSURANCE: ~w~Here's your vehicle! Storage fee: $" .. withdraw_fee)
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				--user.setInsurance({})
				if user_money >= withdraw_fee then
					user.setActiveCharacterData("money", user_money - withdraw_fee)
				else
					local user_bank = user.getActiveCharacterData("bank")
					if user_bank >= withdraw_fee then
						user.setActiveCharacterData("bank", user_bank  - withdraw_fee)
					else
						print("user literally doesn't have any money to withdraw their vehicle from the garage!")
					end
				end
			else
				TriggerClientEvent("garage:vehicleNotStored", userSource)
			end
			--]]
			TriggerClientEvent("garage:vehicleNotStored", userSource)
		else
			withdraw_fee = 50
			TriggerClientEvent("garage:notify", userSource, "Here's your car! Storage Fee: $" .. withdraw_fee)
			TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
			--vehicle.stored = false
			for i = 1, #userVehicles do
				local thisVeh = userVehicles[i]
				if thisVeh.plate == vehicle.plate then
					userVehicles[i].stored = false
					user.setActiveCharacterData("vehicles", userVehicles)
					user.setActiveCharacterData("money", user_money - withdraw_fee)
					-- give money to garage owner --
					if property then
						TriggerEvent("properties:addMoney", property.name, round(0.30 * withdraw_fee, 0))
					end
					return
				end
			end
		end
end)

--[[
RegisterServerEvent("garage:spawn")
AddEventHandler("garage:spawn", function()
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local vehs = user.getActiveCharacterData("vehicles")
		if #(vehs)  == 0 then
			TriggerClientEvent("garage:notify", userSource, "~y~You don't seem to own any vehicles.")
		else
			TriggerClientEvent("garage:spawn", userSource, vehs)
			TriggerClientEvent("garage:notify", userSource, "~g~Here you go. Drive safe!")
		end
	end)
end)
--]]
-- new

RegisterServerEvent("garage:openMenu")
AddEventHandler("garage:openMenu", function(required_jobs)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if required_jobs then
		local userJob = user.getActiveCharacterData("job")
		for i = 1, #required_jobs do
			if required_jobs[i] == userJob then
				local playerVehicles = user.getActiveCharacterData("vehicles")
				TriggerClientEvent("garage:openMenuWithVehiclesLoaded", source, playerVehicles)
				return
			end
			TriggerClientEvent("usa:notify", source, "Garage prohibited!")
		end
	else
		local playerVehicles = user.getActiveCharacterData("vehicles")
		TriggerClientEvent("garage:openMenuWithVehiclesLoaded", source, playerVehicles)
	end
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			if string.match(numberPlateText,tostring(vehicle.plate)) ~= nil or numberPlateText == vehicle.plate then -- player actually owns car that is being stored
				userVehicles[i].stored = true
				user.setActiveCharacterData("vehicles", userVehicles)
				TriggerClientEvent("garage:storeVehicle", userSource)
				return
			end
		end
		TriggerClientEvent("garage:notify", userSource, "~r~You do not own that vehicle!")
	end)
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
AddEventHandler("garage:checkVehicleStatus", function(vehicle)
	print("inside checkVehicleStatus with vehicle = " .. vehicle.model)
	local userSource = tonumber(source)
	local withdraw_fee = 0
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local userVehicles = user.getActiveCharacterData("vehicles")
		local playerInsurance = user.getActiveCharacterData("insurance")
		local user_money = user.getActiveCharacterData("money")
		if vehicle.impounded == true then
			withdraw_fee = 2000
			print("users vehicle was impounded!")
			if user_money >= withdraw_fee then
				TriggerClientEvent("garage:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				user.setActiveCharacterData("money", user_money - withdraw_fee)
				--vehicle.impounded = false
				for i = 1, #userVehicles do
					local thisVeh = userVehicles[i]
					if thisVeh.plate == vehicle.plate then
						print("user retrieved an impounded vehicle.. setting impounded to false")
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
		else
			withdraw_fee = 150
			TriggerClientEvent("garage:notify", userSource, "Here's your car! Storage Fee: $" .. withdraw_fee)
			TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
			--vehicle.stored = false
			for i = 1, #userVehicles do
				local thisVeh = userVehicles[i]
				if thisVeh.plate == vehicle.plate then
					userVehicles[i].stored = false
					user.setActiveCharacterData("vehicles", userVehicles)
					user.setActiveCharacterData("money", user_money - withdraw_fee)
				end
			end
		end
	end)
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
AddEventHandler("garage:openMenu", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local playerVehicles = user.getActiveCharacterData("vehicles")
		TriggerClientEvent("garage:openMenuWithVehiclesLoaded", userSource, playerVehicles)
	end)
end)

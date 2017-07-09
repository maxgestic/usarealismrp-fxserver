RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText)
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local vehicles = user.getVehicles()
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			local vehiclePlate = vehicle.plate
			if string.match(numberPlateText,vehiclePlate) ~= nil then -- player actually owns the car that player is attempting to store
				vehicles[i].stored = true
				user.setVehicles(vehicles)
				TriggerClientEvent("garage:storeVehicle", source)
				return
			end
		end
		-- after checking all owned vehicles, player doesn't appear to own that car
		TriggerClientEvent("garage:notify", source, "~r~You do not own that vehicle!")
	end)
end)

function playerHasValidAutoInsurance(playerInsurance)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			if timestamp.year <= playerInsurance.expireYear then
				if timestamp.month < playerInsurance.expireMonth then
					-- valid insurance
					return true
				else
					-- expired month
					TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry your coverage ended on " .. playerInsurance.month .. "/" .. playerInsurance.year .. ". We won't be able to help you.")
					return false
				end
			else
				-- expired year
				TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry your coverage ended on " .. playerInsurance.month .. "/" .. playerInsurance.year .. ". We won't be able to help you.")
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

RegisterServerEvent("garage:checkVehicleStatus")
AddEventHandler("garage:checkVehicleStatus", function()
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local vehicles = user.getVehicles()
		local playerInsurance = user.getInsurance()
		local autoInsurance = {}
		local hasAutoInsurance = false
		print("#playerInsurance = " .. #playerInsurance)
		for x = 1, #playerInsurance do
			local insurance = playerInsurance[x]
			if insurance then
				if insurance.type == "auto" then
					hasAutoInsurance = true
					autoInsurance = insurance
				end
			end
		end
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			print("checking if " .. GetPlayerName(userSource) ..  " vehicle was impounded")
			print("vehicle.impounded = " .. tostring(vehicle.impounded))
			if vehicle.impounded == true then
				if user.getMoney() >= 2000 then
					TriggerClientEvent("garage:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
					TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
					user.removeMoney(2000)
					vehicles[i].impounded = false
					user.setVehicles(vehicles)
					return
				else
					TriggerClientEvent("garage:notify", source, "~r~BC IMPOUND: ~w~Your car is impounded and can be retrieved for $2,000!")
				end
				return
			end
			-- not impounded, check if stored or not
			if vehicle.stored == false then
				if hasAutoInsurance then
					if playerHasValidAutoInsurance(autoInsurance) then
						TriggerClientEvent("garage:notify", source, "~g~T. ENDS INSURANCE: ~w~Here's your car!")
						TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
					end
				else
					TriggerClientEvent("garage:vehicleNotStored", userSource)
				end
			else
				TriggerClientEvent("garage:notify", userSource, "Here's your car!")
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				vehicles[i].stored = false
				user.setVehicles(vehicles)
			end
		end
	end)
end)

RegisterServerEvent("garage:spawn")
AddEventHandler("garage:spawn", function()
	local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local vehicles = user.getVehicles()
			if #vehicles < 1 then
				TriggerClientEvent("garage:notify", userSource, "~y~You don't seem to own a vehicle.")
			else
				TriggerClientEvent("garage:spawn", userSource, vehicles[1]) -- currently only spawn first vehicle in player's owned vehicles list
				TriggerClientEvent("garage:notify", userSource, "~g~Here you go, Drive safe!")
			end
	end)
end)

TriggerEvent("es:addCommand", "pv", function(source, args, user)
	TriggerClientEvent("chatMessage", source, "Mechanic", {30, 166, 209}, "Sorry man, I can't get to you at the moment! Come by the garage and pick it up.")
end)

TriggerEvent("es:addCommand", "PV", function(source, args, user)
	TriggerClientEvent("chatMessage", source, "Mechanic", {30, 166, 209}, "Sorry man, I can't get to you at the moment! Come by the garage and pick it up.")
end)

RegisterServerEvent("towJob:impoundVehicle")
AddEventHandler("towJob:impoundVehicle", function(targetVehicle)
	if currentlyTowedVehicle then
		if currentlyTowedVehicle == targetVehicle then -- vehicles match update
				-- Gives the loaded user corresponding to the given player id(second argument).
				-- The user object is either nil or the loaded user.
				TriggerEvent('es:getPlayerFromId', source, function(user)
					user:setMoney(user.money + 700) -- subtract price from user's money and store resulting amount
					-- user:setLicense() ??
				end)
			TriggerClientEvent("towJob:deleteVehicle", source, targetVehicle) -- delete vehicle
			currentlyTowedVehicle = nil
			TriggerClientEvent("towJob:success", source)
		else
			print ("tow: VEHICLES DON'T MATCH UP WHEN TOWING")
		end
	else
		print("tow: VEHICLE NOT IN DATABASE AS BEING TOWED!")
	end
end)

-- pv-tow :

local currentlyTowedVehicle = nil

TriggerEvent('es:addCommand', 'tow', function(source, args, user)
	TriggerClientEvent('pv:tow', source)
end)

RegisterServerEvent("tow:towingVehicle")
AddEventHandler("tow:towingVehicle", function(vehicle)
	currentlyTowedVehicle = vehicle
end)

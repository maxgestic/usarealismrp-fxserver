currentlyTowedVehicle = nil

RegisterServerEvent("towJob:impoundVehicle")
AddEventHandler("towJob:impoundVehicle", function(targetVehicle)
	local userSource = source
	if currentlyTowedVehicle then
		print("currentlyTowedVehicle = " .. currentlyTowedVehicle)
		print("targetVehicle = " .. targetVehicle)
		if currentlyTowedVehicle == targetVehicle then -- vehicles match update
				-- Gives the loaded user corresponding to the given player id(second argument).
				-- The user object is either nil or the loaded user.
				TriggerEvent('es:getPlayerFromId', userSource, function(user)
					user.addMoney(700) -- subtract price from user's money and store resulting amount
					-- user:setLicense() ??
					TriggerClientEvent("towJob:deleteVehicle", userSource, targetVehicle) -- delete vehicle
					currentlyTowedVehicle = nil
					TriggerClientEvent("towJob:success", userSource)
				end)
		else
			print ("tow: VEHICLES DON'T MATCH UP WHEN TRYING TO IMPOUND")
		end
	else
		print("tow: NO CURRENTLY SET TOWED VEHICLE!")
	end
end)

-- pv-tow :

TriggerEvent('es:addCommand', 'tow', function(source, args, user)
	TriggerClientEvent('pv:tow', source)
end)

RegisterServerEvent("tow:towingVehicle")
AddEventHandler("tow:towingVehicle", function(vehicle)
	print("setting currentlyTowedVehicle = " .. vehicle)
	currentlyTowedVehicle = vehicle
end)

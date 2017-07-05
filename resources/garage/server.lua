RegisterServerEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function(handle, numberPlateText)
	local userSource = source
	local idents = GetPlayerIdentifiers(userSource)
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
			docid = result._id
			local ownedVehicle = result.vehicle
			if ownedVehicle then
				local ownedVehicleLicensePlate = ownedVehicle.plate
				if string.match(numberPlateText,ownedVehicleLicensePlate) ~= nil then -- player actually owns the car that player is attempting to store
					ownedVehicle.stored = true
					usersTable.updateDocument("essentialmode", docid ,{vehicle = ownedVehicle},function() end)
					TriggerClientEvent("garage:storeVehicle", source)
				else
					TriggerClientEvent("garage:notify", source, "~r~You do not own that vehicle!")
				end
			end
		end)
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
	local idents = GetPlayerIdentifiers(userSource)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		TriggerEvent('es:exposeDBFunctions', function(usersTable)
			usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
				docid = result._id
				local vehicle = result.vehicle
				local playerInsurance = result.insurance
				if vehicle then
					if vehicle.impounded == true then
						if user.get("money") >= 2000 then
							local newPlayerMoney = user.get("money") - 2000
							TriggerClientEvent("garage:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
							TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
							user.removeMoney(2000)
							vehicle.impounded = false
							usersTable.updateDocument("essentialmode", docid ,{money = newPlayerMoney, vehicle = vehicle},function() end)
						else
							TriggerClientEvent("garage:notify", source, "~r~BC IMPOUND: ~w~Your car is impounded and can be retrieved for $2,000!")
						end
						return
					end
					if vehicle.stored == false then
						if playerHasValidAutoInsurance(playerInsurance) then
							TriggerClientEvent("garage:notify", source, "~g~T. ENDS INSURANCE: ~w~Here's your car!")
							TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
						else
							TriggerClientEvent("garage:vehicleNotStored", userSource)
						end
					else
						TriggerClientEvent("garage:notify", userSource, "Here's your car!")
						TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
						vehicle.stored = false
						usersTable.updateDocument("essentialmode", docid ,{vehicle = vehicle},function() end)
					end
				else
					TriggerClientEvent("garage:vehicleNotStored", userSource)
				end
			end)
		end)
	end)
end)

RegisterServerEvent("garage:spawn")
AddEventHandler("garage:spawn", function()
	local userSource = source
	local idents = GetPlayerIdentifiers(userSource)
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
			if not result.vehicle then
				TriggerClientEvent("garage:notify", source, "~y~You don't seem to own a vehicle.")
			else
				TriggerClientEvent("garage:spawn", source, result.vehicle)
				TriggerClientEvent("garage:notify", source, "~g~Here you go, Drive safe!")
			end
		end)
	end)
end)

TriggerEvent("es:addCommand", "pv", function(source, args, user)
	TriggerClientEvent("chatMessage", source, "Mechanic", {30, 166, 209}, "Sorry man, I can't get to you at the moment! Come by the garage and pick it up.")
end)

TriggerEvent("es:addCommand", "PV", function(source, args, user)
	TriggerClientEvent("chatMessage", source, "Mechanic", {30, 166, 209}, "Sorry man, I can't get to you at the moment! Come by the garage and pick it up.")
end)

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
			if timestamp.year <= playerInsurance.expireYear then
				if timestamp.month < playerInsurance.expireMonth then
					-- valid insurance
					return true
				else
					-- expired month
					TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry your coverage ended on " .. playerInsurance.expireMonth .. "/" .. playerInsurance.expireYear.. ". We won't be able to help you.")
					-- TODO: remove auto insurance so player can buy a new one without having to relog to remove it
					return false
				end
			else
				-- expired year
				TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry your coverage ended on " .. playerInsurance.expireMonth .. "/" .. playerInsurance.expireYear .. ". We won't be able to help you.")
				-- TODO: remove auto insurance so player can buy a new one without having to relog to remove it
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
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local userVehicles = user.getActiveCharacterData("vehicles")
		local playerInsurance = user.getActiveCharacterData("insurance")
		if vehicle.impounded == true then
			print("users vehicle was impounded!")
			if user.getMoney() >= 2000 then
				TriggerClientEvent("garage:notify", userSource, "~g~BC IMPOUND: ~w~Here's your car!")
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				local user_money = user.getActiveCharacterData("money")
				user.setActiveCharacterData("money", user_money - 2000)
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
				--TriggerClientEvent("garage:notify", userSource, "~g~T. ENDS INSURANCE: ~w~Here's your vehicle! ~y~You will now need to renew your insurance.")
				TriggerClientEvent("garage:notify", userSource, "~g~T. ENDS INSURANCE: ~w~Here's your vehicle!")
				TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
				--user.setInsurance({})
			else
				TriggerClientEvent("garage:vehicleNotStored", userSource)
			end
		else
			TriggerClientEvent("garage:notify", userSource, "Here's your car!")
			TriggerClientEvent("garage:vehicleStored", userSource, vehicle)
			--vehicle.stored = false
			for i = 1, #userVehicles do
				local thisVeh = userVehicles[i]
				if thisVeh.plate == vehicle.plate then
					userVehicles[i].stored = false
					user.setActiveCharacterData("vehicles", userVehicles)
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

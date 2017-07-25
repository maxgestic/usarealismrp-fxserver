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

local timeout = false

RegisterServerEvent("tow:setJob")
AddEventHandler("tow:setJob", function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if user.getJob() == "tow" then
            print("user " .. GetPlayerName(source) .. " just went off duty for Bubba's Tow Co.!")
            user.setJob("civ")
            TriggerClientEvent("tow:offDuty", source)
        else
            if not timeout then
                print("user " .. GetPlayerName(source) .. " just went on duty for Bubba's Tow Co.!")
                user.setJob("tow")
                TriggerClientEvent("tow:onDuty", source)
                timeout = true
                SetTimeout(15000, function()
                    timeout = false
                end)
            else
                print("player is on timeout and cannot go on duty for Bubba's Tow Co.!")
            end
        end
    end)
end)

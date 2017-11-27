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
					local user_money = user.getActiveCharacterData("money")
					user.setActiveCharacterData("money", user_money + 400)
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
	local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user.getActiveCharacterData("job") == "tow" then
            print("user " .. GetPlayerName(userSource) .. " just went off duty for Bubba's Tow Co.!")
            user.setActiveCharacterData("job", "civ")
            TriggerClientEvent("tow:offDuty", userSource)
        else
            if not timeout then
                print("user " .. GetPlayerName(userSource) .. " just went on duty for Bubba's Tow Co.!")
                user.setActiveCharacterData("job", "tow")
                TriggerClientEvent("tow:onDuty", userSource)
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

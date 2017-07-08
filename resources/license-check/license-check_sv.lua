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
		end
	-- no insurance at all
	return false
end

AddEventHandler("license:searchForLicense", function(source, playerId)
	    TriggerEvent('es:getPlayerFromId', tonumber(playerId), function(user)
			local vehicles = user.getVehicles()
	        local licenses = user.getLicenses()
			local insurancePlans = user.getInsurance()
			if not user then
				TriggerClientEvent("license:notifyNoExist", source, playerId) -- player not in game with that id
				return
			end
			local hasFirearmsPermit = false
			local hasDL = false
			print("#inventory = " .. #licenses)
			for i = 1, #licenses do
				print("found item " .. licenses[i].name)
					if licenses[i].name == "Driver's License" then
						local license =licenses[i]
						TriggerClientEvent("chatMessage", source, "", {0, 141, 155}, "^3Driver's License:")
						TriggerClientEvent("chatMessage", source, "DL", {169, 44, 98}, license.number)
						TriggerClientEvent("chatMessage", source, "FULL NAME", {169, 44, 98}, license.ownerName)
						TriggerClientEvent("chatMessage", source, "EXPIRES", {169, 44, 98}, license.expire)
						TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, license.status)
						hasDL = true
					elseif licenses[i].name == "Firearm Permit" then
						TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^2Firearm Permit^0.")
						hasFirearmsPermit = true
					end
			end
			if not hasDL then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No driver's license.")
			end
			if not hasFirearmsPermit then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No firearm permit on record.")
			end
			if #vehicles > 0 then
				TriggerClientEvent("mdt:vehicleInfo", source, vehicles[1])
			else
				TriggerClientEvent("mdt:vehicleInfo", source, nil)
			end
			if #insurancePlans > 0 then
				if playerHasValidAutoInsurance(insurancePlans[1]) then
					TriggerClientEvent("chatMessage", source, "", {0,141,155}, "^3Auto Insurance:")
					TriggerClientEvent("chatMessage", source, "INSURER", {0,255,0}, insurancePlans[1].planName)
					TriggerClientEvent("chatMessage", source, "EXPIRATION", {0,255,0}, padzero(insurancePlans[1].expireMonth, 2) .. "/" .. insurancePlans[1].expireYear)
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "No auto insurance on record.")
				end
			end
	    end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end


-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'mdt', function(source, args, user)
	local playerJob = user.getJob()
	local argument = args[2] -- player id to check license
	if argument == nil or type(tonumber(argument)) == nil then
		TriggerClientEvent("license:help", source)
	elseif playerJob ~= "cop" and playerJob ~= "sheriff" and playerJob ~= "highwaypatrol" then
		TriggerClientEvent("license:failureNotJurisdiction", source)
	else -- player is a cop, so allow check and perform check with argument = player id to check license
		TriggerEvent("license:searchForLicense", source, argument)
	end
end)

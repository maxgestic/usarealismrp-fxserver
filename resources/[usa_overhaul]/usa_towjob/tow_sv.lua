local TOW_REWARD = {70, 120}

RegisterServerEvent("towJob:giveReward")
AddEventHandler("towJob:giveReward", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "tow" then
		local amountRewarded = math.random(TOW_REWARD[1], TOW_REWARD[2])
		char.giveMoney(amountRewarded)
		TriggerClientEvent('usa:notify', source, 'Vehicle impounded, you have received: ~y~$'..amountRewarded..'.00')
		print("TOW: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has received amount["..amountRewarded..'] for impounding vehicle!')
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
    	TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit towJob:giveReward event, please intervene^0!')
    end
end)

-- pv-tow :

TriggerEvent('es:addJobCommand', 'tow', { "tow" }, function(source, args, char)
	TriggerClientEvent('towJob:towVehicleInFront', source)
end, {
	help = "Load or unload the car in front of you onto a flatbed."
})

RegisterServerEvent("towJob:setJob")
AddEventHandler("towJob:setJob", function(truckSpawnCoords)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "tow" then
		print("TOW: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] is now OFF-DUTY for TOW")
		TriggerClientEvent("towJob:offDuty", source)
		char.set("job", "civ")
	else
		local drivers_license = char.getItem("Driver's License")
		if drivers_license then
			print("TOW: Found item[Driver's License] on " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."], checking suspensions...")
			if drivers_license.status == "valid" then
				local usource = source
				print("TOW: " .. GetPlayerName(usource) .. "["..GetPlayerIdentifier(usource).."] is now ON-DUTY for TOW")
				TriggerClientEvent("towJob:showHelpText", usource, "Use ~y~/dispatch [id] [msg]~s~ to respond to a tow request!")
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/dispatch [id] [msg]^0 to respond to a tow request!")
				Citizen.Wait(6000)
				TriggerClientEvent("towJob:showHelpText", usource, "Use ~y~/tow~s~ when facing a vehicle to load/unload it from the flatbed.")
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/tow^0 when facing a vehicle to load/unload it from the flatbed.")
				Citizen.Wait(6000)
				TriggerClientEvent("towJob:showHelpText", usource, "Use ~y~/ping [id]~s~ to request a person\'s location.")
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/ping [id]^0 to request a person\'s location.")
				Citizen.Wait(6000)
				TriggerClientEvent("towJob:showHelpText", usource, "A tow truck has been equipped for you just there, use this to tow vehicles.")
				TriggerClientEvent("chatMessage", usource, "", {}, "A tow truck has been equipped for you just there, use this to tow vehicles.")
				char.set("job", "tow")
				TriggerClientEvent("towJob:onDuty", usource, truckSpawnCoords)
				return
			else
				TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
				print("TOW: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has a suspended license!")
				return
			end
		end
		if not has_dl then
			TriggerClientEvent("usa:notify", source, "You do not have a driver's license!")
			return
		end
	end
end)

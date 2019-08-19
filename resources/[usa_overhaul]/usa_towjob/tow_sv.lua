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
		TriggerClientEvent("towJob:offDuty", source)
		char.set("job", "civ")
	else
		local drivers_license = char.getItem("Driver's License")
		if drivers_license then
			if drivers_license.status == "valid" then
				local usource = source
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/dispatch [id] [msg]^0 to respond to a tow request!")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/tow^0 when facing a vehicle to load/unload it from the flatbed.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/ping [id]^0 to request a person\'s location.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "A tow truck has been equipped for you just there, use this to tow vehicles.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Press ^3SHIFT + F2 to open the radio^0, left/right arrows keys to change channels, and CAPS LOCK to speak on it")
				char.set("job", "tow")
				TriggerClientEvent("towJob:onDuty", usource, truckSpawnCoords)
				return
			else
				TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
				return
			end
		end
		if not has_dl then
			TriggerClientEvent("usa:notify", source, "You do not have a driver's license!")
			return
		end
	end
end)

RegisterServerEvent("tow:forceRemoveJob")
AddEventHandler("tow:forceRemoveJob", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	char.set("job", "civ")
	TriggerClientEvent("towJob:offDuty", source)
	TriggerClientEvent("radio:unsubscribe", source)
end)
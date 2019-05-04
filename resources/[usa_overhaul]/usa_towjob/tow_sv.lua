local TOW_REWARD = {70, 120}

RegisterServerEvent("towJob:giveReward")
AddEventHandler("towJob:giveReward", function()
	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_money = user.getActiveCharacterData("money")
	local amountRewarded = math.random(TOW_REWARD[1], TOW_REWARD[2])
	user.setActiveCharacterData("money", user_money + amountRewarded)
	TriggerClientEvent('usa:notify', userSource, 'Vehicle impounded, you have received: ~y~$'..amountRewarded..'.00')
	print("TOW: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has received amount["..amountRewarded..'] for impounding vehicle!')
end)

-- pv-tow :

TriggerEvent('es:addJobCommand', 'tow', { "tow" }, function(source, args, user)
	TriggerClientEvent('towJob:towVehicleInFront', source)
end, {
	help = "Load or unload the car in front of you onto a flatbed."
})

RegisterServerEvent("towJob:setJob")
AddEventHandler("towJob:setJob", function(truckSpawnCoords)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_job = user.getActiveCharacterData("job")
	local user_licenses = user.getActiveCharacterData("licenses")
	local has_dl = false
	if user_job == "tow" then
		print("TOW: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now OFF-DUTY for TOW")
		user.setActiveCharacterData("job", "civ")
		TriggerClientEvent("towJob:offDuty", userSource)
	else
		for i = 1, #user_licenses do
		  local item = user_licenses[i]
		  if string.find(item.name, "Driver's License") then
			print("TOW: Found item[Driver's License] on " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."], checking suspensions...")
			has_dl = true
			if item.status == "valid" then
				print("TOW: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] is now ON-DUTY for TOW")
				Citizen.CreateThread(function()
					TriggerClientEvent("towJob:showHelpText", userSource, "Use ~y~/dispatch [id] [msg]~s~ to respond to a tow request!")
					Citizen.Wait(6000)
					TriggerClientEvent("towJob:showHelpText", userSource, "Use ~y~/tow~s~ when facing a vehicle to load/unload it from the flatbed.")
					Citizen.Wait(6000)
					TriggerClientEvent("towJob:showHelpText", userSource, "Use ~y~/ping [id]~s~ to request a person\'s location.")
					Citizen.Wait(6000)
					TriggerClientEvent("towJob:showHelpText", userSource, "A tow truck has been equipped for you just there, use this to tow vehicles.")
				end)
				user.setActiveCharacterData("job", "tow")
				TriggerClientEvent("towJob:onDuty", userSource, truckSpawnCoords)
				return
			else
				TriggerClientEvent("usa:notify", userSource, "Your driver's license is ~y~suspended~s~!")
				print("TOW: " .. GetPlayerName(userSource) .. "["..GetPlayerIdentifier(userSource).."] has a suspended license!")
				return
			end
		  end
		end
		if not has_dl then
			TriggerClientEvent("usa:notify", userSource, "You do not have a driver's license!")
			return
		end
	end
end)

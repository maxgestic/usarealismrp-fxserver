RegisterNetEvent("vehicleCommands:spawnVehicle")
AddEventHandler("vehicleCommands:spawnVehicle", function(modelName)

		local hash = GetHashKey(modelName)

	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(hash)

		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		-- Model loaded, continue

		local playerPed = GetPlayerPed(-1)

		-- Get the player coords so that we know where to spawn it
		local playerCoords = GetEntityCoords(playerPed --[[Ped]], false)

		local heading = GetEntityHeading(playerPed)

		-- Spawn the vehicle and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(hash, playerCoords.x, playerCoords.y + 4.5, playerCoords.z, heading --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])

		SetVehicleNumberPlateText(vehicle, GetPlayerName(PlayerId()))
	end)

end)

RegisterNetEvent("vehicleCommands:error")
AddEventHandler("vehicleCommands:error", function(msg)

	TriggerEvent("chatMessage", "SYSTEM", { 255, 180, 0 }, msg)

end)

RegisterNetEvent("vehicleCommands:setLivery")
AddEventHandler("vehicleCommands:setLivery", function(livery)
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		liveries = GetVehicleLiveryCount(vehicle)
		livery = tonumber(livery)
		if liveries >= livery and livery > 0 then
			SetVehicleLivery(vehicle, livery)
			TriggerEvent("chatMessage", "CAR", { 255, 180, 0 }, "Added livery "..livery.." to vehicle.")
		else
			TriggerEvent("chatMessage", "CAR", { 255, 180, 0 }, livery.." is not a valid livery. Max livery: "..liveries)
		end
	else
		TriggerEvent("chatMessage", "CAR", { 255, 180, 0 }, "You must be in a car to set the livery.")
	end
end)

RegisterNetEvent("vehicleCommands:setExtra")
AddEventHandler("vehicleCommands:setExtra", function(extra, toggle)
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		extra = tonumber(extra)
		if DoesExtraExist(vehicle, extra) then
			if IsVehicleExtraTurnedOn(vehicle, extra) then
				SetVehicleExtra(vehicle, extra, true)
			else
				SetVehicleExtra(vehicle, extra, false)
			end
		else
			TriggerEvent("chatMessage", "CAR", { 255, 180, 0 }, extra.." is not a valid extra.")
		end
	else
		TriggerEvent("chatMessage", "CAR", { 255, 180, 0 }, "You must be in a car to set the livery.")
	end
end)

RegisterNetEvent("vehicleCommands:upgradeEngine")
AddEventHandler("vehicleCommands:upgradeEngine", function(param)
	if param then
		local curVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		local engine = 11
	--	local engineParam = 3
	--	local armor = 16
	--	local armorLevel = 3
	--	local turbo = 18
		local turboActivated = true
		SetVehicleModKit(curVehicle, 0)
		SetVehicleMod(curVehicle, engine, tonumber(param))
		--SetVehicleMod(curVehicle, armor, armorLevel)
		--SetVehicleMod(curVehicle, turbo, turboActivated)
		Citizen.Trace("after upgrading...")
		Citizen.Trace("curVehicle = " .. curVehicle)
		Citizen.Trace("mod #11: " .. GetVehicleMod(curVehicle, engine))
		--Citizen.Trace("mod #16: " .. GetVehicleMod(curVehicle, armor))
		--Citizen.Trace("mod #18: " .. GetVehicleMod(curVehicle, turbo))
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Vehicle engine upgraded! Level: " .. param)
		DrawNotification(0,1)
	else
		Citizen.Trace("no engine param passed!")
		local num = GetNumVehicleMods(curVehicle, engine)
		SetNotificationTextEntry("STRING")
		AddTextComponentString("~y~Options: ~w~0 - " .. num)
		DrawNotification(0,1)
	end
end)

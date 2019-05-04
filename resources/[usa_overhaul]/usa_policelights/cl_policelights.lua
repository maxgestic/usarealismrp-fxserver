local vehWithLights = nil
local lightsEnabled = false
 -- get the entity model for each player when lights are toggled on the vehicle and keep track for everyone
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsDisabledControlJustPressed(0, 58) then
			local playerPed = PlayerPedId()
			local playerVeh = GetVehiclePedIsUsing(playerPed)
			if GetPedInVehicleSeat(playerVeh, -1) == playerPed then
				if playerVeh == vehWithLights then
					PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					lightsEnabled = not lightsEnabled
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if lightsEnabled and vehWithLights then
			local netVeh = VehToNet(vehWithLights)
			SetVehicleLightsMode(vehWithLights, 2)
			SetVehicleLights(vehWithLights, 2)
			ToggleVehicleMod(vehWithLights, 22, true)
			SetVehicleLightMultiplier(vehWithLights, 5.0)
			for i = 1, 20 do
				if lightsEnabled then
					SetVehicleNeonLightEnabled(vehWithLights, 0, true)
					SetVehicleNeonLightsColour(veh, 2, 21, 255)
					TriggerServerEvent('policelights:requestHeadlightColor', netVeh, 8)
					Citizen.Wait(50)
					SetVehicleNeonLightEnabled(vehWithLights, 0, false)
					Citizen.Wait(50)
					SetVehicleNeonLightEnabled(vehWithLights, 1, true)
					SetVehicleNeonLightsColour(veh, 1, 1, 255)
					TriggerServerEvent('policelights:requestHeadlightColor', netVeh, 1)
					Citizen.Wait(50)
					SetVehicleNeonLightEnabled(vehWithLights, 1, false)
				else
					SetVehicleNeonLightEnabled(vehWithLights, 0, false)
					SetVehicleNeonLightEnabled(vehWithLights, 1, false)
					SetVehicleNeonLightEnabled(vehWithLights, 2, false)
					SetVehicleNeonLightEnabled(vehWithLights, 3, false)
					SetVehicleLightMultiplier(vehWithLights, 1.0)
					ToggleVehicleMod(vehWithLights, 22, false)
					SetVehicleLightsMode(vehWithLights, 0)
					SetVehicleLights(vehWithLights, 0)
					SetVehicleFullbeam(vehWithLights, false)
				end
			end
			for i = 1, 10 do
				if lightsEnabled then
					Citizen.Wait(100)
					SetVehicleNeonLightsColour(vehWithLights, 2, 21, 255)
					TriggerServerEvent('policelights:requestHeadlightColor', netVeh, 8)
					SetVehicleNeonLightEnabled(vehWithLights, 0, true)
					SetVehicleNeonLightEnabled(vehWithLights, 1, true)
					SetVehicleNeonLightEnabled(vehWithLights, 2, true)
					SetVehicleNeonLightEnabled(vehWithLights, 3, true)
					Citizen.Wait(100)
					SetVehicleNeonLightEnabled(vehWithLights, 0, false)
					SetVehicleNeonLightEnabled(vehWithLights, 1, false)
					SetVehicleNeonLightEnabled(vehWithLights, 2, false)
					SetVehicleNeonLightEnabled(vehWithLights, 3, false)
					Citizen.Wait(100)
					SetVehicleNeonLightsColour(vehWithLights, 255, 1, 1)
					TriggerServerEvent('policelights:requestHeadlightColor', netVeh, 1)
					SetVehicleNeonLightEnabled(vehWithLights, 0, true)
					SetVehicleNeonLightEnabled(vehWithLights, 1, true)
					SetVehicleNeonLightEnabled(vehWithLights, 2, true)
					SetVehicleNeonLightEnabled(vehWithLights, 3, true)
					Citizen.Wait(100)
					SetVehicleNeonLightEnabled(vehWithLights, 0, false)
					SetVehicleNeonLightEnabled(vehWithLights, 1, false)
					SetVehicleNeonLightEnabled(vehWithLights, 2, false)
					SetVehicleNeonLightEnabled(vehWithLights, 3, false)
				else
					SetVehicleNeonLightEnabled(vehWithLights, 0, false)
					SetVehicleNeonLightEnabled(vehWithLights, 1, false)
					SetVehicleNeonLightEnabled(vehWithLights, 2, false)
					SetVehicleNeonLightEnabled(vehWithLights, 3, false)
					SetVehicleLightMultiplier(vehWithLights, 1.0)
					ToggleVehicleMod(vehWithLights, 22, false)
					SetVehicleLightsMode(vehWithLights, 0)
					SetVehicleLights(vehWithLights, 0)
					SetVehicleFullbeam(vehWithLights, false)
				end
			end
		end
	end
end)

NetworkOverrideClockTime(22, 00, 0)

Citizen.CreateThread(function()
	local red = true
	while true do
		Citizen.Wait(200)
		if lightsEnabled and vehWithLights then
			local netVeh = VehToNet(vehWithLights)
			local positions = {
				{x = 0.0, y = -7.0, z = -1.0},
				{x = -7.0, y = 0.0, z = -1.0},
				{x = 7.0, y = 0.0, z = -1.0}
			}
			for i = 1, #positions do
				local pos = positions[i]
				local vehCoords = GetEntityCoords(vehWithLights)
				local offset = GetOffsetFromEntityInWorldCoords(vehWithLights, pos.x, pos.y, pos.z)
      			local target = offset - vehCoords
				--print(target) 
				if red then 
					TriggerServerEvent('policelights:requestSpotlight', netVeh, target, 255, 1, 1)
				else
					TriggerServerEvent('policelights:requestSpotlight', netVeh, target, 2, 21, 255)
				end
				red = not red
			end
		end
	end
end)

RegisterNetEvent('policelights:enableLightsOnVehicle')
AddEventHandler('policelights:enableLightsOnVehicle', function()
	local playerPed = PlayerPedId()
	local playerVeh = GetVehiclePedIsUsing(playerPed)
	if GetVehicleClass(playerVeh) ~= 18 and GetVehicleClass(playerVeh) ~= 21 and GetVehicleClass(playerVeh) ~= 16 and GetVehicleClass(playerVeh) ~= 15 and GetVehicleClass(playerVeh) ~= 14 and GetVehicleClass(playerVeh) ~= 13 and IsPedInAnyVehicle(playerPed) then
		SetVehicleModKit(playerVeh, 0)
		SetVehicleMod(playerVeh, 14, 1, false)
		vehWithLights = playerVeh
		lightsEnabled = false
		TriggerEvent('usa:notify', 'Undercover lights have been ~g~installed~s~!')
	else
		vehWithLights = nil
		lightsEnabled = false
		TriggerEvent('usa:notify', '~y~This vehicle cannot have undercover lights!')
	end
end)

RegisterNetEvent('policelights:setSpotlight')
AddEventHandler('policelights:setSpotlight', function(netVeh, direction, r, g, b)
	local playerVeh = NetToVeh(netVeh)
	local vehCoords = GetEntityCoords(playerVeh)
	if Vdist(GetEntityCoords(PlayerPedId()), vehCoords) < 300 then
		local beginTime = GetGameTimer()
		while GetGameTimer() - beginTime < 100 do
			Citizen.Wait(0)
			vehCoords = GetEntityCoords(playerVeh)
			DrawSpotLight(vehCoords, direction, r, g, b, 30.0, 10.0, 10.0, 45.0, 10.0)
		end
	end
end)

RegisterNetEvent('policelights:setHeadlightColor')
AddEventHandler('policelights:setHeadlightColor', function(netVeh, value)
	local playerVeh = NetToVeh(netVeh)
	local vehCoords = GetEntityCoords(playerVeh)
	if Vdist(GetEntityCoords(PlayerPedId()), vehCoords) < 300 then
		SetVehicleLightMultiplier(playerVeh, 5.0)
		SetVehicleFullbeam(playerVeh, true)
		SetVehicleHeadlightsColour(playerVeh, value)
	end
end)
local jobCoords = {
	{ 	
		duty = {x = 61.35, y = 123.83, z = 79.20},
		vehicle = {x = 66.25, y = 120.65, z = 79.10, heading = 160.0},
		job = {x = 69.06, y = 127.72, z = 79.21}
	},
	{
		duty = {x = -421.58, y = 6137.19, z = 31.87},
		vehicle = {x = -424.84, y = 6128.60, z = 31.46, heading = 236.0},
		job = {x = -427.83, y = 6133.97, z = 31.47}
	}
}

local deliveryLocations = {
	{x = 92.51, y = 187.70, z = 105.26},
	{x = -969.79, y = -266.51, z = 38.54},
	{x = -992.74, y = -281.59, z = 38.18},
	{x = -1468.50, y= -398.31, z = 38.52},
	{x = -1566.01, y= -231.44, z = 49.46},
	{x = -1368.00, y = -647.18, z = 28.69},
	{x = -1399.43, y = -657.82, z = 28.67},
	{x = -1331.22, y = -739.83, z = 25.26},
	{x = -1357.83, y = -750.14, z = 22.16},
	{x = -1306.35, y = -801.77, z = 17.56},
	{x = -1286.91, y = -833.40, z = 17.09},
	{x = -1257.44, y = -1149.91, z = 7.60},
	{x = -1169.93, y = -1170.87, z = 5.62},
	{x = -1185.98, y= -1385.85, z = 4.62},
	{x = -1146.99, y = -1562.04, z = 4.4},
	{x = -1376.80, y = -913.27, z = 10.35},
	{x = -1314.63, y = -602.79, z = 29.38},
	{x = -1291.52, y = -280.35, z = 38.66},
	{x = -1321.17, y = -184.70, z = 49.97},
	{x = -1406.36, y = -253.62, z = 46.37},
	{x = -720.48, y = -424.24, z = 35.04},
	{x = 121.71, y= -239.95, z = 53.35},
	{x = 332.78, y = -180.64, z = 58.18},
	{x = 263.56, y = -309.62, z = 49.64},
	{x = 499.70, y = -652.06, z = 24.90},
	{x = 727.47, y = -777.88, z = 25.42},
	{x = 866.53, y = -967.46, z = 27.86},
	{x = 844.75, y = -1059.35, z = 28.31},
	{x = 896.49, y = -1036.31, z = 35.11},
	{x = 951.96, y = -1059.47, z = 37.06},
	{x = 724.90, y = -1189.87, z = 24.27},
	{x = 734.25, y = -1311.18, z = 26.99},
	{x = 746.90, y = -1399.38, z = 26.62},
	{x = 724.20, y = -697.28, z = 28.53},
	{x = 983.39, y = -1503.64, z = 31.51},
	{x = 981.07, y = -1705.99, z = 31.22},
	{x = 948.55, y = -1733.54, z = 31.64},
	{x = 981.32, y = -1805.71, z = 35.48},
	{x = 743.94, y = -1797.35, z = 29.29},
	{x = 849.33, y = -1937.99, z = 30.06},
	{x = 877.40, y = -2043.31, z = 31.58},
	{x = 1014.27, y = -2151.00, z = 31.61},
	{x = 853.29, y = -2207.53, z = 30.67},
	{x = 523.65, y = -1966.42, z = 26.54},
	{x = 459.82, y = -1869.54, z = 27.10},
	{x = 420.30, y = -2064.32, z = 22.13},
	{x = 188.91, y = -2019.11, z = 18.28},
	{x = 485.72, y = -1477.00, z = 29.28},
	{x = 216.23, y = -1462.22, z = 29.32},
	{x = -41.18, y = -1748.09, z = 29.56},
	{x = -326.44, y = -1300.56, z = 31.35},
	{x = -174.26, y = -1273.19, z = 32.59},
	{x = -45.31, y = -1290.08, z = 29.20},
	{x = -7.07, y = -1295.51, z = 29.34},
	{x = 106.41, y = -1280.93, z = 29.26},
	{x = 168.20, y = -1299.32, z = 29.37},
	{x = 366.22, y = -1250.87, z = 32.70},
	{x = 34.76, y = -1032.78, z = 29.50},
	{x = 30.15, y = -900.75, z = 29.96},
	{x = 328.46, y = -994.44, z = 29.31},
	{x = 372.88, y = -737.72, z = 29.27},
	{x = 1951.44, y = 3825.18, z = 32.16},
	{x = 1386.67, y = 3622.75, z = 35.01},
	{x = 1358.81, y = 3614.37, z = 34.88},
	{x = 906.34, y = 3655.02, z = 32.56},
	{x = 2467.88, y = 4100.83, z = 38.06},
	{x = 2510.44, y = 4214.50, z = 39.93},
	{x = 2531.17, y = 4114.46, z = 38.74},
	{x = 1702.85, y = 4917.17, z = 42.22},
	{x = 1701.14, y = 4865.64, z = 42.01},
	{x = 1698.26, y = 4836.88, z = 41.93},
	{x = 1646.55, y = 4844.14, z = 42.01},
	{x = 1644.54, y = 4858.02, z = 42.01},
	{x = 1639.51, y = 4879.42, z = 42.14},
	{x = 64.12, y = 6309.59, z = 31.49},
	{x = -39.05, y = 6420.52, z = 31.68},
	{x = -29.93, y = 6457.99, z = 31.45},
	{x = 17.96, y = 6512.31, z = 31.64},
	{x = -8.48, y = 6487.27, z = 31.51},
	{x = -80.211, y = 6502.14, z = 31.49},
	{x = 440.10, y = -981.14, z = 30.68}
}
local currentJob = {
	onDuty = false
}

Citizen.CreateThread(function()
	EnumerateBlips()
	local timeout = GetGameTimer()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		for i = 1, #jobCoords do
			DrawText3D(jobCoords[i].duty.x, jobCoords[i].duty.y, jobCoords[i].duty.z, 8, '[E] - On/Off Duty (~r~GoPostal~s~)')
			if currentJob.onDuty then
				DrawText3D(jobCoords[i].job.x, jobCoords[i].job.y, jobCoords[i].job.z, 8, '[E] - New Delivery')
			end
		end
		if IsControlJustPressed(0, 38) and GetGameTimer() - timeout > 1000 then
			local playerCoords = GetEntityCoords(playerPed)
			for i = 1, #jobCoords do
				if Vdist(playerCoords, jobCoords[i].duty.x, jobCoords[i].duty.y, jobCoords[i].duty.z) < 3.0 then
					TriggerServerEvent('gopostal:toggleDuty', i)
					timeout = GetGameTimer()
				elseif Vdist(playerCoords, jobCoords[i].job.x, jobCoords[i].job.y, jobCoords[i].job.z) < 1.0 and currentJob.onDuty then
					TriggerEvent('gopostal:beginJob')
				end
			end
		end
	end
end)

RegisterNetEvent('gopostal:onDuty')
AddEventHandler('gopostal:onDuty', function(isOnDuty, i)
	if isOnDuty then
		SpawnDeliveryVan(jobCoords[i].vehicle.x, jobCoords[i].vehicle.y, jobCoords[i].vehicle.z, jobCoords[i].vehicle.heading)
		currentJob.onDuty = true
		TriggerEvent('gopostal:beginJob')
	else
		DelVehicle(currentJob.vehicle)
		TriggerEvent('gopostal:quitJob')
		currentJob.onDuty = false
		currentJob = {}
	end
end)

RegisterNetEvent('gopostal:quitJob')
AddEventHandler('gopostal:quitJob', function()
	if currentJob.active then
		DeleteObject(currentJob.packageObject)
		RemoveBlip(currentJob.blip)
		currentJob.active = false
		currentJob.blip = nil
		currentJob.dropOff = nil
		currentJob.beginCoords = nil
		Citizen.Wait(100)
		ClearPedTasks(PlayerPedId())
	end
end)

function SpawnDeliveryVan(x, y, z, heading)
	local playerPed = PlayerPedId()
    local numberHash = GetHashKey("boxville4")
    Citizen.CreateThread(function()
		RequestModel(numberHash)
		while not HasModelLoaded(numberHash) do
		    RequestModel(numberHash)
		    Citizen.Wait(0)
		end
		local vehicle = CreateVehicle(numberHash, x, y, z, heading, true, false)
		SetVehicleOnGroundProperly(vehicle)
		SetVehRadioStation(vehicle, "OFF")
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
		currentJob.vehicle = vehicle

		local vehicle_key = {
			name = "Key -- " .. GetVehicleNumberPlateText(vehicle),
			quantity = 1,
			type = "key",
			owner = "GoPostal Inc.",
			make = "Brute",
			model = "Boxville",
			plate = GetVehicleNumberPlateText(vehicle)
		}

		-- give key to owner
		TriggerServerEvent("garage:giveKey", vehicle_key)
		TriggerServerEvent('mdt:addTempVehicle', 'Brute Boxville', "GoPostal Inc.", GetVehicleNumberPlateText(vehicle))
    end)
end

RegisterNetEvent('gopostal:beginJob')
AddEventHandler('gopostal:beginJob', function()
	if currentJob.onDuty and not currentJob.active then
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		currentJob.active = true
		currentJob.beginCoords = playerCoords
		currentJob.packageObject = CreateObject(GetHashKey('hei_prop_heist_box'), playerCoords, true, true, false)
		RequestAnimDict('anim@heists@box_carry@')
		while not HasAnimDictLoaded('anim@heists@box_carry@') do Citizen.Wait(100) end
		AttachEntityToEntity(currentJob.packageObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, -0.01, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TriggerEvent('usa:showHelp', true, 'Place the package in the van.')
		while currentJob.active do
			Citizen.Wait(0)
			playerCoords = GetEntityCoords(playerPed)
			local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(currentJob.vehicle, 0.0, -4.0, 0.0))
			DrawText3D(x, y, z, 8, 'place package here')
			if Vdist(playerCoords, x, y, z) < 0.5 then
				break
			else
				if not IsEntityPlayingAnim(playerPed, 'anim@heists@box_carry@', 'idle', 3) then
	        		TaskPlayAnim(playerPed, 'anim@heists@box_carry@', "idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
	    		end
	    		DisablePlayerFiring(playerPed, true)
				DisableControlAction(0, 21, true)
				DisableControlAction(0, 23, true)
				DisableControlAction(1, 323, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 22, true)
				DisableControlAction(24, 37, true)
	    	end
	    	if GetVehicleEngineHealth(currentJob.vehicle) < 0 then
	    		TriggerServerEvent('gopostal:quitJob')
	    	end
	    end

	    if currentJob.active then
		    for i = 2, 3 do
		    	SetVehicleDoorOpen(currentJob.vehicle, i, true, true)
		    	Citizen.Wait(500)
		    end
		    Citizen.Wait(2000)
		    DeleteObject(currentJob.packageObject)
		    ClearPedTasks(playerPed)
		    TriggerServerEvent('display:shareDisplay', 'places package in van', 2, 370, 10, 3000)
		    TriggerEvent('usa:showHelp', true, 'Take the package to the location marked on your GPS.')
		    currentJob.dropOff = deliveryLocations[math.random(1, #deliveryLocations)]
		    SetNewWaypoint(currentJob.dropOff.x, currentJob.dropOff.y)
		    currentJob.blip = AddBlipForCoord(currentJob.dropOff.x, currentJob.dropOff.y, currentJob.dropOff.z)
			SetBlipSprite(currentJob.blip, 478)
			SetBlipDisplay(currentJob.blip, 2)
			SetBlipScale(currentJob.blip, 1.2)
			SetBlipColour(currentJob.blip, 31)
			SetBlipAsShortRange(currentJob.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Delivery Location')
			EndTextCommandSetBlipName(currentJob.blip)
		end

	    while currentJob.active do
	    	Citizen.Wait(100)
	    	playerCoords = GetEntityCoords(playerPed)
	    	if Vdist(playerCoords, currentJob.dropOff.x, currentJob.dropOff.y, currentJob.dropOff.z) < 50.0 and GetVehiclePedIsIn(playerPed) == 0 then
	    		TriggerEvent('usa:showHelp', true, 'Retrieve the package from the van.')
	    		break
	    	end
	    	if GetVehicleEngineHealth(currentJob.vehicle) < 0 then
	    		TriggerServerEvent('gopostal:quitJob')
	    	end
	    end

	    while currentJob.active do
	    	Citizen.Wait(0)
	    	playerCoords = GetEntityCoords(playerPed)
	    	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(currentJob.vehicle, 0.0, -4.0, 0.0))
			DrawText3D(x, y, z, 8, '[E] - Grab Package')
			if IsControlJustPressed(0, 38) and Vdist(playerCoords, x, y, z) < 0.5 then
				for i = 2, 3 do
			    	SetVehicleDoorOpen(currentJob.vehicle, i, true, true)
			    	Citizen.Wait(500)
			    end
			    Citizen.Wait(2000)
				TriggerServerEvent('display:shareDisplay', 'grabs package', 2, 370, 10, 3000)
				currentJob.packageObject = CreateObject(GetHashKey('hei_prop_heist_box'), playerCoords, true, true, false)
				RequestAnimDict('anim@heists@box_carry@')
				while not HasAnimDictLoaded('anim@heists@box_carry@') do Citizen.Wait(100) end
				AttachEntityToEntity(currentJob.packageObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
				break
			end
			if GetVehicleEngineHealth(currentJob.vehicle) < 0 then
	    		TriggerServerEvent('gopostal:quitJob')
	    	end
		end

		while currentJob.active do
			Citizen.Wait(0)
			playerCoords = GetEntityCoords(playerPed)
			DrawText3D(currentJob.dropOff.x, currentJob.dropOff.y, currentJob.dropOff.z, 10, 'drop package here')
			if not IsEntityPlayingAnim(playerPed, 'anim@heists@box_carry@', 'idle', 3) then
				TaskPlayAnim(playerPed, 'anim@heists@box_carry@', "idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
			end
			DisablePlayerFiring(playerPed, true)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(1, 323, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(24, 37, true)
			if Vdist(playerCoords, currentJob.dropOff.x, currentJob.dropOff.y, currentJob.dropOff.z) < 0.5 then
				DeleteObject(currentJob.packageObject)
				ClearPedTasks(playerPed)
				TriggerEvent('usa:showHelp', true, 'Package delivered, return to the depot for another!')
				TriggerServerEvent('gopostal:payDriver', Vdist(currentJob.beginCoords, currentJob.dropOff.x, currentJob.dropOff.y, currentJob.dropOff.z))
				RemoveBlip(currentJob.blip)
				currentJob.active = false
				currentJob.blip = nil
				currentJob.dropOff = nil
				currentJob.beginCoords = nil
				break
			end
			if GetVehicleEngineHealth(currentJob.vehicle) < 0 then
	    		TriggerServerEvent('gopostal:quitJob')
	    	end
		end
	else
		TriggerEvent('usa:notify', 'Finish your current job first!')
	end
end)

function DelVehicle(entity)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function EnumerateBlips()
	for i = 1, #jobCoords do
	  local blip = AddBlipForCoord(jobCoords[i].duty.x, jobCoords[i].duty.y, jobCoords[i].duty.z)
	  SetBlipSprite(blip, 479)
	  SetBlipDisplay(blip, 4)
	  SetBlipScale(blip, 0.8)
	  SetBlipColour(blip, 31)
	  SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString('GoPostal Delivery')
	  EndTextCommandSetBlipName(blip)
	end
end
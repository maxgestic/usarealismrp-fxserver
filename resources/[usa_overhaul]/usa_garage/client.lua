--# Public vehicle parking garages to store player vehicles
--# For: USA Realism RP
--# By: minipunch

locations = {
	{ ['x'] = -301.94973754883, ['y'] = 6123.2309570313, ['z'] = 31.499670028687 },
	{ ['x'] = 1698.5390625, ['y'] = 4941.4189453125, ['z'] = 42.126735687256 },
	{ ['x'] = 1502.3321533203, ['y'] = 3758.8825683594, ['z'] = 33.960582733154 },
	{ ['x'] = 2724.9311523438, ['y'] = 1348.2045898438, ['z'] = 24.523973464966 },
	{ ['x'] = 2544.4921875, ['y'] = -389.66342163086, ['z'] = 92.992828369141 },
	{ ['x'] = 1185.3264160156, ['y'] = -1546.4693603516, ['z'] = 39.400947570801 },
	{ ['x'] = -307.64028930664, ['y'] = -757.61248779297, ['z'] = 33.968524932861 },
	{ ['x'] = 248.066, ['y'] = -746.955, ['z'] = 30.8214 },
	{ ['x'] = -982.3, ['y'] = -2880.6, ['z'] = 14.3 }, -- LSIA
	{ ['x'] = -795.98, ['y'] = 322.67, ['z'] = 85.70},
	{ ['x'] = -740.66, ['y'] = -67.24, ['z'] = 41.75},
	{ ['x'] = -11.58, ['y'] = -303.64, ['z'] = 45.80},
	{ ['x'] = -1439.64, ['y'] = -677.51, ['z'] = 26.38},
	{ ["x"] = 196.30528259277, ["y"] = -1664.2943115234, ["z"] = 29.803218841553, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- FD in LS
	{ ["x"] = -455.9, ["y"] = 6040.9, ["z"] = 31.3, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- paleto PD
	{ ["x"] = -357.1, ["y"] = 6094.2, ["z"] = 31.4, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- paleto FD
	{ ["x"] = 1865.5, ["y"] = 3695.9, ["z"] = 33.7, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- sandy PD
	{ ["x"] = 1712.8, ["y"] = 3599.5, ["z"] = 35.3, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- sandy FD
	{ ["x"] = 447.1, ["y"] = -1024.5, ["z"] = 28.6, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- LS PD mission row
	{ ["x"] = 343.7, ["y"] = -560.4, ["z"] = 28.7, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- pillbox medical
	{ ["x"] = 326.4, ["y"] = -1475.6, ["z"] = 29.8, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections"} }, -- one of the hospitals in LS, forgot exaclty the name
	{ ["x"] = 1834.5, ["y"] = 2542.2, ["z"] = 45.9, ["jobs"] = {"sheriff", "ems", "police", "judge", "corrections", "da"} },
	{ ['x'] = 911.6, ['y'] = -163.6, ['z'] = 74.4, ["jobs"] = {"taxi"}},
	{ ['x'] = -77.19, ['y'] = -808.706, ['z'] = 36.48, ['jobs'] = {"dai"}},
	{ ['x'] = -311.8, ['y'] = 228.2, ['z'] = 87.8, ['noBlip'] = true}, -- studio los santos
	{ ['x'] = -620.3, ['y'] = 52.7, ['z'] = 43.7, ['noBlip'] = true}, -- Tinsel Towers Apartments
	{ ['x'] = 364.4, ['y'] = -1700.6, ['z'] = 32.5, ['noBlip'] = true} -- court house (davis, LS)
}

local VEHICLE_DAMAGES = {}
closest_shop = nil

Citizen.CreateThread(function()
    for _, info in pairs(locations) do
			if type(info["jobs"]) == "nil" then
				if not info['noBlip'] then
					info.blip = AddBlipForCoord(info['x'], info['y'], info['z'])
					SetBlipSprite(info.blip, 357)
					SetBlipDisplay(info.blip, 4)
					SetBlipScale(info.blip, info['blipScale'] or 0.7)
					SetBlipColour(info.blip, 4)
					SetBlipAsShortRange(info.blip, true)
					SetBlipColour(info.blip, 18)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Garage")
					EndTextCommandSetBlipName(info.blip)
				end
			end
    end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
	    for _, info in pairs(locations) do
	    	DrawText3D(info['x'], info['y'], info['z'], 10, '[E] - Garage')
			if IsControlJustPressed(0, 86) and Vdist(GetEntityCoords(ped), info['x'], info['y'], info['z']) < 2 then
				Citizen.Wait(50)
				if IsPedInAnyVehicle(ped, true) then
					local handle = GetVehiclePedIsIn(ped, false)
					local numberPlateText = GetVehicleNumberPlateText(handle)
					TriggerServerEvent("garage:storeVehicle", handle, numberPlateText, info["jobs"])
				else
					--TriggerServerEvent("garage:checkVehicleStatus")
					closest_shop = info
					TriggerServerEvent("garage:openMenu", info["jobs"])
					--Citizen.Wait(60000)
				end
			end
		end
	end
end)

RegisterNetEvent("garage:removeDamages")
AddEventHandler("garage:removeDamages", function(plate)
	if VEHICLE_DAMAGES[plate] then
		VEHICLE_DAMAGES[plate] = nil
	end
end)

RegisterNetEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	local plate = GetVehicleNumberPlateText(veh)
	exports.globals:notify("Vehicle has been returned to the garage!")
	-- store engine / body damage --
	VEHICLE_DAMAGES[plate] = {
		engine_health = GetVehicleEngineHealth(veh),
		body_health = GetVehicleBodyHealth(veh),
		dirt_level = GetVehicleDirtLevel(veh),
		windows = {
			[0] = IsVehicleWindowIntact(veh, 0),
			[1] = IsVehicleWindowIntact(veh, 1),
			[2] = IsVehicleWindowIntact(veh, 2),
			[3] = IsVehicleWindowIntact(veh, 3)
		}
	}
	-- delete veh --
	SetEntityAsMissionEntity(veh, true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
	-- store vehicle key with vehicle
	TriggerServerEvent("garage:storeKey", plate)
end)

RegisterNetEvent("garage:vehicleStored")
AddEventHandler("garage:vehicleStored", function(vehicle)
	TriggerEvent("garage:spawn", vehicle)
end)

RegisterNetEvent("garage:spawn")
AddEventHandler("garage:spawn", function(vehicle)
	local playerVehicle = vehicle
	local modelHash = vehicle.hash
	local plateText = vehicle.plate
	local numberHash = modelHash

	local vehicle_key = {
		name = "Key -- " .. vehicle.plate,
		quantity = 1,
		type = "key",
		owner = vehicle.owner,
		make = vehicle.make,
		model = vehicle.model,
		plate = vehicle.plate
	}

	-- give key to owner
	TriggerServerEvent("garage:giveKey", vehicle_key)

	if type(modelHash) ~= "number" then
		numberHash = tonumber(modelHash)
	end

	Citizen.CreateThread(function()
		RequestModel(numberHash)

		while not HasModelLoaded(numberHash) do
			Wait(100)
		end

		local playerPed = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerPed, false)
		local heading = GetEntityHeading(playerPed)
		local vehicle = CreateVehicle(numberHash, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
		SetVehicleNumberPlateText(vehicle, plateText)
		SetVehicleOnGroundProperly(vehicle)
		SetVehRadioStation(vehicle, "OFF")
		SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		SetVehicleEngineOn(vehicle, true, false, false)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)

		-- car customizations
		if playerVehicle.customizations then
			TriggerEvent("customs:applyCustomizations", playerVehicle.customizations)
		end

		-- apply any stored engine / body damage --
		if VEHICLE_DAMAGES[playerVehicle.plate] then
			SetVehicleBodyHealth(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].body_health)
			SetVehicleEngineHealth(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].engine_health)
			SetVehicleDirtLevel(vehicle, VEHICLE_DAMAGES[playerVehicle.plate].dirt_level)
			for index, intact in pairs(VEHICLE_DAMAGES[playerVehicle.plate].windows) do
				if not intact then
					SmashVehicleWindow(vehicle, index)
				end
			end
		end

	end)

end)

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 470
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

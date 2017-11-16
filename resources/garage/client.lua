local locations = {
	{ ['x'] = -301.94973754883, ['y'] = 6123.2309570313, ['z'] = 31.499670028687 },
	{ ['x'] = 1698.5390625, ['y'] = 4941.4189453125, ['z'] = 42.126735687256 },
	{ ['x'] = 1502.3321533203, ['y'] = 3758.8825683594, ['z'] = 33.960582733154 },
	{ ['x'] = 2724.9311523438, ['y'] = 1348.2045898438, ['z'] = 24.523973464966 },
	{ ['x'] = 2544.4921875, ['y'] = -389.66342163086, ['z'] = 92.992828369141 },
	{ ['x'] = 1185.3264160156, ['y'] = -1546.4693603516, ['z'] = 39.400947570801 },
	{ ['x'] = -307.64028930664, ['y'] = -757.61248779297, ['z'] = 33.968524932861 },
	{ ['x'] = 248.066, ['y'] = -746.955, ['z'] = 30.8214 }
}

Citizen.CreateThread(function()
    for _, info in pairs(locations) do
		info.blip = AddBlipForCoord(info['x'], info['y'], info['z'])
		SetBlipSprite(info.blip, 357)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, 4)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Garage")
		EndTextCommandSetBlipName(info.blip)
    end
end)

local allowed = true
local plate = nil
local pv = nil
local stored

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	    for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(GetPlayerPed(-1))) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 2 then
						DrawSpecialText("Press [ ~b~E~w~ ] to access the garage!")
						if IsControlPressed(0, 86) then
							Citizen.Wait(500)
							if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
								local handle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
								local numberPlateText = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
								TriggerServerEvent("garage:storeVehicle", handle, numberPlateText)
							else
								--TriggerServerEvent("garage:checkVehicleStatus")
								TriggerServerEvent("garage:openMenu")
								Citizen.Wait(60000)
							end
						end
				end
			end
		end
	end
end)

RegisterNetEvent("garage:storeVehicle")
AddEventHandler("garage:storeVehicle", function()
	TriggerEvent("garage:notify", "~g~We'll keep this fine thing safe for you.")
	SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
end)

RegisterNetEvent("garage:vehicleNotStored")
AddEventHandler("garage:vehicleNotStored", function()
	TriggerEvent("garage:notify", "~r~Sorry! You have no vehicles stored here and you don't have vehicle insurance.")
end)

RegisterNetEvent("garage:vehicleStored")
AddEventHandler("garage:vehicleStored", function(vehicle)
	TriggerEvent("garage:spawn", vehicle)
end)

--[[ COPY - BACKUP -
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	    for _, info in pairs(locations) do
			if GetDistanceBetweenCoords(info['x'], info['y'], info['z'],GetEntityCoords(GetPlayerPed(-1))) < 50 then
				DrawMarker(1, info['x'], info['y'], info['z']-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info['x'], info['y'], info['z'], true) < 2 then
					if allowed then
						DrawSpecialText("Press [ ~b~E~w~ ] to get your vehicle out of the garage.")
						if IsControlPressed(0, 86) then
							if not pressed then
								TriggerServerEvent("garage:spawn")
								pressed = true
								while pressed do
									Wait(0)
									if(IsControlPressed(0, 86) == false) then
										pressed = false
										break
									end
								end
							end
						end
					else
						DrawSpecialText("Press [ ~b~E~w~ ] to store your vehicle in the garage.")
						if IsControlPressed(0, 86) then
							if not pressed then
								TriggerServerEvent("garage:getVehicleInfo")
							end
						end
					end
				end
			end
		end
	end
end)
]]

RegisterNetEvent("garage:spawn")
AddEventHandler("garage:spawn", function(vehicle)
	local playerVehicle = vehicle
	local modelHash = vehicle.hash
	local plateText = vehicle.plate
	local numberHash = modelHash

	if type(modelHash) ~= "number" then
		numberHash = tonumber(modelHash)
	end

	Citizen.CreateThread(function()
		RequestModel(numberHash)

		while not HasModelLoaded(numberHash) do
			RequestModel(numberHash)
			Citizen.Wait(0)
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

		-- car customizations
		if playerVehicle.customizations then
			TriggerEvent("customs:applyCustomizations", playerVehicle.customizations)
		end

	end)

end)

RegisterNetEvent("garage:notify")
AddEventHandler("garage:notify", function(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end)

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

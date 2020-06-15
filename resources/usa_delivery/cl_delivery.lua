local DELIVERY_COMPANY_COORDS = {
	{
		duty = {x = 61.35, y = 123.83, z = 79.20},
		vehicle = {x = 66.25, y = 120.65, z = 79.10, heading = 160.0}
	},
	{
		duty = {x = -421.58, y = 6137.19, z = 31.87},
		vehicle = {x = -424.84, y = 6128.60, z = 31.46, heading = 236.0}
	}
}

local DELIVERY_LOCATIONS = {}

local currentJob = {
	onDuty = false,
	vehicle = nil,
	packageObject = nil,
	destination = nil,
	destinations = {}
}

local KEYS = {
	E = 86
}

local me = nil

Citizen.CreateThread(function()
	CreateMapBlips()
	local timeout = GetGameTimer()
	while true do
		me = PlayerPedId()
		for i = 1, #DELIVERY_COMPANY_COORDS do
			if not currentJob.onDuty then
				DrawText3D(DELIVERY_COMPANY_COORDS[i].duty.x, DELIVERY_COMPANY_COORDS[i].duty.y, DELIVERY_COMPANY_COORDS[i].duty.z, 8, '[E] - Start Route (~y~GoPostal~s~)')
			else
				DrawText3D(DELIVERY_COMPANY_COORDS[i].duty.x, DELIVERY_COMPANY_COORDS[i].duty.y, DELIVERY_COMPANY_COORDS[i].duty.z, 8, '[E] - End Route (~y~GoPostal~s~)')
			end
		end
		if IsControlJustPressed(0, KEYS.E) and GetGameTimer() - timeout > 1000 then
			local playerCoords = GetEntityCoords(me)
			for i = 1, #DELIVERY_COMPANY_COORDS do
				if Vdist(playerCoords, DELIVERY_COMPANY_COORDS[i].duty.x, DELIVERY_COMPANY_COORDS[i].duty.y, DELIVERY_COMPANY_COORDS[i].duty.z) < 3.0 then
					TriggerServerEvent('gopostal:toggleDuty', i)
					timeout = GetGameTimer()
				end
			end
		end
		Wait(0)
	end
end)

-- assigns a random destination to driver from destination pool --
Citizen.CreateThread(function()
	while true do
		if currentJob.onDuty then
			if currentJob.destinations and #currentJob.destinations > 0 then
				if not currentJob.destination then
					local d = table.remove(currentJob.destinations, 1)
					currentJob.destination = {
						beginAt = GetEntityCoords(PlayerPedId()),
						endAt = d
					}
					TriggerEvent("swayam:SetWayPointWithAutoDisable", currentJob.destination.endAt.x, currentJob.destination.endAt.y, currentJob.destination.endAt.z, 280, 60, "GoPostal Drop Off")
					exports.globals:notify('Take the package to the location marked on your GPS.')
				end
			end
		end
		Wait(1)
	end
end)

-- watch for when player gets close to destination --
Citizen.CreateThread(function()
	while true do
		if currentJob.onDuty and currentJob.destination then
			local mycoords = GetEntityCoords(me)
			local destinationDist = Vdist(mycoords.x, mycoords.y, mycoords.z, currentJob.destination.endAt.x, currentJob.destination.endAt.y, currentJob.destination.endAt.z)
			if destinationDist < 30 then
				local vehx, vehy, vehz = table.unpack(GetOffsetFromEntityInWorldCoords(currentJob.vehicle, 0.0, -4.0, 0.0))
				local truckDist = Vdist(mycoords.x, mycoords.y, mycoords.z, vehx, vehy, vehz)
				DrawText3D(currentJob.destination.endAt.x, currentJob.destination.endAt.y, currentJob.destination.endAt.z, nil, '[E] - Drop off package here')
				DrawText3D(vehx, vehy, vehz, nil, '[E] - Grab Package')
				if IsControlJustPressed(0, KEYS.E) then
					if destinationDist < 3 then
						if currentJob.packageObject then
							DeleteObject(currentJob.packageObject)
							currentJob.packageObject = nil
							ClearPedTasks(me)
							TriggerServerEvent('gopostal:payDriver', currentJob.destination, mycoords, currentJob.destination.endAt.last)
							if currentJob.destination.endAt.last then
								exports.globals:notify("You have completed this route. Take the truck back to a depot.")
								currentJob.destinations = nil
							end
							currentJob.destination = nil
						else
							exports.globals:notify("Where is the package?")
						end
					elseif truckDist < 3 then
						if not currentJob.packageObject then
							currentJob.packageObject = CreateObject(GetHashKey('hei_prop_heist_box'), mycoords, true, true, false)
							RequestAnimDict('anim@heists@box_carry@')
							while not HasAnimDictLoaded('anim@heists@box_carry@') do Citizen.Wait(100) end
							AttachEntityToEntity(currentJob.packageObject, me, GetPedBoneIndex(me, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
							exports.globals:notify("Grabbed package")
						else
							exports.globals:notify("You already took the package!")
						end
					end
				end
			end
		end
		Wait(1)
	end
end)

-- play animation when player has package --
Citizen.CreateThread(function()
	while true do
		if currentJob then
			if currentJob.packageObject then
				if not IsEntityPlayingAnim(me, 'anim@heists@box_carry@', 'idle', 3) then
						TaskPlayAnim(me, 'anim@heists@box_carry@', "idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
				end
				DisablePlayerFiring(me, true)
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
		end
		Wait(20)
	end
end)

RegisterNetEvent('gopostal:onDuty')
AddEventHandler('gopostal:onDuty', function(doGoOnDuty, i, destinations)
	if doGoOnDuty then
		TriggerEvent('gopostal:beginJob', i, destinations)
	else
		TriggerEvent('gopostal:quitJob')
	end
end)

RegisterNetEvent('gopostal:quitJob')
AddEventHandler('gopostal:quitJob', function(fee)
	if currentJob.onDuty then
		if currentJob.vehicle then
			DelVehicle(currentJob.vehicle)
		end
		if currentJob.packageObject then
			DeleteObject(currentJob.packageObject)
		end
		currentJob.onDuty = false
		currentJob.destination = nil
		Citizen.Wait(100)
		ClearPedTasks(me)
		if fee then
			exports.globals:notify('You have been fined ~y~$' .. fee .. '~s~ for quitting.')
		else
			exports.globals:notify("Job ended!")
		end
	end
end)

RegisterNetEvent('gopostal:beginJob')
AddEventHandler('gopostal:beginJob', function(i, destinations)
	if not currentJob.onDuty then
		local playerCoords = GetEntityCoords(me)
		currentJob.onDuty = true
		currentJob.destinations = destinations
		currentJob.vehicle = SpawnDeliveryVan(DELIVERY_COMPANY_COORDS[i].vehicle.x, DELIVERY_COMPANY_COORDS[i].vehicle.y, DELIVERY_COMPANY_COORDS[i].vehicle.z, DELIVERY_COMPANY_COORDS[i].vehicle.heading)
	else
		TriggerEvent('usa:notify', 'Finish your current job first!')
	end
end)

TriggerServerEvent("gopostal:getDeliveryLocations")

RegisterNetEvent('gopostal:getDeliveryLocations')
AddEventHandler('gopostal:getDeliveryLocations', function(locations)
	DELIVERY_LOCATIONS = locations
end)

function SpawnDeliveryVan(x, y, z, heading)
	local numberHash = GetHashKey("boxville4")
	RequestModel(numberHash)
	while not HasModelLoaded(numberHash) do
		Wait(0)
	end
	local vehicle = CreateVehicle(numberHash, x, y, z, heading, true, false)
	TriggerEvent('persistent-vehicles/register-vehicle', vehicle)
	SetVehicleOnGroundProperly(vehicle)
	SetVehRadioStation(vehicle, "OFF")
	SetEntityAsMissionEntity(vehicle, true, true)
	SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
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
	--TriggerServerEvent('mdt:addTempVehicle', 'Brute Boxville', "GoPostal Inc.", GetVehicleNumberPlateText(vehicle))
	return vehicle
end

function DelVehicle(entity)
	TriggerEvent('persistent-vehicles/forget-vehicle', entity)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
end

function DrawText3D(x, y, z, distance, text)
  if distance and not (Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance) then
		return
	end
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

function CreateMapBlips()
	for i = 1, #DELIVERY_COMPANY_COORDS do
	  local blip = AddBlipForCoord(DELIVERY_COMPANY_COORDS[i].duty.x, DELIVERY_COMPANY_COORDS[i].duty.y, DELIVERY_COMPANY_COORDS[i].duty.z)
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

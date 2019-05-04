local currentlyTowedVehicle = nil
local vehicleToImpound = nil
local lastTowTruck = nil
local interactKey = 38
onDuty = "no"

local locations = {
	["Paleto"] = {
		duty = {
			x = -196.027,
			y = 6265.625,
			z = 30.489
		},
		truck_spawn = {
			x = -176.32,
			y = 6283.17,
			z = 31.489,
			heading = 40.0
		},
		impound = {
			x = -171.624,
			y = 6277.602,
			z = 30.489
		},
		ped = {
			x = -196.027,
			y = 6265.625,
			z = 30.489,
			heading = 0.0,
			model = "amy_downtown_01"
		}
	},
	["Sandy"] = {
		duty = {
			x = 2363.89,
			y = 3126.85,
			z = 47.211
		},
		truck_spawn = {
			x = 2369.98,
			y = 3129.17,
			z = 48.82,
			heading = 218.0
		},
		impound = {
			x = 2398.42,
			y = 3108.48,
			z = 47.1806
		},
		ped = {
			x = 2363.89,
			y = 3126.85,
			z = 47.211,
			heading = 0.0,
			model = "amm_farmer_01"
		}
	},
	["Los Santos - Davis"] = {
		duty = {
			x = 409.78,
			y = -1623.41,
			z = 28.29
		},
		truck_spawn = {
			x = 404.18,
			y = -1642.03,
			z = 29.29,
			heading = 225.0
		},
		impound = {
			x = 403.24,
			y = -1633.48,
			z = 28.29
		},
		ped = {
			x = 408.03,
			y = -1624.62,
			z = 28.29,
			heading = -90.0,
			model = "amy_downtown_01"
		}
	}
}

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	EnumerateBlips()
	for name, data in pairs(locations) do
		local hash = -1806291497
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		local ped = CreatePed(4, hash, data.ped.x, data.ped.y, data.ped.z, data.ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true);
	end
end)

Citizen.CreateThread(function()
	local timeout = 0
	while true do
		Citizen.Wait(0)
		for name, data in pairs(locations) do
			DrawText3D(data.duty.x, data.duty.y, (data.duty.z + 1.0), 5, '[E] - On/Off Duty (~g~Tow~s~)')
			DrawText3D(data.impound.x, data.impound.y, (data.impound.z + 1.5), 15, '[E] - Impound Vehicle')
		end
		if IsControlJustPressed(0, 38) then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			for name, data in pairs(locations) do
				local playerPed = PlayerPedId()
				if Vdist(playerCoords, data.duty.x, data.duty.y, data.duty.z) < 3 then
					if timeout > 3 then
						TriggerEvent('usa:notify', "You have clocked in and out too much recently, ~y~please wait~s~.")
					else
						timeout = timeout + 1
						if timeout > 3 then
							Citizen.CreateThread(function()
								local beginTime = GetGameTimer()
								while GetGameTimer() - beginTime < 10000 do
									Citizen.Wait(100)
								end
								timeout = 0
							end)
						end
						TriggerServerEvent("towJob:setJob", data.truck_spawn)
					end
				elseif
					Vdist(playerCoords, data.impound.x, data.impound.y, data.impound.z) < 15.0 then
					if onDuty == "yes" then
						ImpoundVehicle()
					end
				end
			end
		end
	end
end)

RegisterNetEvent("towJob:onDuty")
AddEventHandler("towJob:onDuty", function(coords)
	TriggerEvent('usa:notify', 'You are now ~g~on-duty~s~ for tow.')
	SpawnTowFlatbed(coords)
	onDuty = "yes"
end)

RegisterNetEvent("towJob:offDuty")
AddEventHandler("towJob:offDuty", function()
	TriggerEvent('usa:notify', 'You are now ~y~off-duty~s~ for tow.')
	DelVehicle(lastTowTruck)
	onDuty = "no"
end)

RegisterNetEvent('towJob:towVehicleInFront')
AddEventHandler('towJob:towVehicleInFront', function()
	local playerPed = PlayerPedId()
	if lastTowTruck then

		local coordA = GetEntityCoords(playerPed)
		local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		if currentlyTowedVehicle == nil and not IsPedInAnyVehicle(playerPed, true) then
			if targetVehicle ~= 0 then
				local targetVehicleCoords = GetEntityCoords(targetVehicle, true)
				local towTruckCoords = GetEntityCoords(lastTowTruck, true)

				if Vdist(targetVehicleCoords, towTruckCoords) < 12.0 and IsVehicleWhitelisted(targetVehicle) then

					if lastTowTruck ~= targetVehicle and IsVehicleSeatFree(targetVehicle, -1) then
						local dict = "mini@repair"
            			RequestAnimDict(dict)
            			while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
            			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'tow-truck', 0.5)
						local beginTime = GetGameTimer()
						while GetGameTimer() - beginTime < 8000 do
							Citizen.Wait(1)
							DrawTimer(beginTime, 8000, 1.42, 1.475, 'ATTACHING')
							if not IsEntityPlayingAnim(playerPed, dict, 'fixing_a_player', 3) then
								TaskPlayAnim(playerPed, dict, "fixing_a_player", 8.0, 1.0, -1, 15, 1.0, 0, 0, 0)
							end
						end
						ClearPedTasks(playerPed)
						AttachEntityToEntity(targetVehicle, lastTowTruck, GetEntityBoneIndexByName(lastTowTruck, 'bodyshell'), 0.0, -2.35, 0.75, 0, 0, 0, 1, 1, 0, 1, 0, 1)
						currentlyTowedVehicle = targetVehicle
						vehicleToImpound = currentlyTowedVehicle
					end
				else
					print(IsVehicleWhitelisted(targetVehicle))
					TriggerEvent('usa:notify', 'Towable vehicle not found. (1)')
				end
			else
				TriggerEvent('usa:notify', 'Towable vehicle not found. (2)')
			end
		else
			local detachCoords = GetOffsetFromEntityInWorldCoords(lastTowTruck, 0.0, -12.0, 0.0)
			local dict = "mini@repair"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
			local beginTime = GetGameTimer()
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'tow-truck', 0.5)
			while GetGameTimer() - beginTime < 8000 do
				Citizen.Wait(1)
				DrawTimer(beginTime, 8000, 1.42, 1.475, 'DETACHING')
				if not IsEntityPlayingAnim(playerPed, dict, 'fixing_a_player', 3) then
					TaskPlayAnim(playerPed, dict, "fixing_a_player", 8.0, 1.0, -1, 15, 1.0, 0, 0, 0)
				end
			end
			ClearPedTasks(playerPed)
			DetachEntity(currentlyTowedVehicle, true, true)
			SetEntityCoords(currentlyTowedVehicle, detachCoords)
			currentlyTowedVehicle = nil
		end
	end
end)

RegisterNetEvent('towJob:showHelpText')
AddEventHandler('towJob:showHelpText', function(string)
	DisplayHelpText(string)
end)

RegisterNetEvent('character:setCharacter')
AddEventHandler('character:setCharacter', function()
	onDuty = "no"
	vehicleToImpound = nil
	lastTowTruck = nil
	currentlyTowedVehicle = nil
end)

function EnumerateBlips()
	for name, data in pairs(locations) do
      	local blip = AddBlipForCoord(data.duty.x, data.duty.y, data.duty.z)
		SetBlipSprite(blip, 68)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.75)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Tow Company')
		EndTextCommandSetBlipName(blip)
    end
end

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ImpoundVehicle()
	local targetVehicle = getVehicleInFront()
	if targetVehicle == vehicleToImpound then
		local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if DoesEntityExist(targetVehicle) then
        	local targetPlate = GetVehicleNumberPlateText(targetVehicle, false)
            TriggerServerEvent("impound:impoundVehicle", targetVehicle, targetPlate)
            SetEntityAsMissionEntity(targetVehicle, true, true)
            DelVehicle(targetVehicle)
			vehicleToImpound = nil
			TriggerServerEvent("towJob:giveReward")
		end
	end
end

function SpawnTowFlatbed(coords)
    local numberHash = 1353720154 -- tow truck
    Citizen.CreateThread(function()
		RequestModel(numberHash)
		while not HasModelLoaded(numberHash) do
		    RequestModel(numberHash)
		    Citizen.Wait(0)
		end
		local vehicle = CreateVehicle(numberHash, coords.x, coords.y, coords.z, coords.heading, true, false)
		SetVehicleOnGroundProperly(vehicle)
		SetVehRadioStation(vehicle, "OFF")
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
		lastTowTruck = vehicle

		local vehicle_key = {
			name = "Key -- " .. GetVehicleNumberPlateText(vehicle),
			quantity = 1,
			type = "key",
			owner = "Bubba's Tow",
			make = "MTL",
			model = "Flatbed",
			plate = GetVehicleNumberPlateText(vehicle)
		}

		-- give key to owner
		TriggerServerEvent("garage:giveKey", vehicle_key)
		TriggerServerEvent('mdt:addTempVehicle', 'MTL Flatbed', "Bubba's Tow Co.", GetVehicleNumberPlateText(vehicle))
    end)
end

function IsVehicleWhitelisted(entity)
	if GetVehicleClass(entity) == 14 or GetVehicleClass(entity) == 15 or 
		GetVehicleClass(entity) == 16 or GetVehicleClass(entity) == 21 or 
		GetVehicleClass(entity) == 19 then
			return false
	else
		return true
	end
end

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function DelVehicle(entity)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function getVehicleInFront()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function isPlayerAtTowSpot()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)

	for name, data in pairs(locations) do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,data.impound.x,data.impound.y,data.impound.z,false) < 5 then
			return true
		end
	end

	return false

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
    local factor = (string.len(text)) / 470
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
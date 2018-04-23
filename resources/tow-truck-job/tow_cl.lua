local on_duty = "no"
local currentlyTowedVehicle = nil
local vehicleToImpound = nil
local last_spawned_vehicle = nil

local locations = {
	["Paleto"] = {
		duty = {
			x = -196.027,
			y = 6265.625,
			z = 30.489
		},
		truck_spawn = {
			x = -194.571,
			y = 6279.666,
			z = 31.489,
			heading = 347.428
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
			x = 2376.42,
			y = 3126.12,
			z = 46.9,
			heading = 347.428
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
			x = 398.82,
			y = -1637.94,
			z = 29.29,
			heading = 347.428
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
	for name, data in pairs(locations) do
		local hash = -1806291497
		--local hash = GetHashKey(data.ped.model)
		print("requesting hash...")
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		print("spawning ped, heading: " .. data.ped.heading)
		print("hash: " .. hash)
		local ped = CreatePed(4, hash, data.ped.x, data.ped.y, data.ped.z, data.ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetEntityInvincible(ped)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true);
	end
end)

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

RegisterNetEvent("towJob:success")
AddEventHandler("towJob:success", function()
	TriggerEvent("chatMessage", "Tow", { 255,99,71 }, "^0You have impounded the vehicle for ^2$700^0!")
end)

function impoundVehicle()
	--[[
	local targetVehicle = getVehicleInFrontOfUser()
	if targetVehicle ~= 0 then
		--TriggerServerEvent("towJob:impoundVehicle", targetVehicle)
		if targetVehicle == vehicleToImpound then
			print("impounding vehicle!")
			SetEntityAsMissionEntity(vehicleToImpound, true, true )
			deleteCar(vehicleToImpound)
			vehicleToImpound = nil
			local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
			TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
				TriggerServerEvent("towJob:giveReward", property)
			end)
		else
			print("Trying to tow a vehicle that wasn't attached to your flatbed first!")
		end
	else
		TriggerEvent("chatMessage", "Tow", { 255,99,71 }, "^0There is no vehicle no impound!")
	end
	--]]
	local targetVehicle = getVehicleInFrontOfUser()
	if targetVehicle == vehicleToImpound then
		TriggerEvent("impoundVehicle")
		vehicleToImpound = nil
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
		TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
			TriggerServerEvent("towJob:giveReward", property)
		end)
	end
	Menu.hidden = true -- close menu
end

function getVehicleInFrontOfUser()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function towJobMenu()
	MenuTitle = "Tow Job"
	ClearMenu()
	Menu.addButton("Impound Vehicle (+$700)", "impoundVehicle")
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
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

local playerNotified = false

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		for name, data in pairs(locations) do
			DrawMarker(27, data.impound.x, data.impound.y, data.impound.z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 100, 85, 161, 92, 0, 0, 2, 0, 0, 0, 0)
		end

		if isPlayerAtTowSpot() and not playerNotified then
      		TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Drop the vehicle off inside the marker, face it, then press E to impound it.")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if isPlayerAtTowSpot() then

				towJobMenu()              -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu

			end

		elseif not isPlayerAtTowSpot() then
			playerNotified = false
			Menu.hidden = true
		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

-- pv-tow :

RegisterNetEvent('pv:tow')
AddEventHandler('pv:tow', function()

	local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)

	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)

	if isVehicleTow then

		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						currentlyTowedVehicle = targetVehicle
						vehicleToImpound = currentlyTowedVehicle
						TriggerEvent("chatMessage", "", {255, 255, 255}, "Vehicle successfully attached to towtruck!")
					else
						TriggerEvent("chatMessage", "", {255, 255, 255}, "You can't tow your own tow truck with your own tow truck!")
					end
				end
			else
				TriggerEvent("chatMessage", "", {255, 255, 255}, "There is no vehicle to tow!")
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			TriggerEvent("chatMessage", "", {255, 255, 255}, "The vehicle has been successfully detached!")
			currentlyTowedVehicle = nil
		end
	end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for name, data in pairs(locations) do
			DrawMarker(27, data.duty.x, data.duty.y, data.duty.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 130, 105, 90, 0, 0, 2, 0, 0, 0, 0)
			local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
			if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,data.duty.x,data.duty.y,data.duty.z,false) < 3 then
				--DrawCoolLookingNotification("Press ~y~E~w~ to go work for Downtown Taxi Co.!")
				if on_duty == "yes" then
					DrawSpecialText("Press ~g~E~w~ to go off duty!")
				elseif on_duty == "no" then
					DrawSpecialText("Press ~g~E~w~ to go on duty!")
				elseif on_duty == "timeout" then
					DrawSpecialText("You have clocked in and out too much recently!")
				end
				if IsControlJustPressed(1,38) then
					TriggerServerEvent("tow:setJob", data.truck_spawn)
				end
			elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,data.duty.x,data.duty.y,data.duty.z,false) > 3 then
				-- out of range
			end
		end
	end
end)

function spawnVehicle(coords)
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
				--SetVehicleAsNoLongerNeeded(vehicle)
				last_spawned_vehicle = vehicle
    end)
end

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end

RegisterNetEvent("tow:onDuty")
AddEventHandler("tow:onDuty", function(coords)
	DrawCoolLookingNotificationWithTowPic("Here's your rig! Have a good shift!")
	spawnVehicle(coords)
	on_duty = "yes"
end)

RegisterNetEvent("tow:offDuty")
AddEventHandler("tow:offDuty", function()
	deleteCar(last_spawned_vehicle)
	DrawCoolLookingNotificationWithTowPic("You have clocked out! Have a good one!")
	on_duty = "no"
end)

RegisterNetEvent("tow:onTimeout")
AddEventHandler("tow:onTimeout", function(status)
	if status then
		on_duty = "timeout"
	else
		on_duty = "no"
	end
end)

function DrawCoolLookingNotificationWithTowPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_PROPERTY_TOWING_IMPOUND", "CHAR_PROPERTY_TOWING_IMPOUND", true, 1, name, "", msg)
	DrawNotification(0,1)
end

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

local currentlyTowedVehicle = nil

local tow_duty_ped_heading = 312.352

-- to go on duty as tow truck driver
local towDutyX, towDutyY, towDutyZ = -246.733, 6238.865, 30.49
local spawn = { x =-238.594, y = 6254.200, z =31.489, heading = 192.351 }

local locations = {
	{ x = -221.114, y = 6270.026, z = 30.684 } -- paleto dirt construction lot
}

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
	local targetVehicle = getVehicleInFrontOfUser()
	if targetVehicle ~= 0 then
		--TriggerServerEvent("towJob:impoundVehicle", targetVehicle)
		if targetVehicle == currentlyTowedVehicle then
			print("impounding vehicle!")
			SetEntityAsMissionEntity(currentlyTowedVehicle, true, true )
			deleteCar(currentlyTowedVehicle)
			currentlyTowedVehicle = nil
			TriggerServerEvent("towJob:giveReward")
		else
			print("Trying to tow a vehicle that wasn't attached to your flatbed first!")
		end
	else
		TriggerEvent("chatMessage", "Tow", { 255,99,71 }, "^0There is no vehicle no impound!")
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
	Menu.addButton("Impound Vehicle (+$400)", "impoundVehicle")
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

function isPlayerAtTowSpot()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)

	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 5 then
			return true
		end
	end

	return false

end

local playerNotified = false

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		for i = 1, #locations do
			DrawMarker(1, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 1.0, 100, 85, 161, 92, 0, 0, 2, 0, 0, 0, 0)
		end

		if isPlayerAtTowSpot() and not playerNotified then
      		TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Drop the vehicle off inside the marker, then press E to impound it.")
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
						TriggerEvent("chatMessage", "", {0, 0, 0}, "Vehicle successfully attached to towtruck!")
					else
						TriggerEvent("chatMessage", "", {0, 0, 0}, "You can't tow your own tow truck with your own tow truck!")
					end
				end
			else
				TriggerEvent("chatMessage", "", {0, 0, 0}, "There is no vehicle to tow!")
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			TriggerEvent("chatMessage", "", {0, 0, 0}, "The vehicle has been successfully detached!")
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
		DrawMarker(1, towDutyX, towDutyY, towDutyZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
	    if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,towDutyX,towDutyY,towDutyZ,false) < 3 then
            --DrawCoolLookingNotification("Press ~y~E~w~ to go work for Downtown Taxi Co.!")
    		if IsControlJustPressed(1,38) then
				TriggerServerEvent("tow:setJob")
    		end
        elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,towDutyX,towDutyY,towDutyZ,false) > 3 then
            -- out of range
        end
	end
end)

function spawnVehicle()
    local numberHash = 1353720154 -- t ow truck
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        local playerPed = GetPlayerPed(-1)
        local vehicle = CreateVehicle(numberHash, spawn.x, spawn.y, spawn.z, 0.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehRadioStation(vehicle, "OFF")
        SetEntityAsMissionEntity(vehicle, true, true)
    end)
end

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end

RegisterNetEvent("tow:onDuty")
AddEventHandler("tow:onDuty", function()
	DrawCoolLookingNotificationWithTowPic("Here's your rig! Have a good shift!")
	spawnVehicle()
end)

RegisterNetEvent("tow:offDuty")
AddEventHandler("tow:offDuty", function()
	DrawCoolLookingNotificationWithTowPic("You have clocked out! Have a good one!")
end)

function DrawCoolLookingNotificationWithTowPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_PROPERTY_TOWING_IMPOUND", "CHAR_PROPERTY_TOWING_IMPOUND", true, 1, name, "", msg)
	DrawNotification(0,1)
end

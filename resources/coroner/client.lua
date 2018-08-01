
local isHospitalized = false
local hospitalIdentifier = 0
local hospitalDuration = 0
local timePassed = 0
local inMorgue = false

local return_coords = { x = -239.493, y = 6323.375, z = 32.426 }

--[[
	X COORDINATE = randomSpawnPoint.x
	Y COORDINATE = randomSpawnPoint.y
	Z COORDINATE = randomSpawnPoint.z
	HEADING COORDINATE = randomSpawnPoint.heading
--]]

RegisterNetEvent('HOSPITAL:hospitalize')
AddEventHandler('HOSPITAL:hospitalize', function(customTime, hospIdentifier)
	isHospitalized = true
	hospitalDuration = tonumber(customTime)
	hospitalIdentifier = tonumber(hospIdentifier)
	TriggerEvent("crim:blindfold", false, true)
end)



Citizen.CreateThread(function()
	isHospitalized = false
	hospitalIdentifier = 0
	hospitalDuration = 0
	timePassed = 0
	inMorgue = false

	local morgueTeleportLocations = {
			{x = 262.46, y = -1340.29, z = 24.00, heading = 141.40},
			{x = 260.16, y = -1347.09, z = 24.00, heading = 46.03},
			{x = 256.54, y = -1343.84, z = 24.00, heading = 235.04},
			{x = 256.07, y = -1352.21, z = 24.00, heading = 44.85},
			{x = 251.73, y = -1348.86, z = 24.00, heading = 230.00},
			{x = 249.28, y = -1355.49, z = 24.00, heading = 316.11}
	}

	local interiorID = 60418

	--revive the player if dead before sending to the morgue

	function teleportPlayer(playerPed,locations)
		DoScreenFadeOut(500)

		while IsScreenFadingOut() do
			Citizen.Wait(0)
		end

		NetworkFadeOutEntity(playerPed, true, false)
		Wait(500)

		local index = math.random(1, #morgueTeleportLocations)
		local coords = morgueTeleportLocations[index]
		SetEntityCoords(playerPed, coords.x,coords.y,coords.z,coords.heading, 0, 0, 1)
		NetworkFadeInEntity(playerPed, 0)
		FreezeEntityPosition(playerPed, true)
		RemoveAllPedWeapons(GetPlayerPed(-1), true)

		Wait(500)

		while (not IsInteriorReady(interiorID)) do
			Wait(100)
		end

		DoScreenFadeIn(500)

		while IsScreenFadingIn() do
			Citizen.Wait(0)
		end

		FreezeEntityPosition(playerPed, false)
	end


	local hospitals = {}

	math.randomseed(GetPlayerServerId(GetPlayerIndex()))

	function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(hospitals,newObject)
	end

	createSpawnPoint(-247, -245, 6329, 6332, 33.5, 0) -- Paleto             | paleto or 1
	createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores       | sandy or 2
	createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah        | zonah or 3
	createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill       | pillbox or 4
	createSpawnPoint(335, 340, -1400, -1390, 33.5, 0) -- Central Los Santos | central or 5



	while true do
		Wait(0)

		local ped = GetPlayerPed(-1)

		if( IsEntityAtCoord(GetPlayerPed(-1), 275.5, -1360.3, 24.1, 3.0, 3.0, 3.0, 0, 1, 0) ) then
			if(isHospitalized) then
				local index = math.random(1, #morgueTeleportLocations)
				SetEntityCoords(GetPlayerPed(-1), morgueTeleportLocations[index].x,morgueTeleportLocations[index].y,morgueTeleportLocations[index].z,morgueTeleportLocations[index].heading, 0, 0, 1)
			end
		end

		if (isHospitalized) then

			FreezeEntityPosition(ped, true) -- freeze player in place while in hospital

			if (timePassed >= hospitalDuration) then
				isHospitalized = false
				inMorgue = false
				Wait(1000)
				timePassed = 0

				-- return to paleto for NLR
				SetEntityCoords(ped, return_coords.x, return_coords.y, return_coords.z, 325, 0, 0, 1)

				TriggerServerEvent('HOSPITAL:released')


			elseif (not inMorgue) then
				teleportPlayer(ped, morgueTeleportLocations)

				FreezeEntityPosition(ped, false)
				inMorgue = true
			else
				if (not (GetInteriorFromEntity(ped) == interiorID) ) then
					inMorgue = false
				end
				Wait(100)
			end
		else
			FreezeEntityPosition(ped, false) -- unfreeze player when released from hospital
		end
	end
end)


Citizen.CreateThread(function()
	local messageInterval = 30

	while true do
		Wait(0)
		if (isHospitalized and inMorgue) then
			Wait(1000)
			timePassed = timePassed + 1
			local timeLeft = hospitalDuration - timePassed

			if (timeLeft > 0) then
				if( (timeLeft % messageInterval == 0) or (timeLeft == 15) ) then
				TriggerServerEvent('HOSPITAL:reminder', GetPlayerServerId(GetPlayerIndex()), (timeLeft) )
				end
			end

		end
	end
end)

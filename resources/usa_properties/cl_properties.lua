local properties = {}
local firstSpawn = true
local currentProperty = {} -- property which the player is currently in
local myInstance = {}
local blips = {}
local buzzedApartment = {
	time = 0,
	location = nil,
	index = nil
}
local doorTransition = false

local residents = {
	animation = { dict = "amb@lo_res_idles@", anim = "lying_face_up_lo_res_base" }, -- sleeping animation
	weapons = {"weapon_nightstick", "weapon_crowbar", "weapon_knife", "weapon_bat", "weapon_hammer", "weapon_pistol", "weapon_vintagepistol", "weapon_machete"},
	models = {"a_f_y_hipster_01", "a_m_m_mexlabor_01", "a_m_y_downtown_01", "a_m_y_business_01", "a_m_m_tourist_01", "u_f_y_princess", "u_m_y_paparazzi", "u_m_y_fibmugger_01", "u_m_y_justin", "u_m_m_rivalpap"},
	{
		coords = vec3(341.24, -994.31, -98.745),
		rotation = 270.0,
	},
	{
		coords = vec3(349.8, -996.141, -98.7399),
		rotation = 90.0,
	}
}

local spawnedPeds = {}

local outfitAmount = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

RegisterNetEvent('properties:updateData')
AddEventHandler('properties:updateData', function(location, index, data)
	if not firstSpawn then
		properties[location].rooms[index] = data
	end
end)

RegisterNetEvent('properties:removeData')
AddEventHandler('properties:removeData', function(location, index)
	table.remove(properties[location].rooms, index)
end)

Citizen.CreateThread(function() -- manage instances
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if myInstance.active then
			for i = 0, 255 do

				local found = false
				for j = 1, #myInstance.players do
					local instancePlayer = GetPlayerFromServerId(myInstance.players[j])
					if i == instancePlayer then
						found = true
					end
				end

				if not found then
					local pedToInstance = GetPlayerPed(i)
					SetEntityLocallyInvisible(pedToInstance)
					SetEntityVisible(pedToInstance, false)
					SetEntityCollision(pedToInstance, false, false)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	if firstSpawn then
		TriggerServerEvent('properties:requestAllData')
		while firstSpawn do
			Citizen.Wait(100)
		end
		--TriggerServerEvent('character:loadCharacter', 1, false)
	end
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if _menuPool then
			_menuPool:MouseControlsEnabled(false)
	        _menuPool:ControlDisablingEnabled(false)
	        _menuPool:ProcessMenus()
	    end
		if currentProperty.owner then
			local playerCoords = GetEntityCoords(playerPed)
			local x, y, z = table.unpack(currentProperty.entryCoords)
			if currentProperty.owner ~= -1 then
				local xS, yS, zS = table.unpack(currentProperty.storageCoords)
				local xC, yC, zC = table.unpack(currentProperty.bathroomCoords)
				local xW, yW, zW = table.unpack(currentProperty.wardrobeCoords)
				DrawText3D(x, y, z, 2, '[E] - Exit '.. currentProperty.name)
				DrawText3D(xS, yS, zS, 1, '[E] - Storage')
				DrawText3D(xC, yC, zC, 1, '[E] - Clean')
				if currentProperty.owner == GetPlayerServerId(PlayerId()) then
					DrawText3D(xW, yW, zW, 1, '[E] - Wardrobe')
				end
				if IsControlJustPressed(0, 38) then
					if Vdist(x, y, z, playerCoords) < 0.5 then
						TriggerServerEvent('properties:requestExit', currentProperty.location, currentProperty.index)
						PlayDoorAnimation()
					elseif Vdist(xS, yS, zS, playerCoords) < 1.0 then
						TriggerServerEvent('properties:requestStorage', currentProperty.location, currentProperty.index)
					elseif Vdist(xC, yC, zC, playerCoords) < 1.0 then
						TriggerServerEvent('properties:cleanTools', currentProperty.location, currentProperty.index)
					elseif currentProperty.owner == GetPlayerServerId(PlayerId()) and Vdist(xW, yW, zW, playerCoords) < 1.0 then
						TriggerEvent('properties:openWardrobeMenu')
					end
				end
			else
				local playerCoords = GetEntityCoords(playerPed)
				local x, y, z = table.unpack(currentProperty.entryCoords)
				DrawText3D(x, y, z, 2, '[E] - Exit House')
				if IsControlJustPressed(0, 38) then
					if Vdist(x, y, z, playerCoords) < 0.5 then
						TriggerServerEvent('properties:requestExitFromBurglary', currentProperty.index)
						RemoveResidents()
						PlayDoorAnimation()
					end
				end
			end
			if Vdist(x, y, z, playerCoords) > 50.0 and not doorTransition then
				TriggerServerEvent('properties:requestExit', currentProperty.location, currentProperty.index, true)
			end
		else
			DrawText3D(-115.40, -603.75, 36.28, 15, '[E] - Real Estate')
			for property, data in pairs(properties) do
				if data.type == 'motel' or data.type == 'house' then
					if data.type == 'motel' then
						DrawText3D(data.office[1], data.office[2], data.office[3], 5, '[E] - Move Properties (~g~$500~s~)')
						local dist = Vdist(data.office[1], data.office[2], data.office[3], GetEntityCoords(playerPed))
						if dist > 5.0 and dist < 50.0 then
							DrawMarker(20, data.office[1], data.office[2], data.office[3], 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 206, 47, 39, 255, false, true, 2, nil, nil, false)
						end
					end
					for i = 1, #data.rooms do
						local room = properties[property].rooms[i]
						if room.owner == GetPlayerServerId(PlayerId()) then
							if room.garage then
								DrawText3D(room.garage[1], room.garage[2], room.garage[3], 4, '[E] - Garage')
							end
							if room.locked then
								DrawText3D(room.coords[1], room.coords[2], room.coords[3], 2, '[E] - Enter | [U] - Locked (~y~'..room.name..'~s~)')
							else
								DrawText3D(room.coords[1], room.coords[2], room.coords[3], 2, '[E] - Enter | [U] - Unlocked (~g~'..room.name..'~s~)')
							end
						elseif room.owner then
							DrawText3D(room.coords[1], room.coords[2], room.coords[3], 2, '[E] - Enter (~g~'..room.name..'~s~)')
						end
					end
				elseif data.type == 'apartment' then
					DrawText3D(data.office[1], data.office[2], data.office[3], 10, '[E] - Buzz Apartments')
				end
			end
			if IsControlJustPressed(0, 38) then
				local playerCoords = GetEntityCoords(playerPed)
				if Vdist(playerCoords, -115.40, -603.75, 36.28) < 4 then
					TriggerServerEvent('properties:requestRealEstateMenu')
				end
				for property, data in pairs(properties) do
					if data.type == 'house' then
						for i = 1, #data.rooms do
							local room = data.rooms[i]
							if Vdist(playerCoords, room.coords[1], room.coords[2], room.coords[3]) < 1.0 then
								TriggerServerEvent('properties:requestEntry', property, i)
								PlayDoorAnimation()
							end
							if room.garage and room.owner == GetPlayerServerId(PlayerId()) then
								if Vdist(playerCoords, room.garage[1], room.garage[2], room.garage[3]) < 2.0 then
									if IsPedInAnyVehicle(playerPed, true) then
										local handle = GetVehiclePedIsIn(playerPed, false)
										local numberPlateText = GetVehicleNumberPlateText(handle)
										TriggerServerEvent("garage:storeVehicle", handle, numberPlateText)
									else
										local garage = {
											['x'] = room.garage[1],
											['y'] = room.garage[2],
											['z'] = room.garage[3]
										}
										TriggerServerEvent('garage:openMenu', false, garage)
									end
								end
							end
						end
					else
						if Vdist(playerCoords, data.office[1], data.office[2], data.office[3]) < 3 then
							if data.type == 'motel' then
								TriggerServerEvent('properties:moveProperties', property)
							else
								TriggerEvent('properties:openBuzzMenu', property)
							end
						end
						if data.type == 'motel' then
							for i = 1, #data.rooms do
								local room = properties[property].rooms[i]
								if room.owner then
									if Vdist(room.coords[1], room.coords[2], room.coords[3], playerCoords) < 0.5 then
										TriggerServerEvent('properties:requestEntry', property, i)
										PlayDoorAnimation()
									end
								end
							end
						end
					end
				end
			elseif IsControlJustPressed(0, 303) then
				for property, data in pairs(properties) do
					if data.type == 'motel' or data.type == 'house' then
						for i = 1, #data.rooms do
							local room = properties[property].rooms[i]
							local playerCoords = GetEntityCoords(playerPed)
							if Vdist(room.coords[1], room.coords[2], room.coords[3], playerCoords) < 0.5 then
								if room.owner == GetPlayerServerId(PlayerId()) then
									TriggerServerEvent('properties:toggleLock', property, i)
									PlayDoorAnimation()
								end
							end
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('properties:enterProperty')
AddEventHandler('properties:enterProperty', function(_currentProperty)
	currentProperty = _currentProperty
	myInstance.players = currentProperty.instance
	for i = 1, #myInstance.players do
		print('source '..myInstance.players[i]..' has been placed into room '..currentProperty.index)
	end
	myInstance.active = true
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(currentProperty.entryCoords)
	local heading = currentProperty.entryHeading
	DoorTransition(x, y, z, heading)
end)

RegisterNetEvent('properties:breachProperty')
AddEventHandler('properties:breachProperty', function(_currentProperty)
	print('breaching property')
	currentProperty = _currentProperty
	myInstance.players = currentProperty.instance
	for i = 1, #myInstance.players do
		print('source '..myInstance.players[i]..' has been placed into room '..currentProperty.index)
	end
	myInstance.active = true
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(currentProperty.entryCoords)
	local heading = currentProperty.entryHeading
	DoorTransition(x, y, z, heading, true)
end)

RegisterNetEvent('properties:findRoomToBreach')
AddEventHandler('properties:findRoomToBreach', function(apt)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	for property, data in pairs(properties) do
		if data.type == 'motel' or data.type == 'house' then
			for i = 1, #data.rooms do
				local room = data.rooms[i]
				local x, y, z = table.unpack(room.coords)
				if Vdist(playerCoords, x, y, z) < 1.0 and room.owner then
					TriggerServerEvent('properties:forceEntry', property, i)
				end
			end
		elseif data.type == 'apartment' then
			if tonumber(apt) then
				local x, y, z = table.unpack(data.office)
				if Vdist(playerCoords, x, y, z) < 1.0 then
					for i = 1, #data.rooms do
						local room = data.rooms[i]
						if string.find(room.name, apt) and room.owner then
							TriggerServerEvent('properties:forceEntry', property, i)
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('properties:findRoomToKnock')
AddEventHandler('properties:findRoomToKnock', function()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	for property, data in pairs(properties) do
		if data.type == 'motel' or data.type == 'house' then
			for i = 1, #data.rooms do
				local room = data.rooms[i]
				local x, y, z = table.unpack(room.coords)
				if Vdist(playerCoords, x, y, z) < 1.0 and room.owner then
					RequestAnimDict('timetable@jimmy@doorknock@')
					while not HasAnimDictLoaded('timetable@jimmy@doorknock@') do Wait(100) end
					TaskPlayAnim(PlayerPedId(), 'timetable@jimmy@doorknock@', 'knockdoor_idle', 8.0, 8.0, -1, 48, false)
					Citizen.Wait(300)
					TriggerServerEvent('properties:knockOnDoor', property, i)
					Citizen.Wait(2000)
					ClearPedTasks(PlayerPedId())
				end
			end
		end
	end
end)

RegisterNetEvent('properties:playKnockAnim')
AddEventHandler('properties:playKnockAnim', function()
	local playerPed = PlayerPedId()
	RequestAnimDict('timetable@jimmy@doorknock@')
	while not HasAnimDictLoaded('timetable@jimmy@doorknock@') do Wait(100) end
	TaskPlayAnim(PlayerPedId(), 'timetable@jimmy@doorknock@', 'knockdoor_idle', 8.0, 8.0, -1, 48, false)
	Citizen.Wait(2000)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('properties:updateInstance')
AddEventHandler('properties:updateInstance', function(_instance)
	if #_instance > 0 then
		myInstance.players = _instance
	else
		myInstance.players = {}
		myInstance.active = false
	end
	for i = 0, 255 do
		local playerPed = GetPlayerPed(i)
		if playerPed ~= PlayerPedId() then
			SetEntityCollision(playerPed, true, true)
		end
	end
end)

RegisterNetEvent('properties:loadOutfit')
AddEventHandler('properties:loadOutfit', function(data)
	print('loading outift...')
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	if currentProperty.owner and currentProperty.owner ~= -1 then
		local x, y, z = table.unpack(currentProperty.wardrobeCoords)
		if Vdist(playerCoords, x, y, z) < 1.5 then
			if data then
				DoScreenFadeOut(500)
		        Citizen.Wait(500)
				for key, value in pairs(data["components"]) do
					SetPedComponentVariation(playerPed, tonumber(key), value, data["componentstexture"][key], 0)
				end
				for key, value in pairs(data["props"]) do
					SetPedPropIndex(playerPed, tonumber(key), value, data["propstexture"][key], true)
				end

				local character = {
					components = {},
					componentstexture = {},
					props = {},
					propstexture = {}
				}
				character.hash = GetEntityModel(playerPed)
				for i = 0, 2 do
					character.props[i] = GetPedPropIndex(playerPed, i)
					character.propstexture[i] = GetPedPropTextureIndex(playerPed, i)
				end
				for i = 0, 11 do
					character.components[i] = GetPedDrawableVariation(playerPed, i)
					character.componentstexture[i] = GetPedTextureVariation(playerPed, i)
				end
				TriggerServerEvent("mini:save", character)
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'zip-close', 1.0)
				Citizen.Wait(2000)
				DoScreenFadeIn(500)
		        TriggerEvent("usa:playAnimation", 'clothingshirt', 'try_shirt_positive_d', -8, 1, -1, 48, 0, 0, 0, 0, 3)
			end
		else
			TriggerEvent('usa:notify', 'You are not at a wardrobe!')
		end
	else
		TriggerEvent('usa:notify', 'You are not at a wardrobe!')
	end
end)

RegisterNetEvent('properties:exitProperty')
AddEventHandler('properties:exitProperty', function(noTp)
	local playerPed = PlayerPedId()
	if not noTp then
		local x, y, z = table.unpack(currentProperty.exitCoords)
		local heading = currentProperty.exitHeading
		DoorTransition(x, y, z, heading)
	end
	myInstance = {}
	currentProperty = {}
	for i = 0, 255 do
		local playerPed = GetPlayerPed(i)
		if playerPed ~= PlayerPedId() then
			SetEntityCollision(playerPed, true, true)
		end
	end
end)

RegisterNetEvent('properties:buzzMe')
AddEventHandler('properties:buzzMe', function()
	PlaySoundFrontend(-1, "DOOR_BUZZ", "MP_PLAYER_APARTMENT", 1)
	TriggerEvent('usa:showHelp', true, 'A person is buzzing the apartment, use /buzzaccept to accept.')
end)

RegisterNetEvent('properties:buzzEnter')
AddEventHandler('properties:buzzEnter', function(location, index)
	if buzzedApartment.location == location and buzzedApartment.index == index and GetGameTimer() - buzzedApartment.time < 30000 then
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local x, y, z = table.unpack(properties[location].office)
		if Vdist(playerCoords, x, y, z) < 5 then
			TriggerServerEvent('properties:requestEntry', location, index)
		end
	end
end)

RegisterNetEvent('properties:openStorage')
AddEventHandler('properties:openStorage', function(menu_data)
	LoadPropertyMenu(menu_data, currentProperty.location, currentProperty.index)
	Citizen.CreateThread(function()
		while mainMenu:Visible() do
			Citizen.Wait(100)
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local x, y, z = table.unpack(currentProperty.storageCoords)
			if Vdist(playerCoords, x, y, z) > 3.0 then
				mainMenu:Visible(false)
				RemoveMenuPool()
			end
		end
	end)
end)

RegisterNetEvent('properties:openBuzzMenu')
AddEventHandler('properties:openBuzzMenu', function(location)
	LoadBuzzMenu(location)
	Citizen.CreateThread(function()
		while mainMenu:Visible() do
			Citizen.Wait(100)
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local x, y, z = table.unpack(properties[location].office)
			if Vdist(playerCoords, x, y, z) > 3.0 then
				mainMenu:Visible(false)
				RemoveMenuPool()
			end
		end
	end)
end)

RegisterNetEvent('properties:openRealEstateMenu')
AddEventHandler('properties:openRealEstateMenu', function(property)
	LoadRealEstateMenu(property)
	Citizen.CreateThread(function()
		while mainMenu:Visible() do
			Citizen.Wait(100)
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			if Vdist(playerCoords, -115.40, -603.75, 36.28) > 3.0 then
				mainMenu:Visible(false)
				RemoveMenuPool()
			end
		end
	end)
end)

RegisterNetEvent('properties:openWardrobeMenu')
AddEventHandler('properties:openWardrobeMenu', function()
	LoadWardrobeMenu()
	Citizen.CreateThread(function()
		while mainMenu:Visible() do
			Citizen.Wait(100)
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local x, y, z = table.unpack(currentProperty.wardrobeCoords)
			if Vdist(playerCoords, x, y, z) > 3.0 then
				mainMenu:Visible(false)
				RemoveMenuPool()
			end
		end
	end)
end)

RegisterNetEvent('properties:returnAllData')
AddEventHandler('properties:returnAllData', function(data)
	properties = data
	if firstSpawn then
		firstSpawn = false
	end
end)

RegisterNetEvent('properties:setWaypoint')
AddEventHandler('properties:setWaypoint', function(coords)
	SetNewWaypoint(coords[1], coords[2])
end)

RegisterNetEvent('properties:updateBlip')
AddEventHandler('properties:updateBlip', function(location, index)
	for i = 1, #blips do
		RemoveBlip(blips[i])
	end
	-- property blip
	local x, y, z = table.unpack(properties[location].rooms[index].coords)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, 40)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 61)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Your Property')
	EndTextCommandSetBlipName(blip)
	table.insert(blips, blip)
	-- real estate blip
	local blip = AddBlipForCoord(-115.40, -603.75, 36.28)
	SetBlipSprite(blip, 181)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 61)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Real Estate')
	EndTextCommandSetBlipName(blip)
	table.insert(blips, blip)
end)

RegisterNetEvent('properties:getHeadingForHouse')
AddEventHandler('properties:getHeadingForHouse', function(target, location)
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(playerPed))
	local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
	local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
	local current_zone = GetNameOfZone(x, y, z)
	TriggerServerEvent('properties:continueHousePurchase', target, location, GetEntityHeading(playerPed), lastStreetNAME, current_zone)
end)

RegisterNetEvent('properties:lockpickHouseBurglary')
AddEventHandler('properties:lockpickHouseBurglary', function(index, lockpickItem)
	if GetClockHours() > 6 and GetClockHours() < 20 and math.random() < 0.45 then -- chance of reporting when burglary is happening at day
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed))
		local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
		local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
		TriggerServerEvent('911:Burglary', x, y, z, lastStreetNAME, IsPedMale(playerPed))
	end

	TriggerEvent("lockpick:openlockpick", index)
end)

RegisterNetEvent('properties:enterBurglaryHouse')
AddEventHandler('properties:enterBurglaryHouse', function(_currentProperty)
	currentProperty = _currentProperty
	myInstance.players = currentProperty.instance
	for i = 1, #myInstance.players do
		print('source '..myInstance.players[i]..' has been placed into room '..currentProperty.index)
	end
	myInstance.active = true
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(currentProperty.entryCoords)
	local heading = currentProperty.entryHeading
	local residentSpawned = false

	if math.random() > 0.70 then
		residentSpawned = true
		SpawnResidents()
	end

	exports["_anticheese"]:Disable("speedOrTP")
	DoorTransition(x, y, z, heading)
	exports["_anticheese"]:Enable("speedOrTP")

	local alertness = 0

	Citizen.CreateThread(function()
		while currentProperty.owner == -1 and alertness < 5000 and residentSpawned do
			local beginTime = GetGameTimer()
			while GetGameTimer() - beginTime < 4000 do
				Citizen.Wait(0)
				DrawTimer(math.floor(GetGameTimer() - alertness), 5000, 1.42, 1.475, 'ALERTNESS')
			end
			Citizen.Wait(1000)
		end
	end)

	Citizen.CreateThread(function()
		while currentProperty.owner == -1 and alertness < 5000 and residentSpawned do
			Citizen.Wait(0)
			alertness = alertness + GetPlayerCurrentStealthNoise(PlayerId())
			local speed = GetEntitySpeed(playerPed)
			if speed > 0.7 and speed < 1.0 then
				alertness = alertness + 2
			elseif speed > 1.0 and speed < 1.5 then
				alertness = alertness + 3
			elseif speed > 1.5 and speed < 2.0 then
				alertness = alertness + 10
			elseif speed > 2.0 and speed < 3.0 then
				alertness = alertness + 18
			elseif speed > 3.0 then
				alertness = alertness + 24
			elseif alertness - 1 >= 0 and speed < 0.7 then
				alertness = alertness - 1
			end
			if alertness > 5000 then
				local x, y, z = table.unpack(_currentProperty.exitCoords)
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				TriggerServerEvent('911:Burglary', x, y, z, lastStreetNAME, IsPedMale(playerPed))

				local oneAttacking = false
				for i = 1, #spawnedPeds do
					if not oneAttacking then oneAttacking = true elseif math.random() > 0.8 then return end
					local handle = spawnedPeds[i]
					ClearPedTasksImmediately(handle)
					FreezeEntityPosition(handle, false)
					TaskCombatPed(handle, playerPed, 0, 16)
				end
				break
			end
		end
	end)

	while currentProperty.owner == -1 do
		Wait(0)

		if not currentProperty.cabinets then
			break
		end
		
		for i = 1, #currentProperty.cabinets do
			local cabinet = currentProperty.cabinets[i]
			DrawText3D(cabinet.x, cabinet.y, cabinet.z, 2, '[E] - Search')
		end

		if IsControlJustPressed(0, 38) then
			local playerCoords = GetEntityCoords(playerPed)
			for i = #currentProperty.cabinets, 1, -1 do
				local cabinet = currentProperty.cabinets[i]
				if Vdist(playerCoords, cabinet.x, cabinet.y, cabinet.z) < 1.0 then
					FreezeEntityPosition(playerPed, true)
					local file = 'cabinet1'
					if math.random() > 0.5 then file = 'cabinet2' end
					TriggerServerEvent('InteractSound_SV:PlayOnSource', file, 0.7)
					Citizen.Wait(100)
					alertness = alertness + 500
					local beginTime = GetGameTimer()
					while GetGameTimer() - beginTime < 8000 do
						Citizen.Wait(0)
						DrawTimer(beginTime, 8000, 1.42, 1.435, 'SEARCHING')
					end
					FreezeEntityPosition(playerPed, false)
					table.remove(currentProperty.cabinets, i)
					TriggerServerEvent('properties:searchCabinetBurglary', currentProperty.index)
					break
				end
			end
		end
	end
end)

RegisterNetEvent('properties:breachHouseBurglary')
AddEventHandler('properties:breachHouseBurglary', function(_currentProperty)
	print('breaching property')
	currentProperty = _currentProperty
	myInstance.players = currentProperty.instance
	for i = 1, #myInstance.players do
		print('source '..myInstance.players[i]..' has been placed into room '..currentProperty.index)
	end
	myInstance.active = true
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(currentProperty.entryCoords)
	local heading = currentProperty.entryHeading
	DoorTransition(x, y, z, heading, true)
end)

RegisterNetEvent('properties:setPosition')
AddEventHandler('properties:setPosition', function(coords, heading)
	RequestCollisionAtCoord(coords[1], coords[2], coords[3])
	SetEntityCoordsNoOffset(PlayerPedId(), coords[1], coords[2], coords[3], false, false, false, true)
	if heading then
		SetEntityHeading(PlayerPedId(), heading)
	end
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
	    Citizen.Wait(100)
	    SetEntityCoords(PlayerPedId(), coords[1], coords[2], coords[3], 1, 0, 0, 1)
	end
end)

function LoadRealEstateMenu(property)
	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu('Real Estate', 'Property Management', 0--[[X COORD]], 320 --[[Y COORD]])
	local interior = properties[property['location']].interior
	local motel = NativeUI.CreateItem("Motel Room", "Downgrade to a motel room.")
	local lowend = NativeUI.CreateItem("Low-end Apartment ($"..comma_value(properties['Burton Apartments'].payment).." weekly)", "Move to a low-end apartment at Burton Apartments.")
	local midend = NativeUI.CreateItem("Mid-end Apartment ($"..comma_value(properties['Tinsel Towers'].payment).." weekly)", "Move to a mid-end apartment at Tinsel Towers.")
	local highend = NativeUI.CreateItem("High-end Apartment ($"..comma_value(properties['Eclipse Towers'].payment).." weekly)", "Move to a high-end apartment at Eclipse Towers.")
	motel.Activated = function(parentmenu, selected)
		RemoveMenuPool(_menuPool)
		TriggerServerEvent('properties:estateChange', 'motel')
	end
	lowend.Activated = function(parentmenu, selected)
		RemoveMenuPool(_menuPool)
		TriggerServerEvent('properties:estateChange', 'lowapartment')
	end
	midend.Activated = function(parentmenu, selected)
		RemoveMenuPool(_menuPool)
		TriggerServerEvent('properties:estateChange', 'midapartment')
	end
	highend.Activated = function(parentmenu, selected)
		RemoveMenuPool(_menuPool)
		TriggerServerEvent('properties:estateChange', 'highapartment')
	end

	if interior == 'motel' then
		mainMenu:AddItem(lowend)
		mainMenu:AddItem(midend)
		mainMenu:AddItem(highend)
	elseif interior == 'lowapartment' then
		mainMenu:AddItem(motel)
		mainMenu:AddItem(midend)
		mainMenu:AddItem(highend)
	elseif interior == 'midapartment' then
		mainMenu:AddItem(motel)
		mainMenu:AddItem(lowend)
		mainMenu:AddItem(highend)
	elseif interior == 'highapartment' then
		mainMenu:AddItem(motel)
		mainMenu:AddItem(lowend)
		mainMenu:AddItem(midend)
	end
	_menuPool:RefreshIndex()
    _menuPool:Add(mainMenu)
    mainMenu:Visible(true)
    while mainMenu:Visible() do
    	Citizen.Wait(100)
    	if Vdist(GetEntityCoords(PlayerPedId()), -115.40, -603.75, 36.28) > 5.0 then
    		mainMenu:Visible(false)
    	end
    end
end

function LoadBuzzMenu(location)
	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu('Buzz Apartments', location, 0--[[X COORD]], 320 --[[Y COORD]])
	if AnyActiveRoomsAtLocation(location) then
		for i = 1, #properties[location].rooms do
			local room = properties[location].rooms[i]
			if room.owner then
				local buzzItem = NativeUI.CreateItem(room.name, 'Buzz this apartment')
				if room.owner == GetPlayerServerId(PlayerId()) then
					buzzItem = NativeUI.CreateItem('Enter '..room.name, 'Enter your apartment')
				end
				buzzItem.Activated = function(parentmenu, selected)
					RemoveMenuPool(_menuPool)
					TriggerServerEvent('properties:buzzApartment', location, i)
					buzzedApartment = {
						time = GetGameTimer(),
						location = location,
						index = i
					}
				end
				mainMenu:AddItem(buzzItem)

			end
		end
		_menuPool:RefreshIndex()
	    _menuPool:Add(mainMenu)
	    mainMenu:Visible(true)
	else
		TriggerEvent('usa:notify', 'No apartments to buzz!')
	end
end

function LoadWardrobeMenu()
	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu('Wardrobe', '~b~Choose your outfit', 0--[[X COORD]], 320 --[[Y COORD]])
	local selectedSaveSlot = 1
    local selectedLoadSlot = 1
    local saveslot = UIMenuListItem.New("Slot to Save", outfitAmount)
    local saveconfirm = UIMenuItem.New('Confirm Save', 'Save outfit into the above number')
    saveconfirm:SetRightBadge(BadgeStyle.Tick)
    local loadslot = UIMenuListItem.New("Slot to Load", outfitAmount)
    local loadconfirm = UIMenuItem.New('Load Outfit', 'Load outfit from above number')
    loadconfirm:SetRightBadge(BadgeStyle.Clothes)
    mainMenu:AddItem(loadslot)
    mainMenu:AddItem(loadconfirm)
    mainMenu:AddItem(saveslot)
    mainMenu:AddItem(saveconfirm)

    mainMenu.OnListChange = function(sender, item, index)
        if item == saveslot then
            selectedSaveSlot = item:IndexToItem(index)
        elseif item == loadslot then
            selectedLoadSlot = item:IndexToItem(index)
        end
    end
    mainMenu.OnItemSelect = function(sender, item, index)
        if item == saveconfirm then
            local character = {
				components = {},
				componentstexture = {},
				props = {},
				propstexture = {}
			}
			local ply = GetPlayerPed(-1)
			for i = 0, 2 do
				character.props[i] = GetPedPropIndex(ply, i)
				character.propstexture[i] = GetPedPropTextureIndex(ply, i)
			end
			for i = 0, 11 do
				character.components[i] = GetPedDrawableVariation(ply, i)
				character.componentstexture[i] = GetPedTextureVariation(ply, i)
			end
			TriggerServerEvent("properties:saveOutfit", character, selectedSaveSlot)
			RemoveMenuPool(_menuPool)
        elseif item == loadconfirm then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            TriggerServerEvent('properties:loadOutfit', selectedLoadSlot)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'zip-close', 1.0)
			Citizen.Wait(2000)
			DoScreenFadeIn(500)
            TriggerEvent("usa:playAnimation", 'clothingshirt', 'try_shirt_positive_d', -8, 1, -1, 48, 0, 0, 0, 0, 3)
            RemoveMenuPool(_menuPool)
        end
    end

    _menuPool:RefreshIndex()
    _menuPool:Add(mainMenu)
    mainMenu:Visible(true)
end

function AnyActiveRoomsAtLocation(location)
	for i = 1, #properties[location].rooms do
		if properties[location].rooms[i].owner then
			return true
		end
	end
	return false
end

function LoadPropertyMenu(menu_data, location, index)
	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu('Cupboard', 'Property Storage', 0--[[X COORD]], 320 --[[Y COORD]])
    ------------------------------
    -- load /display money --
    ------------------------------
    local item = NativeUI.CreateItem("Stashed Cash: ~g~$" .. menu_data.money, 'Stashed cash at this property.')
    mainMenu:AddItem(item)
    --------------------
    -- store money --
    --------------------
    local item = NativeUI.CreateItem("Store Cash", "Store cash at this property.")
    item.Activated = function(parentmenu, selected)
        -----------------------------
        -- get amount to store --
        -----------------------------
        -- 1) close menu
        RemoveMenuPool(_menuPool)
        -- 2) get input
        local amount = tonumber(KeyboardInput('Enter amount:', '', 16))
        if amount then
        	TriggerServerEvent("properties:storeMoney", location, index, amount)
        end
    end
    mainMenu:AddItem(item)
    --------------------------
    -- withdraw money --
    --------------------------
    local item = NativeUI.CreateItem("Withdraw Cash", "Withdraw cash from this property.")
    item.Activated = function(parentmenu, selected)
        ----------------------------------
        -- get amount to withdraw --
        ----------------------------------
        -- close menu --
        RemoveMenuPool(_menuPool)
        -- get input to withdraw --
        local amount = tonumber(KeyboardInput('Enter amount:', '', 16))
        if amount then
        	TriggerServerEvent("properties:withdrawMoney", location, index, amount)
        end
    end
    mainMenu:AddItem(item)
    ---------------------
    -- item retrieval  --
    ---------------------
    local retrieval_submenu = _menuPool:AddSubMenu(mainMenu, "Storage", "Retrieve items from this property.", true --[[KEEP POSITION]])
    if #menu_data.property_items > 0 then
        for i = 1, #menu_data.property_items do
            local item = menu_data.property_items[i]
            local color = ""
            if item.legality == "illegal" then
                color = "~r~"
            end
            local itembtn = NativeUI.CreateItem(color .. "(" .. item.quantity .. "x) " .. item.name, "Withdraw this item.")
            itembtn.Activated = function(parentmenu, selected)
                RemoveMenuPool(_menuPool)
                ----------------------------------------------------------------
                -- ask for quantity to retrieve, then try to retrieve it --
                ----------------------------------------------------------------
                if item.quantity > 1 then
               		local amount = tonumber(KeyboardInput('Enter amount:', '', 5))
					if amount then
	               		amount = math.floor(amount)
	                    if amount > 0 then
	                        if item.quantity - amount >= 0 then
	                            TriggerServerEvent("properties:retrieveItem", location, index, item, amount)
	                        else
	                            TriggerEvent('usa:notify', "Quantity input too high!")
	                        end
	                    else
	                        TriggerEvent('usa:notify', "Quantity input too low!")
	                    end
					end
                else
	            	TriggerServerEvent("properties:retrieveItem", location, index, item, item.quantity)
	            end
            end
            retrieval_submenu.SubMenu:AddItem(itembtn)
        end
    else
        local item = NativeUI.CreateItem("You have nothing stored here!", "Press \"Store Items\" to store something here.")
        retrieval_submenu.SubMenu:AddItem(item)
    end
    --------------------
    -- item storage --
    --------------------
    local storage_submenu = _menuPool:AddSubMenu(mainMenu, "Store Items", "Store items at this property.", true --[[KEEP POSITION]])
    if #menu_data.user_items > 0 then
        for i = 1, #menu_data.user_items do
            local item = menu_data.user_items[i]
            local color = ""
            if item.legality == "illegal" then
                color = "~r~"
            end
            local itembtn = NativeUI.CreateItem(color .. "(" .. item.quantity .. "x) " .. item.name, "Store this item.")
            itembtn.Activated = function(parentmenu, selected)
                RemoveMenuPool(_menuPool)
                -- ask for quantity to store, then try to store it --
	            if not item.quantity then item.quantity = 1 end
	            if item.quantity > 1 then
	           		local amount = tonumber(KeyboardInput('Enter amount:', '', 5))
					if amount then
		           		amount = math.floor(amount)
		                if amount > 0 then
		                    if item.quantity - amount >= 0 then
		                        TriggerServerEvent("properties:storeItem", location, index, item, amount)
		                    else
		                        TriggerEvent('usa:notify', "Quantity input too high!")
		                    end
		                else
		                    TriggerEvent('usa:notify', "Quantity input too low!")
		                end
					end
	            else
					if item.name == 'Jerry Can' then
						TriggerEvent('usa:notify', 'You cannot store Jerry Cans here!')
					else
						TriggerServerEvent("properties:storeItem", location, index, item, item.quantity)
					end
	            end
	       	end
            storage_submenu.SubMenu:AddItem(itembtn)
        end
    else
        local item = NativeUI.CreateItem("No items to store!", "You have nothing to store.")
        storage_submenu.SubMenu:AddItem(item)
    end
    _menuPool:RefreshIndex()
    _menuPool:Add(mainMenu)
    mainMenu:Visible(true)
end

DoScreenFadeIn(0)

function RemoveMenuPool()
	_menuPool:CloseAllMenus()
    _menuPool = nil
end

function KeyboardInput(textEntry, inputText, maxLength) -- Thanks to Flatracer for the function.
	TriggerEvent("hotkeys:enable", false)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		TriggerEvent("hotkeys:enable", true)
        return result
    else
		Citizen.Wait(500)
		TriggerEvent("hotkeys:enable", true)
        return nil
    end
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance and not IsPlayerSwitchInProgress() then
    	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / 430
	    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
	end
end

function PlayDoorAnimation()
    while ( not HasAnimDictLoaded( 'anim@mp_player_intmenu@key_fob@' ) ) do
        RequestAnimDict( 'anim@mp_player_intmenu@key_fob@' )
        Citizen.Wait( 0 )
	end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, -1, 48)
end

function DoorTransition(x, y, z, heading, breach)
	doorTransition = true
	if not breach then
		PlayDoorAnimation()
		DoScreenFadeOut(500)
		Wait(500)
		RequestCollisionAtCoord(x, y, z)
		SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, false, false, false, true)
		SetEntityHeading(PlayerPedId(), heading)
		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		    Citizen.Wait(100)
		    SetEntityCoords(PlayerPedId(), x, y, z, 1, 0, 0, 1)
		end
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.5)
		Wait(2000)
		DoScreenFadeIn(500)
	else
		while ( not HasAnimDictLoaded( 'missprologuemcs_1' ) ) do
	        RequestAnimDict( 'missprologuemcs_1' )
	        Citizen.Wait( 0 )
		end
		TaskPlayAnim(PlayerPedId(), "missprologuemcs_1", "kick_down_player_zero", 8.0, 1.0, -1, 14)
		Citizen.Wait(100)
		DoScreenFadeOut(500)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-kick', 0.4)
		Wait(500)
		ClearPedTasks(PlayerPedId())
		RequestCollisionAtCoord(x, y, z)
		SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, false, false, false, true)
		SetEntityHeading(PlayerPedId(), heading)
		while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		    Citizen.Wait(100)
		    SetEntityCoords(PlayerPedId(), x, y, z, 1, 0, 0, 1)
		end
		Wait(2000)
		DoScreenFadeIn(500)
	end
	doorTransition = false
end

function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
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

    local correction = ((1.0 - math.floor(GetSafeZoneSize())) * 100) * 0.005
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

function SpawnResidents()
	local spawnedOne = false

	for i = 1, #residents do

		if not spawnedOne then spawnedOne = true elseif math.random() > 0.4 then return end

		local resident = residents[i]

		local model = residents.models[math.random(1, #residents.models)]
		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(0)
		end

		local ped = CreatePed(4, model, resident.coords, resident.rotation, false, false)
		table.insert(spawnedPeds, ped)

		-- animation
		RequestAnimDict(residents.animation.dict)

		while not HasAnimDictLoaded(residents.animation.dict) do
			Wait(0)
		end

		local weapon = residents.weapons[math.random(1, #residents.weapons)]
		GiveWeaponToPed(ped, GetHashKey(weapon), 255, true, false)
		SetPedDropsWeaponsWhenDead(ped, false)

		TaskPlayAnimAdvanced(ped, residents.animation.dict, residents.animation.anim, resident.coords, 0.0, 0.0, resident.rotation, 8.0, 1.0, -1, 1, 1.0, true, true)
		SetFacialIdleAnimOverride(ped, "mood_sleeping_1", 0)
	end
end

function RemoveResidents()
	for k, ped in pairs(spawnedPeds) do
		SetPedAsNoLongerNeeded(ped)
		DeletePed(ped)
	end

	spawnedPeds = {}
end

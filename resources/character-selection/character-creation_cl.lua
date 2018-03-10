local menuOpen = false
local selectedCharacter = {}
local selectedCharacterSlot = 0

local open_menu_spawn_coords = {
	x = -1236.653,
	y = 4392.405,
	z = 19.532,
	angle = 285.343
}

local spawn_coords_closed_menu = {
	x = 177.596,
	y = 6636.183,
	z = 31.638,
	angle = 168.2
}

local swap_locations = {
{name="Clothes Store", x = 1.27486, y = 6511.89, z = 30.8778}, -- paleto bay
{name="Clothes Store", x = 1692.24, y = 4819.79, z = 41.0631}, -- grape seed
{name="Clothes Store", x = 1199.09, y = 2707.86, z = 37.0226}, -- sandy shores 1
{name="Clothes Store", x = 614.565, y = 2763.17, z = 41.0881}, -- sandy shores 2
{name="Clothes Store", x = -1097.71, y = 2711.18, z = 18.5079}, -- route 68
{name="Clothes Store", x = -3170.52, y = 1043.97, z = 20.0632}, -- chumash, great ocean hwy
{name="Clothes Store", x = -1449.93, y = -236.979, z = 49.0106}, -- vinewood 1
{name="Clothes Store", x = -710.239, y = -152.319, z = 37.0151}, -- vinewood 2
{name="Clothes Store", x = -1192.84, y = -767.861, z = 17.0187}, -- vinewood 3
{name="Clothes Store", x = -163.61, y = -303.987, z = 39.0333}, -- vinewood 4
{name="Clothes Store", x = 125.403, y = -223.887, z = 54.0578}, -- vinewood 5
{name="Clothes Store", x = 423.474, y = -809.565, z = 29.0911}, -- vinewood 6
{name="Clothes Store", x = -818.509, y = -1074.14, z = 11.0281}, -- vinewood 7
{name="Clothes Store", x = 77.7774, y = -1389.87, z = 29.0761} -- vinewood 8
}

RegisterNetEvent("character:swap--check-distance")
AddEventHandler("character:swap--check-distance", function()
  for i = 1, #swap_locations do
	local location = swap_locations[i]
	if GetDistanceBetweenCoords(location.x, location.y, location.z,GetEntityCoords(GetPlayerPed(-1))) < 7 then
	  print("Player is at a swap location!")
	  TriggerServerEvent("character:getCharactersAndOpenMenu", "home")
	end
  end
end)

TriggerServerEvent("character:getCharactersAndOpenMenu", "home") -- REMOVE

RegisterNetEvent("character:open")
AddEventHandler("character:open", function(menu, data)
	menuOpen = true
	toggleMenu(menuOpen, menu, data)
end)

RegisterNetEvent("character:close")
AddEventHandler("character:close", function()
	menuOpen = false
	toggleMenu(menuOpen)
end)

-- loading in character from JS selection
RegisterNetEvent("character:setCharacter")
AddEventHandler("character:setCharacter", function(character)
	RemoveAllPedWeapons(GetPlayerPed(-1), true) -- remove weapons for the case where a different character is selected after choosing one with weapons initially
	print("setting character!")
	local weapons
	if character then
		print("character existed")
		weapons = character.weapons
		if character.appearance then
			print("character.appearance existed")
			if character.appearance.hash then
				print("character.appearance.hash existed")
				local name, model
				model = tonumber(character.appearance.hash)
				Citizen.Trace("giving loading with customizations with hash = " .. model)
				Citizen.CreateThread(function()
					RequestModel(model)
					while not HasModelLoaded(model) do -- Wait for model to load
						RequestModel(model)
						Citizen.Wait(0)
					end
					SetPlayerModel(PlayerId(), model)
					SetModelAsNoLongerNeeded(model)
					-- ADD CUSTOMIZATIONS FROM CLOTHING STORE
					for key, value in pairs(character.appearance["components"]) do
						SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character.appearance["componentstexture"][key], 2)
					end
					for key, value in pairs(character.appearance["props"]) do
						SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character.appearance["propstexture"][key], true)
					end
					print("GIVING WEAPONS TO PED! # = " .. #weapons)
					-- G I V E  W E A P O N S
					for i =1, #weapons do
						GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
					end
				end)
			else
				Citizen.Trace("Could not find saved character skin!")
				print("GIVING WEAPONS TO PED! # = " .. #weapons)
				-- G I V E  W E A P O N S
				for i =1, #weapons do
					GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
				end
			end
		end
	else
		Citizen.Trace("Could not find character!")
	end
end)

RegisterNUICallback('escape', function(data, cb)
	toggleMenu(false)
	cb('ok')
end)

local alreadyCreated = false
RegisterNUICallback('new-character-submit', function(data, cb)
	print("saving character " .. data.firstName)
	if not alreadyCreated then
		TriggerServerEvent("character:new", data)
	end
	cb('ok')
end)

RegisterNUICallback('select-character', function(data, cb)
	toggleMenu(false)
	if data.character.firstName then print("selecting char: " .. data.character.firstName) end
	selectedCharacter = data.character -- set selected character on lua side from selected js char card
	selectedCharacterSlot = tonumber(data.slot) + 1
	TriggerEvent("chat:setCharName", selectedCharacter) -- for chat messages
	TriggerServerEvent("altchat:setCharName", selectedCharacter) -- for altchat messages
	-- loadout the player with the selected character appearance
	TriggerServerEvent("character:loadCharacter", selectedCharacterSlot)
	-- set active character slot
	TriggerServerEvent("character:setActive", selectedCharacterSlot)
	-- update bank balance:
	TriggerEvent("banking:updateBalance", data.character.bank)
	-- check jail status
	--print("checking player jailed status")
	--TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
	cb('ok')
	alreadyCreated = false
end)

RegisterNUICallback('delete-character', function(data, cb)
	local slot = (data.slot) + 1 -- +1 because of js --> lua
	Citizen.Trace("deleting char at slot #" .. slot)
	TriggerServerEvent("character:delete", slot)
	cb('ok')
	alreadyCreated = false
end)

RegisterNUICallback('disconnect', function(data, cb)
	TriggerServerEvent('character:disconnect')
end)

RegisterNUICallback('list', function(data, cb)
	TriggerServerEvent("character:getCharactersAndOpenMenu", "home")
end)

RegisterNetEvent("character:send-nui-message")
AddEventHandler("character:send-nui-message", function(messageTable)
	SendNUIMessage(messageTable)
end)

local camera = nil
local old_camera = nil

function toggleMenu(status, menu, data)
	-- set player position
	local ped = GetPlayerPed(-1)
	if status then
		-- SetEntityCoords(ped, open_menu_spawn_coords.x, open_menu_spawn_coords.y, open_menu_spawn_coords.z, open_menu_spawn_coords.angle, 0, 0, 1)
		-- FreezeEntityPosition(GetPlayerPed(-1), status)
		-- SetEnableHandcuffs(GetPlayerPed(-1), status)
		-- RemoveAllPedWeapons(ped, true)

		local ped = GetPlayerPed(-1)
		SetEntityCoords(ped, 751.31121826172, 6454.3813476563, 31.926473617554, 0.0, 0, 0, 1)
		FreezeEntityPosition(ped, true)
		DisplayHud(false)
		DisplayRadar(false)
		SetEnableHandcuffs(ped, true)
		RemoveAllPedWeapons(ped, true)
		TriggerEvent("modest:setMoneyDisplay", "0")
		TriggerEvent("compass:display", false)
		hud = false
		skyCam = skyCamera

		camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamCoord(camera, 548.78338623047, 6475.6381835938, 165.71755981445)
		SetCamRot(camera, -25.0, 0.0, 80.00, true)
		RenderScriptCams(true, false, 0, 1, 0)
	else
		old_camera = camera

		SetNuiFocus(status, status)
		menuOpen = status
		SendNUIMessage({
			type = "toggleMenu",
			menuStatus = status,
			menu = menu,
			data = data
		})

		StartScreenEffect("DeathFailOut", 3500, false)
		camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamCoord(camera, spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, 165.71755981445)
		SetCamRot(camera, -90.0, 0.0, 80.0, true)
		RenderScriptCams(true, false, camera, 1, 0)

		SetCamActiveWithInterp(camera, old_camera, 2000, false, false)

		while IsCamInterpolating(camera) do
			Citizen.Wait(100)
		end

		zoom = 0
		while zoom < 120 do
			SetCamCoord(camera, spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, 165.71755981445-zoom)
			SetCamRot(camera, -90.0, 0.0, 80.0+zoom/1, true)
			zoom = zoom+0.8
			Citizen.Wait(1)
		end

		RenderScriptCams(false, false, old_camera, 1, 0)
		RenderScriptCams(false, false, camera, 1, 0)
		DestroyCam(old_camera, false)
		DestroyCam(camera, false)

		DoScreenFadeOut(1000)
		-- SetEntityCoords(GetPlayerPed(-1), spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z, 1, 0, 0, 1)

		RequestCollisionAtCoord(spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z)
		SetEntityCoords(ped, spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z, 0.0, 0, 0, 1)
		FreezeEntityPosition(GetPlayerPed(-1), status)
		SetEnableHandcuffs(GetPlayerPed(-1), status)

		DoScreenFadeIn(1000)
	end
	-- should this be here? Seems like SendNUIMessage and SetNuiFocus will be called twice if status == false
	print("status = " .. tostring(status))
	print("ped = " .. ped)
	DisplayHud(not status)
	DisplayRadar(not status)
	-- open / close menu
	SetNuiFocus(status, status)
	menuOpen = status
	SendNUIMessage({
		type = "toggleMenu",
		menuStatus = status,
		menu = menu,
		data = data
	})

end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if menuOpen then
			SetEntityCoords(GetPlayerPed(-1), 751.31121826172, 6454.3813476563, 31.926473617554, open_menu_spawn_coords.angle, 0, 0, 1)
		end
	end
end)

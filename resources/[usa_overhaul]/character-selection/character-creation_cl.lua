local menuOpen = false
local selectedCharacter = {}
local selectedCharacterSlot = 0
local characterLoaded = false

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

local while_menu_open_location = {
	x = 751.31121826172,
	y = 6454.3813476563,
	z = 31.926473617554
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
	{name="Clothes Store", x = 77.7774, y = -1389.87, z = 29.0761}, -- vinewood 8
	{name="Morgue", x = 260.16, y = -1347.09, z = 24.00} -- morgue
}

RegisterNetEvent("character:swap--check-distance")
AddEventHandler("character:swap--check-distance", function()
  for i = 1, #swap_locations do
	local location = swap_locations[i]
	if GetDistanceBetweenCoords(location.x, location.y, location.z,GetEntityCoords(GetPlayerPed(-1))) < 7 then
	  --print("Player is at a swap location!")
	  TriggerServerEvent("character:getCharactersAndOpenMenu", "home")
	end
  end
end)

TriggerServerEvent("character:getCharactersAndOpenMenu", "home")

RegisterNetEvent("character:open")
AddEventHandler("character:open", function(menu, data)
	DoScreenFadeOut(500)
	Citizen.Wait(1000)
	DoScreenFadeIn(500)
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
	Citizen.CreateThread(function()
		RemoveAllPedWeapons(GetPlayerPed(-1), true) -- remove weapons for the case where a different character is selected after choosing one with weapons initially
		---print("setting character!")
		local weapons
		if character then
			--print("character existed")
			weapons = character.weapons
			if character.appearance then
				--print("character.appearance existed")
				if character.appearance.hash then
					local name, model
					model = tonumber(character.appearance.hash)

						RequestModel(model)
						while not HasModelLoaded(model) do -- Wait for model to load
							Citizen.Wait(100)
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
						-- add any tattoos if they have any --
						if character.appearance.tattoos then
							for i = 1, #character.appearance.tattoos do
								ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.appearance.tattoos[i].category), GetHashKey(character.appearance.tattoos[i].hash_name))
							end
						end
						-- add any barber shop customizations if any --
						if character.appearance.head_customizations then
							local head = character.appearance.head_customizations
							local ped = GetPlayerPed(-1)
					    SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
					    --[[ customize face features --
					    if face then
					      local i = 0
					      for name, value in pairs(face) do
					        print("name: " .. name)
					        print("setting index " .. i .. " to value: " .. value / 100.0)
					        SetPedFaceFeature(ped, i, value / 100.0)
					        i = i + 1
					      end
					    end
					    --]] -- on hold cause it wouldn't work
					    -- facial stuff like beards and ageing and what not --
							for i = 1, #head.other do
					      SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
					      if head.other[i][2] ~= 255 then
					        if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
					          SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
					        elseif i == 6 or i == 9 then -- blush, lipstick
					          SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
					        elseif i == 14 then -- hair
										--print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
					          SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
					          SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
					        end
					      end
					    end
							TriggerEvent("barber:loadCustomizations", character.appearance.head_customizations) --// used in 'usa-barbershop' resource
						end
						--print("GIVING WEAPONS TO PED! # = " .. #weapons)
						-- G I V E  W E A P O N S
						for i = 1, #weapons do
							GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
							if weapons[i].components then
								if #weapons[i].components > 0 then
									for x = 1, #weapons[i].components do
										GiveWeaponComponentToPed(GetPlayerPed(-1), weapons[i].hash, GetHashKey(weapons[i].components[x]))
									end
								end
							end
							if weapons[i].tint then
								SetPedWeaponTintIndex(GetPlayerPed(-1), weapons[i].hash, weapons[i].tint)
							end
						end
						SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)

				else
					--Citizen.Trace("Could not find saved character skin!")
					--print("GIVING WEAPONS TO PED! # = " .. #weapons)
					-- G I V E  W E A P O N S
					for i =1, #weapons do
						GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
						if weapons[i].components then
							if #weapons[i].components > 0 then
								for x = 1, #weapons[i].components do
									GiveWeaponComponentToPed(GetPlayerPed(-1), weapons[i].hash, GetHashKey(weapons[i].components[x]))
								end
							end
						end
						if weapons[i].tint then
							SetPedWeaponTintIndex(GetPlayerPed(-1), weapons[i].hash, weapons[i].tint)
						end
					end
					SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
				end
			end
		else
			Citizen.Trace("Could not find character!")
		end
		-- check jailed status when finished loading character --
		TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
		TriggerServerEvent('morgue:checkToeTag')
		FreezeEntityPosition(PlayerPedId(), false)
		characterLoaded = true
	end)
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
	local spawnAtProperty = false
	if data.spawn then -- default is set in JS file (currently paleto bay)
		spawn_coords_closed_menu = {}
		if data.spawn:find("Paleto Bay") then
			spawn_coords_closed_menu = {
				x = 177.596,
				y = 6636.183,
				z = 31.638,
				heading = 130.0
			}
		elseif data.spawn:find("Sandy Shores")  then
			spawn_coords_closed_menu = {
				x = 1501.02,
				y = 3776.2,
				z = 33.5,
				heading = 206.0
			}
		elseif data.spawn:find("Los Santos")  then
			spawn_coords_closed_menu = {
				x = 231.08, 
				y = -874.31, 
				z = 30.5,
				heading = 344.0
			}
		elseif data.spawn:find("Property") then
			spawn_coords_closed_menu = {
				x = -1476.44,
				y = -675.48,
				z = 28.94
			}
			data.spawnAtProperty = true
		end
	end
	toggleMenu(false)
	SpawnCharacter(data)
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

SwitchInPlayer(PlayerPedId())

function toggleMenu(status, menu, data)
	-- set player position
	local ped = GetPlayerPed(-1)
	if status then
		TriggerEvent('usa:toggleHUD', false)
		SetDrawOrigin(0.0, 0.0, 0.0, 0)
		SetEntityCoords(PlayerPedId(), 751.31121826172, 6454.3813476563, 31.926473617554, 0.0, 0, 0, 1)
		FreezeEntityPosition(PlayerPedId(), true)
		SetEnableHandcuffs(PlayerPedId(), true)
		RemoveAllPedWeapons(PlayerPedId(), true)
		TriggerEvent("modest:setMoneyDisplay", "0")
		TriggerEvent("es:setMoneyDisplay", 0)
		TriggerEvent("compass:display", false)
		hud = false
		skyCam = skyCamera

		camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamCoord(camera, 548.78338623047, 6475.6381835938, 165.71755981445)
		SetCamRot(camera, -25.0, 0.0, 80.00, true)
		RenderScriptCams(true, false, 0, 1, 0)
	else
		SetNuiFocus(status, status)
		menuOpen = status
		SendNUIMessage({
			type = "toggleMenu",
			menuStatus = status,
			menu = menu,
			data = data
		})
	end
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

DoScreenFadeIn(500)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if menuOpen then
			SetEntityCoords(GetPlayerPed(-1), while_menu_open_location.x, while_menu_open_location.y, while_menu_open_location.z, open_menu_spawn_coords.angle, 0, 0, 1)
		end
	end
end)

function ClearScreen()
    SetCloudHatOpacity(0.01)
    HideHudAndRadarThisFrame()
    
    -- nice hack to 'hide' HUD elements from other resources/scripts. kinda buggy though.
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function SpawnCharacter(data)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	RenderScriptCams(false, false, camera, 1, 0)
	DestroyCam(camera, false)

	if not IsPlayerSwitchInProgress() then
    	SwitchOutPlayer(PlayerPedId(), 0, 1)
	end

	RequestCollisionAtCoord(spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z)
	SetEntityCoords(PlayerPedId(), spawn_coords_closed_menu.x, spawn_coords_closed_menu.y, spawn_coords_closed_menu.z, 0.0, 0, 0, 1)
	if spawn_coords_closed_menu.heading then SetEntityHeading(PlayerPedId(), spawn_coords_closed_menu.heading) end
	FreezeEntityPosition(PlayerPedId(), true)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Citizen.Wait(100) end
	FreezeEntityPosition(PlayerPedId(), false)

	while GetPlayerSwitchState() ~= 5 do
    	Citizen.Wait(0)
    	ClearScreen()
	end

	Citizen.Wait(0)
	DoScreenFadeIn(500)

	selectedCharacter = data.character -- set selected character on lua side from selected js char card
	selectedCharacterSlot = tonumber(data.slot) + 1
	TriggerEvent("chat:setCharName", selectedCharacter) -- for chat messages
	TriggerServerEvent("altchat:setCharName", selectedCharacter) -- for altchat messages
	-- loadout the player with the selected character appearance
	TriggerServerEvent("character:loadCharacter", selectedCharacterSlot)
	-- set active character slot
	TriggerServerEvent("character:setActive", selectedCharacterSlot, data.spawnAtProperty)
	-- update bank balance:
	TriggerEvent("banking:updateBalance", data.character.bank)

	while not IsScreenFadedIn() or not characterLoaded do
        Citizen.Wait(0)
        ClearScreen()
	end

	local timer = GetGameTimer()
	while true do
        ClearScreen()
        Citizen.Wait(0)
        
        -- wait 5 seconds before starting the switch to the player
        if GetGameTimer() - timer > 5000 then
            
            -- Switch to the player.
            SwitchInPlayer(PlayerPedId())
            
            ClearScreen()
            
            -- Wait for the player switch to be completed (state 12).
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            -- Stop the infinite loop.
            break
        end
    end
    ClearDrawOrigin()
    characterLoaded = false

	-- welcome info --
	TriggerEvent('usa:toggleHUD', true)
	TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0Welcome to ^1U^0S^5A ^3REALISM RP^0!")
	TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0Type ^3'/info' ^0for more help and information!")
	TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^0Press ^3F1 ^0or ^3M ^0to open the interaction menu.")
end
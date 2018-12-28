local policeLockerRooms = {
	{x = -1107.5, y = -847.5, z = 18.4}, -- vespucci PD
	{x = 370.3, y = -1608.4, z = 28.3}, -- davis PD
	{x = 826.5, y = -1291.3, z = 27.3}, -- la mesa PD
	{x = 638.9, y = 1.9, z = 81.8}, -- vinewood PD, elgin ave.
	{x=451.255 , y=-992.41 , z=29.689},
 	{x=1853.2, y=3687.74, z=34.267}, -- sandy
 	--{x=-447.256 , y=6000.667 , z=30.686} -- paleto
 	{x = -449.471, y = 6010.7, z = 31.85}
}

local policeArmourys = {
	{x = -1109.6, y = -844.7, z = 18.4}, -- vespucci PD
	{x = 371.8, y = -1612.1, z = 28.4}, -- davis PD
	{x = 826.6, y = -1288.8, z = 28.2}, -- la mesa PD
	{x = 637.5, y = -2.7, z = 81.8}, -- vinewood PD, elgine ave.
	{x=451.564 , y=-980.095 , z=29.6896},
	{x=1851.34 , y=3683.64 , z=33.2671}, -- sandy
	--{x=-452.361 , y=6006.11 , z=30.8409} -- paleto
	{x = -447.9, y = 6008.7, z = 31.85}
}

local MAX_COMPONENT = 200
local MAX_COMPONENT_TEXTURE = 100

local MAX_PROP = 200
local MAX_PROP_TEXTURE = 100

local arrSkinGeneralCaptions = {"LSPD Male","LSPD Female","Motor Unit","SWAT","Sheriff Male","Sheriff Female","Traffic Warden","Custom Male","Custom Female","FBI 1","FBI 2","FBI 3","FBI 4","Detective Male","Detective Female","Ranger Male", "Ranger Female", "Tactical", "Pilot"}
local arrSkinGeneralValues = {"s_m_y_cop_01","s_f_y_cop_01","S_M_Y_HwayCop_01","S_M_Y_SWAT_01","S_M_Y_Sheriff_01","S_F_Y_Sheriff_01","ig_trafficwarden","mp_m_freemode_01","mp_f_freemode_01","mp_m_fibsec_01","ig_stevehains","ig_andreas","s_m_m_fiboffice_01","s_m_m_ciasec_01","ig_karen_daniels","S_M_Y_Ranger_01","S_F_Y_Ranger_01", "s_m_y_blackops_01", "s_m_m_pilot_02"}
local arrSkinHashes = {}
	for i=1,#arrSkinGeneralValues
		do
		arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
	end

local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
local props = { "Head", "Glasses", "Ear Acessories", "Watch"}

local MENU_OPEN_KEY = 38

local closest_shop = nil

-- Events --
RegisterNetEvent("policestation2:setciv")
AddEventHandler("policestation2:setciv", function(character, playerWeapons)
	Citizen.CreateThread(function()
		local model
		if not character.hash then -- does not have any customizations saved
			model = -408329255 -- some random black dude with no shirt on, lawl
		else
			model = character.hash
		end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
		-- give model customizations if available
		if character.hash then
			for key, value in pairs(character["components"]) do
				--if tonumber(key) ~= 0 or tonumber(key) ~= 1 or tonumber(key) ~= 2 then -- emit barber shop features
					SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
				--end
			end
			for key, value in pairs(character["props"]) do
				SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
			end
		end
		-- add any tattoos if they have any --
		if character.tattoos then
			--print("applying tattoos!")
			for i = 1, #character.tattoos do
				ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
			end
		else
			--print("no tattoos!!!")
		end
		-- add any barber shop customizations if any --
		if character.head_customizations then
			--print("barber shop customizations existed!")
			local head = character.head_customizations
			local ped = GetPlayerPed(-1)
			SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
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
						SetPedComponentVariation(ped, 2, head.other[i][2], GetNumberOfPedTextureVariations(ped,2, 0), 2)
						SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
					end
				end
			end
		end
		-- give weapons
		if playerWeapons then
			for i = 1, #playerWeapons do
				GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
				if playerWeapons[i].components then
			    if #playerWeapons[i].components > 0 then
			      for x = 1, #playerWeapons[i].components do
			        GiveWeaponComponentToPed(GetPlayerPed(-1), playerWeapons[i].hash, GetHashKey(playerWeapons[i].components[x]))
			      end
			    end
			  end
			  if playerWeapons[i].tint then
			    SetPedWeaponTintIndex(GetPlayerPed(-1), playerWeapons[i].hash, playerWeapons[i].tint)
			  end
			end
		end
    end)
end)

RegisterNetEvent("policestation2:isWhitelisted")
AddEventHandler("policestation2:isWhitelisted", function()
	--[[
	local playerhash = GetEntityModel(GetPlayerPed(-1))
	for i=1, #arrSkinHashes do
		if arrSkinHashes[i] == playerhash then
			position = i
		end
	end
	--]]
	CreateUniformMenu(mainMenu)
	mainMenu:Visible(true)
end)

RegisterNetEvent("policestation2:showArmoury")
AddEventHandler("policestation2:showArmoury", function()
	CreateArmoryMenu(mainMenu)
	mainMenu:Visible(true)
end)

RegisterNetEvent("policestation2:giveDefaultLoadout")
AddEventHandler("policestation2:giveDefaultLoadout", function()
	local ped = GetPlayerPed(-1)
	RemoveAllPedWeapons(ped, true)
	--local playerWeapons = { "WEAPON_BZGAS", "WEAPON_FLARE" , "WEAPON_CARBINERIFLE" ,"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
	local playerWeapons = { "WEAPON_BZGAS", "WEAPON_FLARE" ,"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
	local name, hash
	for i = 1, #playerWeapons do
		name = playerWeapons[i]
		hash = GetHashKey(name)
		GiveWeaponToPed(ped, hash, 1000, 0, false) -- get hash given name of weapon
	end
	SetEntityHealth(ped, GetEntityMaxHealth(ped))
	SetPedArmour(ped, 100)
	GiveWeaponComponentToPed(ped, 1593441988 , 0x359B7AAE)
	GiveWeaponComponentToPed(ped, 2210333304, 0x7BC4CDDC)
	GiveWeaponComponentToPed(ped, 2210333304 , 0xC164F53)
end)

RegisterNetEvent("policestation2:setCharacter")
AddEventHandler("policestation2:setCharacter", function(character)
	local ped = GetPlayerPed(-1)
	if character then
		for key, value in pairs(character["components"]) do
			SetPedComponentVariation(ped, tonumber(key), value, character["componentstexture"][key], 0)
		end
		for key, value in pairs(character["props"]) do
			SetPedPropIndex(ped, tonumber(key), value, character["propstexture"][key], true)
		end
		TriggerEvent("policestation2:giveDefaultLoadout")
	end
end)

-- Menu --
--// Main Menu
--//	Skin Selection (array)
--//  Components (submenu)
--//  Props (submenu)
--//  Load Default Uniform
--//  Save Default Uniform
--//  Off Duty

-----------------
-- Set up menu --
-----------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("SASP", "~b~San Andreas State Police", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateUniformMenu(menu)
	local ped = GetPlayerPed(-1)
	menu:Clear()
	-- Model --
	local listitem = UIMenuListItem.New("Uniforms", arrSkinGeneralCaptions, 1)
	menu:AddItem(listitem)
	listitem.OnListSelected = function(sender, item, index)
		if item == listitem then
			--print("Selected ~b~" .. item:IndexToItem(index) .. "~w~...")
			local position = index
			local ply = GetPlayerPed(-1)
			if arrSkinGeneralValues[position] == "mp_m_freemode_01" then
				if not IsPedModel(ply, GetHashKey("mp_m_freemode_01")) then
					local model = GetHashKey("mp_m_freemode_01")
	  			RequestModel(model)
	  			while not HasModelLoaded(model) do -- Wait for model to load
	  				Wait(100)
	  			end
	  			SetPlayerModel(PlayerId(), model)
	  			SetModelAsNoLongerNeeded(model)
					ply = GetPlayerPed(-1)
				end
				--SetPedComponentVariation(ply, 2, 19, 1, 0)
				SetPedComponentVariation(ply, 4, 35, 0, 0)
				--SetPedComponentVariation(ply, 6, 24, 0, 0)
				SetPedComponentVariation(ply, 8, 58, 0, 0)
				SetPedComponentVariation(ply, 11, 55, 0, 0)
			elseif arrSkinGeneralValues[position] == "mp_f_freemode_01" then
				if not IsPedModel(ply, GetHashKey("mp_f_freemode_01")) then
					local model = GetHashKey("mp_f_freemode_01")
	  			RequestModel(model)
	  			while not HasModelLoaded(model) do -- Wait for model to load
	  				Wait(100)
	  			end
	  			SetPlayerModel(PlayerId(), model)
	  			SetModelAsNoLongerNeeded(model)
					ply = GetPlayerPed(-1)
				end
				--SetPedComponentVariation(ply, 0, 33, 0, 0)
				--SetPedComponentVariation(ply, 2, 4, 4, 0)
				SetPedComponentVariation(ply, 3, 14, 0, 0)
				SetPedComponentVariation(ply, 4, 34, 0, 0)
				--SetPedComponentVariation(ply, 6, 27, 0, 0)
				SetPedComponentVariation(ply, 8, 35, 0, 0)
				SetPedComponentVariation(ply, 11, 48, 0, 0)
			else
				local modelhashed = GetHashKey(arrSkinGeneralValues[position])
				RequestModel(modelhashed)
				while not HasModelLoaded(modelhashed) do
					Wait(100)
				end
				SetPlayerModel(PlayerId(), modelhashed)
				--SetPedDefaultComponentVariation(PlayerId());
				--drawTxt(ply,0,1,0.5,0.8,0.6,255,255,255,255)
				SetPedDefaultComponentVariation(ply)
				SetModelAsNoLongerNeeded(modelhashed)
			end
			TriggerEvent("policestation2:giveDefaultLoadout")
			TriggerServerEvent("policestation2:onduty")
			TriggerEvent("interaction:setPlayersJob", "police") -- set interaction menu javascript job variable to "police"
			TriggerEvent("ptt:isEmergency", true)
		end
	end
	-- Components --
	local submenu = _menuPool:AddSubMenu(menu, "Components", "Modify components", true --[[KEEP POSITION]])
	for i = 1, #components do
		local selectedComponent = GetPedDrawableVariation(ped, i - 1)
		local selectedTexture = GetPedTextureVariation(ped, i - 1)
		--local maxComponent = GetNumberOfPedDrawableVariations(ped, i - 1)
		--local maxTexture = GetNumberOfPedTextureVariations(ped, i - 1, selectedComponent)
		local arr = {}
		for j = 0, MAX_COMPONENT + 1 do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(components[i], arr, selectedComponent)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedComponent = index - 1
				SetPedComponentVariation(ped, i - 1, selectedComponent, 0, 0)
				selectedTexture = 0
			end
		end
		submenu:AddItem(listitem)
		--if maxTexture > 1 then
			arr = {}
			for j = 0, MAX_COMPONENT_TEXTURE + 1 do arr[j] = j - 1 end
			local listitem = UIMenuListItem.New(components[i] .. " Texture", arr, selectedTexture)
			listitem.OnListChanged = function(sender, item, index)
				if item == listitem then
					selectedTexture = index - 1
					SetPedComponentVariation(ped, i - 1, selectedComponent, selectedTexture, 0)
				end
			end
			submenu:AddItem(listitem)
		--end
	end
	-- Props --
	local submenu = _menuPool:AddSubMenu(menu, "Props", "Modify props", true --[[KEEP POSITION]])
	for i = 1, 3 do
		local selectedProp = GetPedPropIndex(ped, i - 1)
		local selectedPropTexture = GetPedPropTextureIndex(ped, i - 1)
		--local maxProp = GetNumberOfPedPropDrawableVariations(ped, i - 1)
		--local maxPropTexture = GetNumberOfPedPropTextureVariations(ped, i - 1, selectedProp)
		local arr = {}
		for j = 0, MAX_PROP + 1 do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(props[i], arr, selectedProp)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedProp = index - 1
				if selectedProp > -1 then
					SetPedPropIndex(ped, i - 1, selectedProp, 0, true)
				else
					ClearPedProp(ped, i - 1)
				end
			end
		end
		submenu:AddItem(listitem)
		-- add texture variation --
		--if maxPropTexture > 1 and selectedProp > -1 then
			arr = {}
			for j = 0, MAX_PROP_TEXTURE do arr[j] = j - 1 end
			local listitem = UIMenuListItem.New(props[i] .. " Texture", arr, selectedPropTexture)
			listitem.OnListChanged = function(sender, item, index)
				if item == listitem then
					--print("Selected ~b~" .. index .. "~w~...")
					selectedPropTexture = index - 1
					SetPedPropIndex(ped, i - 1, selectedProp, selectedPropTexture, true)
				end
			end
			submenu:AddItem(listitem)
		--end
	end
	local item = NativeUI.CreateItem("Clear Props", "Reset props.")
	item.Activated = function(parentmenu, selected)
		ClearPedProp(ped, 0)
		ClearPedProp(ped, 1)
		ClearPedProp(ped, 2)
	end
	submenu:AddItem(item)
	-- Load Default Uniform --
	local item = NativeUI.CreateItem("Load Stored", "Load your stored uniform")
	item.Activated = function(parentmenu, selected)
		TriggerServerEvent("policestation2:loadDefaultUniform")
		TriggerEvent("interaction:setPlayersJob", "police") -- set interaction menu javascript job variable to "police"
		TriggerEvent("ptt:isEmergency", true)
	end
	menu:AddItem(item)
	-- Save Default Uniform --
	local item = NativeUI.CreateItem("Save Uniform", "Save as your stored uniform.")
	item.Activated = function(parentmenu, selected)
		local character = {
				["components"] = {},
				["componentstexture"] = {},
				["props"] = {},
				["propstexture"] = {}
			}
			local ply = GetPlayerPed(-1)
			--local debugstr = "| Props: "
			for i=0,2 -- instead of 3?
				do
				character.props[i] = GetPedPropIndex(ply, i)
				character.propstexture[i] = GetPedPropTextureIndex(ply, i)
				--debugstr = debugstr .. character.props[i] .. "->" .. character.propstexture[i] .. ","
			end
			--debugstr = debugstr .. "| Components: "
			for i=0,11
				do
				character.components[i] = GetPedDrawableVariation(ply, i)
				character.componentstexture[i] = GetPedTextureVariation(ply, i)
				--debugstr = debugstr .. character.components[i] .. "->" .. character.componentstexture[i] .. ","
			end
			--print(debugstr)
			TriggerServerEvent("policestation2:saveasdefault", character)
	end
	menu:AddItem(item)
	-- Clock Out --
	local item = NativeUI.CreateItem("Clock Out", "Sign off duty.")
	item.Activated = function(parentmenu, selected)
		TriggerServerEvent("policestation2:offduty")
		TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
		TriggerEvent("ptt:isEmergency", false)
	end
	menu:AddItem(item)
end

function CreateArmoryMenu(menu)
	local ped = GetPlayerPed(-1)
	menu:Clear()

	local item = NativeUI.CreateItem("Armor", "Get a new armored vest.")
	item.Activated = function(parentmenu, selected)
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		SetPedArmour(ped, 100)
		exports.globals:notify("Armor and Health restored")
	end
	menu:AddItem(item)

	local item = NativeUI.CreateItem("Default Load Out", "Get the default load out.")
	item.Activated = function(parentmenu, selected)
		TriggerEvent("policestation2:giveDefaultLoadout")
		exports.globals:notify("Default Load Out")
	end
	menu:AddItem(item)

	local item = NativeUI.CreateItem("Marksman Load Out", "Get the marksman load out.")
	item.Activated = function(parentmenu, selected)
		RemoveAllPedWeapons(ped, true)
		local playerWeapons = { "WEAPON_FLARE" , "WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_SNIPERRIFLE"}
		local name, hash
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			hash = GetHashKey(name)
		  GiveWeaponToPed(ped, hash, 1000, 0, false) -- get hash given name of weapon
		end
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		SetPedArmour(ped, 100)
		GiveWeaponComponentToPed(ped, 1593441988 , 0x359B7AAE)
		GiveWeaponComponentToPed(ped, 100416529 , 0xBC54DA77)
		exports.globals:notify("Marksman Load Out")
	end
	menu:AddItem(item)

	local item = NativeUI.CreateItem("Undercover Load Out", "Get the undercover load out.")
	item.Activated = function(parentmenu, selected)
		RemoveAllPedWeapons(ped, true)
		local playerWeapons = { "WEAPON_COMBATPISTOL", "WEAPON_STUNGUN" }
		local name, hash
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			hash = GetHashKey(name)
		  GiveWeaponToPed(ped, hash, 1000, 0, false) -- get hash given name of weapon
		end
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		SetPedArmour(ped, 100)
		exports.globals:notify("Undercover Load Out")
	end
	menu:AddItem(item)

	local item = NativeUI.CreateItem("Carbine Rifle", "Get a carbine rifle.")
	item.Activated = function(parentmenu, selected)
		local playerWeapons = { "WEAPON_CARBINERIFLE" }
		local name, hash
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			hash = GetHashKey(name)
		  GiveWeaponToPed(ped, hash, 1000, 0, false) -- get hash given name of weapon
		end
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		-- give flashlights (not sure which is which atm):
		GiveWeaponComponentToPed(ped, 2210333304, 0x7BC4CDDC)
		GiveWeaponComponentToPed(ped, 2210333304, 0xC164F53)
	end
	menu:AddItem(item)

	local item = NativeUI.CreateItem("Pump Shotgun", "Get a pump shotgun.")
	item.Activated = function(parentmenu, selected)
		local playerWeapons = { "WEAPON_PUMPSHOTGUN" }
		local name, hash
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			hash = GetHashKey(name)
			GiveWeaponToPed(ped, hash, 1000, 0, false) -- get hash given name of weapon
		end
		SetEntityHealth(ped, GetEntityMaxHealth(ped))
		-- give flashlights (not sure which is which atm):
		GiveWeaponComponentToPed(ped, 2210333304, 0x7BC4CDDC)
		GiveWeaponComponentToPed(ped, 2210333304, 0xC164F53)
	end
	menu:AddItem(item)
end

_menuPool:RefreshIndex()

-- Functions --
function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

-- Script Loop --
Citizen.CreateThread(function()
	while true do
		Wait(0)
		-- vars --
		local me = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(me, false)

    -- Process Menu --
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()

		for i = 1, #policeLockerRooms do
			if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,policeLockerRooms[i].x,policeLockerRooms[i].y,policeLockerRooms[i].z)  <  50 then
				DrawMarker(27, policeLockerRooms[i].x, policeLockerRooms[i].y, policeLockerRooms[i].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
				DrawMarker(27, policeArmourys[i].x, policeArmourys[i].y, policeArmourys[i].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 90, 0, 0, 2, 0, 0, 0, 0)
				if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,policeLockerRooms[i].x,policeLockerRooms[i].y,policeLockerRooms[i].z)  <  2 then
						drawTxt("Press [~y~E~w~] to access the locker room",7,1,0.5,0.8,0.5,255,255,255,255)
						if IsControlJustPressed(1, MENU_OPEN_KEY) then
								closest_shop = policeLockerRooms[i] --// set shop player is at
								--mainMenu:Visible(not mainMenu:Visible())
								if not mainMenu:Visible() then

									-- TODO: first check white list status before opening menu --
									TriggerServerEvent("policestation2:checkWhitelist", "policestation2:isWhitelisted")

									--CreateUniformMenu(mainMenu)
									--mainMenu:Visible(true)
								else
									mainMenu:Visible(false)
									mainMenu:Clear()
								end
						end
				elseif Vdist(playerCoords.x,playerCoords.y,playerCoords.z,policeArmourys[i].x,policeArmourys[i].y,policeArmourys[i].z)  <  2 then
					drawTxt("Press [~y~E~w~] to access the police armory",7,1,0.5,0.8,0.5,255,255,255,255)
					if IsControlJustPressed(1, MENU_OPEN_KEY) then
							closest_shop = policeArmourys[i] --// set shop player is at
							--mainMenu:Visible(not mainMenu:Visible())
							if not mainMenu:Visible() then

								-- TODO: first check white list status before opening menu --
								TriggerServerEvent("policestation2:checkWhitelist", "policestation2:showArmoury")

								--CreateUniformMenu(mainMenu)
								--mainMenu:Visible(true)
							else
								mainMenu:Visible(false)
								mainMenu:Clear()
							end
					end
				else
						if closest_shop then
								closest_shop = nil
								if mainMenu:Visible() then
										mainMenu:Visible(false)
										mainMenu:Clear()
								end
						end
				end
			end
		end

	end
end)

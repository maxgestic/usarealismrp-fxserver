-- Global Variables --
local EMSLockerRooms = {
{x = 319.27481079102, y = -559.21624755859, z = 28.743782043457}, -- pillbox medical
{x = -447.24325561523, y= -329.1171875, z = 33.601892089844}, -- mt. zonoah
{x = 1196.320435703, y = -1465.4461669922, z = 34.859535217285}, -- LS fire station 9
{x = 207.106, y = -1641.45, z = 28.5},
{x = 373.269, y = -1441.48, z = 28.5},
{x=-366.269, y = 6102.27, z = 35.6397}, -- paleto
--{x=1692.13, y=3586.27, z=34.7209} -- sandy
{x = 1701.4, y = 3604.1, z = 35.9} -- sandy (interior / ymap)
}

local arrSkinGeneralCaptions = {"MP Male", "MP Female", "Fireman", "Paramedic - Male", "Paramedic - Female", "Doctor"}
local arrSkinGeneralValues = {"mp_m_freemode_01", "mp_f_freemode_01", "s_m_y_fireman_01","s_m_m_paramedic_01","s_f_y_scrubs_01", "s_m_m_doctor_01"}
local arrSkinHashes = {}
for i=1,#arrSkinGeneralValues
	do
	arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
end

local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
local props = { "Head", "Glasses", "Ear Acessories", "Watch"}

local MAX_COMPONENT = 200
local MAX_COMPONENT_TEXTURE = 100

local MAX_PROP = 200
local MAX_PROP_TEXTURE = 100

local MENU_OPEN_KEY = 38

local closest_shop = nil

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

function IsNearEMSLocker()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(EMSLockerRooms) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= 2) then
			return true
		end
	end
end

RegisterNetEvent("emsstation2:setciv")
AddEventHandler("emsstation2:setciv", function(character, playerWeapons)
	Citizen.CreateThread(function()
		local model
		if not character.hash then -- does not have any customizations saved
			model = -408329255 -- some random black dude with no shirt on, lawl
		else
			model = character.hash
		end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            Citizen.Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
		-- give model customizations if available
		if character.hash then
			for key, value in pairs(character["components"]) do
				SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
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
						SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
						SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
					end
				end
			end
		else
			print("no barber shop customizations!")
		end
		-- give weapons
		if playerWeapons then
			for i = 1, #playerWeapons do
				print("playerWeapons[i].hash = " .. playerWeapons[i].hash)
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

RegisterNetEvent("emsstation2:isWhitelisted")
AddEventHandler("emsstation2:isWhitelisted", function()
	--[[
	local playerhash = GetEntityModel(GetPlayerPed(-1))
	for i=1,#arrSkinHashes
	do
		if(arrSkinHashes[i] == playerhash) then
			position = i
		end
	end
	menu = 1
	--]]
	CreateMenu(mainMenu)
	mainMenu:Visible(true)
end)

RegisterNetEvent("emsstation2:setCharacter")
AddEventHandler("emsstation2:setCharacter", function(character)
	if character then
		for key, value in pairs(character["components"]) do
			SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
		end
		for key, value in pairs(character["props"]) do
			SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
		end
		TriggerEvent("emsstation2:giveDefaultLoadout")
	end
end)

RegisterNetEvent("emsstation2:giveDefaultLoadout")
AddEventHandler("emsstation2:giveDefaultLoadout", function()
	Citizen.Trace("true")
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	local playerWeapons = { "WEAPON_FLARE" , "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
	local name, hash
	for i = 1, #playerWeapons do
		name = playerWeapons[i]
		hash = GetHashKey(name)
		 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
	end
	SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
end)

-----------------
-- Set up menu --
-----------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("EMS", "~b~San Andreas Medical Services", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateMenu(menu)
	local ped = GetPlayerPed(-1)
	menu:Clear()
	-- Model --
	local listitem = UIMenuListItem.New("Uniforms", arrSkinGeneralCaptions, 1)
	menu:AddItem(listitem)
	listitem.OnListSelected = function(sender, item, index)
		if item == listitem then
			print("Selected ~b~" .. item:IndexToItem(index) .. "~w~...")
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
				SetPedComponentVariation(ply, 1, 121, 0, 0)
				SetPedComponentVariation(ply, 3, 85, 0, 0)
				SetPedComponentVariation(ply, 4, 25, 3, 0)
				SetPedComponentVariation(ply, 6, 61, 0, 0)
				SetPedComponentVariation(ply, 7, 126, 0, 0)
				SetPedComponentVariation(ply, 8, 129, 0, 0)
				SetPedComponentVariation(ply, 11, 250, 1, 0)
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
				SetPedComponentVariation(ply, 1, 121, 0, 0)
				SetPedComponentVariation(ply, 3, 96, 0, 0)
				SetPedComponentVariation(ply, 4, 37, 0, 0)
				SetPedComponentVariation(ply, 6, 74, 1, 0)
				SetPedComponentVariation(ply, 7, 96, 0, 0)
				SetPedComponentVariation(ply, 8, 159, 0, 0)
				SetPedComponentVariation(ply, 11, 250, 1, 0)
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
			TriggerEvent("emsstation2:giveDefaultLoadout")
			TriggerServerEvent("emsstation2:onduty")
			TriggerEvent("interaction:setPlayersJob", "ems") -- set interaction menu javascript job variable to "ems"
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
		for j = 0, MAX_COMPONENT do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(components[i], arr, selectedComponent)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedComponent = index
				SetPedComponentVariation(ped, i - 1, index, 0, 0)
				selectedTexture = 0
			end
		end
		submenu:AddItem(listitem)
		--if maxTexture > 1 then
				arr = {}
				for j = 0, MAX_COMPONENT_TEXTURE do arr[j] = j - 1 end
				local listitem = UIMenuListItem.New(components[i] .. " Texture", arr, selectedTexture)
				listitem.OnListChanged = function(sender, item, index)
					if item == listitem then
						selectedTexture = index
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
			for j = 0, MAX_PROP do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(props[i], arr, selectedProp)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedProp = index
				if selectedProp > -1 then
					SetPedPropIndex(ped, i - 1, selectedProp, 0, true)
				else
					ClearPedProp(ped, i - 1)
				end
			end
		end
		submenu:AddItem(listitem)
		--if maxPropTexture > 1 and selectedProp > -1 then
			arr = {}
			for j = 0, MAX_PROP_TEXTURE do arr[j] = j - 1 end
			local listitem = UIMenuListItem.New(props[i] .. " Texture", arr, selectedPropTexture)
			listitem.OnListChanged = function(sender, item, index)
				if item == listitem then
					--print("Selected ~b~" .. index .. "~w~...")
					selectedPropTexture = index
					SetPedPropIndex(ped, i - 1, selectedProp, selectedPropTexture, true)
				end
			end
			submenu:AddItem(listitem)
		--end
	end
	-- clear props button --
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
		TriggerServerEvent("emsstation2:loadDefaultUniform", character)
		TriggerEvent("interaction:setPlayersJob", "ems") -- set interaction menu javascript job variable to "ems"
		TriggerEvent("ptt:isEmergency", true)
	end
	menu:AddItem(item)
	-- Save Default Uniform --
	local item = NativeUI.CreateItem("Save Uniform", "Save your current uniform")
	item.Activated = function(parentmenu, selected)
		local character = {
			["components"] = {},
			["componentstexture"] = {},
			["props"] = {},
			["propstexture"] = {}
		}
		local ply = GetPlayerPed(-1)
		character.hash = GetEntityModel(GetPlayerPed(-1))
		--local debugstr = "Player Hash: " .. character.hash .. "| Props: "
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
		--Citizen.Trace(debugstr)
		TriggerServerEvent("emsstation2:saveasdefault", character)
	end
	menu:AddItem(item)
	local item = NativeUI.CreateItem("Clock Out", "Sign off duty.")
	item.Activated = function(parentmenu, selected)
		TriggerServerEvent("emsstation2:offduty")
		TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
		TriggerEvent("ptt:isEmergency", false)
		parentmenu:Visible(false)
	end
	menu:AddItem(item)
end

--[[
RegisterNetEvent("emsstation2:ShowMainMenu")
AddEventHandler("emsstation2:ShowMainMenu", function()

	TriggerEvent("GUI2:Title", "EMS Menu")

	TriggerEvent("GUI2:StringArray", "Skin:", arrSkinGeneralCaptions, position, function(cb)
		Citizen.CreateThread(function()
			position = cb
			local ply = GetPlayerPed(-1)
			if arrSkinGeneralValues[position] == "mp_m_freemode_01" then
				SetPedComponentVariation(ply, 1, 121, 0, 0)
				SetPedComponentVariation(ply, 3, 85, 0, 0)
				SetPedComponentVariation(ply, 4, 25, 3, 0)
				SetPedComponentVariation(ply, 6, 61, 0, 0)
				SetPedComponentVariation(ply, 7, 126, 0, 0)
				SetPedComponentVariation(ply, 8, 129, 0, 0)
				SetPedComponentVariation(ply, 11, 250, 1, 0)
			elseif arrSkinGeneralValues[position] == "mp_f_freemode_01" then
				SetPedComponentVariation(ply, 1, 121, 0, 0)
				SetPedComponentVariation(ply, 3, 96, 0, 0)
				SetPedComponentVariation(ply, 4, 37, 0, 0)
				SetPedComponentVariation(ply, 6, 74, 1, 0)
				SetPedComponentVariation(ply, 7, 96, 0, 0)
				SetPedComponentVariation(ply, 8, 159, 0, 0)
				SetPedComponentVariation(ply, 11, 250, 1, 0)
			else
				local modelhashed = GetHashKey(arrSkinGeneralValues[position])
				RequestModel(modelhashed)
				while not HasModelLoaded(modelhashed) do
					Citizen.Wait(100)
				end
				SetPlayerModel(PlayerId(), modelhashed)
				--SetPedDefaultComponentVariation(PlayerId());
				--drawTxt(ply,0,1,0.5,0.8,0.6,255,255,255,255)
				SetPedDefaultComponentVariation(ply)
				SetModelAsNoLongerNeeded(modelhashed)
			end
			TriggerEvent("emsstation2:giveDefaultLoadout")
			TriggerServerEvent("emsstation2:onduty")
			TriggerEvent("interaction:setPlayersJob", "ems") -- set interaction menu javascript job variable to "ems"
			TriggerEvent("ptt:isEmergency", true)
		end)
	end)

	TriggerEvent("GUI2:Option", "Primary Components", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 2
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Secondary Components", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 3
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Props", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 4
		else

		end
		end)

		TriggerEvent("GUI2:Option", "Load Default", function(cb)
			if(cb) then
				Citizen.Trace("true")
				TriggerServerEvent("emsstation2:loadDefaultUniform", character)
				TriggerEvent("interaction:setPlayersJob", "ems") -- set interaction menu javascript job variable to "police"
				TriggerEvent("ptt:isEmergency", true)
				--menu = 4
			end
		end)

		TriggerEvent("GUI2:Option", "Save as default", function(cb)
			if(cb) then
				local character = {
					["components"] = {},
					["componentstexture"] = {},
					["props"] = {},
					["propstexture"] = {}
				}
				local ply = GetPlayerPed(-1)
				character.hash = GetEntityModel(GetPlayerPed(-1))
				local debugstr = "Player Hash: " .. character.hash .. "| Props: "
				for i=0,2 -- instead of 3?
					do
					character.props[i] = GetPedPropIndex(ply, i)
					character.propstexture[i] = GetPedPropTextureIndex(ply, i)
					debugstr = debugstr .. character.props[i] .. "->" .. character.propstexture[i] .. ","
				end
				debugstr = debugstr .. "| Components: "
				for i=0,11
					do
					character.components[i] = GetPedDrawableVariation(ply, i)
					character.componentstexture[i] = GetPedTextureVariation(ply, i)
					debugstr = debugstr .. character.components[i] .. "->" .. character.componentstexture[i] .. ","
				end
				Citizen.Trace(debugstr)
				TriggerServerEvent("emsstation2:saveasdefault", character)
				--Citizen.Trace("calling server function: giveMeMyWeaponsPlease...")
				--TriggerServerEvent("mini:giveMeMyWeaponsPlease")
			end
		end)

	TriggerEvent("GUI2:Option", "Off-Duty", function(cb)
		if(cb) then
			Citizen.Trace("true")
			TriggerServerEvent("emsstation2:offduty")
			TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
			TriggerEvent("ptt:isEmergency", false)
			--menu = 4
		else
		end
		end)

	TriggerEvent("GUI2:Update")
end)

RegisterNetEvent("emsstation2:ShowPropsMenu")
AddEventHandler("emsstation2:ShowPropsMenu", function()
	TriggerEvent("GUI2:Title", "Props")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 1
		else

		end
		end)

	local props = { "Head", "Glasses", "Ear Acessories", "Watch"};
	local ply = GetPlayerPed(-1)
	for i=0,3
		do
		local selectedProp = GetPedPropIndex(ply, i)
		local selectedPropTexture = GetPedPropTextureIndex(ply, i)
		local maxProp = GetNumberOfPedPropDrawableVariations(ply, i)
		local maxPropTexture = GetNumberOfPedPropTextureVariations(ply, i, selectedProp)
		--local maxPropTexture = GetNumberOfPedPropTextureVariations(ply, i
		if(maxProp > 0) then
		TriggerEvent("GUI2:Int", props[i+1] .. " (" .. maxProp .. ")", selectedProp, -1, maxProp - 1, function(cb)
				selectedProp = cb
				if(selectedProp > -1) then
					SetPedPropIndex(ply, i, selectedProp, 0, true)
				else
					ClearPedProp(ply, i)
				end
				--selectedTexture = 0
				end)
		end
		if (maxPropTexture > 1 and selectedProp > -1) then
			TriggerEvent("GUI2:Int", props[i+1] .. " Texture (" .. maxPropTexture .. ")", selectedPropTexture, 0, maxPropTexture - 1, function(cb)
				selectedPropTexture = cb
					SetPedPropIndex(ply, i, selectedProp, selectedPropTexture, true)
				--selectedTexture = 0
				end)
		end
	end


	TriggerEvent("GUI2:Update")

end)

RegisterNetEvent("emsstation2:ShowComponentsMenu1")
AddEventHandler("emsstation2:ShowComponentsMenu1", function()
	local components = {"Face","Head","Hair","Torso","Legs","Hands","Feet","Eyes","Acessories","Tasks","Textures","Torso2"}
	TriggerEvent("GUI2:Title", "Components 1")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 1
		else

		end
		end)
	local ply = GetPlayerPed(-1)
	for i=0,5 do
		if i == 0 or i == 2 or i == 5 then -- ignore head and hair options
			-- do nothing
		else
			local selectedComponent = GetPedDrawableVariation(ply, i)
			local selectedTexture = GetPedTextureVariation(ply, i)
			local maxComponent = GetNumberOfPedDrawableVariations(ply, i)
			local maxTexture = GetNumberOfPedTextureVariations(ply, i, selectedComponent)
			if(maxComponent > 1) then
				TriggerEvent("GUI2:Int", components[i+1] .. " (" .. maxComponent .. ")", selectedComponent, 0, maxComponent - 1, function(cb)
					selectedComponent = cb
					SetPedComponentVariation(ply, i, selectedComponent, 0, 0)
					selectedTexture = 0
					end)
			end
			if(maxTexture > 1) then
				TriggerEvent("GUI2:Int", components[i+1] .. " Texture (" .. maxTexture .. ")", selectedTexture, 0, maxTexture - 1, function(cb)
					selectedTexture = cb
					SetPedComponentVariation(ply, i, selectedComponent, selectedTexture, 0)
					end)
			end
		end
	end
	TriggerEvent("GUI2:Update")
end)

RegisterNetEvent("emsstation2:ShowComponentsMenu2")
AddEventHandler("emsstation2:ShowComponentsMenu2", function()
	local components = {"Face","Head","Hair","Torso","Legs","Hands","Feet","Eyes","Acessories","Tasks","Textures","Torso2"}
	TriggerEvent("GUI2:Title", "Components 2")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu = 1
		else

		end
		end)
	local ply = GetPlayerPed(-1)
	for i=6,11
		do
		local selectedComponent = GetPedDrawableVariation(ply, i)
		local selectedTexture = GetPedTextureVariation(ply, i)
		local maxComponent = GetNumberOfPedDrawableVariations(ply, i)
		local maxTexture = GetNumberOfPedTextureVariations(ply, i, selectedComponent)
		if(maxComponent > 1) then
			TriggerEvent("GUI2:Int", components[i+1] .. " (" .. maxComponent .. ")", selectedComponent, 0, maxComponent - 1, function(cb)
				selectedComponent = cb
				SetPedComponentVariation(ply, i, selectedComponent, 0, 0)
				selectedTexture = 0
				end)
		end
		if(maxTexture > 1) then
			TriggerEvent("GUI2:Int", components[i+1] .. " Texture (" .. maxTexture .. ")", selectedTexture, 0, maxTexture - 1, function(cb)
				selectedTexture = cb
				SetPedComponentVariation(ply, i, selectedComponent, selectedTexture, 0)
				end)
		end
	end
	TriggerEvent("GUI2:Update")
end)
--]]

Citizen.CreateThread(function()

	while true do
		-- vars --
		local me = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(me, false)

    -- Process Menu --
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()

		for i = 1, #EMSLockerRooms do
			if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,EMSLockerRooms[i].x,EMSLockerRooms[i].y,EMSLockerRooms[i].z)  <  50 then
				DrawMarker(27, EMSLockerRooms[i].x, EMSLockerRooms[i].y, EMSLockerRooms[i].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
				if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,EMSLockerRooms[i].x,EMSLockerRooms[i].y,EMSLockerRooms[i].z)  <  2 then
						drawTxt("Press [~y~E~w~] to access the locker room",7,1,0.5,0.8,0.5,255,255,255,255)
						if IsControlJustPressed(1, MENU_OPEN_KEY) then
								closest_shop = EMSLockerRooms[i] --// set shop player is at
								--mainMenu:Visible(not mainMenu:Visible())
								if not mainMenu:Visible() then

									-- TODO: first check white list status before opening menu --
									TriggerServerEvent("emsstation2:checkWhitelist", "emsstation2:isWhitelisted")

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
		Wait(0)
	end

end)

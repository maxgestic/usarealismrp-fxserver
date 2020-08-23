-- Global Variables --
local EMSLockerRooms = {
{x = 319.27481079102, y = -559.21624755859, z = 28.743782043457}, -- pillbox medical
{x = -447.24325561523, y= -329.1171875, z = 33.601892089844}, -- mt. zonoah
{x = 1196.320435703, y = -1465.4461669922, z = 34.859535217285}, -- LS fire station 9
{x = 207.106, y = -1641.45, z = 28.5},
{x = 373.269, y = -1441.48, z = 28.5},
{x=-366.269, y = 6102.27, z = 35.6397}, -- paleto
--{x=1692.13, y=3586.27, z=34.7209} -- sandy
{x = 1701.4, y = 3604.1, z = 35.9}, -- sandy (interior / ymap)
{x = 338.24346923828,y = -586.91796875, z = 74.165657043457}, -- pillbox helipad
{x = 301.4, y = -599.26, z = 43.28} -- pillbox lockeroom
}

local emsoutfitamount = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local arrSkinGeneralCaptions = {"MP Male", "MP Female", "Fireman", "Paramedic - Male", "Paramedic - Female", "Doctor"}
local arrSkinGeneralValues = {"mp_m_freemode_01", "mp_f_freemode_01", "s_m_y_fireman_01","s_m_m_paramedic_01","s_f_y_scrubs_01", "s_m_m_doctor_01"}
local arrSkinHashes = {}
for i=1,#arrSkinGeneralValues do
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
			-- eye color --
			if head.eyeColor then
				SetPedEyeColor(ped, head.eyeColor)
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
		SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
	end
end)

-----------------
-- Set up menu --
-----------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("LSFD", "~b~Los Santos Fire Dept.", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateMenu(menu)
	local ped = GetPlayerPed(-1)
	menu:Clear()
	local submenu2 = _menuPool:AddSubMenu(menu, "Outfits", "Save and load outfits", true)
	local selectedSaveSlot = 1
    local selectedLoadSlot = 1
    local saveslot = UIMenuListItem.New("Slot to Save", emsoutfitamount)
    local saveconfirm = UIMenuItem.New('Confirm Save', 'Save outfit into the above number')
    saveconfirm:SetRightBadge(BadgeStyle.Tick)
    local loadslot = UIMenuListItem.New("Slot to Load", emsoutfitamount)
    local loadconfirm = UIMenuItem.New('Load Outfit', 'Load outfit from above number')
    loadconfirm:SetRightBadge(BadgeStyle.Clothes)
    submenu2.SubMenu:AddItem(loadslot)
    submenu2.SubMenu:AddItem(loadconfirm)
    submenu2.SubMenu:AddItem(saveslot)
    submenu2.SubMenu:AddItem(saveconfirm)

	submenu2.SubMenu.OnListChange = function(sender, item, index)
        if item == saveslot then
            selectedSaveSlot = item:IndexToItem(index)
        elseif item == loadslot then
            selectedLoadSlot = item:IndexToItem(index)
        end
    end
    submenu2.SubMenu.OnItemSelect = function(sender, item, index)
        if item == saveconfirm then
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
			TriggerServerEvent("emsstation2:saveOutfit", character, selectedSaveSlot)
        elseif item == loadconfirm then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            TriggerServerEvent('emsstation2:loadOutfit', selectedLoadSlot)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'zip-close', 1.0)
			Citizen.Wait(2000)
			DoScreenFadeIn(500)
            TriggerEvent("usa:playAnimation", 'clothingshirt', 'try_shirt_positive_d', -8, 1, -1, 48, 0, 0, 0, 0, 3)
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
		submenu.SubMenu:AddItem(listitem)
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
				submenu.SubMenu:AddItem(listitem)
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
		submenu.SubMenu:AddItem(listitem)
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
			submenu.SubMenu:AddItem(listitem)
		--end
	end
	-- clear props button --
	local item = NativeUI.CreateItem("Clear Props", "Reset props.")
	item.Activated = function(parentmenu, selected)
		ClearPedProp(ped, 0)
		ClearPedProp(ped, 1)
		ClearPedProp(ped, 2)
	end
	submenu.SubMenu:AddItem(item)
	local loadoutBtn = NativeUI.CreateItem("Get Loadout", "Retrieve flares and a fire extinguisher")
	loadoutBtn.Activated = function(parentmenu, selected)
		TriggerServerEvent("ems:getLoadout")
	end
	menu:AddItem(loadoutBtn)
	local item = NativeUI.CreateItem("Clock Out", "Sign off duty")
	item.Activated = function(parentmenu, selected)
		TriggerServerEvent("emsstation2:offduty")
		TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
		TriggerEvent("ptt:isEmergency", false)
		parentmenu:Visible(false)
	end
	menu:AddItem(item)
end

_menuPool:RefreshIndex()

-- Functions --
function DrawText3D(x, y, z, distance, text)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
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
end

Citizen.CreateThread(function()
	while true do
		local me = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(me, false)
	    _menuPool:MouseControlsEnabled(false)
	    _menuPool:ControlDisablingEnabled(false)
	    _menuPool:ProcessMenus()
		for i = 1, #EMSLockerRooms do
			DrawText3D(EMSLockerRooms[i].x, EMSLockerRooms[i].y, EMSLockerRooms[i].z, 5, '[E] - Locker Room')
			if Vdist(playerCoords, EMSLockerRooms[i].x, EMSLockerRooms[i].y, EMSLockerRooms[i].z)  <  2 then
				if IsControlJustPressed(1, MENU_OPEN_KEY) then
					closest_shop = EMSLockerRooms[i] --// set shop player is at
					if not mainMenu:Visible() then
						TriggerServerEvent("emsstation2:checkWhitelist")
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
		Wait(0)
	end
end)

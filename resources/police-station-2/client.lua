-- MENU CODE
RegisterNetEvent("GUI2:Title")
AddEventHandler("GUI2:Title", function(title)
	Menu.Title(title)
	end)

RegisterNetEvent("GUI2:Option")
AddEventHandler("GUI2:Option", function(option, cb)
	cb(Menu.Option(option))
	end)

RegisterNetEvent("GUI2:Bool")
AddEventHandler("GUI2:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
		end)
	end)

RegisterNetEvent("GUI2:Int")
AddEventHandler("GUI2:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
		end)
	end)

RegisterNetEvent("GUI2:StringArray")
AddEventHandler("GUI2:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
		end)
	end)

RegisterNetEvent("GUI2:Update")
AddEventHandler("GUI2:Update", function()
	Menu.updateSelection()
	end)
-- /MENU CODE

--Global Variables

local menu_loadout = 0
local menu_armoury = 0
local position = 1
local policeLockerRooms = {
{x=439.817 , y=-993.397 , z=29.689},
{x=451.255 , y=-992.41 , z=29.689},
 {x=1853.2, y=3687.74, z=33.267}, -- sandy
 --{x=-447.256 , y=6000.667 , z=30.686} -- paleto
 {x = -449.471, y = 6010.7, z = 30.85}
}
local policeArmourys = {
{x=451.564 , y=-980.095 , z=29.6896},
{x=1851.34 , y=3683.64 , z=33.2671}, -- sandy
--{x=-452.361 , y=6006.11 , z=30.8409} -- paleto
{x = -447.9, y = 6008.7, z = 30.85}
}

local arrSkinGeneralCaptions = {"LSPD Male","LSPD Female","Motor Unit","SWAT","Sheriff Male","Sheriff Female","Traffic Warden","Custom Male","Custom Female","FBI 1","FBI 2","FBI 3","FBI 4","Detective Male","Detective Female","Ranger Male", "Ranger Female", "Tactical", "Pilot"}
local arrSkinGeneralValues = {"s_m_y_cop_01","s_f_y_cop_01","S_M_Y_HwayCop_01","S_M_Y_SWAT_01","S_M_Y_Sheriff_01","S_F_Y_Sheriff_01","ig_trafficwarden","mp_m_freemode_01","mp_f_freemode_01","mp_m_fibsec_01","ig_stevehains","ig_andreas","s_m_m_fiboffice_01","s_m_m_ciasec_01","ig_karen_daniels","S_M_Y_Ranger_01","S_F_Y_Ranger_01", "s_m_y_blackops_01", "s_m_m_pilot_02"}
local arrSkinHashes = {}
	for i=1,#arrSkinGeneralValues
		do
		arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
	end

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

function IsNearStore()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(policeLockerRooms) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= 1.5) then
			return true
		end
	end
end

function IsNearArmoury()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for _, item in pairs(policeArmourys) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= 2) then
			return true
		end
	end
end

RegisterNetEvent("policestation2:setCharacter")
AddEventHandler("policestation2:setCharacter", function(character)
	if character then
		for key, value in pairs(character["components"]) do
			SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
		end
		for key, value in pairs(character["props"]) do
			SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
		end
		TriggerEvent("policestation2:giveDefaultLoadout")
	end
end)

RegisterNetEvent("policestation2:notify")
AddEventHandler("policestation2:notify", function(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("policestation2:giveDefaultLoadout")
AddEventHandler("policestation2:giveDefaultLoadout", function()
	Citizen.Trace("true")
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	--local playerWeapons = { "WEAPON_BZGAS", "WEAPON_FLARE" , "WEAPON_CARBINERIFLE" ,"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
	local playerWeapons = { "WEAPON_BZGAS", "WEAPON_FLARE" ,"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
	local name, hash
	for i = 1, #playerWeapons do
		name = playerWeapons[i]
		hash = GetHashKey(name)
		 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
	end
	SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
	SetPedArmour(GetPlayerPed(-1), 100)
	Citizen.Trace("giving flashlight components to cop...")
	GiveWeaponComponentToPed(GetPlayerPed(-1), 1593441988 , 0x359B7AAE)
	GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0x7BC4CDDC)
	GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304 , 0xC164F53)

end)

RegisterNetEvent("policestation2:isWhitelisted")
AddEventHandler("policestation2:isWhitelisted", function()
	local playerhash = GetEntityModel(GetPlayerPed(-1))
	for i=1,#arrSkinHashes
	do
		if(arrSkinHashes[i] == playerhash) then
			position = i
		end
	end
	menu_loadout = 1
end)

RegisterNetEvent("policestation2:showArmoury")
AddEventHandler("policestation2:showArmoury", function()
	--Citizen.Trace("Inside is whitelisted client evnet")
	--menu = 1

	menu_armoury = 1
end)

RegisterNetEvent("policestation2:setciv")
AddEventHandler("policestation2:setciv", function(character, playerWeapons)
	Citizen.CreateThread(function()
		local model
		if not character.hash then -- does not have any customizations saved
			print("did not find character.hash!")
			model = -408329255 -- some random black dude with no shirt on, lawl
		else
			print("found a character hash!")
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
						SetPedHairColor(ped, head.other[i][4], head.other[i][4])
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

RegisterNetEvent("policestation2:ShowArmouryMenu")
AddEventHandler("policestation2:ShowArmouryMenu", function()

	TriggerEvent("GUI2:Title", "LSPD Armoury")

	TriggerEvent("GUI2:Option", "Armour", function(cb)
		if(cb) then
			Citizen.Trace("true")
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			TriggerEvent("policestation2:notify","Armour and Health Restored")
			--menu_loadout = 2
		end
		end)

	TriggerEvent("GUI2:Option", "Default Loadout", function(cb)
		if(cb) then
			TriggerEvent("policestation2:giveDefaultLoadout")
			TriggerEvent("policestation2:notify","Default Loadout")
		end
		end)

	TriggerEvent("GUI2:Option", "Marksman Loadout", function(cb)
		if(cb) then
			Citizen.Trace("true")
			RemoveAllPedWeapons(GetPlayerPed(-1), true)
			local playerWeapons = { "WEAPON_FLARE" , "WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_SNIPERRIFLE"}
			local name, hash
			for i = 1, #playerWeapons do
				name = playerWeapons[i]
				hash = GetHashKey(name)
				 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			GiveWeaponComponentToPed(GetPlayerPed(-1), 1593441988 , 0x359B7AAE)
			GiveWeaponComponentToPed(GetPlayerPed(-1), 100416529 , 0xBC54DA77)
			TriggerEvent("policestation2:notify","Marksman Loadout")

			--menu_loadout = 2
		end
		end)

	TriggerEvent("GUI2:Option", "Undercover Loadout", function(cb)
		if(cb) then
			Citizen.Trace("true")
			RemoveAllPedWeapons(GetPlayerPed(-1), true)
			local playerWeapons = { "WEAPON_COMBATPISTOL", "WEAPON_STUNGUN" }
			local name, hash
			for i = 1, #playerWeapons do
				name = playerWeapons[i]
				hash = GetHashKey(name)
				 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			--Citizen.Trace("giving flashlight components to cop...")
			TriggerEvent("policestation2:notify","Undercover Loadout")
			--menu_loadout = 2
		end
		end)

	TriggerEvent("GUI2:Option", "Prison Guard Loadout", function(cb)
		if(cb) then
			Citizen.Trace("true")
			RemoveAllPedWeapons(GetPlayerPed(-1), true)
			local playerWeapons = {"WEAPON_FLASHLIGHT", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK"}
			local name, hash
			for i = 1, #playerWeapons do
				name = playerWeapons[i]
				hash = GetHashKey(name)
				 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			--Citizen.Trace("giving flashlight components to cop...")
			TriggerEvent("policestation2:notify","Prison Guard Loadout")
			--menu_loadout = 2
		end
		end)

		TriggerEvent("GUI2:Option", "Carbine Rifle", function(cb)
		if(cb) then
			local playerWeapons = {"WEAPON_CARBINERIFLE"}
			local name, hash
			for i = 1, #playerWeapons do
				name = playerWeapons[i]
				hash = GetHashKey(name)
				GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			-- give flashlights (not sure which is which atm):
			GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0x7BC4CDDC)
			GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0xC164F53)
			Citizen.Trace("giving flashlight components to cop...")
		end
		end)

		TriggerEvent("GUI2:Option", "Pump Shotgun", function(cb)
		if(cb) then
			local playerWeapons = {"WEAPON_PUMPSHOTGUN"}
			local name, hash
			for i = 1, #playerWeapons do
				name = playerWeapons[i]
				hash = GetHashKey(name)
				GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			end
			SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
			SetPedArmour(GetPlayerPed(-1), 100)
			-- give flashlights (not sure which is which atm):
			GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0x7BC4CDDC)
			GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0xC164F53)
		end
		end)

	TriggerEvent("GUI2:Update")
end)

RegisterNetEvent("policestation2:ShowMainMenu")
AddEventHandler("policestation2:ShowMainMenu", function()

	TriggerEvent("GUI2:Title", "LSPD Loadout")

	TriggerEvent("GUI2:StringArray", "Skin:", arrSkinGeneralCaptions, position, function(cb)
		Citizen.CreateThread(function()
			position = cb
			local ply = GetPlayerPed(-1)
			if arrSkinGeneralValues[position] == "mp_m_freemode_01" then
				--SetPedComponentVariation(ply, 2, 19, 1, 0)
				SetPedComponentVariation(ply, 4, 35, 0, 0)
				--SetPedComponentVariation(ply, 6, 24, 0, 0)
				SetPedComponentVariation(ply, 8, 58, 0, 0)
				SetPedComponentVariation(ply, 11, 55, 0, 0)
			elseif arrSkinGeneralValues[position] == "mp_f_freemode_01" then
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
					Citizen.Wait(100)
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
			TriggerEvent("ptt:iscop", true)
		end)
	end)

	TriggerEvent("GUI2:Option", "Primary Components", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 2
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Secondary Components", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 3
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Props", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 4
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Load Default", function(cb)
		if(cb) then
			Citizen.Trace("true")
			TriggerServerEvent("policestation2:loadDefaultUniform", character)
			TriggerEvent("interaction:setPlayersJob", "police") -- set interaction menu javascript job variable to "police"
			TriggerEvent("ptt:iscop", true)
			--menu = 4
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Save as Default", function(cb)
		if(cb) then
			Citizen.Trace("true")
			local character = {
				["components"] = {},
				["componentstexture"] = {},
				["props"] = {},
				["propstexture"] = {}
			}
			local ply = GetPlayerPed(-1)
			local debugstr = "| Props: "
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
			TriggerServerEvent("policestation2:saveasdefault", character)
			--Citizen.Trace("calling server function: giveMeMyWeaponsPlease...")
			--TriggerServerEvent("mini:giveMeMyWeaponsPlease")
		else

		end
		end)

	TriggerEvent("GUI2:Option", "Off Duty", function(cb)
		if(cb) then
			Citizen.Trace("true")
			TriggerServerEvent("policestation2:offduty")
			TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
			TriggerEvent("ptt:iscop", false)
			--menu = 4
		else

		end
		end)

	--[[TriggerEvent("GUI2:Option", "Save", function(cb)
		if(cb) then
			--Citizen.Trace("true")
			local character = {
				["hash"] = "",
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
			TriggerServerEvent("mini:save", character)
			Citizen.Trace("calling server function: giveMeMyWeaponsPlease...")
			TriggerServerEvent("mini:giveMeMyWeaponsPlease")
			menu = false
		else

		end
	end)]]--
	TriggerEvent("GUI2:Update")
end)

RegisterNetEvent("policestation2:ShowPropsMenu")
AddEventHandler("policestation2:ShowPropsMenu", function()
	TriggerEvent("GUI2:Title", "Props")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 1
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

RegisterNetEvent("policestation2:ShowComponentsMenu1")
AddEventHandler("policestation2:ShowComponentsMenu1", function()
	local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
	TriggerEvent("GUI2:Title", "Components 1")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 1
		else

		end
		end)
	local ply = GetPlayerPed(-1)
	for i=0,5
		do
		if ( arrSkinGeneralValues[position] == "mp_m_freemode_01" or arrSkinGeneralValues[position] == "mp_f_freemode_01" ) and ( i == 0 or i == 2 or i == 5 ) then -- ignore head and hair options
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

RegisterNetEvent("policestation2:ShowComponentsMenu2")
AddEventHandler("policestation2:ShowComponentsMenu2", function()
	local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
	TriggerEvent("GUI2:Title", "Components 2")
	TriggerEvent("GUI2:Option", "..Back", function(cb)
		if(cb) then
			Citizen.Trace("true")
			menu_loadout = 1
		else

		end
		end)
	local ply = GetPlayerPed(-1)
	for i=6,11
		do
		if ( arrSkinGeneralValues[position] == "mp_m_freemode_01" or arrSkinGeneralValues[position] == "mp_f_freemode_01" ) and ( i == -1 ) then
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

--[[Citizen.CreateThread(function()
	--for _, item in pairs(policeLockerRooms) do
		--Citizen.Wait(0)
		--DrawMarker(1, item.x, item.y, item.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
	--end
end)]]--

Citizen.CreateThread(function()

	while true do
		for _, item in pairs(policeLockerRooms) do
			DrawMarker(27, item.x,item.y,item.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		for _, item in pairs(policeArmourys) do
			DrawMarker(27, item.x,item.y,item.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if (IsNearStore() == true) then
			if(menu_loadout == 0) then
				drawTxt('Press ~g~E~s~ to open Loadout Menu',0,1,0.5,0.8,0.6,255,255,255,255)
			end
		else
			menu_loadout = 0
		end
		if (IsNearArmoury() == true) then
			if(menu_armoury == 0) then
				drawTxt('Press ~g~E~s~ to open Armoury Menu',0,1,0.5,0.8,0.6,255,255,255,255)
			end
		else
			menu_armoury = 0
		end

		if(IsControlJustPressed(1, 51) and IsNearStore() == true) then
			if(menu_loadout == 0) then
				TriggerServerEvent("policestation2:checkWhitelist", "policestation2:isWhitelisted")
			else
				menu_loadout = 0
			end

		end

		if(IsControlJustPressed(1, 51) and IsNearArmoury() == true) then
			if(menu_armoury == 0) then
				--TriggerServerEvent("policestation2:checkWhitelist", "policestation2:isWhitelisted")
				TriggerServerEvent("policestation2:checkWhitelist", "policestation2:showArmoury")
				--TriggerEvent("policestation2:showArmoury")
			else
				menu_armoury = 0
			end

		end



		if(menu_loadout == 1) then
			--Show main menu
			TriggerEvent("policestation2:ShowMainMenu")
			elseif(menu_loadout == 2) then
			--Show components menu
			TriggerEvent("policestation2:ShowComponentsMenu1")
			elseif(menu_loadout == 3) then
			--Show Props Menu
			TriggerEvent("policestation2:ShowComponentsMenu2")
			elseif(menu_loadout == 4) then
			--Show Props Menu
			TriggerEvent("policestation2:ShowPropsMenu")
		end
		if(menu_armoury == 1) then
			TriggerEvent("policestation2:ShowArmouryMenu")
		end
		Wait(0)
	end
	end)

RegisterNetEvent("CS:giveWeapons")
AddEventHandler("CS:giveWeapons", function(weapons)
	-- weapons
	for i = 1, #weapons do
		local weaponHash = weapons[i].hash
		GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 1000, 0, false) -- name already is the hash
	end
end)

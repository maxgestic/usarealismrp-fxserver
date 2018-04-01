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
local position = 1
local LockerRooms = {
    {x=3502.5 , y=3762.45 , z=29.010}
}

local arrSkinGeneralCaptions = {"Marine", "Marine 2", "Marine Young", "Marine Young 2", "Marine 3", "Pilot"}
local arrSkinGeneralValues = {"s_m_m_marine_01", "s_m_m_marine_02", "s_m_y_marine_01", "s_m_y_marine_02", "s_m_y_marine_03", "s_m_m_pilot_02"}
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
	for _, item in pairs(LockerRooms) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= 2) then
			return true
		end
	end
end

RegisterNetEvent("job-private-sec:setCharacter")
AddEventHandler("job-private-sec:setCharacter", function(character)
	--Citizen.Trace("Inside is whitelisted client evnet")
	--menu = 1
	if character.hash then
            local name, model
            model = tonumber(character.hash)
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
                for key, value in pairs(character["components"]) do
                    SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
                end
                for key, value in pairs(character["props"]) do
                    SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
                end
				TriggerEvent("job-private-sec:giveDefaultLoadout")
			end)
	end
	--menu_armoury = 1
end)

RegisterNetEvent("job-private-sec:notify")
AddEventHandler("job-private-sec:notify", function(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)


--TODO
RegisterNetEvent("job-private-sec:giveDefaultLoadout")
AddEventHandler("job-private-sec:giveDefaultLoadout", function()
	Citizen.Trace("true")
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	local playerWeapons = { "WEAPON_COMBATPISTOL","WEAPON_PUMPSHOTGUN", "WEAPON_FLASHLIGHT" }
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
end)

RegisterNetEvent("job-private-sec:isWhitelisted")
AddEventHandler("job-private-sec:isWhitelisted", function()
	Citizen.Trace("Inside is whitelisted client evnet")
	local playerhash = GetEntityModel(GetPlayerPed(-1))
	for i=1,#arrSkinHashes
	do
		if(arrSkinHashes[i] == playerhash) then
			position = i
		end
	end
	menu_loadout = 1
end)

RegisterNetEvent("job-private-sec:setciv")
AddEventHandler("job-private-sec:setciv", function(character, playerWeapons)
	Citizen.CreateThread(function()
		local model
		if not character.hash then -- does not have any customizations saved
			model = -408329255 -- some random black dude with no shirt on, lawl
		else
			model = character.hash
		end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
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
		-- give weapons
		if playerWeapons then
			for i = 1, #playerWeapons do
				print("playerWeapons[i].hash = " .. playerWeapons[i].hash)
				GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
			end
		end
    end)
end)


RegisterNetEvent("job-private-sec:ShowMainMenu")
AddEventHandler("job-private-sec:ShowMainMenu", function()

	TriggerEvent("GUI2:Title", "Delta PMC")

	TriggerEvent("GUI2:StringArray", "Skin:", arrSkinGeneralCaptions, position, function(cb)
		Citizen.CreateThread(function()
			position = cb
			local modelhashed = GetHashKey(arrSkinGeneralValues[position])
			Citizen.Trace("setting model to hash: " .. modelhashed)
			Citizen.Trace("index = " .. position)
			Citizen.Trace("value = " .. arrSkinGeneralValues[position])
			Citizen.Trace("caption = " .. arrSkinGeneralCaptions[position])
			RequestModel(modelhashed)
			while not HasModelLoaded(modelhashed) do
				RequestModel(modelhashed)
				Citizen.Wait(0)
			end
			SetPlayerModel(PlayerId(), modelhashed)
			--SetPedDefaultComponentVariation(PlayerId());
			local ply = GetPlayerPed(-1)
			--drawTxt(ply,0,1,0.5,0.8,0.6,255,255,255,255)
			SetPedDefaultComponentVariation(ply)
			SetModelAsNoLongerNeeded(modelhashed)
			TriggerEvent("job-private-sec:giveDefaultLoadout")
			TriggerServerEvent("job-private-sec:onduty")
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

	TriggerEvent("GUI2:Option", "Off-Duty", function(cb)
		if(cb) then
			Citizen.Trace("true")
			TriggerServerEvent("job-private-sec:offduty")
			--menu = 4
		else

		end
		end)
	TriggerEvent("GUI2:Update")
end)

RegisterNetEvent("job-private-sec:ShowPropsMenu")
AddEventHandler("job-private-sec:ShowPropsMenu", function()
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

RegisterNetEvent("job-private-sec:ShowComponentsMenu1")
AddEventHandler("job-private-sec:ShowComponentsMenu1", function()
	local components = {"Face","Head","Hair","Torso","Legs","Hands","Feet","Eyes","Acessories","Tasks","Textures","Torso2"}
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

RegisterNetEvent("job-private-sec:ShowComponentsMenu2")
AddEventHandler("job-private-sec:ShowComponentsMenu2", function()
	local components = {"Face","Head","Hair","Torso","Legs","Hands","Feet","Eyes","Acessories","Tasks","Textures","Torso2"}
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

Citizen.CreateThread(function()

	while true do
		for _, item in pairs(LockerRooms) do
			DrawMarker(1, item.x,item.y,item.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if (IsNearStore() == true) then
			if(menu_loadout == 0) then
				drawTxt('Press ~g~E~s~ to open Loadout Menu',0,1,0.5,0.8,0.6,255,255,255,255)
			end
		else
			menu_loadout = 0
		end

		if(IsControlJustPressed(1, 51) and IsNearStore() == true) then
			if(menu_loadout == 0) then
				TriggerServerEvent("job-private-sec:checkWhitelist")
			else
				menu_loadout = 0
			end

		end

		if(menu_loadout == 1) then
			--Show main menu
			TriggerEvent("job-private-sec:ShowMainMenu")
			elseif(menu_loadout == 2) then
			--Show components menu
			TriggerEvent("job-private-sec:ShowComponentsMenu1")
			elseif(menu_loadout == 3) then
			--Show Props Menu
			TriggerEvent("job-private-sec:ShowComponentsMenu2")
			elseif(menu_loadout == 4) then
			--Show Props Menu
			TriggerEvent("job-private-sec:ShowPropsMenu")
		end
		Wait(0)
	end
	end)

--[[
Citizen.CreateThread(function()
	for _, item in pairs(LockerRooms) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, 374)
		SetBlipAsShortRange(item.blip, true)
		SetBlipColour(item.blip, 69)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Delta PMC")
		EndTextCommandSetBlipName(item.blip)
	end
	end)
--]]

RegisterNetEvent("CS:giveWeapons")
AddEventHandler("CS:giveWeapons", function(weapons)
	-- weapons
	for i = 1, #weapons do
		local weaponHash = weapons[i].hash
		GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 1000, 0, false) -- name already is the hash
	end
end)

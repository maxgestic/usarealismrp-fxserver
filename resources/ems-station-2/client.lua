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
local menu = 0
local position = 1
local EMSLockerRooms = {
{x = 207.106, y = -1641.45, z = 28.5},
{x = 373.269, y = -1441.48, z = 28.5},
{x=-366.269, y = 6102.27, z = 34.4397}, -- paleto
{x=1694.01, y=3589.87, z=40.3212} -- sandy
}

local arrSkinGeneralCaptions = {"Fireman", "Paramedic - Male", "Paramedic - Female", "Doctor"}
local arrSkinGeneralValues = {"s_m_y_fireman_01","s_m_m_paramedic_01","s_f_y_scrubs_01", "s_m_m_doctor_01"}
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

RegisterNetEvent("emsstation2:notify")
AddEventHandler("emsstation2:notify", function(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

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

RegisterNetEvent("emsstation2:isWhitelisted")
AddEventHandler("emsstation2:isWhitelisted", function()
	--Citizen.Trace("Inside is whitelisted client evnet")
	local playerhash = GetEntityModel(GetPlayerPed(-1))
	for i=1,#arrSkinHashes
	do
		if(arrSkinHashes[i] == playerhash) then
			position = i
		end
	end
	menu = 1
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

RegisterNetEvent("emsstation2:ShowMainMenu")
AddEventHandler("emsstation2:ShowMainMenu", function()

	TriggerEvent("GUI2:Title", "EMS Menu")

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
			TriggerEvent("emsstation2:giveDefaultLoadout")
			TriggerServerEvent("emsstation2:onduty")
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

	TriggerEvent("GUI2:Option", "Off-Duty", function(cb)
		if(cb) then
			Citizen.Trace("true")
			TriggerServerEvent("emsstation2:offduty")
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

Citizen.CreateThread(function()

	while true do
		for _, item in pairs(EMSLockerRooms) do
			DrawMarker(1, item.x,item.y,item.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 255, 102, 255, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if (IsNearEMSLocker() == true) then
			if(menu == 0) then
				drawTxt('Press ~g~E~s~ to open EMS Menu',0,1,0.5,0.8,0.6,255,255,255,255)
			end
		else
			menu = 0
		end

		if(IsControlJustPressed(1, 51) and IsNearEMSLocker() == true) then
			if(menu == 0) then
				TriggerServerEvent("emsstation2:checkWhitelist", "emsstation2:isWhitelisted")
			else
				menu = 0
			end

		end

		if(menu == 1) then
			--Show main menu
			TriggerEvent("emsstation2:ShowMainMenu")
			elseif(menu == 2) then
			--Show components menu
			TriggerEvent("emsstation2:ShowComponentsMenu1")
			elseif(menu == 3) then
			--Show Props Menu
			TriggerEvent("emsstation2:ShowComponentsMenu2")
			elseif(menu == 4) then
			--Show Props Menu
			TriggerEvent("emsstation2:ShowPropsMenu")
		end
		Wait(0)
	end
end)

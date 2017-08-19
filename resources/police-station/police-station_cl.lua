local shopX,shopY,shopZ = 451.255, -992.41, 30.6896
local locations = {
	--{ x=-452.147, y=6005.43, z=30.500 },
	{ x=439.817, y=-993.397, z=29.689 },
	--{ x=1854.330, y=3700.847, z=33.265 },
	{ x=451.255, y=-992.41, z = 29.1896 }
}

RegisterNetEvent("policeStation:isWhitelisted")
AddEventHandler("policeStation:isWhitelisted", function()
	toggleDuty()              -- Menu to draw
	Menu.hidden = not Menu.hidden    -- Hide/Show the menu
end)

RegisterNetEvent("policeStation:notify")
AddEventHandler("policeStation:notify", function(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("policeStation:giveWeapons")
AddEventHandler("policeStation:giveWeapons", function(playerWeapons)
	local name, hash
	Citizen.CreateThread(function()
		Citizen.Wait(1)
		-- weapons
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			if string.match(name, "_") then
				hash = GetHashKey(name)
				GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			else
				GiveWeaponToPed(GetPlayerPed(-1), tonumber(name), 1000, 0, false) -- name already is the hash
			end
		end
	end)
end)

RegisterNetEvent("policeStation:giveCivWeapons")
AddEventHandler("policeStation:giveCivWeapons", function(playerWeapons)
	-- weapons
	Citizen.CreateThread(function()
		for i = 1, #playerWeapons do
			local hash = playerWeapons[i].hash
			 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
		end
    end)
end)

RegisterNetEvent("policeStation:changeSkin")
AddEventHandler("policeStation:changeSkin", function(skinName, armour, giveSheriffWeapons)

	if string.match(skinName,"_") then

		skinName = GetHashKey(skinName)

	end

    if skinName == nil then
        Citizen.Trace("skin was null.\n")
        return
    end

    Citizen.CreateThread(function()
		local model = tonumber(skinName)

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

		if giveSheriffWeapons then
			-- grab weapons
			TriggerEvent("policeStation:giveSheriffWeapons")
		end

		-- give max armor
		if armour then
			SetPedArmour(GetPlayerPed(-1), 100)
		else
			SetPedArmour(GetPlayerPed(-1), 0)
		end
    end)

end)

RegisterNetEvent("policeStation:giveSheriffLoadout")
AddEventHandler("policeStation:giveSheriffLoadout", function(model)
	skinName = model
	-- change into uniform / get weapons
	if string.match(skinName,"_") then
		skinName = GetHashKey(skinName)
	end
	if skinName == nil then
		Citizen.Trace("skin was null.\n")
		return
	end
	Citizen.CreateThread(function()
		local model = tonumber(skinName)
		RequestModel(model)
		while not HasModelLoaded(model) do -- Wait for model to load
			RequestModel(model)
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
		local playerWeapons = { "WEAPON_BZGAS", "WEAPON_FLARE" , "WEAPON_CARBINERIFLE" ,"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER" }
		local name, hash
		for i = 1, #playerWeapons do
			name = playerWeapons[i]
			hash = GetHashKey(name)
			 GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
		end
		SetPedArmour(GetPlayerPed(-1), 100)
	end)
end)

RegisterNetEvent("policeStation:giveCivLoadout")
AddEventHandler("policeStation:giveCivLoadout", function(character, playerWeapons)
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

-- PROPS:
function randomizeProps()
	SetPedRandomProps(GetPlayerPed(-1))
end

function propsMenu()
	MenuTitle = "Props"
	ClearMenu()
	Menu.addButton("Randomize", "randomizeProps", nil)
	Menu.addButton("Hat", "giveHat", nil)
	Menu.addButton("Glasses", "giveGlasses", nil)
end

function randomizeEarStuff() -- need to test
	local ped = GetPlayerPed(-1)
	local PED_PROP_EAR = 2
	local index = math.random(0,GetNumberOfPedPropDrawableVariations(ped, PED_PROP_EAR))
	SetPedPropIndex(ped, PED_PROP_GLASSES, index, 0, true)
end

function randomizeGlasses()
	local ped = GetPlayerPed(-1)
	local PED_PROP_GLASSES = 1
	local index = math.random(0,GetNumberOfPedPropDrawableVariations(ped, 1))
	SetPedPropIndex(ped, PED_PROP_GLASSES, index, 0, true) -- sport front down (index = 0)
	--SetPedPropIndex(ped, PED_PROP_GLASSES, 1, 0, true) -- sport back (index = 1) .. etc
	--SetPedPropIndex(ped, PED_PROP_GLASSES, 2, 0, true) -- sport front up
	--SetPedPropIndex(ped, PED_PROP_GLASSES, 3, 0, true) -- aviator front down
end

function giveGlasses()
	MenuTitle = "Glasses"
	ClearMenu()
	Menu.addButton("Randomize", "randomizeGlasses", nil)
end

function giveHat()
	local ped = GetPlayerPed(-1)
	local PED_PROP_HATS = 0
	SetPedPropIndex(ped, PED_PROP_HATS, 0, 0, true)
end
-- COMPONENTS:
function componentTest()
	local const = 0
	local ped = GetPlayerPed(-1)
    local drawVariation = math.random(0,GetNumberOfPedDrawableVariations(ped, const))
	local textureVariation = math.random(0,GetNumberOfPedTextureVariations(ped, const, 0))
	SetPedComponentVariation(ped, const, drawVariation, textureVariation, 0)
	SetPedComponentVariation(GetPlayerPed(-1), 3, drawVariation, textureVariation, 2)
end

function randomizeComponents()
	SetPedRandomComponentVariation(GetPlayerPed(-1))
end

function componentMenu()
	MenuTitle = "Variations"
	ClearMenu()
	Menu.addButton("Randomize", "randomizeComponents", nil)
	Menu.addButton("Reset Components", "resetComponents", nil)
end
---------------------------
-- ** FACE/HAND SKIN COLOR ** --
-- 0 is face/hand skin color
	-- black skin 1:
		-- p1 = 3, p2 = 1
	-- default skin:
		-- p1 = 0, p2 = 0
	-- default skin no stache:
		-- p1 = 0, p2 = 1
	-- black skin 2:
		-- p1 = 2, p2 = 0
	-- black skin 3:
		-- p1 = 2, p2 = 1
	-- black skin 3:
		-- p1 = 1, p2 = 0
-- ** glasses/hats ** --
-- HAT = 0
-- SPORT GLASSES UP = 2
--SPORT GLASSES DOWN = 0
-- AVIATOR GLASSES = 3

----------------------------
-- 3 is skin color for arms
-- 9 is for police vest
-- 8 is a watch only (?)
-- 10 is for the rankings on sleeve

function toggleArmour()
	local ped = GetPlayerPed(-1)
	local previous0 = GetPedDrawableVariation(ped, 0)
	local previous0texture = GetPedTextureVariation(ped, 0)
	local previous3 = GetPedDrawableVariation(ped, 3)
	local previous3texture = GetPedTextureVariation(ped, 3)
	if GetPedArmour(ped) < 100  then
		SetPedComponentVariation(ped, 0, previous0, previous0texture, 1)
		SetPedComponentVariation(ped, 3, previous3, previous3texture, 1)
		SetPedComponentVariation(ped, 9, 2, 0, 1) -- add vest
		SetPedArmour(ped, 100)
    else
		SetPedComponentVariation(ped, 0, previous0, previous0texture, 1)
		SetPedComponentVariation(ped, 3, previous3, previous3texture, 1)
		SetPedComponentVariation(ped, 9, 0, 0, 1) -- remove vest?
		SetPedArmour(ped, 0)
    end
end

function resetComponents()
	SetPedDefaultComponentVariation(GetPlayerPed(-1))
end

function clearProps()
	ClearAllPedProps(GetPlayerPed(-1))
end

function pedVariationMenu()
	MenuTitle = "Variations"
	ClearMenu()
	Menu.addButton("Toggle Armour", "toggleArmour", nil)
	Menu.addButton("Components", "componentMenu", nil)
	Menu.addButton("Props", "propsMenu", nil)
	Menu.addButton("Clear All", "clearProps", nil)
end

function toggleDuty()
	MenuTitle = "Police Duty"
	ClearMenu()
	Menu.addButton("Variations", "pedVariationMenu", nil)
	Menu.addButton("Male Deputy","givePoliceLoadout", "male")
	Menu.addButton("Female Deputy","givePoliceLoadout", "female")
	Menu.addButton("Male Cop","giveUCLoadout", "s_m_y_cop_01")
	Menu.addButton("Female Cop","giveUCLoadout", "s_f_y_cop_01")
	Menu.addButton("UC 1","giveUCLoadout", "s_m_m_ciasec_01")
	Menu.addButton("UC 2","giveUCLoadout", "s_m_m_fiboffice_01")
	Menu.addButton("UC 3","giveUCLoadout", "s_m_m_fibsec_01")
	Menu.addButton("UC 4","giveUCLoadout", "s_m_m_chemsec_01")
	Menu.addButton("FED 1","giveUCLoadout", "s_m_y_blackops_01")
	Menu.addButton("Civilian","giveCivLoadout", nil)
	Menu.addButton("Cancel","cancel", nil)
end

function givePoliceLoadout(gender)
	TriggerServerEvent("policeStation:toggleDuty", gender)
	Menu.hidden = true
end

function giveUCLoadout(modelName)
	TriggerServerEvent("policeStation:toggleUCDuty", modelName )
end

function giveCivLoadout()
	TriggerServerEvent("policeStation:giveCivStuff")
	Menu.hidden = true
end

function cancel()
	Menu.hidden = true
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

function isPlayerAtPD()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)

	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 2 then
			return true
		end
	end

	return false

end

local playerNotified = false


Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		for i = 1, #locations do
			DrawMarker(1, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		end

		if isPlayerAtPD() and not playerNotified then
			TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to go on/off duty")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if isPlayerAtPD() then

				-- check player against the white list
				TriggerServerEvent("policeStation:checkWhitelist")

				if not stored then
					-- save skin for user canceling
					skinBeforeRandomizing = GetEntityModel(GetPlayerPed(-1))
					stored = true
				end

				--toggleDuty()              -- Menu to draw
				--Menu.hidden = not Menu.hidden    -- Hide/Show the menu

			end

		elseif not isPlayerAtPD() then
			playerNotified = false
			Menu.hidden = true
		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

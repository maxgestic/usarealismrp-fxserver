local skinIndex = 1
local maxSkinIndex = 421 -- max skins
local shopLocations = {
	{x = 1.27486, y = 6511.89, z = 30.8778}, -- paleto bay
	{x = 1692.24, y = 4819.79, z = 41.0631}, -- grape seed
	{x = 1199.09, y = 2707.86, z = 37.0226}, -- sandy shores 1
	{x = 614.565, y = 2763.17, z = 41.0881}, -- sandy shores 2
	{x = -1097.71, y = 2711.18, z = 18.5079}, -- route 68
	{x = -3170.52, y = 1043.97, z = 20.0632}, -- chumash, great ocean hwy
	{x = -1449.93, y = -236.979, z = 49.0106}, -- vinewood 1
	{x = -710.239, y = -152.319, z = 37.0151}, -- vinewood 2
	{x = -1192.84, y = -767.861, z = 17.0187}, -- vinewood 3
	{x = -163.61, y = -303.987, z = 39.0333}, -- vinewood 4
	{x = 125.403, y = -223.887, z = 54.0578}, -- vinewood 5
	{x = 423.474, y = -809.565, z = 29.0911}, -- vinewood 6
	{x = -818.509, y = -1074.14, z = 11.0281}, -- vinewood 7
	{x = 77.7774, y = -1389.87, z = 29.0761}, -- vinewood 8
}

local skinBeforeRandomizing, saved
local stored = false

RegisterNetEvent("clothingStore:notify")
AddEventHandler("clothingStore:notify", function(msg)
	DrawCoolLookingNotification(msg)
end)

function randomizeCharacter()
	TriggerServerEvent("mini:randomizeCharacter")
end

RegisterNetEvent("mini:giveWeapons")
AddEventHandler("mini:giveWeapons", function(weapons)
	Citizen.Trace("inside of mini:giveWeapons now!")
	if weapons then
		for i =1, #weapons do
			Citizen.Trace("giving player weapon: " .. weapons[i].name)
			GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
		end
	end
end)

RegisterNetEvent("mini:changeSkin")
AddEventHandler("mini:changeSkin", function(skinName)

	local model

	saved = false

    if skinName == nil then
        Citizen.Trace("skin was null.\n")
        return
    end

    Citizen.CreateThread(function()
		if string.match(skinName, "_") then
			Citizen.Trace("skinName 1 = " .. skinName)
        	model = GetHashKey(skinName)
		else
			Citizen.Trace("skinName 2 = " .. skinName)
			model = tonumber(skinName)
		end

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end)

end)

function cancel()
	-- give player model
	if string.match(skinBeforeRandomizing, "_") then
		model = GetHashKey(skinBeforeRandomizing)
	else
		model = tonumber(skinBeforeRandomizing)
	end

    RequestModel(model)
    while not HasModelLoaded(model) do -- Wait for model to load
        RequestModel(model)
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

	TriggerEvent("chatMessage", "SYSTEM", { 0, 128, 255 }, "Skin change canceled.")

	stored = false

	Menu.hidden = true

	TriggerServerEvent("mini:giveMeMyWeaponsPlease")

end

function save()

	Citizen.Trace("inside of 'save' method")

	if not saved then

		local playerModel = GetEntityModel(GetPlayerPed(-1))

		TriggerServerEvent("mini:save", playerModel)
		Citizen.Trace("calling server function: giveMeMyWeaponsPlease...")
		TriggerServerEvent("mini:giveMeMyWeaponsPlease")

		saved = true

		Menu.hidden = true

	else

		TriggerEvent("chatMessage", "SYSTEM", { 0, 128, 255 }, "You have already saved your model.")

	end

end

RegisterNetEvent("clothingStore:resetIndex")
AddEventHandler("clothingStore:resetIndex", function()

	skinIndex = 1

end)

function next()
	if skinIndex <= maxSkinIndex then
		if skinIndex == maxSkinIndex then
			skinIndex = 1
		else
			skinIndex = skinIndex + 1
		end
		TriggerServerEvent("clothingStore:selectSkin", skinIndex)
	end
end

function previous()
	if skinIndex >= 1 then
		if skinIndex == 1 then
			skinIndex = maxSkinIndex
		else
			skinIndex = skinIndex - 1
		end
		TriggerServerEvent("clothingStore:selectSkin", skinIndex)
	end
end

function randomizeComponents()
	SetPedRandomComponentVariation(GetPlayerPed(-1), 1)
end

function randomizeProps()
	SetPedRandomProps(GetPlayerPed(-1))
end

function giveHat()
	local ped = GetPlayerPed(-1)
	local PED_PROP_HATS = 0
	SetPedPropIndex(ped, PED_PROP_HATS, 0, 0, true)
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

function propsMenu()
	MenuTitle = "Props"
	ClearMenu()
	Menu.addButton("Randomize", "randomizeProps", nil)
	Menu.addButton("Hat", "giveHat", nil)
	Menu.addButton("Glasses", "giveGlasses", nil)
end

function clothingStoreMenu()
	MenuTitle = "Character Menu"
	ClearMenu()
	Menu.addButton("Props", "propsMenu", nil)
	Menu.addButton("Randomize Components", "randomizeComponents", nil)
	Menu.addButton("Randomize Model","randomizeCharacter", nil)
	Menu.addButton("Next","next", nil)
	Menu.addButton("Previous","previous", nil)
	Menu.addButton("Save","save", nil)
	Menu.addButton("Cancel","cancel", nil)
end

function isPlayerAtClothingShop()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)

	for i = 1, #shopLocations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopLocations[i].x,shopLocations[i].y,shopLocations[i].z,false) < 5 then
			return true
		end
	end

	return false

end

local playerNotified = false

	Citizen.CreateThread(function()

		while true do

			Citizen.Wait(0)

			for i = 1, #shopLocations do
				DrawMarker(1, shopLocations[i].x, shopLocations[i].y, shopLocations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
			end

			if isPlayerAtClothingShop() and not playerNotified then
				TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to buy clothing!")
				playerNotified = true
			end
			if IsControlJustPressed(1,Keys["E"]) then

				if isPlayerAtClothingShop() then

					if not stored then
						-- save skin for user canceling
						skinBeforeRandomizing = GetEntityModel(GetPlayerPed(-1))
						stored = true
					end

					clothingStoreMenu()              -- Menu to draw
					Menu.hidden = not Menu.hidden    -- Hide/Show the menu

				end

			elseif not isPlayerAtClothingShop() then
				stored = false
				playerNotified = false
				Menu.hidden = true
			end
			Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false
		end
	end)

	function DrawCoolLookingNotification(msg)
	    SetNotificationTextEntry("STRING")
	    AddTextComponentString(msg)
	    DrawNotification(0,1)
	end

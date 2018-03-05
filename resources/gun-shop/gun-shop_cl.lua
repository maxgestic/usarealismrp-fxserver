local playerWeapons
local shopX,shopY,shopZ = -330.803, 6085.742, 31.455
 locations = {
	{ x=-330.290, y=6083.839, z=30.500 },
	{ x=-3172.045, y=1087.621, z=19.838 },
	{ x=-1117.707, y=2698.373, z=17.554 },
	{ x=1693.934, y=3759.389, z=33.705 },
	{ x=251.738, y=-49.590, z=68.941 },
	{ x=-1306.148, y=-394.082, z=35.695 },
	{ x=-662.276, y=-935.913, z=20.829 },
	{ x=21.913, y=-1107.593, z=28.797 },
	{ x=842.328, y=-1033.175, z=27.194 },
	{ x=2567.881, y=294.578, z=107.734 },
	{ x=810.295, y=-2157.112, z=28.6190 },
}

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterNetEvent("gunShop:showSellMenu")
AddEventHandler("gunShop:showSellMenu", function(weapons)
    Citizen.Trace("calling sellMenu with #weapons = " .. #weapons)
    sellMenu(weapons)
end)

RegisterNetEvent("mini:equipWeapon")
AddEventHandler("mini:equipWeapon", function(source, hash, name)
    Citizen.Trace("hash = " .. hash)
    Citizen.Trace("name = " .. name)
	local playerPed = GetPlayerPed(-1)
	GiveWeaponToPed(playerPed, hash, 60, false, true)
end)

RegisterNetEvent("mini:insufficientFunds")
AddEventHandler("mini:insufficientFunds", function(price, purchaseType)

	if purchaseType == "gun" then
		TriggerEvent("chatMessage", "Dealer:", { 255,99,71 }, "^0You don't have enough money to purchase that! Sorry!")
	end

end)

RegisterNetEvent("gunShop:showGunShopMenu")
AddEventHandler("gunShop:showGunShopMenu", function()
    gunShopMenu()
    Menu.hidden = not Menu.hidden
end)

RegisterNetEvent("gunShop:showNoPermitMenu")
AddEventHandler("gunShop:showNoPermitMenu", function()
    noPermitMenu()
    Menu.hidden = not Menu.hidden
end)

function buyPermit()
    TriggerServerEvent("gunShop:buyPermit")
    Menu.hidden = not Menu.hidden
end

function buyWeapon(params)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
		TriggerServerEvent("mini:checkGunMoney",params, property)
	end)
	Menu.hidden = true -- close menu
end

function MeleeMenu()

	MenuTitle = "Melee Weapons"
	ClearMenu()

	local weapon

	for i = 1, #storeWeapons["melee"] do
		weapon = storeWeapons["melee"][i]
		Menu.addButton(weapon.name .. " ($" .. weapon.price .. ")","buyWeapon", weapon)
	end

end

function HandgunsMenu()

	MenuTitle = "Handguns"
	ClearMenu()

	local weapon

	for i = 1, #storeWeapons["handguns"] do
		weapon = storeWeapons["handguns"][i]
		Menu.addButton(weapon.name .. " ($" .. weapon.price .. ")","buyWeapon", weapon)
	end

end

function ShotgunsMenu()
	MenuTitle = "Shotguns"
	ClearMenu()
	local weapon
	for i = 1, #storeWeapons["shotguns"] do
		weapon = storeWeapons["shotguns"][i]
		Menu.addButton(weapon.name .. " ($" .. weapon.price .. ")","buyWeapon", weapon)
	end
end

function gunShopMenu()
	MenuTitle = "Weapon Shop"
	ClearMenu()
	Menu.addButton("Buy","buyMenu", nil)
	Menu.addButton("Sell","loadWeapons", nil)
	Menu.hidden = true
end

function noPermitMenu()
    Menu.title = "Buy a permit"
    ClearMenu()
    Menu.addButton("($2,000) Permit", "buyPermit", nil)
end

function buyMenu()
	MenuTitle = "Purchase"
	ClearMenu()
	Menu.addButton("Melee","MeleeMenu", nil)
	Menu.addButton("Handguns","HandgunsMenu", nil)
	Menu.addButton("Shotguns","ShotgunsMenu", nil)
end

function sellWeapon(weapon)
	--remove weapon
	--update player inventory / money
	print("inside sellWeapon with weapon.name = " .. weapon.name)
	RemoveWeaponFromPed(GetPlayerPed(-1),weapon.hash)
	TriggerServerEvent("gunShop:sellWeapon", weapon)
	Menu.hidden = true
end

function loadWeapons()
	ClearMenu()
	TriggerServerEvent("gunShop:refreshWeaponList")
end

function sellMenu(playerWeapons)
	MenuTitle = "Sell"
	ClearMenu()
	Menu.hidden = false
	for i=1, #playerWeapons do
		local weapon = playerWeapons[i]
		Menu.addButton("($" .. round(.50*weapon.price, 0) .. ") " .. weapon.name, "sellWeapon", weapon)
	end
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

function isPlayerAtGunShop()
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
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if isPlayerAtGunShop() and not playerNotified then
			TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to open weapon menu!")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then
            Citizen.Trace("'E' was just pressed")
			if isPlayerAtGunShop() then
                Citizen.Trace("player was at gun shop")
                TriggerServerEvent("gunShop:checkPermit")
                --Menu.hidden = not Menu.hidden
			end
		elseif not isPlayerAtGunShop() then
			playerNotified = false
			Menu.hidden = true
		end
		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false
	end
end)

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = {
  {x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
}
-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	for i = 1, #JOB_PEDS do
		local hash = -1064078846 
		--local hash = GetHashKey(data.ped.model)
		print("requesting hash...")
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		print("spawning ped, heading: " .. JOB_PEDS[i].heading)
		print("hash: " .. hash)
		local ped = CreatePed(4, hash, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z, JOB_PEDS[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetEntityInvincible(ped)
		SetPedRandomComponentVariation(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true);
	end
end)

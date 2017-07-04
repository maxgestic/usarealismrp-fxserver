local shopX,shopY,shopZ = 129.345, -1920.89, 20.0187
 locations = {
	{ x=129.345, y=-1920.89, z=20.0187 }
}

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterNetEvent("blackMarket:equipWeapon")
AddEventHandler("blackMarket:equipWeapon", function(source, hash, name)
	local playerPed = GetPlayerPed(-1)
	GiveWeaponToPed(playerPed, hash, 60, false, true)
end)

RegisterNetEvent("blackMarket:insufficientFunds")
AddEventHandler("blackMarket:insufficientFunds", function(price, purchaseType)

	if purchaseType == "gun" then
        DrawCoolLookingNotification("You don't have enough money to purchase that! Sorry!")
	end

end)

RegisterNetEvent("blackMarket:notify")
AddEventHandler("blackMarket:notify", function(msg)
    DrawCoolLookingNotification(msg)
end)

RegisterNetEvent("blackMarket:displaySellMenu")
AddEventHandler("blackMarket:displaySellMenu", function(weapons)
    if not weapons then
        DrawCoolLookingNotification("You have no weapons to sell.")
        return
    elseif #weapons <= 0 then
        DrawCoolLookingNotification("You have no weapons to sell.")
        return
    end
        sellMenu(weapons)
end)

function buyWeapon(params)
	TriggerServerEvent("blackMarket:checkGunMoney",params)
	Menu.hidden = true -- close menu
end

function WeaponsMenu()
	MenuTitle = "Weapons"
	ClearMenu()
	local weapon
	for i = 1, #storeItems["weapons"] do
		weapon = storeItems["weapons"][i]
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

function buyMenu()
	MenuTitle = "Purchase"
	ClearMenu()
	Menu.addButton("Weapons","WeaponsMenu", nil)
end

function sellWeapon(weapon)
	--remove weapon
	--update player inventory / money
	print("inside sellWeapon with weapon.name = " .. weapon.name)
	RemoveWeaponFromPed(GetPlayerPed(-1),weapon.hash)
	TriggerServerEvent("blackMarket:sellWeapon", weapon)
	Menu.hidden = true
end

function loadWeapons()
    Menu.hidden = not Menu.hidden
	ClearMenu()
	TriggerServerEvent("blackMarket:getWeaponsAndDisplaySellMenu")
end

function sellMenu(weapons)
	MenuTitle = "Sell"
	ClearMenu()
	Menu.hidden = false
    Citizen.Trace("at sell menu client func, #weapons = " .. #weapons)
    for i=1, #weapons do
    	local weapon = weapons[i]
    	Menu.addButton("($" .. round(.50*weapon.price, 0) .. ") " .. weapon.name, "sellWeapon", weapon)
    end
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

function isPlayerAtBlackMarket()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 5 then
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
			DrawMarker(1, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
		end
		if isPlayerAtBlackMarket() and not playerNotified then
            DrawCoolLookingNotification("Press ~y~E~w~ to open black market menu!")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then
			if isPlayerAtBlackMarket() then
				gunShopMenu()              -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu
			end
		elseif not isPlayerAtBlackMarket() then
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

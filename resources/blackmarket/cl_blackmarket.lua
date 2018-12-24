local MENU_KEY = 38 -- "E"

locations = {
	--{ x=129.345, y=-1920.89, z=20.0187 },
    --{ x= -2166.786, y = 5197.684, z = 15.880} -- island north of map by paleto
    { x = -315.1, y = -2780.9, z = 5.1 } -- South LS (docks, where marcus suggested)
}

local storeItems = {
    ["weapons"] = {
		    { name = "Lock Pick", type = "misc", hash = 615608432, price = 1000, legality = "illegal", quantity = 1, weight = 5 },
        { name = "Molotov", type = "weapon", hash = 615608432, price = 650, legality = "illegal", quantity = 1, weight = 20 },
        { name = "Brass Knuckles", type = "weapon", hash = -656458692, price = 650, legality = "illegal", quantity = 1, weight = 5 },
        { name = "Dagger", type = "weapon", hash = -1834847097, price = 1250, legality = "illegal", quantity = 1, weight = 10 },
        { name = "Switchblade", type = "weapon", hash = -538741184, price = 5000, legality = "illegal", quantity = 1, weight = 10 },
        { name = "AP Pistol", type = "weapon", hash = 0x22D8FE39, price = 38550, legality = "illegal", quantity = 1, weight = 15 },
        { name = "Sawn-off", type = "weapon", hash = 0x7846A318, price = 25000, legality = "illegal", quantity = 1, weight = 30 },
        { name = "Micro SMG", type = "weapon", hash = 324215364, price = 50000, legality = "illegal", quantity = 1, weight = 30 },
        { name = "SMG", type = "weapon", hash = 736523883, price = 50700, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Machine Pistol", type = "weapon", hash = -619010992, price = 45500, legality = "illegal", quantity = 1, weight = 20 },
        { name = "Tommy Gun", type = "weapon", hash = 1627465347, price = 95750, legality = "illegal", quantity = 1, weight = 45 },
        { name = "AK47", type = "weapon", hash = -1074790547, price = 120500, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Carbine", type = "weapon", hash = -2084633992, price = 120500, legality = "illegal", quantity = 1, weight = 45 },
        --{ name = "Compact Rifle", type = "weapon", hash = 1649403952, price = 19550, legality = "illegal", quantity = 1, weight = 55 },
        --{ name = "MK2 Assault Rifle", type = "weapon", hash = 961495388, price = 19550, legality = "illegal", quantity = 1, weight = 45 },
        { name = "Bullpup Rifle", type = "weapon", hash = 2132975508, price = 150000, legality = "illegal", quantity = 1, weight = 45 },
        --{ name = "Advanced Rifle", type = "weapon", hash = -1357824103, price = 20550, legality = "illegal", quantity = 1, weight = 45 },
        --{ name = "Assault SMG", type = "weapon", hash = -270015777, price = 40500, legality = "illegal", quantity = 1, weight = 45 }
        --{ name = "MK2 Carbine Rifle", type = "weapon", hash = 4208062921, price = 20550, legality = "illegal", quantity = 1, weight = 45 }
    }
}

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Gun Trader", "~b~What are you looking for?", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

RegisterNetEvent("blackMarket:equipWeapon")
AddEventHandler("blackMarket:equipWeapon", function(source, hash, name)
	local playerPed = GetPlayerPed(-1)
	GiveWeaponToPed(playerPed, hash, 60, false, true)
end)

function CreateItemList(menu)
  ---------------------------------------------
  -- Button for each weapon in each category --
  ---------------------------------------------
  for i = 1, #storeItems["weapons"] do
    local item = NativeUI.CreateItem(storeItems["weapons"][i].name, "Purchase price: $" .. comma_value(storeItems["weapons"][i].price))
    item.Activated = function(parentmenu, selected)
      TriggerServerEvent("blackMarket:requestPurchase", i)
    end
    menu:AddItem(item)
  end
end

function isPlayerAtBlackMarket()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 5 then
			return locations[i]
		end
	end
	return nil
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

----------------
-- add to GUI --
----------------
CreateItemList(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    -- Process Menu --
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    ------------------
    -- Draw Markers --
    ------------------
		for i = 1, #locations do
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
		end
    -------------------
    -- draw help txt --
    -------------------
    if isPlayerAtBlackMarket() then
      drawTxt("Press [~y~E~w~] to open the black market menu",7,1,0.5,0.8,0.5,255,255,255,255)
    else
      if mainMenu:Visible() then
        mainMenu:Visible(false)
      end
    end
    --------------------------
    -- Listen for menu open --
    --------------------------
		if IsControlJustPressed(1, MENU_KEY) then
			if isPlayerAtBlackMarket() then
                mainMenu:Visible(not mainMenu:Visible())
			end
		end
	end
end)

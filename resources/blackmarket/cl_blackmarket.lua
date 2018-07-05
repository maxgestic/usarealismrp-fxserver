local MENU_KEY = 38 -- "E"

locations = {
	--{ x=129.345, y=-1920.89, z=20.0187 },
    { x= -2166.786, y = 5197.684, z = 15.880} -- island north of map by paleto
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
			return true
		end
	end
	return false
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
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
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

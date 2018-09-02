local MENU_KEY = 38 -- "E"

local ITEMS = { -- must be kept in sync with one in sv_bike-shop.lua --
  {name = "BMX", price = 500, hash = 1131912276},
  {name = "Cruiser", price = 500, hash = 448402357},
  {name = "Fixster", price = 850, hash = -836512833},
  {name = "Scorcher", price = 1200, hash = -186537451},
  {name = "TriBike", price = 1450, hash = 1127861609}
}

local locations = {
	{ x = 125.1, y = 6629.6, z = 32.0 }, -- paleto
    {x = -1107.0, y = -1693.8, z = 4.4}, -- LS
    {x = 1231.5, y = 2726.0, z = 38.0} -- sandy
}

local closest = nil

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

function isPlayerAtBikeShop()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 2.0 then
            closest = locations[i]
			return true
		end
	end
	return false
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

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Bike Shop", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateItemList(menu)
  ---------------------------------------------
  -- Button for each weapon in each category --
  ---------------------------------------------
  for i = 1, #ITEMS do
    local item = NativeUI.CreateItem(ITEMS[i].name, "Purchase price: $" .. comma_value(ITEMS[i].price))
    item.Activated = function(parentmenu, selected)
      TriggerServerEvent("bikeShop:requestPurchase", i, closest)
    end
    menu:AddItem(item)
  end
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
			DrawMarker(27, locations[i].x, locations[i].y, locations[i].z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 170, 0, 170, 0, 0, 2, 0, 0, 0, 0)
		end
    -------------------
    -- draw help txt --
    -------------------
    if isPlayerAtBikeShop() then
      drawTxt("Press [~y~E~w~] to open the bike shop menu",7,1,0.5,0.8,0.5,255,255,255,255)
    else
      if mainMenu:Visible() then
        mainMenu:Visible(false)
      end
    end
    --------------------------
    -- Listen for menu open --
    --------------------------
		if IsControlJustPressed(1, MENU_KEY) then
			if isPlayerAtBikeShop() then
        mainMenu:Visible(not mainMenu:Visible())
			end
		end
	end
end)

RegisterNetEvent("bikeShop:toggleMenu")
AddEventHandler("bikeShop:toggleMenu", function(toggle)
  mainMenu:Visible(toggle)
end)

RegisterNetEvent("bikeShop:spawnBike")
AddEventHandler("bikeShop:spawnBike", function(bike, location)
  -- thread code stuff below was taken from an example on the wiki
  -- Create a thread so that we don't 'wait' the entire game
  Citizen.CreateThread(function()
    -- Request the model so that it can be spawned
    RequestModel(bike.hash)
    -- Check if it's loaded, if not then wait and re-request it.
    while not HasModelLoaded(bike.hash) do
      Citizen.Wait(100)
    end
    -- Model loaded, continue
    -- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
    local vehicle = CreateVehicle(bike.hash, location.x, location.y, location.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
  end)
end)

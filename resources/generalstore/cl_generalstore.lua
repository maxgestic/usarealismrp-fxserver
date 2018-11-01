--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_LOCATIONS = {
    {x=1961.061, y=3741.604, z=31.343 },
    { x=374.586, y=326.037, z=102.566 },
    --{ x=1136.534, y=-971.131, z=45.415 },
    {x = 1136.3, y = -981.0, z = 45.5},
    { x=-1224.188, y=-907.065, z=11.326 },
    { x=26.453, y=-1347.059, z=28.497 },
    { x=-48.437, y=-1756.889, z=28.421 },
    {x=-707.712, y=-914.231, z=18.215 },
    { x=1166.5310, y=2708.920, z=37.157 },
    { x=1698.458, y=4924.744, z=42.063 },
    { x=1729.413, y=6414.426, z=34.037 },
    { x=-3039.294, y=586.014, z=6.908 },
    { x=1162.799, y=-324.155, z=68.205 },
    {  x=2556.836, y=382.416, z=107.622 },
    { x=2678.409, y=3280.871, z=54.241 },
    { x=547.486, y=2670.635, z=41.156 },
    { x=-1820.852, y=792.453, z=137.119 },
    { x=-3242.260, y=1001.569, z=11.830 },
    {x=-2968.126, y=390.579, z=14.043 },
    { x=-1487.241, y=379.843, z=39.163 },
	{x = 1743.3, y = 2578.1, z = 44.6}
}

local GENERAL_STORE_ITEMS = {} -- loaded from server

local created_menus = {}

local MENU_KEY = 38

local TIMEOUT = nil

-------------------
-- utility funcs --
-------------------
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

function IsAnyMenuVisible()
	for i = 1, #created_menus do
		if created_menus[i]:Visible() then
			return true
		end
	end
	return false
end

function CloseAllMenus()
	for i = 1, #created_menus do
		if created_menus[i]:Visible() then
			created_menus[i]:Visible(false)
		end
	end
end

function IsNearStore(store)
  local mycoords = GetEntityCoords(GetPlayerPed(-1))
  if Vdist(store.x, store.y, store.z, mycoords.x, mycoords.y, mycoords.z) < 3.0 then
    return true
  else
    return false
  end
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

function DrawGroundMarker(location)
  DrawMarker(27, location.x, location.y, location.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
end

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("General Store", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

table.insert(created_menus, mainMenu)

--------------------------------
-- Construct GUI menu buttons --
--------------------------------
function CreateGeneralStoreMenu(menu)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, items in pairs(GENERAL_STORE_ITEMS) do
    local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. category .. " items", true --[[KEEP POSITION]])
		table.insert(created_menus, submenu)
    for i = 1, #items do
      ---------------------------------------------
      -- Button for each item in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(items[i].name, "Purchase price: $" .. comma_value(items[i].price))
      item.Activated = function(parentmenu, selected)
        if not TIMEOUT then
          TIMEOUT = GetGameTimer()
          local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
          TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
            if property then
              TriggerServerEvent("generalStore:buyItem", property, items[i])
            else
              TriggerServerEvent("generalStore:buyItem", 0, items[i])
            end
          end)
          Citizen.CreateThread(function()
            while GetGameTimer() - TIMEOUT < 900 do
              Wait(100)
            end
            TIMEOUT = nil
          end)
        end
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu:AddItem(item)
    end
  end
  ----------------------------
  -- Close menu button --
  ----------------------------
  local item = NativeUI.CreateItem("Close", "Close the menu.")
  item.Activated = function(parentmenu, selected)
    CloseAllMenus()
  end
  menu:AddItem(item)
end

Citizen.CreateThread(function()
  local closest_location = nil
  while true do
    Wait(1)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    -- see if close to any stores --
    for i = 1, #GENERAL_STORE_LOCATIONS do
      if Vdist(mycoords.x, mycoords.y, mycoords.z, GENERAL_STORE_LOCATIONS[i].x, GENERAL_STORE_LOCATIONS[i].y, GENERAL_STORE_LOCATIONS[i].z) < 50.0 then
        DrawGroundMarker(GENERAL_STORE_LOCATIONS[i])
        if IsNearStore(GENERAL_STORE_LOCATIONS[i]) then
          drawTxt("Press [~y~E~w~] to open the General Store menu",7,1,0.5,0.8,0.5,255,255,255,255)
          if IsControlJustPressed(1, MENU_KEY) and not IsAnyMenuVisible() then
            mainMenu:Visible(not mainMenu:Visible())
            closest_location = GENERAL_STORE_LOCATIONS[i]
          end
        end
      end
    end
    -- close menu when far away --
    if closest_location then
      if not IsNearStore(closest_location) then
        if IsAnyMenuVisible() then
          closest_location = nil
          CloseAllMenus()
        end
      end
    end
  end
end)

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = {
  --{x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
  {x = 1727.7, y = 6415.6, z = 35.0, heading = 180.0},
  {x = 549.2, y = 2670.9, z = 42.2, heading = 130.0, hash = -573920724}, -- harmony
  {x = 1165.9, y = 2710.9, z = 38.2, heading = 180.0, hash = -573920724}, -- harmony
  {x = 1959.96, y = 3740.2, z = 32.3, heading = 180.0, hash = -573920724}, -- sandy shores
  {x = -3242.6, y = 999.9, z = 12.8, heading = 320.0, hash = -573920724}, -- north west los santos coast
  {x = -3039.1, y = 584.5, z = 7.9, heading = 30.0, hash = -573920724}, -- north west los santos coast
  {x = -2966.1, y = 390.8, z = 15.0, heading = 120.0, hash = -573920724}, -- north west los santos coast
  {x = 372.5, y = 326.7, z = 103.6, heading = 180.0, hash = -573920724}, -- los santos
  {x = -1221.7, y = -908.5, z = 12.3, heading = 60.0, hash = -573920724}, -- los santos
  {x = 1133.9, y = -982.6, z = 46.2, heading = 260.0, hash = -573920724}, -- los santos
  {x = -47.0, y = -1758.6, z = 29.4, heading = 90.0} -- los santos
}

Citizen.CreateThread(function()
	for i = 1, #JOB_PEDS do
		local hash = -840346158

        if JOB_PEDS[i].hash then
            hash = JOB_PEDS[i].hash
        end

		--local hash = GetHashKey(data.ped.model)
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		local ped = CreatePed(4, hash, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z, JOB_PEDS[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true);
	end
end)

RegisterNetEvent("generalStore:loadItems")
AddEventHandler("generalStore:loadItems", function(items)
  GENERAL_STORE_ITEMS = items
  -----------------
  -- Create Menu --
  -----------------
  CreateGeneralStoreMenu(mainMenu)
  _menuPool:RefreshIndex()
end)

TriggerServerEvent("generalStore:loadItems")

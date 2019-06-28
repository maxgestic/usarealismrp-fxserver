--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_LOCATIONS = {
    {x=1960.981, y=3739.764, z=32.543 }, -- Sandy Shores
    { x=372.996, y=325.607, z=103.766 }, -- Clinton Ave
    --{ x=1136.534, y=-971.131, z=45.415 },
    {x = 1134.92, y = -983.06, z = 46.6}, -- El Rancho Blvd
    { x=-1221.888, y=-907.435, z=12.526 }, -- San Andreas Ave
    { x=25.07, y=-1348.019, z=29.697 }, -- Innocence Blvd
    { x=-47.877, y=-1758.3689, z=29.621 }, -- Grove St.
    {x=-706.714, y=-914.608, z=19.415 }, -- Ginger St.
    { x=1165.2210, y=2710.220, z=38.357 }, -- Route 68
    { x=1697.578, y=4924.014, z=42.263 }, -- Grapeseed Main St.
    { x=1728.165, y=6414.316, z=35.237 }, -- Paleto Bay
    { x=-3038.484, y=585.294, z=8.108 }, -- Ineseno Road
    { x=1164.349, y=-323.805, z=69.355 }, -- Mirror Park Blvd.
    {  x=2557.936, y=381.366, z=108.822 }, -- Palomino Fwy
    { x=2678.981, y=3279.541, z=55.441 }, -- Senora Fwy.
    { x=548.286, y=2672.005, z=42.35 }, -- Harmony
    { x=-1819.872, y=793.053, z=138.259 }, -- Banham Canyon Dr.
    { x=-3241.570, y=1000.506, z=12.990 }, -- Barbareno Rd.
    {x=-2967.086, y=391.539, z=15.243 }, -- Great Ocean Hwy
    {x = 1745.03, y = 2579.84, z = 46.0, prison = true} -- Prison
}

local HARDWARE_STORE_LOCATIONS = {
  {x = 46.38, y = -1749.47, z = 29.63},
  {x = 2748.35, y = 3472.56, z = 55.67}
}

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = { -- Z coords are Z-1 or the ped will float!
  --{x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
  {x = 1727.7, y = 6415.6, z = 34.03, heading = 250.0},
  {x = 549.2, y = 2670.9, z = 41.2, heading = 95.0, hash = -573920724}, -- harmony
  {x = 1165.9, y = 2710.9, z = 37.2, heading = 180.0, hash = -573920724}, -- harmony
  {x = 1959.96, y = 3740.2, z = 32.3, heading = 300.0, hash = -573920724}, -- sandy shores
  {x = -3242.6, y = 999.9, z = 11.83, heading = 320.0, hash = -573920724}, -- north west los santos coast
  {x = -3039.1, y = 584.5, z = 6.9, heading = 30.0, hash = -573920724}, -- north west los santos coast
  {x = -2966.1, y = 390.8, z = 15.0, heading = 85.0, hash = -573920724}, -- north west los santos coast
  {x = 372.5, y = 326.7, z = 102.6, heading = 250.0, hash = -573920724}, -- los santos
  {x = -1221.7, y = -908.5, z = 11.3, heading = 40.0, hash = -573920724}, -- los santos
  {x = 1133.9, y = -982.6, z = 46.2, heading = 260.0, hash = -573920724}, -- los santos
  {x = -47.0, y = -1758.6, z = 28.4, heading = 90.0}, -- los santos
  {x = 24.34, y = -1347.215, z = 28.49, heading = 270.0}, -- los santos
  {x = -705.99, y = -914.53, z = 18.21, heading = 95.55}, -- los santos
  {x = 1697.088, y = 4923.35, z = 41.06, heading = 322.0}, -- los santos
  {x = 1165.02, y = -323.60, z = 68.2, heading = 95.0}, -- los santos
  {x = 2557.145, y = 380.64, z = 107.62, heading = 350.0, hash = -573920724}, -- sandy
  {x = 2677.729, y = 3279.42, z = 54.24, heading = 330.0, hash = -573920724}, -- senora fwy
  {x = -1819.304, y = 793.56, z = 137.088, heading = 132.0} -- richman
}

local BLIPS = {}
local GENERAL_STORE_ITEMS = {} -- loaded from server
local HARDWARE_STORE_ITEMS = {}
local closest_location = nil

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
  if Vdist(store.x, store.y, store.z, mycoords.x, mycoords.y, mycoords.z) < 1.7 then
    return true
  else
    return false
  end
end

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

----------------------
---- Set up blips ----
----------------------

function EnumerateBlips()
  if #BLIPS == 0 then
    for i = 1, #GENERAL_STORE_LOCATIONS do
      if not GENERAL_STORE_LOCATIONS[i].prison then
        local blip = AddBlipForCoord(GENERAL_STORE_LOCATIONS[i].x, GENERAL_STORE_LOCATIONS[i].y, GENERAL_STORE_LOCATIONS[i].z)
        SetBlipSprite(blip, 52)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 36)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('General Store')
        EndTextCommandSetBlipName(blip)
        table.insert(BLIPS, blip)
      end
    end
    for i = 1, #HARDWARE_STORE_LOCATIONS do
      local blip = AddBlipForCoord(HARDWARE_STORE_LOCATIONS[i].x, HARDWARE_STORE_LOCATIONS[i].y, HARDWARE_STORE_LOCATIONS[i].z)
      SetBlipSprite(blip, 473)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.7)
      SetBlipAsShortRange(blip, true)
      SetBlipColour(blip, 64)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('Hardware Store')
      EndTextCommandSetBlipName(blip)
      table.insert(BLIPS, blip)
    end
  end
end

TriggerServerEvent('blips:getBlips')

RegisterNetEvent('blips:returnBlips')
AddEventHandler('blips:returnBlips', function(blipsTable)
  if blipsTable['store'] then
    EnumerateBlips()
  else
    for _, k in pairs(BLIPS) do
      print(k)
      RemoveBlip(k)
    end
    BLIPS = {}
  end
end)

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("General Store", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
mainMenuHardware = NativeUI.CreateMenu("Hardware Store", "~b~Welcome!", 0, 320)
_menuPool:Add(mainMenu)
_menuPool:Add(mainMenuHardware)

table.insert(created_menus, mainMenu)
table.insert(created_menus, mainMenuHardware)

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
          local business = exports["usa-businesses"]:GetClosestStore(15)
          TriggerServerEvent("generalStore:buyItem", items[i], 'GENERAL', closest_location.prison, business)
          Citizen.CreateThread(function()
            while GetGameTimer() - TIMEOUT < 200 do
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

function CreateHardwareStoreMenu(menu)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, items in pairs(HARDWARE_STORE_ITEMS) do
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
          local business = exports["usa-businesses"]:GetClosestStore(15)
          TriggerServerEvent("generalStore:buyItem", items[i], 'HARDWARE', nil, business)
          Citizen.CreateThread(function()
            while GetGameTimer() - TIMEOUT < 200 do
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
  while true do
    Wait(1)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    for i = 1, #GENERAL_STORE_LOCATIONS do
      DrawText3D(GENERAL_STORE_LOCATIONS[i].x, GENERAL_STORE_LOCATIONS[i].y, GENERAL_STORE_LOCATIONS[i].z, 5, '[E] - General Store')
    end
    for i = 1, #HARDWARE_STORE_LOCATIONS do
      DrawText3D(HARDWARE_STORE_LOCATIONS[i].x, HARDWARE_STORE_LOCATIONS[i].y, HARDWARE_STORE_LOCATIONS[i].z, 7, '[E] - Hardware Store')
    end
    if IsControlJustPressed(1, MENU_KEY) and not IsAnyMenuVisible() then
      -- see if close to any stores --
      for i = 1, #GENERAL_STORE_LOCATIONS do
        if IsNearStore(GENERAL_STORE_LOCATIONS[i]) then
          mainMenu:Visible(not mainMenu:Visible())
          closest_location = GENERAL_STORE_LOCATIONS[i]
        end
      end
      for i = 1, #HARDWARE_STORE_LOCATIONS do
        if IsNearStore(HARDWARE_STORE_LOCATIONS[i]) then
          mainMenuHardware:Visible(not mainMenuHardware:Visible())
          closest_location = HARDWARE_STORE_LOCATIONS[i]
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

RegisterNetEvent("hardwareStore:loadItems")
AddEventHandler("hardwareStore:loadItems", function(items)
  HARDWARE_STORE_ITEMS = items
  -----------------
  -- Create Menu --
  -----------------
  CreateHardwareStoreMenu(mainMenuHardware)
  _menuPool:RefreshIndex()
end)

TriggerServerEvent("generalStore:loadItems")
TriggerServerEvent("hardwareStore:loadItems")

--# Weapon components & tints shop, two kinds -- illegal and legal, each at different locations.
--# for USA REALISM RP
--# by: minipunch

local MENU_KEY = 38 -- "E"

local ITEMS = {}

RegisterNetEvent("weaponExtraShop:getItems")
AddEventHandler("weaponExtraShop:getItems", function(items)
    ITEMS = items
    CreateTintMenu(legalShopMenu, true)
    CreateTintMenu(illegalShopMenu, false)
    CreateLegalExtrasMenu(legalShopMenu)
    CreateIllegalExtrasMenu(illegalShopMenu)
    _menuPool:RefreshIndex()
end)

TriggerServerEvent("weaponExtraShop:getItems")

local locations = {
	{ x = -329.92, y = 6078.9, z = 31.6, legal = true }, -- paleto ammunation
  { x = 1691.6, y = 3757.4, z = 34.7, legal = true }, -- sandy shores ammunation
  { x = -1308.89, y = -390.27, z = 36.9, legal = true }, -- blvd. del perro ammunation
  { x = 249.1, y = -45.58, z = 70.1, legal = true }, -- spanish ave.
  { x  = -665.34, y = -938.9, z = 22.0, legal = true }, -- Linsday Circus
  { x = 17.701, y = -1110.00, z = 29.95, legal = true }, -- Adam's Apple Blvd.
  { x = 845.46, y = -1029.78, z = 28.4, legal = true }, -- Vespucci
  --{ x = 129.6, y = -1920.3, z = 21.3, legal = false } -- grove st
  --{ x = 752.996, y = -3192.206, z = 6.07, legal = false } -- terminal, industrial LS
  {x = 180.8, y = 2793.2, z = 45.7, legal = false, ped = { heading = 260.0, hash = -907676309 }} -- sandy shores, harmony area
}

local created_menus = {}

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

function isPlayerAtWeaponExtraShop()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z) < 1.0 then
			return locations[i]
		end
	end
	return nil
end

function DrawText3D(x, y, z, text)
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

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
legalShopMenu = NativeUI.CreateMenu("Weapon Extras", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
illegalShopMenu = NativeUI.CreateMenu("Weapon Extras", "~b~What are you looking for?", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(legalShopMenu)
_menuPool:Add(illegalShopMenu)

table.insert(created_menus, legalShopMenu)
table.insert(created_menus, illegalShopMenu)

function CreateTintMenu(menu, legal)
  local submenu = _menuPool:AddSubMenu(menu, "Tints", "See our selection of Tints", true --[[KEEP POSITION]])
  table.insert(created_menus, submenu)
  local tint
  if legal then
    tint = ITEMS["Tints"].legal
  else
    tint = ITEMS["Tints"].illegal
  end
  for id, info in pairs(tint) do
    -------------------
    -- Tint options  --
    -------------------
    local item = NativeUI.CreateItem(info.name, "Purchase price: $" .. comma_value(info.price))
    item.Activated = function(parentmenu, selected)
      local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
      local equipped_weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
      TriggerServerEvent("weaponExtraShop:requestTintPurchase", id, equipped_weapon, legal, 0)
    end
    submenu:AddItem(item)
  end
end

function CreateLegalExtrasMenu(menu)
  -- submenu for components
  local componentsubmenu = _menuPool:AddSubMenu(menu, "Components", "See our selection of weapon components & extras.", true --[[KEEP POSITION]])
  table.insert(created_menus, componentsubmenu)
  -- each weapon --
  for weapon, components in pairs(ITEMS["Components"].legal) do
    local submenu = _menuPool:AddSubMenu(componentsubmenu, weapon, "See our selection of " .. weapon .. " components.", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu)
    for i = 1, #components do
      ---------------------------------------------
      -- Button for each weapon in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(components[i].name, "Purchase price: $" .. comma_value(components[i].price))
      item.Activated = function(parentmenu, selected)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
        local equipped_weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        if equipped_weapon == components[i].weapon_hash then
          if not HasPedGotWeaponComponent(GetPlayerPed(-1), equipped_weapon, GetHashKey(components[i].value)) then
            TriggerServerEvent("weaponExtraShop:requestComponentPurchase", weapon, i, equipped_weapon, true, property)
          else
              TriggerEvent("usa:notify", "You already have that upgrade!")
          end
        else
          TriggerEvent("usa:notify", "Please equip the weapon before upgrading!")
        end
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu:AddItem(item)
    end
  end
end

function CreateIllegalExtrasMenu(menu)
  -- submenu for components
  local componentsubmenu = _menuPool:AddSubMenu(menu, "Components", "See our selection of weapon components & extras.", true --[[KEEP POSITION]])
  table.insert(created_menus, componentsubmenu)
  -- each weapon --
  for weapon, components in pairs(ITEMS["Components"].illegal) do
    local submenu = _menuPool:AddSubMenu(componentsubmenu, weapon, "See our selection of " .. weapon .. " components.", true --[[KEEP POSITION]])
    table.insert(created_menus, submenu)
    for i = 1, #components do
      ---------------------------------------------
      -- Button for each weapon in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(components[i].name, "Purchase price: $" .. comma_value(components[i].price))
      item.Activated = function(parentmenu, selected)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
        local equipped_weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        if equipped_weapon == components[i].weapon_hash then
          if not HasPedGotWeaponComponent(GetPlayerPed(-1), equipped_weapon, GetHashKey(components[i].value)) then
            TriggerServerEvent("weaponExtraShop:requestComponentPurchase", weapon, i, equipped_weapon, false, property)
          else
              TriggerEvent("usa:notify", "You already have that upgrade!")
          end
        else
          TriggerEvent("usa:notify", "Please equip the weapon before upgrading!")
        end
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu:AddItem(item)
    end
  end
end

local closest_shop = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    -- Process Menu --
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    -------------------------------------
    -- Draw Markers / set closest shop --
    -------------------------------------
    local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
    local isCloseToAny = false
    for i = 1, #locations do
      local dist = GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,true)
      if dist < 10 then
          DrawText3D(locations[i].x,locations[i].y,locations[i].z, '[E] - Weapon Extras')
          if dist < 2.0 then
            closest_shop = locations[i]
            isCloseToAny = true
          end
      end
    end
    if not isCloseToAny then
      closest_shop = nil
    end
    if not closest_shop then
      if IsAnyMenuVisible() then
        closest_shop = nil
        CloseAllMenus()
      end
    end
    --------------------------
    -- Listen for menu open --
    --------------------------
		if IsControlJustPressed(1, MENU_KEY) then
			if closest_shop then
        if closest_shop.legal then
          legalShopMenu:Visible(not legalShopMenu:Visible())
        else
          illegalShopMenu:Visible(not illegalShopMenu:Visible())
        end
			end
		end
	end
end)

RegisterNetEvent("weaponExtraShop:applyComponent")
AddEventHandler("weaponExtraShop:applyComponent", function(component)
  GiveWeaponComponentToPed(GetPlayerPed(-1), component.weapon_hash, GetHashKey(component.value))
end)

RegisterNetEvent("weaponExtraShop:applyTint")
AddEventHandler("weaponExtraShop:applyTint", function(value)
  local equipped_weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
  if GetPedWeaponTintIndex(GetPlayerPed(-1), equipped_weapon) ~= id then
    SetPedWeaponTintIndex(GetPlayerPed(-1), equipped_weapon, tonumber(value))
  else
    TriggerEvent("usa:notify", "Tint already applied!")
  end
end)

RegisterNetEvent("weaponExtraShop:toggleMenu")
AddEventHandler("weaponExtraShop:toggleMenu", function(toggle)
  legalShopMenu:Visible(toggle)
end)

Citizen.CreateThread(function() -- spawn shop peds
	for i = 1, #locations do
        local loc = locations[i]
        if loc.ped then
            RequestModel(loc.ped.hash)
            while not HasModelLoaded(loc.ped.hash) do
                Wait(100)
            end
    		local ped = CreatePed(4, loc.ped.hash, loc.x, loc.y, loc.z, loc.ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
    		SetEntityCanBeDamaged(ped,false)
    		SetPedCanRagdollFromPlayerImpact(ped,false)
    		TaskSetBlockingOfNonTemporaryEvents(ped,true)
    		SetPedFleeAttributes(ped,0,0)
    		SetPedCombatAttributes(ped,17,1)
    		SetPedRandomComponentVariation(ped, true)
    		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
        end
	end
end)

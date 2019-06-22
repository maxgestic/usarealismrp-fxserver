--# Weapon components & tints shop, two kinds -- illegal and legal, each at different locations.
--# for USA REALISM RP
--# by: minipunch

local MENU_KEY = 38 -- "E"

local ITEMS = { -- must be kept in sync with one in sv_weaponeaxtrashop.lua --
  ["Tints"] = {
    legal = {
      [0] = {name = "Normal", price = 500},
      [1] = {name = "Green", price = 500},
      [2] = {name = "Gold", price = 500},
      [3] = {name = "Pink", price = 500},
      [4] = {name = "Army", price = 500},
      [5] = {name = "LSPD", price = 500},
      [6] = {name = "Orange", price = 500},
      [7] = {name = "Platinum", price = 500}
    },
    illegal = {
      [0] = {name = "Normal", price = 600},
      [1] = {name = "Green", price = 600},
      [2] = {name = "Gold", price = 600},
      [3] = {name = "Pink", price = 600},
      [4] = {name = "Army", price = 600},
      [5] = {name = "LSPD", price = 600},
      [6] = {name = "Orange", price = 600},
      [7] = {name = "Platinum", price = 600}
    }
  },
  ["Components"] = {
    legal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 200, weapon_hash = 453432689},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PISTOL_VARMOD_LUXE", price = 500, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Etched Wood Grip Finish", value = "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", price = 500, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 200, weapon_hash = -771403250},
        {name = "Etched Wood Grip Finish", value = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", price = 2000, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 200, weapon_hash = 1593441988},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", price = 3000, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 200, weapon_hash = -1716589765},
        {name = "Platinum Pearl Deluxe Finish", value = "COMPONENT_PISTOL50_VARMOD_LUXE", price = 500, weapon_hash = -1716589765}
      },
      ["Revolver"] = {
        {name = "Variation 1", value = "COMPONENT_REVOLVER_VARMOD_BOSS", price = 500, weapon_hash = -1045183535},
        {name = "Variation 2", value = "COMPONENT_REVOLVER_VARMOD_GOON", price = 500, weapon_hash = -1045183535}
      },
      -- Shotguns --
      ["Pump Shotgun"] = {
        {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 200, weapon_hash = 487013001},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", price = 500, weapon_hash = 487013001}
      },
      ["Bullpup Shotgun"] = {
        {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 250, weapon_hash = -1654528753}
      }
    },
    illegal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL_CLIP_02", price = 1500, weapon_hash = 453432689},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP_02", price = 1500, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_SNSPISTOL_CLIP_02", price = 1500, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_HEAVYPISTOL_CLIP_02", price = 1500, weapon_hash = -771403250},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 1500, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_COMBATPISTOL_CLIP_02", price = 1500, weapon_hash = 1593441988},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 1500, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL50_CLIP_02", price = 1500, weapon_hash = -1716589765},
        {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 1500, weapon_hash = -1716589765}
      },
      ["Vintage Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_VINTAGEPISTOL_CLIP_02", price = 1500, weapon_hash = 137902532},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 1500, weapon_hash = 137902532}
      },
      -- other --
      ["Switchblade"] = {
        {name = "Variation 1", value = "COMPONENT_SWITCHBLADE_VARMOD_VAR1", price = 400, weapon_hash = -538741184}
      },
      ["Brass Knuckles"] = {
        {name = "Stock", value = "COMPONENT_KNUCKLE_VARMOD_BASE", price = 500, weapon_hash = -656458692},
        {name = "Pimp", value = "COMPONENT_KNUCKLE_VARMOD_PIMP", price = 500, weapon_hash = -656458692},
        {name = "Ballas", value = "COMPONENT_KNUCKLE_VARMOD_BALLAS", price = 500, weapon_hash = -656458692},
        {name = "Dollars", value = "COMPONENT_KNUCKLE_VARMOD_DOLLAR", price = 500, weapon_hash = -656458692},
        {name = "Diamond", value = "COMPONENT_KNUCKLE_VARMOD_DIAMOND", price = 500, weapon_hash = -656458692},
        {name = "Hate", value = "COMPONENT_KNUCKLE_VARMOD_HATE", price = 500, weapon_hash = -656458692},
        {name = "Love", value = "COMPONENT_KNUCKLE_VARMOD_LOVE", price = 500, weapon_hash = -656458692},
        {name = "Player", value = "COMPONENT_KNUCKLE_VARMOD_PLAYER", price = 500, weapon_hash = -656458692},
        {name = "King", value = "COMPONENT_KNUCKLE_VARMOD_KING", price = 500, weapon_hash = -656458692},
        {name = "Vagos", value = "COMPONENT_KNUCKLE_VARMOD_VAGOS", price = 500, weapon_hash = -656458692}
      },
      ["Pump Shotgun"] = {
        {name = "Suppressor", value = "COMPONENT_AT_SR_SUPP", price = 2000, weapon_hash = 487013001}
      },
      ["SMG"] = {
        {name = "Extended Magazine", value = "COMPONENT_SMG_CLIP_02", price = 1500, weapon_hash = 736523883},
        {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO_02", price = 750, weapon_hash = 736523883},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 1500, weapon_hash = 736523883},
        {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 500, weapon_hash = 736523883},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_SMG_VARMOD_LUXE", price = 900, weapon_hash = 736523883}
      }
    }
  }
}

local locations = {
	{ x = -329.92, y = 6078.9, z = 31.6, legal = true }, -- paleto ammunation
  { x = 1691.6, y = 3757.4, z = 34.7, legal = true }, -- sandy shores ammunation
  { x = -1308.89, y = -390.27, z = 36.9, legal = true }, -- blvd. del perro ammunation
  { x = 249.1, y = -45.58, z = 70.1, legal = true }, -- spanish ave.
  { x  = -665.34, y = -938.9, z = 22.0, legal = true }, -- Linsday Circus
  { x = 17.701, y = -1110.00, z = 29.95, legal = true }, -- Adam's Apple Blvd.
  { x = 845.46, y = -1029.78, z = 28.4, legal = true }, -- Vespucci
  --{ x = 129.6, y = -1920.3, z = 21.3, legal = false } -- grove st
  { x = 752.996, y = -3192.206, z = 6.07, legal = false } -- terminal, industrial LS
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

----------------
-- add to GUI --
----------------
CreateTintMenu(legalShopMenu, true)
CreateTintMenu(illegalShopMenu, false)
CreateLegalExtrasMenu(legalShopMenu)
CreateIllegalExtrasMenu(illegalShopMenu)
_menuPool:RefreshIndex()

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
      if dist < 2.0 then
        DrawText3D(locations[i].x,locations[i].y,locations[i].z, '[E] - Weapon Extras')
        closest_shop = locations[i]
        isCloseToAny = true
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

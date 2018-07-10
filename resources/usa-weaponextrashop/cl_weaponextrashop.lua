--# Weapon components & tints shop, two kinds -- illegal and legal, each at different locations.
--# for USA REALISM RP
--# by: minipunch

local MENU_KEY = 38 -- "E"

local ITEMS = { -- must be kept in sync with one in sv_weaponeaxtrashop.lua --
  ["Tints"] = {
    [0] = {name = "Normal", price = 100},
    [1] = {name = "Green", price = 400},
    [2] = {name = "Gold", price = 1000},
    [3] = {name = "Pink", price = 600},
    [4] = {name = "Army", price = 500},
    [5] = {name = "LSPD", price = 600},
    [6] = {name = "Orange", price = 500},
    [7] = {name = "Platinum", price = 1000}
  },
  ["Components"] = {
    legal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 453432689},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PISTOL_VARMOD_LUXE", price = 3000, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Etched Wood Grip Finish", value = "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", price = 2000, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = -771403250},
        {name = "Etched Wood Grip Finish", value = "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", price = 2000, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 1593441988},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", price = 3000, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = -1716589765},
        {name = "Platinum Pearl Deluxe Finish", value = "COMPONENT_PISTOL50_VARMOD_LUXE", price = 2700, weapon_hash = -1716589765}
      },
      ["Revolver"] = {
        {name = "Variation 1", value = "COMPONENT_REVOLVER_VARMOD_BOSS", price = 1200, weapon_hash = -1045183535},
        {name = "Variation 2", value = "COMPONENT_REVOLVER_VARMOD_GOON", price = 1200, weapon_hash = -1045183535}
      },
      -- Shotguns --
      ["Pump Shotgun"] = {
        {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 900, weapon_hash = 487013001},
        {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", price = 3000, weapon_hash = 487013001}
      },
      ["Bullpup Shotgun"] = {
        {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 700, weapon_hash = -1654528753}
      }
    },
    illegal = {
      -- pistols --
      ["Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL_CLIP_02", price = 4500, weapon_hash = 453432689},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP_02", price = 6000, weapon_hash = 453432689}
      },
      ["SNS Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_SNSPISTOL_CLIP_02", price = 4500, weapon_hash = -1076751822}
      },
      ["Heavy Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_HEAVYPISTOL_CLIP_02", price = 4500, weapon_hash = -771403250},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = -771403250}
      },
      ["Combat Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_COMBATPISTOL_CLIP_02", price = 4500, weapon_hash = 1593441988},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 1593441988}
      },
      [".50 Cal Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_PISTOL50_CLIP_02", price = 4500, weapon_hash = -1716589765},
        {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6000, weapon_hash = -1716589765}
      },
      ["Vintage Pistol"] = {
        {name = "Extended Magazine", value = "COMPONENT_VINTAGEPISTOL_CLIP_02", price = 4500, weapon_hash = 137902532},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 137902532}
      },
      ["AP Pistol"] = {
        {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 900, weapon_hash = 584646201},
        {name = "Extended Magazine", value = "COMPONENT_APPISTOL_CLIP_02", price = 4500, weapon_hash = 584646201},
        {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 584646201},
        {name = "Gilded Gun Metal Finish", value = "COMPONENT_APPISTOL_VARMOD_LUXE", price = 2700, weapon_hash = 584646201}
      },
      -- other --
      ["Switchblade"] = {
          {name = "Variation 1", value = "COMPONENT_SWITCHBLADE_VARMOD_VAR1", price = 2500, weapon_hash = -538741184}
      },
      ["Brass Knuckles"] = {
        {name = "Stock", value = "COMPONENT_KNUCKLE_VARMOD_BASE", price = 500, weapon_hash = -656458692},
        {name = "Pimp", value = "COMPONENT_KNUCKLE_VARMOD_PIMP", price = 900, weapon_hash = -656458692},
        {name = "Ballas", value = "COMPONENT_KNUCKLE_VARMOD_BALLAS", price = 900, weapon_hash = -656458692},
        {name = "Dollars", value = "COMPONENT_KNUCKLE_VARMOD_DOLLAR", price = 900, weapon_hash = -656458692},
        {name = "Diamond", value = "COMPONENT_KNUCKLE_VARMOD_DIAMOND", price = 900, weapon_hash = -656458692},
        {name = "Hate", value = "COMPONENT_KNUCKLE_VARMOD_HATE", price = 900, weapon_hash = -656458692},
        {name = "Love", value = "COMPONENT_KNUCKLE_VARMOD_LOVE", price = 900, weapon_hash = -656458692},
        {name = "Player", value = "COMPONENT_KNUCKLE_VARMOD_PLAYER", price = 900, weapon_hash = -656458692},
        {name = "King", value = "COMPONENT_KNUCKLE_VARMOD_KING", price = 900, weapon_hash = -656458692},
        {name = "Vagos", value = "COMPONENT_KNUCKLE_VARMOD_VAGOS", price = 900, weapon_hash = -656458692}
      },
      ["Sawn Off Shotgun"] = {
          {name = "Gilded Gun Metal Finish", value = "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE", price = 2500, weapon_hash = 2017895192}
      },
      ["Pump Shotgun"] = {
          {name = "Suppressor", value = "COMPONENT_AT_SR_SUPP", price = 6200, weapon_hash = 487013001}
      },
      ["Micro SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_MICROSMG_CLIP_02", price = 4500, weapon_hash = 324215364},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = 324215364},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6000, weapon_hash = 324215364},
          {name = "Flashlight", value = "COMPONENT_AT_PI_FLSH", price = 1500, weapon_hash = 324215364},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_MICROSMG_VARMOD_LUXE", price = 3000, weapon_hash = 324215364}
      },
      ["SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_SMG_CLIP_02", price = 4500, weapon_hash = 736523883},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO_02", price = 5500, weapon_hash = 736523883},
          {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = 736523883},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 1500, weapon_hash = 736523883},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_SMG_VARMOD_LUXE", price = 3000, weapon_hash = 736523883}
      },
      ["Machine Pistol"] = {
          {name = "Extended Magazine", value = "COMPONENT_MACHINEPISTOL_CLIP_02", price = 4500, weapon_hash = -619010992},
          {name = "Suppressor", value = "COMPONENT_AT_PI_SUPP", price = 6000, weapon_hash = -619010992}
      },
      ["Tommy Gun"] = {
          {name = "Extended Magazine", value = "COMPONENT_GUSENBERG_CLIP_02", price = 4500, weapon_hash = 1627465347}
      },
      ["AK47"] = {
          {name = "Extended Magazine", value = "COMPONENT_ASSAULTRIFLE_CLIP_02", price = 3500, weapon_hash = -1074790547},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = -1074790547},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6500, weapon_hash = -1074790547},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = -1074790547},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -1074790547},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE", price = 4000, weapon_hash = -1074790547}
      },
      ["Carbine Rifle"] = {
          {name = "Extended Magazine", value = "COMPONENT_CARBINERIFLE_CLIP_02", price = 4500, weapon_hash = -2084633992},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MEDIUM", price = 5500, weapon_hash = -2084633992},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP", price = 6500, weapon_hash = -2084633992},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = -2084633992},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -2084633992},
          {name = "Rail Cover", value = "COMPONENT_AT_RAILCOVER_01", price = 3500, weapon_hash = -2084633992},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_CARBINERIFLE_VARMOD_LUXE", price = 4000, weapon_hash = -2084633992}
      },
      ["Bullpup Rifle"] = {
          {name = "Extended Magazine", value = "COMPONENT_BULLPUPRIFLE_CLIP_02", price = 4500, weapon_hash = 2132975508},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_SMALL", price = 5500, weapon_hash = 2132975508},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP", price = 6500, weapon_hash = 2132975508},
          {name = "Grip", value = "COMPONENT_AT_AR_AFGRIP", price = 3500, weapon_hash = 2132975508},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = 2132975508},
          {name = "Gilded Gun Metal Finish", value = "COMPONENT_BULLPUPRIFLE_VARMOD_LOW", price = 4000, weapon_hash = 2132975508}
      },
      ["Assault SMG"] = {
          {name = "Extended Magazine", value = "COMPONENT_ASSAULTSMG_CLIP_02", price = 4500, weapon_hash = -270015777},
          {name = "Scope", value = "COMPONENT_AT_SCOPE_MACRO", price = 5500, weapon_hash = -270015777},
          {name = "Suppressor", value = "COMPONENT_AT_AR_SUPP_02", price = 6500, weapon_hash = -270015777},
          {name = "Flashlight", value = "COMPONENT_AT_AR_FLSH", price = 3500, weapon_hash = -270015777},
          {name = "Yusuf Amir Luxury Finish", value = "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER", price = 4000, weapon_hash = -270015777}
      }
    }
  }
}

local locations = {
	{ x = -332.2, y = 6082.1, z = 31.5, legal = true }, -- paleto ammunation
  { x = 1691.6, y = 3757.4, z = 34.7, legal = true }, -- sandy shores ammunation
  { x = -1305.0, y = -391.1, z = 36.7, legal = true }, -- blvd. del perro ammunation
  { x = 253.1, y = -47.2, z = 69.9, legal = true }, -- spanish ave.
  { x  = -665.2, y = -935.4, z = 21.8, legal = true }, -- Linsday Circus
  { x = 19.3, y = -1106.3, z = 29.8, legal = true }, -- Adam's Apple Blvd.
  { x = 845.1, y = -1033.6, z = 28.2, legal = true }, -- Vespucci
  --{ x = 129.6, y = -1920.3, z = 21.3, legal = false } -- grove st
  { x = 181.4, y = 2792.8, z = 45.7, legal = false } -- sandy shores, harmony
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
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,true) < 1.3 then
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

function CreateTintMenu(menu)
  local submenu = _menuPool:AddSubMenu(menu, "Tints", "See our selection of Tints", true --[[KEEP POSITION]])
  table.insert(created_menus, submenu)
  for id, info in pairs(ITEMS["Tints"]) do
    -------------------
    -- Tint options  --
    -------------------
    local item = NativeUI.CreateItem(info.name, "Purchase price: $" .. comma_value(info.price))
    item.Activated = function(parentmenu, selected)
      local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
      TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
        local equipped_weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        TriggerServerEvent("weaponExtraShop:requestTintPurchase", id, equipped_weapon, property)
      end)
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
        TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
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
        end)
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
        TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
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
        end)
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
CreateTintMenu(legalShopMenu)
CreateTintMenu(illegalShopMenu)
CreateLegalExtrasMenu(legalShopMenu)
CreateIllegalExtrasMenu(illegalShopMenu)
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
    local closest_shop = isPlayerAtWeaponExtraShop()
    if closest_shop then
      drawTxt("Press [~y~E~w~] to open the weapon extra shop menu",7,1,0.5,0.8,0.5,255,255,255,255)
    else
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

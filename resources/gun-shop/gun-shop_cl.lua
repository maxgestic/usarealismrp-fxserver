--# Gun store that also inserts a firearm permit.
--# For this to work without modification, you will need the latest copy of the usa_rp resource
--# Created for USA REALISM RP
--# by: minipunch
local MENU_KEY = 38 -- "E"
local playerWeapons
local locations = {
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
	{ x=810.295, y=-2157.112, z=28.6190 }
}

local created_menus = {}

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

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Ammunation", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

table.insert(created_menus, mainMenu)

--------------------------------
-- Construct GUI menu buttons --
--------------------------------
function CreateWeaponShopMenu(menu)
  ----------------------------
  -- Purchase permit button --
  ----------------------------
  local item = NativeUI.CreateItem("Purchase Firearm License", "Purchase price: $2,000")
  item:SetLeftBadge(BadgeStyle.Star)
  item.Activated = function(parentmenu, selected)
    local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
    TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
      TriggerServerEvent("gunShop:buyPermit", property)
      --item:SetLeftBadge(BadgeStyle.None)
    end)
  end
  menu:AddItem(item)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, weapons in pairs(storeWeapons) do
    local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. category, true --[[KEEP POSITION]])
		table.insert(created_menus, submenu)
    for i = 1, #weapons do
      ---------------------------------------------
      -- Button for each weapon in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(weapons[i].name, "Purchase price: $" .. comma_value(weapons[i].price))
      item.Activated = function(parentmenu, selected)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
        TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
          TriggerServerEvent("gunShop:requestPurchase", category, i, property)
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
CreateWeaponShopMenu(mainMenu)
_menuPool:RefreshIndex()

-------------------------------------------
-- open menu when near gun shop location --
-------------------------------------------
Citizen.CreateThread(function()
	local menu_opened = false
	local closest_location = nil
  while true do
    Citizen.Wait(0)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:ProcessMenus()
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
		-- see if close to any stores --
    for i = 1, #locations do
      if Vdist(mycoords.x, mycoords.y, mycoords.z, locations[i].x, locations[i].y, locations[i].z) < 50.0 then
        DrawMarker(27, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
        if IsControlJustPressed(1, MENU_KEY) and not IsAnyMenuVisible() then
          if Vdist(mycoords.x, mycoords.y, mycoords.z, locations[i].x, locations[i].y, locations[i].z) < 1.3 then
            mainMenu:Visible(not mainMenu:Visible())
						closest_location = locations[i]
          end
        end
      end
    end
		-- close menu when far away --
		if closest_location then
			if Vdist(mycoords.x, mycoords.y, mycoords.z, closest_location.x, closest_location.y, closest_location.z) > 1.3 then
				if IsAnyMenuVisible() then
					closest_location = nil
					CloseAllMenus()
				end
			end
		end
  end
end)

RegisterNetEvent("mini:equipWeapon")
AddEventHandler("mini:equipWeapon", function(source, hash, name)
	local playerPed = GetPlayerPed(-1)
	if hash ~= GetHashKey("GADGET_PARACHUTE") then	--Dont auto equip parachutes from gunstore
		GiveWeaponToPed(playerPed, hash, 60, false, true)
	end
end)

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = {
  {x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
}
Citizen.CreateThread(function()
	for i = 1, #JOB_PEDS do
		local hash = -1064078846
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
		SetEntityInvincible(ped)
		SetPedRandomComponentVariation(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true);
	end
end)

--# Gun store that also inserts a firearm permit.
--# For this to work without modification, you will need the latest copy of the usa_rp resource
--# Created for USA REALISM RP
--# by: minipunch
local MENU_KEY = 38 -- "E"
local playerWeapons
local locations = {
	{ x=-331.17, y=6084.47, z=31.59 },
	{ x=-3172.96, y=1088.03, z=21.00 },
	{ x=-1118.53, y=2699.26, z=18.68 },
	{ x=1692.75, y=3760.52, z=34.9 },
	{ x=253.23, y=-50.22, z= 70.1 },
	{ x=-1304.72, y=-394.31, z=36.80 },
	{ x=-662.33, y=-934.23, z=21.95 },
	{ x=22.34, y=-1106.102, z=29.90},
	{ x=842.65, y=-1034.57, z=28.35 },
	{ x=2568.14, y=293.26, z=108.92 },
	{ x=810.37, y=-2158.36, z=29.81 }
}

local purchasedWeapons = 0

local STORE_ITEMS = {}

TriggerServerEvent("gunShop:getItems")

RegisterNetEvent("gunShop:getItems")
AddEventHandler("gunShop:getItems", function(items)
	STORE_ITEMS = items
	CreateWeaponShopMenu(mainMenu)
	_menuPool:RefreshIndex()
end)

-- create map blips --
for i = 1, #locations do
  local blip = AddBlipForCoord(locations[i].x, locations[i].y, locations[i].z)
  SetBlipSprite(blip, 119)
  SetBlipDisplay(blip, 4)
  SetBlipScale(blip, 0.8)
  SetBlipColour(blip, 50)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Gun Store')
  EndTextCommandSetBlipName(blip)
end

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

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Ammunation", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

--------------------------------
-- Construct GUI menu buttons --
--------------------------------
function CreateWeaponShopMenu(menu)
  -----------------------------------
  -- Adds button for each category --
  -----------------------------------
  for category, weapons in pairs(STORE_ITEMS) do
    local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. category, true --[[KEEP POSITION]])
    for i = 1, #weapons do
      ---------------------------------------------
      -- Button for each weapon in each category --
      ---------------------------------------------
      local item = NativeUI.CreateItem(weapons[i].name, "Purchase price: $" .. comma_value(weapons[i].price))
      item.Activated = function(parentmenu, selected)
        local business = exports["usa-businesses"]:GetClosestStore(15)
         TriggerServerEvent("gunShop:requestPurchase", category, i, business)
      end
      ----------------------------------------
      -- add to sub menu created previously --
      ----------------------------------------
      submenu.SubMenu:AddItem(item)
    end
  end
end

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
    	DrawText3D(locations[i].x, locations[i].y, locations[i].z, 5, '[E] - Ammunation')
    	if IsControlJustPressed(1, MENU_KEY) and not _menuPool:IsAnyMenuOpen() then
				if Vdist(mycoords.x, mycoords.y, mycoords.z, locations[i].x, locations[i].y, locations[i].z) < 1.3 then
					Wait(500)
					if not IsControlPressed(1, MENU_KEY) then -- not held
	    			TriggerServerEvent('gunShop:requestOpenMenu')
						closest_location = locations[i]
					else -- held
						local business = exports["usa-businesses"]:GetClosestStore(15)
						TriggerServerEvent("gunShop:purchaseLicense", business)
					end
				end
    	end
    end
		-- close menu when far away --
		if closest_location then
      if Vdist(mycoords.x, mycoords.y, mycoords.z, closest_location.x, closest_location.y, closest_location.z) > 1.3 then
        if _menuPool then
          if _menuPool:IsAnyMenuOpen() then
            closest_location = nil
            _menuPool:CloseAllMenus()
          end
        end
			end
		end
  end
end)

RegisterNetEvent("mini:equipWeapon")
AddEventHandler("mini:equipWeapon", function(hash, attachments)
	local playerPed = GetPlayerPed(-1)
	if hash ~= GetHashKey("GADGET_PARACHUTE") then	--Dont auto equip parachutes from gunstore
		GiveWeaponToPed(playerPed, hash, 60, false, true)
		if attachments then
			for i = 1, #attachments do
				if type(attachments[i]) ~= "number" then
					GiveWeaponComponentToPed(playerPed, hash, GetHashKey(attachments[i]))
				else
					GiveWeaponComponentToPed(playerPed, hash, attachments[i])
				end
			end
		end
	end
end)

RegisterNetEvent('gunShop:openMenu')
AddEventHandler('gunShop:openMenu', function()
	mainMenu:Visible(not mainMenu:Visible())
end)

RegisterNetEvent('gunShop:addRecentlyPurchased')
AddEventHandler('gunshop:addRecentlyPurchased', function()
  purchasedWeapons = purchasedWeapons + 1
  if purchasedWeapons > 3 then
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed))
    local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
    local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
    TriggerServerEvent('911:SuspiciousWeaponBuying', x, y, z, lastStreetNAME, IsPedMale(playerPed))
  end
end)

RegisterNetEvent("gunShop:showCCWTerms")
AddEventHandler("gunShop:showCCWTerms", function()
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^01) The license holder is legally allowed to carry a weapon so long as it remains ^3CONCEALED^0 at all times.")
	Wait(4000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^02) If contacted by a law enforcement officer for any reason, and the license holder is armed, the license holder shall immediately inform the officer they are a CCW licensee and when the officer requests the license holder’s CCW license, the license holder will provide their CCW license as proof they are legally carrying a concealed weapon.")
	Wait(9000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^03) License holder shall surrender the CCW license and/or concealed weapon to any sworn peace officer upon demand.")
	Wait(5000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^04) License holder shall not unnecessarily display or expose the concealed weapon or license.")
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(90000)
    if purchasedWeapons > 0  then
      purchasedWeapons = purchasedWeapons - 1
    end
  end
end)

--------------------
-- Spawn job peds --
--------------------
local JOB_PEDS = {
  --{x = -331.043, y = 6086.09, z = 30.40, heading = 180.0}
}

Citizen.CreateThread(function()
	for i = 1, #JOB_PEDS do
		local hash = -1064078846
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

function ShowCCWTerms(src)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^01) The license holder is legally allowed to carry a weapon so long as it remains ^3CONCEALED^0 at all times.")
	Wait(4000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^02) If contacted by a law enforcement officer for any reason, and the license holder is armed, the license holder shall immediately inform the officer they are a CCW licensee and when the officer requests the license holder’s CCW license, the license holder will provide their CCW license as proof they are legally carrying a concealed weapon.")
	Wait(9000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^03) License holder shall surrender the CCW license and/or concealed weapon to any sworn peace officer upon demand.")
	Wait(5000)
	TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^04) License holder shall not unnecessarily display or expose the concealed weapon or license.")
end

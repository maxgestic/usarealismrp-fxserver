local MENU_KEY = 38 -- "E"
local closest_shop = nil

local markets = {
    ['marketA'] = {
        ['coords'] = {363.83, -1830.4, 28.5},
        ['pedHash'] = GetHashKey('u_m_y_pogo_01'),
        ['pedHeading'] = 0.0,
        ['items'] = {
            {name = 'Pistol', type = 'weapon', hash = 453432689, price = 3000, legality = 'illegal', quantity = 1, weight = 10, objectModel = "w_pi_pistol"},
            {name = 'Vintage Pistol', type = 'weapon', hash = 137902532, price = 4000, legality = 'illegal', quantity = 1, weight = 10, objectModel = "w_pi_vintage_pistol"},
            {name = 'Heavy Pistol', type = 'weapon', hash = -771403250, price = 4500, legality = 'illegal', quantity = 1, weight = 15, objectModel = "w_pi_heavypistol"},
            {name = 'Pistol .50', type = 'weapon', hash = -1716589765, price = 4500, legality = 'illegal', quantity = 1, weight = 18, objectModel = "w_pi_pistol50"},
            {name = 'Pump Shotgun', type = 'weapon', hash = 487013001, price = 9000, legality = 'illegal', quantity = 1, weight = 30, objectModel = "w_sg_pumpshotgun"},
            {name = 'Razor Blade', type = 'misc', price = 500, legality = 'legal', quantity = 1, residue = false, weight = 3},
            {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10}
        }
    },
    ['marketB'] = {
        ['coords'] = {1380.87, 2172.51, 97.81},
        ['pedHash'] = GetHashKey('g_m_m_chiboss_01'),
        ['pedHeading'] = 88.0,
        ['items'] = {
            {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10},
            {name = 'Razor Blade', type = 'misc', price = 500, legality = 'legal', quantity = 1, residue = false, weight = 3},
            {name = 'SMG', type = 'weapon', hash = 736523883, price = 200000, legality = 'illegal', quantity = 1, weight = 55, objectModel = "w_sb_smg"},
            {name = 'Heavy Shotgun', type = 'weapon', hash = 984333226, price = 8000, legality = 'illegal', quantity = 1, weight = 35, objectModel = "w_sg_heavyshotgun"},
            {name = 'SNS Pistol', type = 'weapon', hash = -1076751822, price = 3500, legality = 'illegal', quantity = 1, weight = 8, objectModel = "w_pi_sns_pistol"},
            {name = 'Combat Pistol', type = 'weapon', hash = 1593441988, price = 3500, legality = 'illegal', quantity = 1, weight = 10, objectModel = "w_pi_combatpistol"},
            {name = 'Switchblade', type = 'weapon', hash = -538741184, price = 1500, legality = 'illegal', quantity = 1, weight = 5},
            {name = 'Brass Knuckles', type = 'weapon', hash = -656458692, price = 1100, legality = 'illegal', quantity = 1, weight = 5},
        }
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
mainMenu = NativeUI.CreateMenu("Black Market", "~b~What are you looking for?", 0 --[[X COORD]], 320 --[[Y COORD]])
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
    for k, v in pairs(markets) do
        local x, y, z = table.unpack(markets[k]['coords'])
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < 5 then
            for i = 1, #markets[k]['items'] do
                local item = NativeUI.CreateItem(markets[k]['items'][i].name, "Purchase price: $" .. comma_value(markets[k]['items'][i].price))
                item.Activated = function(parentmenu, selected)
                  TriggerServerEvent("blackMarket:requestPurchase", k, i)
                end
                menu:AddItem(item)
            end
        end
    end
end

function IsPlayerAtBlackMarket()
    local atblackmarket = false
    for k, v in pairs(markets) do
        local x, y, z = table.unpack(markets[k]['coords'])
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < 5 then
            closest_shop = k
            atblackmarket = true
        end
    end
    if atblackmarket then return true else return false end
end

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
    	for k, v in pairs(markets) do
            local x, y, z = table.unpack(markets[k]['coords'])
    		DrawText3D(x, y, z, 8, '[E] - Black Market')
    	end
        --------------------------
        -- Listen for menu open --
        --------------------------
		if IsControlJustPressed(1, MENU_KEY) then
			if IsPlayerAtBlackMarket() then
                mainMenu:Clear()
                CreateItemList(mainMenu)
                mainMenu:Visible(not mainMenu:Visible())
			end
		end

        if mainMenu:Visible() then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local x, y, z = table.unpack(markets[closest_shop]['coords'])
            if Vdist(playerCoords, x, y, z) > 5.0 then
                mainMenu:Visible(false)
            end
        end
	end
end)

Citizen.CreateThread(function()
    for k, v in pairs(markets) do
        local mkt = markets[k]
        RequestModel(mkt['pedHash'])
        while not HasModelLoaded(mkt['pedHash']) do
            Citizen.Wait(100)
        end
        local ped = CreatePed(4, mkt['pedHash'], mkt['coords'][1], mkt['coords'][2], mkt['coords'][3] - 1.0, mkt['pedHeading'], false, true)
        SetEntityCanBeDamaged(ped,false)
        SetPedCanRagdollFromPlayerImpact(ped,false)
        SetBlockingOfNonTemporaryEvents(ped,true)
        SetPedFleeAttributes(ped,0,0)
        SetPedCombatAttributes(ped,17,1)
        SetPedRandomComponentVariation(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, true);
    end
end)

function DrawText3D(x, y, z, distance, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
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
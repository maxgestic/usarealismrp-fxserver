local LOCATIONS = {
    {x = 1986.0, y = 3054.3, z = 47.3}, -- yellow jack
    {x = -560.2, y = 286.7, z = 82.3}, -- tequilala
    {x = -1393.6, y = -606.6, z = 30.4}, -- bahama mamas
    {x = 127.4, y = -1284.6, z = 29.3} -- vanilla unicorn
}

local ITEMS = {} -- loaded from server
TriggerServerEvent("bars:loadItems")

local MENU_OPEN_KEY = 38

local closest_bar = nil

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Bar", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

RegisterNetEvent("bars:loadItems")
AddEventHandler("bars:loadItems", function(items)
  ITEMS = items
  -----------------
  -- Create Menu --
  -----------------
  CreateBarMenu(mainMenu)
  _menuPool:RefreshIndex()
end)

function CreateBarMenu(menu)
    for category, items in pairs(ITEMS) do
        local submenu = _menuPool:AddSubMenu(menu, category, "See our selection of " .. string.lower(category), true --[[KEEP POSITION]])
        for name, info in pairs(items) do
            local item = NativeUI.CreateItem(name, "($" .. comma_value(info.price) .. ") " .. (info.caption or ""))
            item.Activated = function(parentmenu, selected)
                TriggerServerEvent("bars:buy", category, name)
                local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
                TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
                    TriggerServerEvent("bars:buy", category, name, property)
                end)
            end
            submenu:AddItem(item)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- vars --
        local me = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(me, false)

        -- Process Menu --
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()

        for i = 1, #LOCATIONS do
			if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,LOCATIONS[i].x,LOCATIONS[i].y,LOCATIONS[i].z)  <  50 then
				DrawMarker(27, LOCATIONS[i].x, LOCATIONS[i].y, LOCATIONS[i].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 90, 0, 0, 2, 0, 0, 0, 0)
				if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,LOCATIONS[i].x,LOCATIONS[i].y,LOCATIONS[i].z)  <  2 then
					drawTxt("Press [~y~E~w~] to access the bar",7,1,0.5,0.8,0.5,255,255,255,255)
					if IsControlJustPressed(1, MENU_OPEN_KEY) then
							closest_bar = LOCATIONS[i] --// set shop player is at
							if not _menuPool:IsAnyMenuOpen() then
                                -- open menu --
                                mainMenu:Visible(true)
							else
                                -- close menu --
								_menuPool:CloseAllMenus()
							end
					end
				else
					if closest_bar then
						closest_bar = nil
						if _menuPool:IsAnyMenuOpen() then
							_menuPool:CloseAllMenus()
						end
					end
				end
			end
		end
    end
end)

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

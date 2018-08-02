local MENU_KEY = 38 -- "E"

local locations = {
	--{ x=-447.723, y=6013.65, z=30.700 },
	--{ x=441.301, y=-981.434, z=29.689 },
	--{ x=1853.616, y=3687.966, z=33.267 },
	-- {x = -544.857, y = -204.422, z = 37.2152} -- LS
	{x= -447.845, y = 6013.775, z = 31.719}, -- paleto
	{x = 1855.458, y = 3688.599, z = 34.273} -- sandy
}

local DL_PRICE = 250

function isPlayerAtDMV()
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	for i = 1, #locations do
		if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,locations[i].x,locations[i].y,locations[i].z,false) < 2.0 then
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
mainMenu = NativeUI.CreateMenu("DMV", "~b~Department of Motor Vehicles", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateDMVMenu(menu)
  ----------------------
  -- Purchase License --
  ----------------------
  local item = NativeUI.CreateItem("Driver's License", "Purchase price: $" .. DL_PRICE)
  item.Activated = function(parentmenu, selected)
    TriggerServerEvent("dmv:buyLicense")
  end
  menu:AddItem(item)
	-------------------------
	-- See any suspensions --
	-------------------------
	local item = NativeUI.CreateItem("Suspensions", "Purchase price: $" .. DL_PRICE)
	item.Activated = function(parentmenu, selected)
		TriggerServerEvent("dmv:getLicenseStatus")
	end
	menu:AddItem(item)
end

----------------
-- add to GUI --
----------------
CreateDMVMenu(mainMenu)
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
    if isPlayerAtDMV() then
      drawTxt("Press [~y~E~w~] to open the DMV menu",7,1,0.5,0.8,0.5,255,255,255,255)
    else
      if mainMenu:Visible() then
        mainMenu:Visible(false)
      end
    end
    --------------------------
    -- Listen for menu open --
    --------------------------
		if IsControlJustPressed(1, MENU_KEY) then
			if isPlayerAtDMV() then
        mainMenu:Visible(not mainMenu:Visible())
			end
		end
	end
end)

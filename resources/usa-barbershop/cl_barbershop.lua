--# made by: minipunch
--# for: USA REALISM RP

local BARBER_SHOPS = {
  {x = -279.154, y = 6226.192, z = 31.705}, -- paleto,
  {x = -34.97777557373, y = -150.9037322998, z = 57.086517333984},
  {x = 1211.0759277344, y = -475.00064086914, z = 66.218032836914},
  {x = 1934.115234375, y = 3730.7399902344, z = 32.854434967041},
  {x = -1281.9802246094, y = -1119.6861572266, z = 7.0001249313354},
  {x = 139.21583557129, y = -1708.9689941406, z = 29.301620483398},
  {x = -815.59008789063, y = -182.16806030273, z = 37.568920135498}
}

local purchases = {}

local closest_shop = nil --// keep track of closest shop to help keep track of shop player is currently at

local old_head = {
  parent1 = 0,
  --parent2 = 23,
  parent3 = 25,
  parent2 = 0,
  skin1 = 0,
  --skin2 = 2,
  skin3 = 20,
  skin2 = 0,
  mix1 = 0.5,
  mix2 = 0.5,
  mix3 = 0.0,
  isParent = false,
  other = {
    {"Blemishes", 255, 23},
    {"Facial Hair", 255, 28, 0},
    {"Eyebrows", 255, 33, 0},
    {"Ageing", 255, 14},
    {"Makeup", 255, 74},
    {"Blush", 255, 6, 0},
    {"Complexion", 255, 11},
    {"Sun Damage", 255, 10},
    {"Lipstick", 255, 9, 0},
    {"Moles/Freckles", 255, 17},
    {"Chest Hair", 255, 16, 0},
    {"Body Blemishes", 255, 11},
    {"Add Body Blemishes", 255, 1},
    {"Hair", 0, 100, 0} -- change max ?
  }
}

local MENU_OPEN_KEY = 38

local MAX_PARENT_OPTIONS = 45
local MAX_COLOR_OPTIONS = 85

---------------------------
-- Set up main menu --
---------------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Barber Shop", "~b~Herr Kutz Barber", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

-- Functions --
function UpdateHead(ped, head)
  -- customize head stuff, like beards and skin tone and what not --
  SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
  --[[ customize face features --
  if face then
    local i = 0
    for name, value in pairs(face) do
      print("name: " .. name)
      print("setting index " .. i .. " to value: " .. value / 100.0)
      SetPedFaceFeature(ped, i, value / 100.0)
      i = i + 1
    end
  end
  --]] -- on hold cause it wouldn't work
  -- facial stuff like beards and ageing and what not --
  for i = 1, #head.other do
    SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
    if head.other[i][2] ~= 255 then
      if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
        SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
      elseif i == 6 or i == 9 then -- blush, lipstick
        SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
      elseif i == 14 then -- hair
        SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
        SetPedHairColor(ped, head.other[i][4], 0)
      end
    end
  end
end

function SetPedDefaultHead(ped)
  -- head & skin details --
  old_head.other = {
    {"Blemishes", 255, 23},
    {"Facial Hair", 255, 28, 0},
    {"Eyebrows", 255, 33, 0},
    {"Ageing", 255, 14},
    {"Makeup", 255, 74},
    {"Blush", 255, 6, 0},
    {"Complexion", 255, 11},
    {"Sun Damage", 255, 10},
    {"Lipstick", 255, 9, 0},
    {"Moles/Freckles", 255, 17},
    {"Chest Hair", 255, 16, 0},
    {"Body Blemishes", 255, 11}, -- same here, also test going on/off duty for ems/police
    {"Add Body Blemishes", 255, 1}, -- see if necessary
    {"Hair", 0, 100, 0}
  }
  --SetPedHeadBlendData(ped, old_head.parent1, old_head.parent2, old_head.parent3, old_head.skin1, old_head.skin2, old_head.skin3, old_head.mix1, old_head.mix2, old_head.mix3, false) -- needed to apply head overlays like facial hair
  for i = 1, #old_head.other do
    SetPedHeadOverlay(ped, i - 1, 255, 1.0)
    --[[
    if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
      SetPedHeadOverlayColor(ped, i - 1, 1, old_head.other[i][3])
    elseif i == 6 or i == 9 then -- blush, lipstick
      SetPedHeadOverlayColor(ped, i - 1, 2, old_head.other[i][3])
    end
    --]]
  end
end

RegisterNetEvent("barber:loadCustomizations")
AddEventHandler("barber:loadCustomizations", function(customizations)
  old_head.parent1 = customizations.parent1
  old_head.parent2 = customizations.parent2
  old_head.parent3 = customizations.parent3
  old_head.skin1 = customizations.skin1
  old_head.skin2 = customizations.skin2
  old_head.skin3 = customizations.skin3
  old_head.isParent = customizations.isParent
  old_head.other = customizations.other
end)

-- Main Menu --
function CreateBarberShopMenu(menu)
    --// overview:
    -- parent and skin color submenu
    -- customization buttons
    -- checkout button
    -- reset button
    -- exit button

    ---------------------------------------
    -- Parent / Skin Color Buttons --
    ---------------------------------------
    local parentValuesArr = {}
    for j = 1, MAX_PARENT_OPTIONS do parentValuesArr[j] = j end

    local parent_item_1 = UIMenuSliderItem.New("Parent 1", parentValuesArr, 1, "Customize Parent 1")
    parent_item_1.OnSliderChanged = function(menu, item, index)
        old_head.parent1 = index
        UpdateHead(GetPlayerPed(-1), old_head)
    end
    menu:AddItem(parent_item_1)

    local parent_item_2 = UIMenuSliderItem.New("Parent 2", parentValuesArr, 1, "Customize Parent 2")
    parent_item_2.OnSliderChanged = function(menu, item, index)
        old_head.parent2 = index
        UpdateHead(GetPlayerPed(-1), old_head)
    end
    menu:AddItem(parent_item_2)

    local skin_item_1 = UIMenuSliderItem.New("Skin 1", parentValuesArr, 1, "Customize Skin 1")
    skin_item_1.OnSliderChanged = function(menu, item, index)
        old_head.skin1 = index
        UpdateHead(GetPlayerPed(-1), old_head)
    end
    menu:AddItem(skin_item_1)

    local skin_item_2 = UIMenuSliderItem.New("Skin 2", parentValuesArr, 1, "Customize Skin 2")
    skin_item_2.OnSliderChanged = function(menu, item, index)
        old_head.skin2 = index
        UpdateHead(GetPlayerPed(-1), old_head)
    end
    menu:AddItem(skin_item_2)

    ---------------------------------
    -- Customization Buttons --
    ---------------------------------
    for i = 1, #old_head.other do
        local option_name =  old_head.other[i][1]
        local max_options = old_head.other[i][3]
        local valuesArr = {}
        for j = 1, max_options do
            valuesArr[j] = j
        end
        local newitem = UIMenuSliderItem.New(option_name, valuesArr, 1, "Customize " .. old_head.other[i][1])
        newitem.OnSliderChanged = function(menu, item, index)
            old_head.other[i][2] = index
            UpdateHead(GetPlayerPed(-1), old_head)
        end
        menu:AddItem(newitem)
        -- Color variations --
        if i == 2 or i == 3 or i == 11 or i == 6 or i == 9 or i == 14 then
            local colorArr = {}
            for j = 1, MAX_COLOR_OPTIONS do colorArr[j] = j end
            local newVariationitem = UIMenuSliderItem.New(option_name .. " color", colorArr, 1, "Customize " .. option_name .. " color")
            newVariationitem.OnSliderChanged = function(menu, item, index)
                old_head.other[i][4] = index
                UpdateHead(GetPlayerPed(-1), old_head)
            end
            menu:AddItem(newVariationitem)
          end
    end

    --------------------------
    -- Checkout Button --
    --------------------------
    local checkout_item = NativeUI.CreateItem("Checkout", "Save your changes.")
    checkout_item.Activated = function(parentmenu, selected)
      -- Close Menu --
      _menuPool:CloseAllMenus()
      -- Finish Checkout  / Save --
      local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
      TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
        TriggerServerEvent("barber:checkout", old_head, property)
      end)
    end
    menu:AddItem(checkout_item)

    ---------------------
    -- Reset Button --
    ---------------------
    local reset_item = NativeUI.CreateItem("Reset", "Reset your changes.")
    reset_item.Activated = function(parentmenu, selected)
      SetPedDefaultHead(GetPlayerPed(-1))
      -- TODO: call server event to get character customizations then call barber:loadCustomizations with returned customizations to save appearance in 'old_head' var
      -- then call TriggerServerEvent("usa:loadPlayerComponents") to reset appearance
    end
    menu:AddItem(reset_item)

    ---------------------
    -- Exit Button --
    ---------------------
    local exit_item = NativeUI.CreateItem("Exit", "Exit the barber shop menu.")
    exit_item.Activated = function(parentmenu, selected)
        _menuPool:CloseAllMenus()
        TriggerServerEvent("usa:loadPlayerComponents")
    end
    menu:AddItem(exit_item)
end

-- add map blips --
Citizen.CreateThread(function()

    local function addBlips()
      for i = 1, #BARBER_SHOPS do
        local blip = AddBlipForCoord(BARBER_SHOPS[i].x, BARBER_SHOPS[i].y, BARBER_SHOPS[i].z)
        SetBlipSprite(blip, 71)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Barber Shop")
        EndTextCommandSetBlipName(blip)
      end
    end

    addBlips()
end)

-------------------
-- add to GUI --
-------------------
CreateBarberShopMenu(mainMenu)
_menuPool:RefreshIndex()

-- Draw Markers / Help Text / Listen for menu open key press --
Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- vars --
        local me = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(me, false)

        -----------------------
        -- Process Menu --
        -----------------------
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()

    	for i = 1, #BARBER_SHOPS do
    		if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,BARBER_SHOPS[i].x,BARBER_SHOPS[i].y,BARBER_SHOPS[i].z)  <  50 then
    		    DrawMarker(27, BARBER_SHOPS[i].x, BARBER_SHOPS[i].y, BARBER_SHOPS[i].z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
                if Vdist(playerCoords.x,playerCoords.y,playerCoords.z,BARBER_SHOPS[i].x,BARBER_SHOPS[i].y,BARBER_SHOPS[i].z)  <  5 then
                    closest_shop = BARBER_SHOPS[i] --// set shop player is at
                    drawTxt("Press [~y~E~w~] to open the barber shop menu",7,1,0.5,0.8,0.5,255,255,255,255)
                    if IsControlJustPressed(1, MENU_OPEN_KEY) then
                        mainMenu:Visible(not mainMenu:Visible())
                        PlayPoliceReport("SCRIPTED_SCANNER_REPORT_JSH_2A_04", 0.0) -- test
                    end
                else
                    if closest_shop then
                        closest_shop = nil
                        TriggerServerEvent("usa:loadPlayerComponents")
                        if mainMenu:Visible() then
                            mainMenu:Visible(false)
                        end
                    end
                end
            end
    	end

    end
end)

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

--# made by: minipunch
--# for: USA REALISM RP

-- property coord: x = -274.606, y = 6226.58, z = 31.69 (paleto)

-- ped coord: x = -277.637, y = 6230.133, z = 31.69 (cashier, paleto)
-- peed coord: x = -278.04, y = 6224.733, z = 31.705 (barber, paleto)

local SHOPS = {
  {x = -279.154, y = 6226.192, z = 31.705}, -- paleto,
  {x = -34.97777557373, y = -150.9037322998, z = 57.086517333984},
  {x = 1211.0759277344, y = -475.00064086914, z = 66.218032836914},
  {x = 1934.115234375, y = 3730.7399902344, z = 32.854434967041},
  {x = -1281.9802246094, y = -1119.6861572266, z = 7.0001249313354},
  {x = 139.21583557129, y = -1708.9689941406, z = 29.301620483398},
  {x = -815.59008789063, y = -182.16806030273, z = 37.568920135498}

}

local menu = {
  open = false,
  key = 38, -- "E",
  page = "home",
  settings = {
    MAX_PARENTS_OPTIONS = 45
  }
}

local purchases = {}

local last_entered = nil

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

-- reset to default values --
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
        SetPedHairColor(ped, head.other[i][4], head.other[i][4])
      end
    end
  end
end

-------------------------
-- SHOP DETECTION LOOP --
-------------------------
Citizen.CreateThread(function()
  addBlips()
  while true do
    local me = GetPlayerPed(-1)
    local player_coords = GetEntityCoords(GetPlayerPed(-1))
    for i = 1, #SHOPS do
      if not menu.open then
        if Vdist(player_coords.x, player_coords.y, player_coords.z, SHOPS[i].x, SHOPS[i].y, SHOPS[i].z) < 3.0 then
          last_entered = SHOPS[i]
          drawTxt("Press [~y~E~w~] to open the barber shop menu",0,1,0.5,0.8,0.6,255,255,255,255)
          if IsControlJustPressed(1,menu.key) and not IsPedDeadOrDying(GetPlayerPed(-1)) then
            local playerCoords = GetEntityCoords(me, false)
            menu.open = true
            purchases = {}
            --SetPedHeadBlendData(me, 0, 4, 25, 6, 4, 20, .5, 0.5, 0.2 , false) -- needed to apply head overlays like facial hair
          end
        end
      else
        if last_entered then
          if Vdist(player_coords.x, player_coords.y, player_coords.z, last_entered.x, last_entered.y, last_entered.z) >= 3.0 then
            last_entered = nil
            if menu.open == true then
              menu.page = "home"
              menu.open = false
              TriggerServerEvent("usa:loadPlayerComponents")
            end
          end
        end
      end
    end
    --drawMarkers()
    Wait(0)
  end
end)

---------------
-- MENU LOOP --
---------------
Citizen.CreateThread(function()
  while true do
    local me = GetPlayerPed(-1)
    if menu.open then
      TriggerEvent("GUI-barbershop:Title", "Herr Kutz Barber")
      if menu.page == "home" then
        ----------
        -- HOME --
        ----------
        TriggerEvent("GUI-barbershop:Option", "Head & Skin Color >", function(cb)
          if(cb) then
            menu.page = "head"
          end
        end)
        -------------------
        -- OTHER OPTIONS --
        -------------------
        for i = 1, #old_head.other do
          TriggerEvent("GUI-barbershop:Int", old_head.other[i][1], old_head.other[i][2], 0, old_head.other[i][3], function(cb)
            if(cb) then
              old_head.other[i][2] = cb
              --print("settng " .. old_head.other[i][1] .. " to val: " .. cb)
              UpdateHead(me, old_head)
            end
          end)
          if i == 2 or i == 3 or i == 11 or i == 6 or i == 9 or i == 14 then
            TriggerEvent("GUI-barbershop:Int", old_head.other[i][1] .. " color", old_head.other[i][4], 0, 85, function(cb)
              if(cb) then
                old_head.other[i][4] = cb
                --print("settng " .. old_head.other[i][1] .. " color to val: " .. cb)
                UpdateHead(me, old_head)
              end
            end)
          end
        end
        ---------------------
        -- EXIT / CHECKOUT --
        ---------------------
        TriggerEvent("GUI-barbershop:Option", "~y~Checkout", function(cb)
          if(cb) then
            menu.page = "home"
            menu.open = false
            local playerCoords = GetEntityCoords(me, false)
            TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
              TriggerServerEvent("barber:checkout", old_head, property)
            end)
          end
        end)
        TriggerEvent("GUI-barbershop:Option", "~r~Reset", function(cb)
          if(cb) then
            SetPedDefaultHead(me)
          end
        end)
        TriggerEvent("GUI-barbershop:Option", "~y~Exit", function(cb)
          if(cb) then
            menu.page = "home"
            menu.open = false
            TriggerServerEvent("usa:loadPlayerComponents")
          end
        end)
      else
        ------------------------
        -- head customization --
        ------------------------
        if menu.page == "head" then
          -------------
          -- PARENTS --
          -------------
          TriggerEvent("GUI-barbershop:Int", "Parent 1", old_head.parent1, 0, menu.settings.MAX_PARENTS_OPTIONS, function(cb)
            if(cb) then
              --("selected index: " .. selected_index)
              --SetPedHeadOverlay(me, 1, selected_index, 1.0)
  	          --SetPedHeadOverlayColor(ped, 0, v[2], v[3], v[3])
              --SetPedComponentVariation(me, 2, selected_index, 0, 1)
              old_head.parent1 = cb
              UpdateHead(me, old_head)
            end
          end)
          TriggerEvent("GUI-barbershop:Int", "Parent 2", old_head.parent2, 0, menu.settings.MAX_PARENTS_OPTIONS, function(cb)
            if(cb) then
              old_head.parent2 = cb
              UpdateHead(me, old_head)
            end
          end)
          ----------------
          -- SKIN COLOR --
          ----------------
          TriggerEvent("GUI-barbershop:Int", "Skin 1", old_head.skin1, 0, menu.settings.MAX_PARENTS_OPTIONS, function(cb)
            if(cb) then
              old_head.skin1 = cb
              UpdateHead(me, old_head)
            end
          end)
          TriggerEvent("GUI-barbershop:Int", "Skin 2", old_head.skin2, 0, menu.settings.MAX_PARENTS_OPTIONS, function(cb)
            if(cb) then
              old_head.skin2 = cb
              UpdateHead(me, old_head)
            end
          end)
          ------------------
          -- reset button --
          ------------------
          TriggerEvent("GUI-barbershop:Option", "~r~Reset", function(cb)
            if(cb) then
              --old_head.parent1, old_head.parent2, old_head.skin1, old_head.skin2 = 0, 0, 0, 0
              SetPedHeadBlendData(me, old_head.parent1, old_head.parent2, old_head.parent3, old_head.skin1, old_head.skin2, old_head.skin3, old_head.mix1, old_head.mix2, old_head.mix3, old_head.isParent)
            end
          end)
          -----------------
          -- back button --
          -----------------
          TriggerEvent("GUI-barbershop:Option", "Back", function(cb)
            if(cb) then
              menu.page = "home"
            end
          end)
        end
      end
      ----------
      -- UPDATE --
      ----------
      TriggerEvent("GUI-barbershop:Update")
    end
    Wait(0)
  end
end)

------------------------
--- utility functions --
------------------------
function addBlips()
  for i = 1, #SHOPS do
    local blip = AddBlipForCoord(SHOPS[i].x, SHOPS[i].y, SHOPS[i].z)
    SetBlipSprite(blip, 71)
    SetBlipColour(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Barber Shop")
    EndTextCommandSetBlipName(blip)
  end
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

----------------
-- MENU STUFF --
----------------
RegisterNetEvent("GUI-barbershop:Title")
AddEventHandler("GUI-barbershop:Title", function(title)
  Menu.Title(title)
end)

RegisterNetEvent("GUI-barbershop:Option")
AddEventHandler("GUI-barbershop:Option", function(option, cb)
  cb(Menu.Option(option))
end)

RegisterNetEvent("GUI-barbershop:Bool")
AddEventHandler("GUI-barbershop:Bool", function(option, bool, cb)
  Menu.Bool(option, bool, function(data)
    cb(data)
  end)
end)

RegisterNetEvent("GUI-barbershop:Int")
AddEventHandler("GUI-barbershop:Int", function(option, int, min, max, cb)
  Menu.Int(option, int, min, max, function(data)
    cb(data)
  end)
end)

RegisterNetEvent("GUI-barbershop:StringArray")
AddEventHandler("GUI-barbershop:StringArray", function(option, array, position, cb)
  Menu.StringArray(option, array, position, function(data)
    cb(data)
  end)
end)

RegisterNetEvent("GUI-barbershop:Update")
AddEventHandler("GUI-barbershop:Update", function()
  Menu.updateSelection()
end)

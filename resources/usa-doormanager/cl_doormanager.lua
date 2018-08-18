--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS_TO_MANAGE = {
  {name = "Bolingbroke Prison", locations = {{x = 1836.1, y = 2604.6,  z = 45.6}, {x = 1852.8, y = 2613.3, z = 45.7}}, distance = 30.0, model = 741314661, locked = false, draw_marker = true},
  {name = "Bolingbroke Prison", locations = {{x = 1826.6, y = 2605.1, z = 45.6}, {x = 1812.6, y = 2598.2, z = 45.5}}, distance = 30.0, model = 741314661, locked = false, draw_marker = true},
  {name = "BCSO Paleto / Side 1", locations = {{x = -429.9, y = 5986.8, z = 31.5}}, distance = 30.0, model = -1156020871, locked = false, draw_marker = true},
  {name = "BCSO Paleto / Side 2", locations = {{x = -431.4, y = 5988.3, z = 31.5}}, distance = 30.0, model = -1156020871, locked = false, draw_marker = true},
  {name = "Mission Row / Door 1", x = 464.2, y = -1002.6, z = 24.9, distance = 2.0, model = -1033001619, locked = false, draw_marker = false},
  {name = "Mission Row / Door 2", x = 463.8, y = -991.9, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 1", x = 462.8, y = -993.7, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, distance = 2.0, model = 631614199, locked = false, draw_marker = false},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, distance = 30.0, model = -250842784, locked = false, draw_marker = false},
  {name = "BCSO Station Gate - Paleto", locations = {{x = -455.4, y = 6031.7, z = 31.3}, {x = -459.3, y = 6015.6, z = 31.5}}, distance = 30.0, model = -1483471451, locked = false, draw_marker = true},
  --{name = "BCSO Station Gate 2 - Paleto", x = -459.3, y = 6015.6, z = 31.5, distance = 30.0, model = -1483471451, locked = false, draw_marker = true},
  {name = "BCSO Station - Right Door", x = -443.6, y = 6015.3, z = 31.7, distance = 2.0, model = -1501157055, locked = false, draw_marker = false},
  {name = "BCSO Station - Left Door", x = -444.5, y = 6016.2, z = 31.7, distance = 2.0, model = -1501157055, locked = false, draw_marker = false},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.5, z = 31.5, distance = 30.0, model = -1156020871, locked = false, draw_marker = false},
  {name = "BCSO Station - Sandy Shores", x = 1854.7, y = 3684.2, z = 34.3, distance = 20.0, model = -1765048490, locked = false, draw_marker = false},
  {name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 28", x = 1729.4, y = 2628.1, z = 53.06, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true},
  {name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, distance = 30.0, model = -642608865, locked = true, draw_marker = false, cell_block = true}
}

local LOCK_KEY = 38 -- "E"
local ACTIVATE_LOCK_SWITCH_DISTANCE = 1.5
local DRAW_MARKER_RANGE = 50
local DRAW_3D_TEXT_RANGE = 2.5
local RELOCK_DISTANCE = 50.0
local DEBUG = false

local FIRST_JOIN = true

local me = GetPlayerPed(-1)
local mycoords = GetEntityCoords(me)

RegisterNetEvent("doormanager:debug")
AddEventHandler("doormanager:debug", function()
  DEBUG = not DEBUG
end)

RegisterNetEvent("doormanager:update")
AddEventHandler("doormanager:update", function(doors)
  for k, v in pairs(doors) do
    DOORS_TO_MANAGE[k].locked = v.locked
  end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
    ---------------------------------------
    -- LOAD STATE OF DOORS ON FIRST JOIN --
    ---------------------------------------
    if FIRST_JOIN then
      TriggerServerEvent("doormanager:firstJoin")
      FIRST_JOIN = false
    end

    me = GetPlayerPed(-1)
    mycoords = GetEntityCoords(me, 1)

    -----------------------------
    -- CHECK DIST TO EACH DOOR --
    -----------------------------
    for i = 1, #DOORS_TO_MANAGE do

      -- below if statement used to convert locations not set up as a table yet --
      if not DOORS_TO_MANAGE[i].locations then
        DOORS_TO_MANAGE[i].locations = {{x = DOORS_TO_MANAGE[i].x, y = DOORS_TO_MANAGE[i].y, z = DOORS_TO_MANAGE[i].z}}
      end

      for j = 1, #DOORS_TO_MANAGE[i].locations do
        -----------------------------------
        -- LISTEN FOR DOOR TOGGLE EVENTS --
        -----------------------------------
        if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) <= ACTIVATE_LOCK_SWITCH_DISTANCE then
          DrawSpecialText("Press ~g~E~w~ to toggle lock at: " .. DOORS_TO_MANAGE[i].name)
          if IsControlJustPressed(1, LOCK_KEY) then
            TriggerServerEvent("doormanager:checkDoorLock", i, DOORS_TO_MANAGE[i], DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z)
            --if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.2, "cell-lock", 0.2) end
          end
        end
        --------------------------
        -- DRAW MARKERS / TEXT  --
        --------------------------
        if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) < DRAW_MARKER_RANGE then
          -------------------------
          -- draw ground markers --
          -------------------------
          if DOORS_TO_MANAGE[i].draw_marker then
            DrawMarker(27, DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z - 0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 40, 40, 240, 90, 0, 0, 2, 0, 0, 0, 0)
          end
          ------------------
          -- draw 3d text --
          ------------------
          if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) < DRAW_3D_TEXT_RANGE then
            if DOORS_TO_MANAGE[i].locked then
              DrawText3Ds(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, "Press [E] to Unlock")
            else
              DrawText3Ds(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, "Press [E] to Lock")
            end
          end
        end
      end

    end
	end
end)

Citizen.CreateThread(function()
  while true do
    ------------------------------------------------------------------------------------
    -- MAKE SURE DOORS STAY LOCKED (things like leaving the area would unlock things) --
    ------------------------------------------------------------------------------------
    for i = 1, #DOORS_TO_MANAGE do
      -- below if statement used to convert locations not set up as a table yet --
      if not DOORS_TO_MANAGE[i].locations then
        DOORS_TO_MANAGE[i].locations = {{x = DOORS_TO_MANAGE[i].x, y = DOORS_TO_MANAGE[i].y, z = DOORS_TO_MANAGE[i].z}}
      end

      for j = 1, #DOORS_TO_MANAGE[i].locations do
      --if DOORS_TO_MANAGE[i].coords then
        if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) <= RELOCK_DISTANCE then
          if DEBUG then print("making sure door is locked: " .. DOORS_TO_MANAGE[i].name) end
            --local ent = GetObject(DOORS_TO_MANAGE[i].model, DOORS_TO_MANAGE[i].distance, DOORS_TO_MANAGE[i].locations[1].x, DOORS_TO_MANAGE[i].locations[1].y, DOORS_TO_MANAGE[i].locations[1].z)
            local ent = GetObject(DOORS_TO_MANAGE[i].model, DOORS_TO_MANAGE[i].distance, DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z)
            if ent then
              if DEBUG then print("ent: " .. ent) end
              if not DOORS_TO_MANAGE[i].cell_block then
                if DOORS_TO_MANAGE[i].locked then
                  FreezeEntityPosition(ent, true)
                end
              elseif DOORS_TO_MANAGE[i].cell_block then
                SetEntityAsMissionEntity(ent, true, true)
                if DOORS_TO_MANAGE[i].locked then
                  SetEntityVisible(ent, true)
                else
                  SetEntityVisible(ent, false)
                  SetEntityCollision(ent, false, true)
                end
              end
            end
        end
      --end
      end
    end
    Wait(5000) -- check approx. every 2 seconds
  end
end)

RegisterNetEvent("doormanager:toggleDoorLock")
AddEventHandler("doormanager:toggleDoorLock", function(index, locked, x, y, z)
  local door = DOORS_TO_MANAGE[index]
  local door_entity = GetObject(door.model, door.distance, x, y, z)
  if not door.cell_block then
    FreezeEntityPosition(door_entity, locked)
  else
    SetEntityAsMissionEntity(door_entity, true, true)
    if locked then
      SetEntityVisible(door_entity, true)
      SetEntityCollision(door_entity, true, true)
      --SetEntityRotation(door_entity, 0, 0, 0, 2, true)
    else
      SetEntityVisible(door_entity, false)
      SetEntityCollision(door_entity, false, true)
      --SetEntityRotation(door_entity, 0, 0, 90, 2, true)
    end
  end
  DOORS_TO_MANAGE[index].locked = locked
end)

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
  SetTextFont(7)
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

function GetObject(target_obj, range, x, y, z)
  local playerped = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(playerped)
  local handle, obj = FindFirstObject()
  local success
  local robj = nil
  local distanceFrom
  repeat
    local pos = GetEntityCoords(obj)
    local distance = Vdist(pos.x, pos.y, pos.z, x, y, z)
    if canPedBeUsed(obj) and distance < range and (distanceFrom == nil or distance < distanceFrom) and GetEntityModel(obj) == target_obj then
      distanceFrom = distance
      robj = obj
    end
    success, obj = FindNextObject(handle)
  until not success
  EndFindObject(handle)
  return robj
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    --local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

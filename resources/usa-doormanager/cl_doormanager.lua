--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS_TO_MANAGE = {} -- loaded from server file on start of resource

local LOCK_KEY = 38 -- "E"
local ACTIVATE_LOCK_SWITCH_DISTANCE = 1.5
local DRAW_MARKER_RANGE = 50
local DRAW_3D_TEXT_RANGE = 2.0
local RELOCK_DISTANCE = 50.0
local DEBUG = false
local doorBeingLocked = nil

local FIRST_JOIN = true

local me = GetPlayerPed(-1)
local mycoords = GetEntityCoords(me)

RegisterNetEvent("doormanager:debug")
AddEventHandler("doormanager:debug", function()
  DEBUG = not DEBUG
end)

RegisterNetEvent("doormanager:update")
AddEventHandler("doormanager:update", function(doors)
  DOORS_TO_MANAGE = doors
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
				if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) <= DOORS_TO_MANAGE[i]._dist and not DOORS_TO_MANAGE[i].static then
					if IsControlJustPressed(1, LOCK_KEY) and DOORS_TO_MANAGE[i] ~= doorBeingLocked then
						PlayLockAnim()
						Citizen.Wait(400)
						TriggerServerEvent("doormanager:checkDoorLock", i, DOORS_TO_MANAGE[i], DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z)
						--if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.2, "cell-lock", 0.2) end
					end
				end
				------------------
				-- draw 3d text --
				------------------
				if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) < DRAW_3D_TEXT_RANGE and not DOORS_TO_MANAGE[i].static and not DOORS_TO_MANAGE[i].ymap and DOORS_TO_MANAGE[i] ~= doorBeingLocked then
					local doorObject = GetClosestObjectOfType(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, 1.0, DOORS_TO_MANAGE[i].model, false, false, false)
					--print("heading: " .. GetEntityHeading(doorObject))
					local door = GetEntityCoords(doorObject)
					local angle = 0
					if DOORS_TO_MANAGE[i].angle then
						angle = math.rad(DOORS_TO_MANAGE[i].angle+GetEntityHeading(doorObject))
					else
						print("USA-DOORMANAGER: " .. DOORS_TO_MANAGE[i].name .. " IS MISSING AN ANGLE PROPERTY, PLEASE ADD")
					end
					local r = DOORS_TO_MANAGE[i].offsetY
					local x=door.x+r*math.cos(angle)
					local y=door.y+r*math.sin(angle)
					if DOORS_TO_MANAGE[i].locked then
					DrawText3Ds(x+DOORS_TO_MANAGE[i].offsetX, y, door.z+DOORS_TO_MANAGE[i].offsetZ, "[E] - Locked")
					else
					DrawText3Ds(x+DOORS_TO_MANAGE[i].offsetX, y, door.z+DOORS_TO_MANAGE[i].offsetZ, "[E] - Unlocked")
					end
				elseif Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) < DRAW_3D_TEXT_RANGE and not DOORS_TO_MANAGE[i].static and DOORS_TO_MANAGE[i].ymap then
					if DOORS_TO_MANAGE[i].locked then
						DrawText3Ds(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, "[E] - Locked")
					else
						DrawText3Ds(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, "[E] - Unlocked")
					end
				end
				--------------------------	
				-- DRAW MARKERS / TEXT  --	
				--------------------------	
				if Vdist(DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z, mycoords.x, mycoords.y, mycoords.z) < DRAW_MARKER_RANGE and not DOORS_TO_MANAGE[i].static then	
					-------------------------	
					-- draw ground markers --	
					-------------------------	
					if DOORS_TO_MANAGE[i].draw_marker then	
						DrawMarker(27, DOORS_TO_MANAGE[i].locations[j].x, DOORS_TO_MANAGE[i].locations[j].y, DOORS_TO_MANAGE[i].locations[j].z - 0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 40, 40, 240, 90, 0, 0, 2, 0, 0, 0, 0)	
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
  if door then
      local door_entity = GetObject(door.model, door.distance, x, y, z)
      if not door.cell_block then
        if locked and not door.ymap then
          while math.floor(GetEntityHeading(door_entity)) ~= door.heading do
            --print(GetEntityHeading(door_entity))
            local mycoords = GetEntityCoords(PlayerPedId())
            Citizen.Wait(1)
            if Vdist(door.x, door.y, door.z, mycoords.x, mycoords.y, mycoords.z) < DRAW_3D_TEXT_RANGE then
              doorBeingLocked = door
              local door = GetEntityCoords(door_entity)
              local angle = math.rad(DOORS_TO_MANAGE[index].angle+GetEntityHeading(door_entity))
              local r = DOORS_TO_MANAGE[index].offsetY
              local x=door.x+r*math.cos(angle)
              local y=door.y+r*math.sin(angle)
              DrawText3Ds(x+DOORS_TO_MANAGE[index].offsetX, y, door.z+DOORS_TO_MANAGE[index].offsetZ, "Locking...", 320, 2)
            end
          end
          doorBeingLocked = nil
        end
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
  end
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

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function PlayLockAnim()
    if not IsPedCuffed(GetPlayerPed(-1)) then
        loadAnimDict('anim@mp_player_intmenu@key_fob@')
        ped = GetPlayerPed(-1)
        TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, -1, 48)
    end
end

--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS_TO_MANAGE = {} -- loaded from server file on start of resource

local LOCK_KEY = 38 -- "E"
local ACTIVATE_LOCK_SWITCH_DISTANCE = 1.5
local DRAW_MARKER_RANGE = 50
local RELOCK_DISTANCE = 100.0
local DEBUG = false
local doorBeingLocked = nil
local doorRadius = 1.0
local drawTextRange = 2.0

local FIRST_JOIN = true

local playerPed = GetPlayerPed(-1)
local playerCoords = GetEntityCoords(playerPed)

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

		playerPed = GetPlayerPed(-1)
	  playerCoords = GetEntityCoords(playerPed)

      -----------------------------------
      -- LISTEN FOR DOOR TOGGLE EVENTS --
      -----------------------------------
    if IsControlJustPressed(1, LOCK_KEY) then
      for i = 1, #DOORS_TO_MANAGE do
        local door = DOORS_TO_MANAGE[i]
        if door ~= doorBeingLocked and Vdist(door.x, door.y, door.z, playerCoords.x, playerCoords.y, playerCoords.z) <= door._dist and not door.static then
          PlayLockAnim()
          Citizen.Wait(400)
          TriggerServerEvent("doormanager:checkDoorLock", i, door.x, door.y, door.z)
          --if SOUND_ENABLE then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 1.2, "cell-lock", 0.2) end
        end
      end
    end
		-----------------------------
		-- CHECK DIST TO EACH DOOR --
		-----------------------------
		for i = 1, #DOORS_TO_MANAGE do
      local door = DOORS_TO_MANAGE[i]
			------------------
			-- draw 3d text --
			------------------
      doorRadius = 1.0
      drawTextRange = 2.0
      if door.gate then drawTextRange = 7.0 doorRadius = 6.0 end
			if Vdist(door.x, door.y, door.z, playerCoords.x, playerCoords.y, playerCoords.z) < drawTextRange and not door.static and door.offset and door ~= doorBeingLocked then
        local doorObject = GetClosestObjectOfType(door.x, door.y, door.z, doorRadius, door.model, false, false, false)
        local doorCoords = GetEntityCoords(doorObject)
        if not door.gate then
					--print("heading: " .. GetEntityHeading(doorObject))
          local offsetX, offsetY, offsetZ = table.unpack(door.offset)
					local angle = math.rad(180+GetEntityHeading(doorObject))
					local x=doorCoords.x+offsetY*math.cos(angle)
					local y=doorCoords.y+offsetY*math.sin(angle)
					if door.locked then DrawText3Ds(x+offsetX, y, doorCoords.z+offsetZ, "[E] - Locked") else DrawText3Ds(x+offsetX, y, doorCoords.z+offsetZ, "[E] - Unlocked") end
        else
          local offsetX, offsetY, offsetZ = table.unpack(door.offset)
          local x, y, z = table.unpack(doorCoords)
          --print(doorCoords)
          if door.locked and door ~= doorBeingLocked then DrawText3Ds(x+offsetX, y+offsetY, z+offsetZ, "[E] - Locked") else DrawText3Ds(x+offsetX, y+offsetY, z+offsetZ, "[E] - Unlocked") end
        end
			elseif Vdist(door.x, door.y, door.z, playerCoords.x, playerCoords.y, playerCoords.z) < drawTextRange and not door.static and door ~= doorBeingLocked and not door.offset then
				if door.locked then
					DrawText3Ds(door.x, door.y, door.z, "[E] - Locked")
				else
					DrawText3Ds(door.x, door.y, door.z, "[E] - Unlocked")
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
      local door = DOORS_TO_MANAGE[i]
      if door.gate then doorRadius = 6.0 end
      --if DOORS_TO_MANAGE[i].coords then
      if Vdist(door.x, door.y, door.z, playerCoords.x, playerCoords.y, playerCoords.z) <= RELOCK_DISTANCE then
        if DEBUG then print("making sure door is locked: " ..door.name) end
        --local ent = GetObject(DOORS_TO_MANAGE[i].model, DOORS_TO_MANAGE[i].distance, DOORS_TO_MANAGE[i].locations[1].x, DOORS_TO_MANAGE[i].locations[1].y, DOORS_TO_MANAGE[i].locations[1].z)
        local doorObject = GetClosestObjectOfType(door.x, door.y, door.z, doorRadius, door.model, false, false, false)
        if doorObject then
						--[[
          if not IsEntityAMissionEntity(doorObject) then
            SetEntityAsMissionEntity(doorObject, true, true)
          end
						--]]
          if DEBUG then print("ent: " .. doorObject) end
          if not door.cell_block then
            if door.locked then
              FreezeEntityPosition(doorObject, true)
              -- print('freezing pos of door: ' ..door.name)
            end
          else
            if door.locked then
              SetEntityVisible(doorObject, true)
            else
              SetEntityVisible(doorObject, false)
              SetEntityCollision(doorObject, false, true)
            end
          end
        end
      end
    end
  Wait(5000) -- check approx. every 2 seconds
  end
end)

RegisterNetEvent("doormanager:toggleDoorLock")
AddEventHandler("doormanager:toggleDoorLock", function(index, locked, x, y, z)  
  local door = DOORS_TO_MANAGE[index]
  if door then
      if door.gate then doorRadius = 6.0 end
      local doorObject = GetClosestObjectOfType(x, y, z, doorRadius, door.model, false, false, false)
      --print("mission entity: " .. tostring(IsEntityAMissionEntity(doorObject)))
			--[[
      if not IsEntityAMissionEntity(doorObject) then
        SetEntityAsMissionEntity(doorObject, true, true)
      end
			--]]
      if not door.cell_block then
        if locked and door.offset then
          if not door.gate then
            while math.floor(GetEntityHeading(doorObject)) ~= door.heading do
              --print(GetEntityHeading(doorObject))
              Citizen.Wait(1)
              local playerCoords = GetEntityCoords(PlayerPedId())
              local doorCoords = GetEntityCoords(doorObject)
              local offsetX, offsetY, offsetZ = table.unpack(door.offset)
              doorBeingLocked = door
              if Vdist(x, y, z, table.unpack(playerCoords)) < drawTextRange then
                local angle = math.rad(180+GetEntityHeading(doorObject))
                local r = offsetY
                local x=doorCoords.x+r*math.cos(angle)
                local y=doorCoords.y+r*math.sin(angle)
                DrawText3Ds(x+offsetX, y, doorCoords.z+offsetZ, "Locking...")
              end
            end
          else
            _x, _y, _z = table.unpack(door.lockedCoords)
            local doorCoords = GetEntityCoords(doorObject)
            while GetDistanceBetweenCoords(doorCoords.x, doorCoords.y, doorCoords.z, _x, _y, _z, false) > 0.2 do
              --print("dist: " .. GetDistanceBetweenCoords(GetEntityCoords(doorObject).x, GetEntityCoords(doorObject).y, GetEntityCoords(doorObject).z, _x, _y, _z, false))
              --print(GetEntityCoords(doorObject))
              Citizen.Wait(1)
              local playerCoords = GetEntityCoords(PlayerPedId())
              local offsetX, offsetY, offsetZ = table.unpack(door.offset)
              doorBeingLocked = door
              if Vdist(x, y, z, table.unpack(playerCoords)) < 8.0 then
                DrawText3Ds(doorCoords.x+offsetX, doorCoords.y+offsetY, doorCoords.z+offsetZ, 'Locking...')
              end
            end
          end
          doorBeingLocked = nil
        end
        FreezeEntityPosition(doorObject, locked)
      else
        SetEntityAsMissionEntity(doorObject, true, true)
        if locked then
          SetEntityVisible(doorObject, true)
          SetEntityCollision(doorObject, true, true)
          --SetEntityRotation(door_entity, 0, 0, 0, 2, true)
        else
          SetEntityVisible(doorObject, false)
          SetEntityCollision(doorObject, false, true)
          --SetEntityRotation(door_entity, 0, 0, 90, 2, true)
        end
      end
      DOORS_TO_MANAGE[index].locked = locked
  end
end)

RegisterNetEvent('doormanager:lockpickDoor')
AddEventHandler('doormanager:lockpickDoor', function(lockpickItem)
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)
  for i = 1, #DOORS_TO_MANAGE do
    local door = DOORS_TO_MANAGE[i]
    local x, y, z = door.x, door.y, door.z
    if Vdist(playerCoords, x, y, z) < 1.0 then
      if door.lockpickable then
        local start_time = GetGameTimer()
        local duration = 30000
        -- play animation:
        local anim = {
          dict = "veh@break_in@0h@p_m_one@",
          name = "low_force_entry_ds"
        }
        RequestAnimDict(anim.dict)
        while not HasAnimDictLoaded(anim.dict) do
          Wait(100)
        end
        local x, y, z = table.unpack(playerCoords)
        local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
        local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
        TriggerServerEvent('911:LockpickingDoor', x, y, z, lastStreetNAME, IsPedMale(playerPed))
        Citizen.CreateThread(function()
          while GetGameTimer() - start_time < duration do
            Citizen.Wait(0)
            DisableControlAction(0, 301, true)
            DisableControlAction(0, 86, true)
            DisableControlAction(0, 244, true)
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 79, true)
            DisableControlAction(0, 73, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 311, true)
            DrawTimer(start_time, duration, 1.42, 1.475, 'LOCKPICKING')
          end
        end)
        while GetGameTimer() - start_time < duration do
          Wait(0)
          local x, y, z = table.unpack(GetEntityCoords(playerPed))
          --print("IsEntityPlayingAnim(me, anim.dict, anim.name, 3): " .. tostring(IsEntityPlayingAnim(me, anim.dict, anim.name, 3)))
          if not IsEntityPlayingAnim(playerPed, anim.dict, anim.name, 3) then
                TaskPlayAnim(playerPed, anim.dict, anim.name, 8.0, 1.0, -1, 11, 1.0, false, false, false)
                Citizen.Wait(2000)
                ClearPedTasks(playerPed)
                SetEntityCoords(playerPed, x, y, z - 1.0, false, false, false, false)
              end
          if Vdist(playerCoords, x, y, z) > 3.0 then
            TriggerEvent("usa:notify", "Lockpick ~y~failed~s~, out of range!")
            ClearPedTasksImmediately(playerPed)
            return
          end
        end
        if math.random() < 0.6 then
          TriggerServerEvent('doormanager:checkDoorLock', i, door.x, door.y, door.z, true)
          TriggerEvent("usa:notify", "Lockpick was ~y~successful~s~!")
          return
        else
          TriggerEvent("usa:notify", "Lockpick has ~y~broken~s~!")
          TriggerServerEvent("usa:removeItem", lockpickItem, 1)
          return
        end
      else
        TriggerEvent('usa:notify', 'This door cannot be lockpicked!')
        return
      end
    end
  end
 end)

RegisterNetEvent('doormanager:advancedPick')
AddEventHandler('doormanager:advancedPick', function(advancedPick)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for i = 1, #DOORS_TO_MANAGE do
        local door = DOORS_TO_MANAGE[i]
        local x, y, z = door.x, door.y, door.z
        if Vdist(playerCoords, x, y, z) < 1.0 then
            if door.advancedlockpickable then
                local start_time = GetGameTimer()
                local duration = 60000
                -- play animation:
                local anim = {
                    dict = "veh@break_in@0h@p_m_one@",
                    name = "low_force_entry_ds"
                }
                RequestAnimDict(anim.dict)
                while not HasAnimDictLoaded(anim.dict) do
                    Wait(100)
                end
                local x, y, z = table.unpack(playerCoords)
                local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
                local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                TriggerServerEvent('911:BankRobbery', x, y, z, lastStreetNAME, IsPedMale(playerPed))
                Citizen.CreateThread(function()
                    while GetGameTimer() - start_time < duration do
                        Citizen.Wait(0)
                        DisableControlAction(0, 301, true)
                        DisableControlAction(0, 86, true)
                        DisableControlAction(0, 244, true)
                        DisableControlAction(0, 245, true)
                        DisableControlAction(0, 288, true)
                        DisableControlAction(0, 79, true)
                        DisableControlAction(0, 73, true)
                        DisableControlAction(0, 37, true)
                        DisableControlAction(0, 311, true)
                        DrawTimer(start_time, duration, 1.42, 1.475, 'LOCKPICKING')
                    end
                end)
                while GetGameTimer() - start_time < duration do
                    Wait(0)
                    local x, y, z = table.unpack(GetEntityCoords(playerPed))
                    if not IsEntityPlayingAnim(playerPed, anim.dict, anim.name, 3) then
                        TaskPlayAnim(playerPed, anim.dict, anim.name, 8.0, 1.0, -1, 11, 1.0, false, false, false)
                        Citizen.Wait(2000)
                        ClearPedTasks(playerPed)
                        SetEntityCoords(playerPed, x, y, z - 1.0, false, false, false, false)
                    end
                end
                if math.random() < 0.7 then
                    TriggerServerEvent('doormanager:checkDoorLock', i, door.x, door.y, door.z, true)
                    TriggerEvent("usa:notify", "Lockpick was ~y~successful~s~!")
                    return
                else
                    TriggerEvent("usa:notify", "Lockpick has ~y~broken~s~!")
                    TriggerServerEvent("usa:removeItem", advancedPick, 1)
                    return
                end
            else
                TriggerEvent('usa:notify', 'You cannot use advanced lockpicks here!')
                return
            end
        end
    end
end)

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
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
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
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

--# by: minipunch
--# for USA REALISM rp
--# spot light script for police vehicles that syncs server sided

local SPOTLIGHTS = {}
local MY_SPOTLIGHT = false

local OFFSET_X = 0.0 -- left/right
local OFFSET_Y = 7.0 -- forward/back
local OFFSET_Z = 0.0 -- up/down

local myveh = 0

RegisterNetEvent("spotlight:syncSpotlights")
AddEventHandler("spotlight:syncSpotlights", function(spotlights)
  --print("synced all spotlights!")
  SPOTLIGHTS = spotlights
end)

RegisterNetEvent("spotlight:syncSpotlight")
AddEventHandler("spotlight:syncSpotlight", function(spotlight)
  for i = 1, #SPOTLIGHTS do
    if SPOTLIGHTS[i].uuid == spotlight.uuid then
      SPOTLIGHTS[i] = spotlight
      break
    end
  end
end)

RegisterNetEvent("spotlight:spotlight")
AddEventHandler("spotlight:spotlight", function()
  if not MY_SPOTLIGHT then
    local me = GetPlayerPed(-1)
    local mycoords = GetEntityCoords(me)
    myveh = GetVehiclePedIsIn(me, false)
    if myveh ~= 0 then
      local vehcoords = GetEntityCoords(veh)
      local forward = GetOffsetFromEntityInWorldCoords(me, OFFSET_X, OFFSET_Y, OFFSET_Z)
      local target = forward - mycoords
      local spotlight = {
        source = {
          x = vehcoords.x,
          y = vehcoords.y,
          z = vehcoords.z
        },
        dir = {
          x = target['x'],
          y = target['y'],
          z = target['z']
        },
        uuid = math.random(999999999)
      }
      TriggerServerEvent("spotlight:addSpotlight", spotlight)
      MY_SPOTLIGHT = spotlight
      --print("spotlight on!")
	  TriggerEvent("usa:notify", "Spotlight ~g~on")
    else
      TriggerEvent("usa:notify", "Not in vehicle!")
    end
  else
    TriggerServerEvent("spotlight:removeSpotlight", MY_SPOTLIGHT)
    MY_SPOTLIGHT = nil
    --print("spotlight off!")
	TriggerEvent("usa:notify", "Spotlight ~r~off")
  end
end)

---------------------
-- draw spotlights --
---------------------
Citizen.CreateThread(function()
  while true do
    ----------------------
    -- draw spot lights --
    ----------------------
    if #SPOTLIGHTS > 0 then
      for i = 1, #SPOTLIGHTS do
        DrawSpotLight(SPOTLIGHTS[i].source.x, SPOTLIGHTS[i].source.y, SPOTLIGHTS[i].source.z, SPOTLIGHTS[i].dir.x, SPOTLIGHTS[i].dir.y, SPOTLIGHTS[i].dir.z, 255, 255, 255, 100.0, 1.0, 0.0, 13.0, 1.0)
      end
    end
    ------------------------------
    -- listen for hot key press --
    ------------------------------
    --[[
    if IsControlPressed(0, 47) and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      TriggerServerEvent("spotlight:checkJob")
    end
    --]]
    Wait(0)
  end
end)

----------------------
-- update if moving --
----------------------
Citizen.CreateThread(function()
  while true do
    local me = GetPlayerPed(-1)
    if MY_SPOTLIGHT and IsPedInAnyVehicle(me, true) then
      local mycoords = GetEntityCoords(me)
      local veh = GetVehiclePedIsIn(me, false)
      local vehcoords
      local doUpdate = false
      if veh ~= 0 and veh == myveh then
        vehcoords = GetEntityCoords(veh)
        if vehcoords.x ~= MY_SPOTLIGHT.source.x or vehcoords.y ~= MY_SPOTLIGHT.source.y or vehcoords.z ~= MY_SPOTLIGHT.source.z then
          MY_SPOTLIGHT.source.x = vehcoords.x
          MY_SPOTLIGHT.source.y = vehcoords.y
          MY_SPOTLIGHT.source.z = vehcoords.z
          doUpdate = true
        end
      end
      if IsControlPressed(0, 27) then
        --print("moving up")
        OFFSET_Z = OFFSET_Z + 0.2
        local spotvec = GetOffsetFromEntityInWorldCoords(me, OFFSET_X, OFFSET_Y, OFFSET_Z)
        local target = spotvec - mycoords
        MY_SPOTLIGHT.dir = {
          x = target['x'],
          y = target['y'],
          z = target['z']
        }
        doUpdate = true
      elseif IsControlPressed(0, 173) then
        --print("moving down")
        OFFSET_Z = OFFSET_Z - 0.2
        local spotvec = GetOffsetFromEntityInWorldCoords(me, OFFSET_X, OFFSET_Y, OFFSET_Z)
        local target = spotvec - mycoords
        MY_SPOTLIGHT.dir = {
          x = target['x'],
          y = target['y'],
          z = target['z']
        }
        doUpdate = true
      elseif IsControlPressed(0, 174) then
        --print("moving left!")
        OFFSET_X = OFFSET_X - 0.2
        local spotvec = GetOffsetFromEntityInWorldCoords(me, OFFSET_X, OFFSET_Y, OFFSET_Z)
        local target = spotvec - mycoords
        MY_SPOTLIGHT.dir = {
          x = target['x'],
          y = target['y'],
          z = target['z']
        }
        doUpdate = true
      elseif IsControlPressed(0, 175) then
        --print("moving right!")
        OFFSET_X = OFFSET_X + 0.2
        local spotvec = GetOffsetFromEntityInWorldCoords(me, OFFSET_X, OFFSET_Y, OFFSET_Z)
        local target = spotvec - mycoords
        MY_SPOTLIGHT.dir = {
          x = target['x'],
          y = target['y'],
          z = target['z']
        }
        doUpdate = true
      end
      if doUpdate then
        --print("updating!")
        TriggerServerEvent("spotlight:updateSpotlight", MY_SPOTLIGHT)
      end
    end
    Wait(2)
  end
end)

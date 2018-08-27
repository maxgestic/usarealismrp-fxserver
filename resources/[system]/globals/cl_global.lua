--------------------------------------------------------------
-- Send GTA style notification above minimap on bottom left --
--------------------------------------------------------------
function notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(0,1)
end

-----------------------------------------------------------------------------------------
-- Easy to use API for FiveM iterator functions to loop through all entities of a type --
-- Call exports.globals:EnumrateObjects() for objects, etc...
-- Ex: for veh in exports.globals:EnumrateVehicles() do
--      print("vehicle handle: " .. veh)
--     end
-----------------------------------------------------------------------------------------
local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

-------------------------------------
-- Start action (me) message --
-------------------------------------
local ACTION_MESSAGE_TIME_SECONDS = 5
RegisterNetEvent("globals:startActionMessage")
AddEventHandler("globals:startActionMessage", function(msg, range, playerId)
    Citizen.CreateThread(function()
        local player = GetPlayerFromServerId(playerId)
        local ped = GetPlayerPed(player)
        local coords = GetEntityCoords(ped)
        local myped = GetPlayerPed(-1)
        local mycoords = GetEntityCoords(myped)
        local start = GetGameTimer()
        if Vdist(mycoords.x, mycoords.y, mycoords.z, coords.x, coords.y, coords.z) <= range and Vdist(mycoords.x, mycoords.y, mycoords.z, coords.x, coords.y, coords.z) > 0.0 then
            while GetGameTimer() - start < ACTION_MESSAGE_TIME_SECONDS * 1000 do
                coords = GetEntityCoords(ped)
                mycoords = GetEntityCoords(myped)
                Draw3DText(coords.x, coords.y, coords.z + 0.3, msg)
                Wait(0)
            end
        end
    end)
end)

function Draw3DText(x,y,z, text)
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

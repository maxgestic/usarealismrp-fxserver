local MAX_ITEM_TRADE_DISTANCE = 1.5
local MAX_TACKLE_DISTANCE = 1.5
local ACTION_MESSAGE_TIME_SECONDS = 6.5

function MaxItemTradeDistance()
	return MAX_ITEM_TRADE_DISTANCE
end

function MaxTackleDistance()
	return MAX_TACKLE_DISTANCE
end

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
local nbrDisplaying = 0
RegisterNetEvent('globals:startActionMessage')
AddEventHandler('globals:startActionMessage', function(source, text, maxDist, time)
  offset = 0 + (nbrDisplaying*0.06)
  if nbrDisplaying < 5 then
    Display(GetPlayerFromServerId(source), text, offset, maxDist, time)
  end
end)

function Display(ped, text, offset, maxDist, time)
  local displaying = true
  Citizen.CreateThread(function()
    Wait(time)
    displaying = false
  end)
  Citizen.CreateThread(function()
    nbrDisplaying = nbrDisplaying + 1
    while displaying do
      Wait(0)
      local coords = GetEntityCoords(GetPlayerPed(ped), false)
      DrawText3Ds(coords['x'], coords['y'], coords['z']+offset+0.3, text, maxDist)
    end
    nbrDisplaying = nbrDisplaying - 1
  end)
end

function DrawText3Ds(x, y, z, text, maxDist)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
		local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    if dist <= maxDist then
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
end

function GetUserInput()
    -- get withdraw amount from user input --
    DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 15 )
    while true do
        if ( UpdateOnscreenKeyboard() == 1 ) then
            local input = GetOnscreenKeyboardResult()
            if ( string.len( input ) > 0 ) then
                -- do something with the input var
                return input
            else
                DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 15 )
            end
        elseif ( UpdateOnscreenKeyboard() == 2 ) then
            break
        end
        Wait( 0 )
    end
end

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

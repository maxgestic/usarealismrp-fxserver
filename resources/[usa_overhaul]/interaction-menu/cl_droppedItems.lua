local DROPPED_ITEMS = {}
local E_KEY = 246

TriggerServerEvent("interaction:getDroppedItems")

RegisterNetEvent("interaction:getDroppedItems")
AddEventHandler("interaction:getDroppedItems", function(items)
  DROPPED_ITEMS = items
  for i = 1, #DROPPED_ITEMS do
    if DROPPED_ITEMS[i].objectModel then
      local objectHash = GetHashKey(DROPPED_ITEMS[i].objectModel)
      local prop = CreateObject(objectHash, DROPPED_ITEMS[i].coords.x, DROPPED_ITEMS[i].coords.y + 0.5, DROPPED_ITEMS[i].coords.z - 0.99, true, false, true)
    end
  end
end)

RegisterNetEvent("interaction:addDroppedItem")
AddEventHandler("interaction:addDroppedItem", function(item)
  table.insert(DROPPED_ITEMS, item)
end)

RegisterNetEvent("interaction:removeDroppedItem")
AddEventHandler("interaction:removeDroppedItem", function(index)
  if DROPPED_ITEMS[index] then
    if DROPPED_ITEMS[index].objectModel then
	  local objectModel = DROPPED_ITEMS[index].objectModel
	  local itemObject = GetClosestObjectOfType(DROPPED_ITEMS[index].coords.x, DROPPED_ITEMS[index].coords.y, DROPPED_ITEMS[index].coords.z, 1.0, objectModel, false, false, false)
	  DeleteObject(itemObject)
	end
    table.remove(DROPPED_ITEMS, index)
  end
end)

RegisterNetEvent("interaction:finishedPickupAttempt")
AddEventHandler("interaction:finishedPickupAttempt", function()
  attemptingPickup = false
end)

Citizen.CreateThread(function()
  while true do
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    for i = 1, #DROPPED_ITEMS do
      local item = DROPPED_ITEMS[i]
      if Vdist(coords.x, coords.y, coords.z, item.coords.x, item.coords.y, item.coords.z) < 50 then
        if not item.objectModel then
          DrawMarker(27, item.coords.x, item.coords.y, item.coords.z - 0.89, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 1.0, 240, 30, 140, 100, 0, 0, 2, 0, 0, 0, 0)
        end
        if Vdist(coords.x, coords.y, coords.z, item.coords.x, item.coords.y, item.coords.z) < 3.5 then
          DrawText3Ds(item.coords.x, item.coords.y, item.coords.z - 0.3, 370, 16, '[Y] - ' .. item.name)
          if IsControlJustPressed(1, E_KEY) and not attemptingPickup then
            attemptingPickup = true
            TriggerServerEvent("interaction:attemptPickup", item)
            break
          end
        end
      end
    end
    Wait(0)
  end
end)

function DrawText3Ds(x,y,z,q,a, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    if dist < a then
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / q
	    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end
end

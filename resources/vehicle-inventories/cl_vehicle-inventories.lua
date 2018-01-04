local SETTINGS = {
  inventory_key = 311 -- "E"
}

--------------------
-- EVENT HANDLERS --
--------------------
RegisterNetEvent("vehicle:loadedInventory")
AddEventHandler("vehicle:loadedInventory", function(target_vehicle_inventory)
  print("loaded target vehicle inventory with #: " .. #target_vehicle_inventory)
  if target_vehicle_inventory then
    if #target_vehicle_inventory > 0 then
      for i = 1, #target_vehicle_inventory do
        local item = target_vehicle_inventory[i]
        TriggerEvent('chatMessage', "", {}, "["..i.."] (x"..item.quantity..") " .. item.name)
      end
    else
      TriggerEvent('chatMessage', "", {}, "Vehicle has nothing stored in it!")
    end
  else
    print("Error. Something went wrong when trying to load the vehicle's inventory!")
  end
end)

RegisterNetEvent("vehicle:checkTargetVehicleForStorage")
AddEventHandler("vehicle:checkTargetVehicleForStorage", function(item, quantity)
  -- 1) get quantity to store from user input
  -- 2) store item with given quantity
  -- 3) remove item from user inventory or decrement appropriate quantity
  local target_vehicle = getVehicleInFrontOfUser()
  print("target_vehicle: " .. target_vehicle)
  -- see if car is locked or not:
  local lock_status = GetVehicleDoorLockStatus(target_vehicle)
  if lock_status ~= 2 then
    if target_vehicle ~= 0 then
      local target_vehicle_plate = GetVehicleNumberPlateText(target_vehicle)
      print("plate #: " .. target_vehicle_plate)
      SetVehicleDoorOpen(target_vehicle, 5, false, false)
      -- play animation:
      local anim = {
        dict = "anim@mp_fireworks",
        name = "place_firework_1_rocket"
      }
      --[[
      RequestAnimDict(anim.dict)
      while not HasAnimDictLoaded(anim.dict) do
        Citizen.Wait(100)
      end
      if not IsEntityPlayingAnim(GetPlayerPed(-1), anim.dict, anim.name, 3) and not IsPedInAnyVehicle(GetPlayerPed(-1), 1) then
        TaskPlayAnim(GetPlayerPed(-1), anim.dict, anim.name, 8.0, -8, 3000, 53, 0, 0, 0, 0)
      end
      --]]
      TriggerEvent("usa:playAnimation", anim.name, anim.dict, 4)
      --print("calling vehicle:storeItem with item.quantity: " .. item.quantity .. ", which will be changed to: " .. quantity)
      TriggerServerEvent("vehicle:storeItem", target_vehicle_plate, item, quantity)
      TriggerServerEvent("usa:removeItem", item, quantity)
      -- remove weapon from ped if type was weapon:
      if item.type == "weapon" then
        RemoveWeaponFromPed(GetPlayerPed(-1), item.hash)
      end
    end
  else
    TriggerEvent("usa:notify", "Vehicle is locked. Can't open storage.")
  end
end)

RegisterNetEvent("vehicle:retrieveWeapon")
AddEventHandler("vehicle:retrieveWeapon", function(target_item, target_vehicle_plate)
  -- Get quantity to transfer from user input:
  Citizen.CreateThread( function()
          DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
          while true do
              if ( UpdateOnscreenKeyboard() == 1 ) then
                  local input_amount = GetOnscreenKeyboardResult()
                  if ( string.len( input_amount ) > 0 ) then
                      local amount = tonumber( input_amount )
                      if ( amount > 0 ) then
                          -- trigger server event to remove money
                          amount = round(amount, 0)
                          local quantity_to_transfer = amount
                          if quantity_to_transfer <= target_item.quantity then
                            -- Remove/decrement full item with name data.itemName from vehicle inventory with plate matching target_vehicle.plate:
                            print("removing item (" .. target_item.name .. ") from vehicle inventory, quantity: " .. quantity_to_transfer)
                            TriggerServerEvent("vehicle:removeItem", target_item.name, quantity_to_transfer, target_vehicle_plate)
                            -- Add/increment full item with name data.itemName into player's inventory:
                            TriggerServerEvent("usa:insertItem", target_item, quantity_to_transfer)
                          else
                            TriggerEvent("usa:notify", "Quantity input too high!")
                          end
                      end
                      -- experimental:
                      TriggerServerEvent("vehicle:finishedUsingInventory", target_vehicle_plate)
                      break
                  else
                      DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
                  end
              elseif ( UpdateOnscreenKeyboard() == 2 ) then
                  -- experimental:
                  TriggerServerEvent("vehicle:finishedUsingInventory", target_vehicle_plate)
                  break
              end
          Citizen.Wait( 0 )
      end
  end )
end)

RegisterNetEvent("vehicle:continueRetrievingItem")
AddEventHandler("vehicle:continueRetrievingItem", function(plate, item, quantity)
  -- Remove/decrement full item with name data.itemName from vehicle inventory with plate matching target_vehicle.plate:
  print("removing item (" .. item.name .. ") from vehicle inventory, quantity: " .. quantity)
  TriggerServerEvent("vehicle:removeItem", item.name, quantity, plate)
  -- Add/increment full item with name data.itemName into player's inventory:
  TriggerServerEvent("usa:insertItem", item, quantity)
  -- experimental:
  TriggerServerEvent("vehicle:finishedUsingInventory", plate)
end)
-----------------------------------------
-- OPEN/CLOSE TARGET VEHICLE INVENTORY --
-----------------------------------------
Citizen.CreateThread(function()
	while true do
		Wait(0)
    --print("waiting for key press in veh inventories resource...")
		if IsControlJustPressed(1, SETTINGS.inventory_key) then
      local target_vehicle = getVehicleInFrontOfUser()
      print("target_vehicle: " .. target_vehicle)
      if target_vehicle ~= 0 then
        local target_vehicle_plate = GetVehicleNumberPlateText(target_vehicle)
        print("plate #: " .. target_vehicle_plate)
        SetVehicleDoorOpen(target_vehicle, 5, false, false)
        TriggerServerEvent("vehicle:getInventory", target_vehicle_plate)
      end
    end
	end
end)

-----------------------
-- UTILITY FUNCTIONS --
-----------------------
function getVehicleInFrontOfUser()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 1.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

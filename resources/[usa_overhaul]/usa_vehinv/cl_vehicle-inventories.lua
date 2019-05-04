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
  --print("target_vehicle: " .. target_vehicle)
  -- see if car is locked or not:
  local lock_status = GetVehicleDoorLockStatus(target_vehicle)
  if lock_status ~= 2 then -- not locked
    if target_vehicle ~= 0 then -- there is a detected vehicle
      local target_vehicle_plate = GetVehicleNumberPlateText(target_vehicle)
      TriggerServerEvent("vehicle:canVehicleHoldItem", target_vehicle, target_vehicle_plate, item, quantity)
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
          amount = math.floor(amount)
          if ( amount > 0 ) then
            -- trigger server event to remove money
            local quantity_to_transfer = amount
            if quantity_to_transfer <= target_item.quantity then
              -- Remove/decrement full item with name data.itemName from vehicle inventory with plate matching target_vehicle.plate:
              --print("removing item (" .. target_item.name .. ") from vehicle inventory, quantity: " .. quantity_to_transfer)
              TriggerServerEvent("vehicle:removeItem", target_item, quantity_to_transfer, target_vehicle_plate)
              -- Add/increment full item with name data.itemName into player's inventory:
              TriggerServerEvent("usa:insertItem", target_item, quantity_to_transfer)
            else
              TriggerEvent("usa:notify", "Quantity input too high!")
            end
          else
            TriggerEvent("usa:notify", "Quantity input too low!")
          end
          -- kinda experimental:
          TriggerServerEvent("vehicle:finishedUsingInventory", target_vehicle_plate)
          break
        else
          DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
        end
      elseif (UpdateOnscreenKeyboard() == 2) then
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
  TriggerServerEvent("vehicle:removeItem", item, quantity, plate)
  -- Add/increment full item with name data.itemName into player's inventory:
  item.quantity = quantity
  TriggerServerEvent("usa:insertItem", item, quantity)
  -- experimental:
  TriggerServerEvent("vehicle:finishedUsingInventory", plate)
end)

RegisterNetEvent("vehicle:continueStoringItem")
AddEventHandler("vehicle:continueStoringItem", function(vehId, plate, item, quantity, tempVeh)
  --print("inside continue storing item function....")
  SetVehicleDoorOpen(vehId, 5, false, false)
  -- play animation:
  local anim = {
    dict = "anim@mp_fireworks",
    name = "place_firework_1_rocket"
  }
  --TriggerEvent("usa:playAnimation", anim.name, anim.dict, 4)
  --TriggerEvent("usa:playAnimation", anim.dict, anim.name, 5, 1, 4000, 31, 0, 0, 0, 0)
  TriggerEvent("usa:playAnimation", anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 4)
  --print("calling vehicle:storeItem with item.quantity: " .. item.quantity .. ", which will be changed to: " .. quantity)
  if not tempVeh then TriggerServerEvent("vehicle:storeItem", plate, item, quantity) else TriggerServerEvent("vehicle:storeTempItem", plate, item, quantity) end
  TriggerServerEvent("usa:removeItem", item, quantity)
  -- remove weapon from ped if type was weapon:
  if item.type == "weapon" then
    RemoveWeaponFromPed(GetPlayerPed(-1), item.hash)
  end
end)
-----------------------------------------
-- OPEN/CLOSE TARGET VEHICLE INVENTORY --
-----------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(1, SETTINGS.inventory_key) then
            local target_vehicle = getVehicleInFrontOfUser()
            if target_vehicle ~= 0 and IsEntityAVehicle(target_vehicle) then
                local target_vehicle_plate = GetVehicleNumberPlateText(target_vehicle)
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
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 2.0, 0.0)
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

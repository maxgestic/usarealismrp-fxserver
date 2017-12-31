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
  if target_vehicle ~= 0 then
    local target_vehicle_plate = GetVehicleNumberPlateText(target_vehicle)
    print("plate #: " .. target_vehicle_plate)
    SetVehicleDoorOpen(target_vehicle, 5, false, false)
    TriggerServerEvent("vehicle:storeItem", target_vehicle_plate, item, quantity)
    TriggerServerEvent("usa:removeItem", item, quantity)
  end
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
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

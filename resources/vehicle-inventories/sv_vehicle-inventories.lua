local vehicles_being_checked = {}

RegisterNetEvent("vehicle:finishedUsingInventory")
AddEventHandler("vehicle:finishedUsingInventory", function(plate)
  vehicles_being_checked[plate] = nil
end)

RegisterServerEvent("vehicle:getInventory")
AddEventHandler("vehicle:getInventory", function(target_plate_number)
  print("inside vehicle:getInventory...")
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayers", function(players)
    if players then
      for id, player in pairs(players) do
        local player_vehicles = player.getActiveCharacterData("vehicles")
        for i = 1, #player_vehicles do
          local veh = player_vehicles[i]
          if string.find(target_plate_number, tostring(veh.plate)) then
            TriggerClientEvent("vehicle:loadedInventory", userSource, veh.inventory)
          end
        end
      end
    end
  end)
end)

-- store an item in a vehicle
-- note: assumes that the quantity provided is <= item.quantiy
RegisterServerEvent("vehicle:storeItem")
AddEventHandler("vehicle:storeItem", function(vehicle_plate, item, quantity)
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayers", function(players)
    if players then
      for id, player in pairs(players) do
        local player_vehicles = player.getActiveCharacterData("vehicles")
        for i = 1, #player_vehicles do
          local veh = player_vehicles[i]
          if string.find(vehicle_plate, tostring(veh.plate)) then
            local vehicle_inventory = veh.inventory
            if not vehicle_inventory then
              print("vehicle inventory did not exist, setting to {}")
              vehicle_inventory = {}
              player_vehicles[i].inventory = {}
            end
            for j = 1, #vehicle_inventory do
              local vehicle_inventory_item = vehicle_inventory[j]
              if vehicle_inventory_item.name == item.name then
                player_vehicles[i].inventory[j].quantity = player_vehicles[i].inventory[j].quantity + quantity
                player.setActiveCharacterData("vehicles", player_vehicles)
                return
              end
            end
            item.quantity = quantity -- set quantity to the one provided as user input, assumes quantity provided is <= to item.quantity
            -- not already in inventory, add it:
            print("adding item to vehicle: " .. item.name .. ", quantity: " .. quantity)
            table.insert(player_vehicles[i].inventory, item)
            player.setActiveCharacterData("vehicles", player_vehicles)
          end
        end
      end
    end
  end)
end)

RegisterServerEvent("vehicle:removeItem")
AddEventHandler("vehicle:removeItem", function(item_name, quantity, target_vehicle_plate)
  print("inside vehicle:removeItem!")
  print("target item name: " .. item_name)
  print("target plate #: " .. target_vehicle_plate)
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayers", function(players)
    if players then
      for id, player in pairs(players) do
        local player_vehicles = player.getActiveCharacterData("vehicles")
        for i = 1, #player_vehicles do
          local veh = player_vehicles[i]
          if string.find(target_vehicle_plate, tostring(veh.plate)) then -- this is the vehicle whose inventory we want to target
            local vehicle_inventory = veh.inventory
            for j = 1, #vehicle_inventory do
              local vehicle_inventory_item = vehicle_inventory[j]
              if vehicle_inventory_item.name == item_name then
                player_vehicles[i].inventory[j].quantity = player_vehicles[i].inventory[j].quantity - quantity
                if player_vehicles[i].inventory[j].quantity <= 0 then
                  print("removing item from vehicle inventory!")
                  table.remove(player_vehicles[i].inventory, j)
                  player.setActiveCharacterData("vehicles", player_vehicles)
                  print("removed item from vehicle inventory!")
                else
                  print("decremented item quantity in vehicle inventory!")
                  player.setActiveCharacterData("vehicles", player_vehicles)
                end
                return
              end
            end
          end
        end
      end
    end
  end)
end)

-- when retrieving a weapon from a vehicle, first check if player has room for it
RegisterServerEvent("vehicle:checkPlayerWeaponAmount")
AddEventHandler("vehicle:checkPlayerWeaponAmount", function(item, vehicle_plate)
  local userSource = tonumber(source)
  if not vehicles_being_checked[vehicle_plate] then
    vehicles_being_checked[vehicle_plate] = true
    print("checking user weapon #...")
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
      local user_weapons = user.getActiveCharacterData("weapons")
      if #user_weapons < 3 then
        TriggerEvent("es:getPlayers", function(players)
          if players then
            for id, player in pairs(players) do
              local player_vehicles = player.getActiveCharacterData("vehicles")
              for i = 1, #player_vehicles do
                local veh = player_vehicles[i]
                if string.find(vehicle_plate, tostring(veh.plate)) then -- this is the vehicle whose inventory we want to target
                  local vehicle_inventory = veh.inventory
                  for j = 1, #vehicle_inventory do
                    local vehicle_inventory_item = vehicle_inventory[j]
                    if vehicle_inventory_item.name == item.name then
                      --if vehicle_inventory_item.quantity >= quantity then
                        print("weapon was still in vehicle to retrieve!")
                        TriggerClientEvent("vehicle:retrieveWeapon", userSource, item, vehicle_plate)
                        --TriggerClientEvent("vehicle:continueRetrievingItem", userSource, plate, item, quantity)
                        return
                    --  else
                    --    TriggerClientEvent("usa:notify", userSource, "Quantity input too high!")
                      --  return
                    --  end
                    end
                  end
                  -- not in vehicle at all:
                  TriggerClientEvent("usa:notify", userSource, "Item not in vehicle!")
                end
              end
            end
          end
        end)
      else
        TriggerClientEvent("usa:notify", userSource, "Can't carry more than 3 weapons!")
      end
    end)
  else
    print("****discontinuing****")
    TriggerClientEvent("usa:notify", userSource, "Please wait a moment.")
  end
end)

RegisterServerEvent("vehicle:isItemStillInVehicle")
AddEventHandler("vehicle:isItemStillInVehicle", function(plate, item, quantity)
  local userSource = tonumber(source)
  if not vehicles_being_checked[plate] then
    vehicles_being_checked[plate] = true
    print("inside vehicle:isItemStillInVehicle...")
    TriggerEvent("es:getPlayers", function(players)
      if players then
        for id, player in pairs(players) do
          local player_vehicles = player.getActiveCharacterData("vehicles")
          for i = 1, #player_vehicles do
            local veh = player_vehicles[i]
            if string.find(plate, tostring(veh.plate)) then -- this is the vehicle whose inventory we want to target
              local vehicle_inventory = veh.inventory
              for j = 1, #vehicle_inventory do
                local vehicle_inventory_item = vehicle_inventory[j]
                if vehicle_inventory_item.name == item.name then
                  if vehicle_inventory_item.quantity >= quantity then
                    print("item was still in vehicle to retrieve and had enough quantity!")
                    TriggerClientEvent("vehicle:continueRetrievingItem", userSource, plate, item, quantity)
                    return
                  else
                    TriggerClientEvent("usa:notify", userSource, "Quantity input too high!")
                    return
                  end
                end
              end
              -- not in vehicle at all:
              TriggerClientEvent("usa:notify", userSource, "Item not in vehicle!")
            end
          end
        end
      end
    end)
  else
    print("****discontinuing****")
    TriggerClientEvent("usa:notify", userSource, "Please wait a moment.")
  end
end)

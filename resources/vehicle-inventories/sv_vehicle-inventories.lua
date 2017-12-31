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
            for j = 1, #vehicle_inventory do
              local vehicle_inventory_item = vehicle_inventory[j]
              if vehicle_inventory_item.name == item.name then
                player_vehicles[i].inventory[j].quantity = player_vehicles[i].inventory[j].quantity + quantity
                player.setActiveCharacterData("vehicles", player_vehicles)
                return
              end
            end
            -- not already in inventory, add it:
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

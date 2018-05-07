RegisterServerEvent("carDamage:checkForRepairKit")
AddEventHandler("carDamage:checkForRepairKit", function(vehicle)
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            if i <= #inventory and i ~= 0 then
                if inventory[i].name == "Repair Kit" then
                    if math.random(1, 100) < 70 then -- 70% chance to repair
                        TriggerClientEvent("carDamage:repairVehicle", userSource, vehicle)
                    else
                        TriggerClientEvent("carDamage:notifiyCarRepairFailed", userSource)
                    end
                    if inventory[i].quantity > 1 then
                        inventory[i].quantity = inventory[i].quantity - 1
                        user.setActiveCharacterData("inventory", inventory)
                    else
                        table.remove(inventory, i)
                        user.setActiveCharacterData("inventory", inventory)
                    end
                    CancelEvent()
                    return
                end
            end
        end
        TriggerClientEvent("carDamage:notifyNoRepairKit", userSource)
    end)
end)

RegisterServerEvent("vehicle:checkForKey")
AddEventHandler("vehicle:checkForKey", function(plate)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local inv = user.getActiveCharacterData("inventory")
    for i = 1, #inv do
      local item = inv[i]
      if item then
        if string.find(item.name, "Key") then
          if string.find(plate, item.plate) then
            TriggerClientEvent("vehicle:setEngineStatus", userSource, true)
            return
          end
        end
      end
    end
    -- no key owned for vehicle trying to lock/unlock
    TriggerClientEvent("usa:notify", userSource, "You don't have the keys to turn this vehicle on!")
end)

TriggerEvent('es:addCommand', 'hotwire', function(source, args, user)
  TriggerEvent("usa:getPlayerItem", source, "Toolkit", function(item)
    if item then
      TriggerClientEvent('vehicle:hotwire', source)
      TriggerEvent("usa:removeItem", item, 1, source)
    else
      TriggerClientEvent("usa:notify", source, "You don't have the tools required!")
    end
  end)
  --TriggerClientEvent('vehicle:hotwire', source)
end, {help = "Try to hotwire the vehicle you are in"})

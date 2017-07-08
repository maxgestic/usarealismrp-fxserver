RegisterServerEvent("carDamage:checkForRepairKit")
AddEventHandler("carDamage:checkForRepairKit", function(vehicle)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local inventory = user.getInventory()
        for i = 1, #inventory do
                if inventory[i].name == "Repair Kit" then
                    if math.random(1, 100) < 60 then -- 60% chance to repair
                        TriggerClientEvent("carDamage:repairVehicle", source, vehicle)
                    else
                        TriggerClientEvent("carDamage:notifiyCarRepairFailed", source)
                    end
                    if inventory[i].quantity > 1 then
                        user.inventory[i].quantity = user.inventory[i].quantity - 1
                    else
                        table.remove(inventory, i)
                    end
                    user.setInventory(inventory)
                    CancelEvent()
                    return
                end
        end
        TriggerClientEvent("carDamage:notifyNoRepairKit", source)
    end)
end)

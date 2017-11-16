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

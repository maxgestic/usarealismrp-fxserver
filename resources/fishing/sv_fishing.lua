RegisterServerEvent("fishing:giveFish")
AddEventHandler("fishing:giveFish", function(fish)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getInventory()
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == fish.name then
                print("found fish " .. item.name .. " in player's inventory already! incrementing..")
                inventory[i].quantity = item.quantity + 1
                user.setInventory(inventory)
                return
            end
        end
        print("adding fish to player inventory!")
        table.insert(inventory, fish)
        user.setInventory(inventory)
    end)
end)

RegisterServerEvent("fishing:sellFish")
AddEventHandler("fishing:sellFish", function()
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getInventory()
        for i = 1, #inventory do
            local item = inventory[i]
            if item then
                if item.type == "fish" then
                    print("found fish " .. item.name .. " in player's inventory already! selling..")
                    if item.quantity > 1 then
                        inventory[i].quantity = item.quantity - 1
                    else
                        table.remove(inventory, i)
                    end
                    user.setInventory(inventory)
                    user.addMoney(item.worth)
                    TriggerClientEvent("usa_rp:notify", userSource, "You have sold (1x) " .. item.name .. " for $" .. item.worth)
                end
            end
        end
    end)
end)

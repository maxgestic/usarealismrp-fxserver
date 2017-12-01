function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(item)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getMoney() >= item.price then
            user.removeMoney(item.price)
            local inventory = user.getInventory()
            for i = 1, #inventory do
                if inventory[i].name == item.name then
                    inventory[i].quantity = inventory[i].quantity + 1
                    user.setInventory(inventory)
                    return
                end
            end
            -- not already in player inventory at this point, so add it
            table.insert(inventory, item)
            user.setInventory(inventory)
        else
            -- not enough money
        end
    end)
end)

RegisterServerEvent("generalStore:getItemsAndDisplay")
AddEventHandler("generalStore:getItemsAndDisplay", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local inventory = user.getInventory()
        local items = {}
        for i = 1, #inventory do
            if inventory[i].legality == "legal" and inventory[i].type ~= "weapon" then
                table.insert(items, inventory[i])
            end
        end
        TriggerClientEvent("generalStore:displayItemsToSell", userSource, items)
    end)
end)

RegisterServerEvent("generalStore:sellItem")
AddEventHandler("generalStore:sellItem", function(item)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local inventory = user.getInventory()
        for i = 1, #inventory do
            if inventory[i].name == item.name then
                if inventory[i].quantity > 1 then
                    inventory[i].quantity = inventory[i].quantity - 1
                else
                    table.remove(inventory,i)
                end
                user.addMoney(round(.50*item.price,0))
                user.setInventory(inventory)
                return
            end
        end
    end)
end)

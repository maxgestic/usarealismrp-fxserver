function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(item)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
      local user_money = user.getActiveCharacterData("money")
        if user_money >= item.price then
          user.setActiveCharacterData("money", user_money - item.price)
            if item.name ~= "Cell Phone" then
                local inventory = user.getActiveCharacterData("inventory")
                for i = 1, #inventory do
                    if inventory[i].name == item.name then
                        inventory[i].quantity = inventory[i].quantity + 1
                        user.setActiveCharacterData("inventory", inventory)
                        return
                    end
                end
                -- not already in player inventory at this point, so add it
                table.insert(inventory, item)
                user.setActiveCharacterData("inventory", inventory)
            else
                --Generate number
                --Add Registered Owner
                --print(os.time())
                item.number = string.sub(tostring(os.time()), -8)
                item.owner = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
                item.name = item.name .. " - " .. item.number
                local inventory = user.getActiveCharacterData("inventory")
                table.insert(inventory, item)
                user.setActiveCharacterData("inventory", inventory)
                print(item.number .. " ---- " .. item.owner)
            end
        else
            -- not enough money
        end
    end)
end)

RegisterServerEvent("generalStore:getItemsAndDisplay")
AddEventHandler("generalStore:getItemsAndDisplay", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local inventory = user.getActiveCharacterData("inventory")
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
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            if inventory[i].name == item.name then
                if inventory[i].quantity > 1 then
                    inventory[i].quantity = inventory[i].quantity - 1
                else
                    table.remove(inventory,i)
                end
                local user_money = user.getActiveCharacterData("money")
                user.setActiveCharacterData("money", user_money + round(.50*item.price,0))
                user.setActiveCharacterData("inventory", inventory)
                return
            end
        end
    end)
end)

RegisterServerEvent("interaction:tackle")
AddEventHandler("interaction:tackle", function(targetId)
    TriggerClientEvent("interaction:ragdoll", targetId)
end)

RegisterServerEvent("test:cuff")
AddEventHandler("test:cuff", function(playerId, playerName)
    print("going to cuff " .. playerName .. " with id of " .. playerId)
    --TriggerClientEvent("cuff:Handcuff", tonumber(1), GetPlayerName(source))
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if user then
            playerJob = user.getActiveCharacterData("job")
            if playerJob == "sheriff" or playerJob == "cop" then
                print("cuffing player " .. GetPlayerName(source) .. "...")
                TriggerClientEvent("cuff:Handcuff", tonumber(playerId), GetPlayerName(source))
            else
                print("player was not on duty to cuff")
            end
        else
            print("player with that ID # did not exist...")
        end
    end)
end)

RegisterServerEvent("interaction:loadInventoryForInteraction")
AddEventHandler("interaction:loadInventoryForInteraction", function()
    print("loading inventory for interaction menu...")
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local inventory = user.getActiveCharacterData("inventory")
            local weapons = user.getActiveCharacterData("weapons")
            local licenses = user.getActiveCharacterData("licenses")
            TriggerClientEvent("interaction:inventoryLoaded", userSource, inventory, weapons, licenses)
        else
            print("interaction: user did not exist")
        end
    end)
end)

RegisterServerEvent("interaction:checkForPhone")
AddEventHandler("interaction:checkForPhone", function()
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == "Cell Phone" then
                TriggerClientEvent("interaction:playerHadPhone", userSource)
                return
            end
        end
        TriggerClientEvent("interaction:notify", userSource, "You have no cell phone to open!")
    end)
end)

RegisterServerEvent("interaction:removeItemFromPlayer")
AddEventHandler("interaction:removeItemFromPlayer", function(itemName)
    itemName = removeQuantityFromItemName(itemName)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == itemName then
                if item.quantity > 1 then
                    inventory[i].quantity = item.quantity - 1
                    user.setActiveCharacterData("inventory", inventory)
                    return
                else
                    table.remove(inventory, i)
                    user.setInventory(inventory)
                    return
                end
            end
        end
    end)
end)

RegisterServerEvent("interaction:dropItem")
AddEventHandler("interaction:dropItem", function(itemName)
    local userSource = tonumber(source)
    itemName = removeQuantityFromItemName(itemName)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        -- inventory
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == itemName then
                --print("found matching item to drop!")
                if item.quantity > 1 then
                    inventory[i].quantity = item.quantity - 1
                    user.setActiveCharacterData("inventory", inventory)
                    return
                else
                    table.remove(inventory, i)
                    user.setInventory(inventory)
                    return
                end
            end
        end
        -- weapons
        local weapons = user.getActiveCharacterData("weapons")
        for i = 1, #weapons do
            local item = weapons[i]
            if item.name == itemName then
                --print("found matching item to drop!")
                table.remove(weapons, i)
                user.setActiveCharacterData("weapons", weapons)
                TriggerClientEvent("interaction:equipWeapon", userSource, item, false)
                return
            end
        end
        -- licenses
        local licenses = user.getActiveCharacterData("licenses")
        for i = 1, #licenses do
            local item = licenses[i]
            if item.name == itemName then
                --print("found matching item to drop!")
                table.remove(licenses, i)
                user.setActiveCharacterData("licenses", licenses)
                return
            end
        end
    end)
end)

function removeQuantityFromItemName(itemName)
    if string.find(itemName,"%)") then
        local i = string.find(itemName, "%)")
        i = i + 2
        itemName = string.sub(itemName, i)
        --print("new item name = " .. itemName)
    end
    return itemName
end

RegisterServerEvent("interaction:giveItemToPlayer")
AddEventHandler("interaction:giveItemToPlayer", function(item, targetPlayerId)
    local userSource = tonumber(source)
    print("inside of server func with target id = " .. targetPlayerId)
    print("item.name = " .. item.name)
    -- give item to nearest player
    TriggerEvent("es:getPlayerFromId", targetPlayerId, function(user)
        if user then
            if not item.type then
                -- must be a license (no item.type)
                print("giving a license!")
                local licenses = user.getActiveCharacterData("licenses")
                table.insert(licenses, item)
                user.setActiveCharacterData("licenses", licenses)
            else
                if item.type == "weapon" then
                    print("giving a weapon!")
                    local weapons = user.getActiveCharacterData("weapons")
                    if #weapons < 3 then
                        table.insert(weapons, item)
                        user.setActiveCharacterData("weapons", weapons)
                        TriggerClientEvent("interaction:equipWeapon", targetPlayerId, item, true)
                        TriggerClientEvent("interaction:equipWeapon", userSource, item, false)
                    else
                        TriggerClientEvent("interaction:notify", userSource, GetPlayerName(targetPlayerId) .. " can't hold anymore weapons!")
                        return
                    end
                else
                    local found = false
                    print("giving an inventory item!")
                    local inventory = user.getActiveCharacterData("inventory")
                    for i = 1, #inventory do
                        if inventory[i].name == item.name then
                            found = true
                            inventory[i].quantity = inventory[i].quantity + 1
                            user.setActiveCharacterData("inventory", inventory)
                        end
                    end
                    if not found then
                        item.quantity = 1
                        table.insert(inventory, item)
                        user.setActiveCharacterData("inventory", inventory)
                    end
                end
            end
            -- remove from source player
            removeItemFromPlayer(item, userSource)
            TriggerClientEvent("interaction:notify", userSource, "You gave " .. GetPlayerName(targetPlayerId) .. ": (x1) " .. item.name)
            TriggerClientEvent("interaction:notify", targetPlayerId, GetPlayerName(userSource) .. " has given you " .. ": (x1) " .. item.name)
        else
            print("player with id #" .. targetPlayerId .. " is not in game!")
            return
        end
    end)
end)

function removeItemFromPlayer(item, userSource)
    -- remove item from player
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            if not item.type then
                -- must be a license (no item.type)
                print("removing a license!")
                local licenses = user.getActiveCharacterData("licenses")
                for i = 1, #licenses do
                    if licenses[i].name == item.name and licenses[i].ownerName == item.ownerName then
                        --print("found a matching licenses to remove!!")
                        table.remove(licenses, i)
                        user.setActiveCharacterData("licenses", licenses)
                        return
                    end
                end
            else
                if item.type == "weapon" then
                    print("removing a weapon!")
                    local weapons = user.getActiveCharacterData("weapons")
                    for i = 1, #weapons do
                        if weapons[i].name == item.name then
                            print("found a matching weapon to remove!")
                            table.remove(weapons,i)
                            user.setActiveCharacterData("weapons", weapons)
                            return
                        end
                    end
                else
                    print("removing an inventory item!")
                    local inventory = user.getActiveCharacterData("inventory")
                    for i = 1, #inventory do
                        if inventory[i].name == item.name then
                            print("found matching item to remove!")
                            if inventory[i].quantity > 1 then
                                inventory[i].quantity = inventory[i].quantity - 1
                                user.setActiveCharacterData("inventory", inventory)
                                return
                            else
                                table.remove(inventory,i)
                                user.setActiveCharacterData("inventory", inventory)
                                return
                            end
                        end
                    end
                end
            end
        else
            print("player with id #" .. targetPlayerId .. " is not in game!")
        end
    end)
end

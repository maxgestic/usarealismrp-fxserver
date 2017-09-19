RegisterServerEvent("test:cuff")
AddEventHandler("test:cuff", function(playerId, playerName)
    print("going to cuff " .. playerName .. " with id of " .. playerId)
    --TriggerClientEvent("cuff:Handcuff", tonumber(1), GetPlayerName(source))
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if user then
            playerJob = user.getJob()
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
            local inventory = user.getInventory()
            local weapons = user.getWeapons()
            local licenses = user.getLicenses()
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
        local inventory = user.getInventory()
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

RegisterServerEvent("interaction:checkPlayerJob")
AddEventHandler("interaction:checkPlayerJob", function()
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            print("SUCCESS! PLAYER'S JOB = " .. user.getJob())
            TriggerClientEvent("interaction:sendPlayersJob", userSource, user.getJob())
        end
    end)
end)

RegisterServerEvent("interaction:removeItemFromPlayer")
AddEventHandler("interaction:removeItemFromPlayer", function(itemName)
    if string.find(itemName,"%)") then
        local i = string.find(itemName, "%)")
        i = i + 2
        itemName = string.sub(itemName, i)
        print("new item name = " .. itemName)
    end
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getInventory()
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == itemName then
                if item.quantity > 1 then
                    inventory[i].quantity = item.quantity - 1
                    user.setInventory(inventory)
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

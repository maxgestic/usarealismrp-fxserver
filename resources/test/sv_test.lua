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
            end
        end
    end)
end)

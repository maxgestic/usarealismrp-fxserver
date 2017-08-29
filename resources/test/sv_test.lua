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

--[[
Gets called when the player is initialized.
AddEventHandler('es:initialized', function(player)
    print("PLAYER INITILIAZED! INSIDE JSCOREBOARD!")
    local player_group = player.getGroup()
    print("scoreboard group = " .. player_group)
    TriggerClientEvent("jscoreboard:setUserGroup", source, player_group)
end)
--]]

-- Gets called when a player is fully loaded.
AddEventHandler('es:playerLoaded', function(source)
    print("INSIDE JSCOREBOARD PLAYER LOADED!")
    local userSource = tonumber(source)
    print("userSource = " .. userSource)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_group = user.getGroup()
        print("scoreboard user group = " .. user_group)
        TriggerClientEvent("jscoreboard:setUserGroup", userSource, user_group)
    end)
end)

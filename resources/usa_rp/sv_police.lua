local players = {}

-- confiscating weapons
TriggerEvent('es:addCommand', 'confiscate', function(source, args, user)
    if user.getJob() == "sheriff"  or user.getJob() == "admin" or user.getJob() == "superadmin" or user.getJob() == "owner" then
        targetPlayer = tonumber(args[2])
        TriggerEvent("es:getPlayerFromId", targetPlayer, function(user)
            if not players[targetPlayer] then
                if user then
                    -- save user's confiscated weapons
                    players[targetPlayer] = user.getWeapons()
                    for i = 1, #players[targetPlayer] do
                        local weapon = players[targetPlayer][i]
                        -- notify officer
                        TriggerClientEvent("chatMessage", source, "", {}, "You have confiscated a ^3" .. weapon.name .. "^0 from " .. GetPlayerName(targetPlayer))
                    end
                    -- remove weapons from inventory
                    user.setWeapons({})
                    -- take from player
                    TriggerClientEvent("police:confiscateWeapons", targetPlayer)
                else
                    -- player does not exist / is not online
                end
            else -- player's weapons have already been confiscated
                if GetPlayerName(targetPlayer) then
                    print("calling rearm for " .. GetPlayerName(targetPlayer))
                    for i = 1, #players[targetPlayer] do
                        local weapon = players[targetPlayer][i]
                        TriggerClientEvent("chatMessage", source, "", {}, "You have returned " .. GetPlayerName(targetPlayer) .. "'s ^3" .. weapon.name)
                    end
                    user.setWeapons(players[targetPlayer])
                    players[targetPlayer] = nil
                    TriggerClientEvent("police:rearm", targetPlayer)
                end
            end
        end)
    else
        TriggerClientEvent("chatMessage", source, "", {}, "^3Only LEOs can use /confiscate!")
    end
end)

-- rearm ped
TriggerEvent('es:addCommand', 'rearm', function(source, args, user)
    local targetPlayer = tonumber(args[2])
    print("calling rearm for " .. GetPlayerName(targerPlayer))
    TriggerClientEvent("police:rearm", targetPlayer)
end)

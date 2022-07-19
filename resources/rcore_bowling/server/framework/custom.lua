local lastWager = 0

CreateThread(function()
    if Config.Framework == 3 then
        PlayerHasMoney = function(serverId, amount)
            local char = exports["usa-characters"]:GetCharacter(serverId)
            return char.get("money") >= amount
        end

        PlayerTakeMoney = function(serverId, amount)
            amount = math.abs(amount)
            local char = exports["usa-characters"]:GetCharacter(serverId)
            char.removeMoney(amount)
            lastWager = amount
        end

        PlayerGiveMoney = function(serverId, amount)
            if #(GetEntityCoords(serverId) - Config.Blips[1]) >= 150 or amount > lastWager then
                DropPlayer(serverId, "LISTEN BUDDY -- ONE MORE TIME AND YOU'RE GONE!!!!!!!!!!!!!!!!!!!!!!!!!!! BAN BAN B A N")
                return
            end
            local char = exports["usa-characters"]:GetCharacter(serverId)
            char.giveMoney(amount)
        end

        SendNotification = function(serverId, msg)
            TriggerClientEvent("usa:notify", serverId, msg)
        end
    end
end)
CreateThread(function()
    if not Config.EnableESX and not Config.EnableQBCore and not Config.EnableCustomEvents then
        ShowNotification = function(source, text)
            TriggerClientEvent('lsrp_stickers:showNotification', source, text)
        end

        GetPlayerId = function(source)
            return ''
        end

        GetPlayerJob = function(source)
            return ''
        end

        PayAmount = function(source, amount)
            return true
        end

        IsPlayerAllowed = function(source)
            return true
        end
    end
end)
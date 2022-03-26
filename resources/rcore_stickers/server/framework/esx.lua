CreateThread(function()
    if Config.EnableESX then
        local ESX = exports['es_extended']:getSharedObject()

        ShowNotification = function(source, text)
            TriggerClientEvent('esx:showNotification', source, text)
        end

        GetPlayerId = function(source)
            return ESX.GetPlayerFromId(source).getIdentifier()
        end

        GetPlayerJob = function(source)
            return ESX.GetPlayerFromId(source).job['name']
        end

        PayAmount = function(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
                
                return true
            else
                return false
            end
        end

        -- Edit this function to your needs if you want this script to be accessible only for certain players
        IsPlayerAllowed = function(source)
            return true
        end
    end
end)
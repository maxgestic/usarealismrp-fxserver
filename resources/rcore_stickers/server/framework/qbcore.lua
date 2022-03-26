CreateThread(function()
    if Config.EnableQBCore then
        local QBCore = exports['qb-core']:GetCoreObject()

        ShowNotification = function(source, text)
            TriggerClientEvent('QBCore:Notify', source, text)
        end

        GetPlayerId = function(source)
            return QBCore.Functions.GetIdentifier(source, 'license')
        end

        GetPlayerJob = function(source)
            return QBCore.Functions.GetPlayer(source).PlayerData.job['name']
        end

        PayAmount = function(source, amount)
            local player = QBCore.Functions.GetPlayer(source)

            if player.PlayerData.money['cash'] >= amount then
                player.Functions.RemoveMoney('cash', amount)

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
CreateThread(function()
    if Config.EnableQBCore then
        local QBCore = exports['qb-core']:GetCoreObject()

        ShowNotification = function(text)
            QBCore.Functions.Notify(text, nil, 5000)
        end
    end
end)
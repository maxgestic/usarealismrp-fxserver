CreateThread(function()
    if not Config.EnableESX and not Config.EnableQBCore and not Config.EnableCustomEvents then
        ShowNotification = function(text)
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandThefeedPostTicker(true, true)
        end

        RegisterNetEvent('lsrp_stickers:showNotification')
        AddEventHandler('lsrp_stickers:showNotification', ShowNotification)
    end
end)
CreateThread(function()
    if Config.EnableCustomEvents then
        ShowNotification = function(text)
            TriggerEvent('rcore_stickers:showNotification', text)
        end
    end
end)

RegisterNetEvent("rcore_stickers:showNotification")
AddEventHandler("rcore_stickers:showNotification", function(text)
    exports.globals:notify(text)
end)

RegisterNetEvent("rcore_stickers:open")
AddEventHandler("rcore_stickers:open", function()
    ExecuteCommand("stickers")
end)
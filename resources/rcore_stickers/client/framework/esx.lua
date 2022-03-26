CreateThread(function()
    if Config.EnableESX then
        local ESX = exports['es_extended']:getSharedObject()

        ShowNotification = function(text)
            ESX.ShowNotification(text, true, false, 140)
        end
    end
end)
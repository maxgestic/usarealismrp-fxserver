local MENU_OPEN = false

RegisterNetEvent("commerce:openStore")
AddEventHandler("commerce:openStore", function()
    toggleStoreGUI(true)
end)

RegisterNUICallback("closeStore", function(data, cb)
    toggleStoreGUI(false)
end)

RegisterNUICallback("purchase", function(data, cb)
    toggleStoreGUI(false)
    TriggerServerEvent("commerce:purchase", data.id)
end)

function toggleStoreGUI(doOpen)
    MENU_OPEN = doOpen
    SendNUIMessage({
        type = "toggle",
        doOpen = doOpen
    })
    SetNuiFocus(doOpen, doOpen)
end
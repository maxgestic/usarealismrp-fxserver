local MENU_OPEN = false

RegisterNetEvent("commerce:openStore")
AddEventHandler("commerce:openStore", function()
    MENU_OPEN = true
    SendNUIMessage({
        type = "toggle",
        doOpen = true
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("closeStore", function(data, cb)
    MENU_OPEN = false
    SendNUIMessage({
        type = "toggle",
        doOpen = false
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback("purchase", function(data, cb)
    TriggerServerEvent("commerce:purchase", data.id)
end)
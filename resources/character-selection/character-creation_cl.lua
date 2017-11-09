local menuOpen = false

RegisterNetEvent("character:test")
AddEventHandler("character:test", function()
    toggleMenu(not menuOpen)
end)

RegisterNetEvent("character:open")
AddEventHandler("character:open", function()
    toggleMenu(true)
end)

RegisterNUICallback('escape', function(data, cb)
    toggleMenu(false)
    cb('ok')
end)

function toggleMenu(status)
    SetNuiFocus(status, status)
    menuOpen = status
    SendNUIMessage({
        type = "toggleMenu",
        menuStatus = status
    })
end

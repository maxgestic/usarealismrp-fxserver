local menuOpen = false

RegisterNetEvent("character:open")
AddEventHandler("character:open", function(menu, data)
    menuOpen = true
    toggleMenu(menuOpen, menu, data)
end)

RegisterNetEvent("character:close")
AddEventHandler("character:close", function()
    menuOpen = false
    toggleMenu(menuOpen)
end)

RegisterNUICallback('escape', function(data, cb)
    toggleMenu(false)
    cb('ok')
end)

RegisterNUICallback('new-character-submit', function(data, cb)
    local characterData = {
        firstName = data.firstName,
        middleName = data.middleName,
        lastName = data.lastName,
        dateOfBirth = data.dateOfBirth
    }
    -- save the new character with the data from the GUI form into the first character slot
    TriggerServerEvent("character:save", characterData, 1)
    cb('ok')
end)

function toggleMenu(status, menu, data)
    SetNuiFocus(status, status)
    menuOpen = status
    SendNUIMessage({
        type = "toggleMenu",
        menuStatus = status,
        menu = menu,
        data = data
    })
end

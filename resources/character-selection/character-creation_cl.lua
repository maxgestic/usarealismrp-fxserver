local menuOpen = false
local selectedCharacter = {}
local selectedCharacterSlot = 0

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
    print("saving character " .. data.firstName .. " into slot #" .. data.slot)
    local slot = data.slot
    local characterData = {
        firstName = data.firstName,
        middleName = data.middleName,
        lastName = data.lastName,
        dateOfBirth = data.dateOfBirth
    }
    -- save the new character with the data from the GUI form into the first character slot
    TriggerServerEvent("character:save", characterData, slot)
    cb('ok')
end)

RegisterNUICallback('select-character', function(data, cb)
    Citizen.Trace("selecting char: " .. data.character.firstName)
    selectedCharacter = data.character -- set selected character on lua side from selected js char card
    selectedCharacterSlot = tonumber(data.slot) + 1
    TriggerEvent("chat:setCharName", selectedCharacter)
    TriggerServerEvent("altchat:setCharName", selectedCharacter)
    toggleMenu(false)
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

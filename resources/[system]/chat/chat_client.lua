local chatInputActive = false
local chatInputActivating = false

-- START CHAR RELATED STUFF --
local characterName = {
    first = "",
    middle = "",
    last = ""
}

RegisterNetEvent("chat:setCharName")
AddEventHandler("chat:setCharName", function(character)
    characterName.first = character.firstName
    characterName.middle = character.middleName
    characterName.last = character.lastName
end)
-- END CHAR RELATED STUFF

RegisterNetEvent('chatMessage')

AddEventHandler('chatMessage', function(name, color, message)
    SendNUIMessage({
        name = name,
        color = color,
        message = message
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false

    SetNuiFocus(false)

    if data.message then
        local id = PlayerId()

        --local r, g, b = GetPlayerRgbColour(id, _i, _i, _i)
        local r, g, b = 0, 0x99, 255

        local author = characterName.first .. " " .. characterName.last
        TriggerServerEvent('chatMessageEntered', author, { r, g, b }, data.message)
        Citizen.Trace("data.message = " .. data.message)

    end

    cb('ok')
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)

    while true do
        Wait(0)

        if not chatInputActive then
            if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    meta = 'openChatBox'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end
    end
end)

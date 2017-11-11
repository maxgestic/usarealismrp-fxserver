TriggerEvent('es:addCommand', 'test', function(source, args, user)
    if args[2] then
        if args[2] ~= "close" then
            local menu = args[2]
            TriggerClientEvent("character:open", source, menu)
        else
            TriggerClientEvent("character:close", source)
        end
    end
end)

RegisterServerEvent("character:setActive")
AddEventHandler("character:setActive", function(slot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            for i = 1, #characters do
                if i == tonumber(slot) then
                    characters[i].active = true
                else
                    characters[i].active = false
                end
            end
            user.setCharacters(characters)
        end
    end)
end)

RegisterServerEvent("character:save")
AddEventHandler("character:save", function(characterData, slot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            characters[slot] = characterData
            print("saving character data into slot #" .. slot)
            user.setCharacters(characters)
        end
    end)
end)

RegisterServerEvent("character:loadAppearance")
AddEventHandler("character:loadAppearance", function(activeSlot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            local character = characters[activeSlot]
            TriggerClientEvent("character:setAppearance", userSource, character)
        end
    end)
end)

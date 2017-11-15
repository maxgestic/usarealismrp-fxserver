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
            print("trying to save character data into slot #" .. slot .. "...")
            characters[slot] = characterData
            user.setCharacters(characters)
            print("done saving character data into slot #" .. slot)
        end
    end)
end)

RegisterServerEvent("character:loadCharacter")
AddEventHandler("character:loadCharacter", function(activeSlot)
    print("trying to load character in active slot #" .. activeSlot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            local character = characters[activeSlot]
            TriggerClientEvent("character:setCharacter", userSource, character)
            print("loaded character at slot #" .. activeSlot .. " with #weapons = " .. #(character.weapons))
        end
    end)
end)

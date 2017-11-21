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
            local money_to_display = 0
            local characters = user.getCharacters()
            for i = 1, #characters do
                if i == tonumber(slot) then
                    characters[i].active = true
                    money_to_display = characters[i].money
                else
                    characters[i].active = false
                end
            end
            user.setCharacters(characters)
            user.setActiveCharacterData("money", money_to_display) -- set money GUI in top right (?)
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

RegisterServerEvent("character:deleteCharacter")
AddEventHandler("character:deleteCharacter", function(slot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            print("trying to delete character at slot #" .. slot .. "...")
            characters[slot] = {active = false}
            user.setCharacters(characters)
            print("done deleting character at slot #" .. slot)
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

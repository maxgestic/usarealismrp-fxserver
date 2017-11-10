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

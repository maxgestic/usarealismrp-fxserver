TriggerEvent('es:addCommand', 'test', function(source, args, user)
    TriggerClientEvent("character:test", source)
end)

TriggerEvent('es:addCommand', 'trailer', function(source, args, char)
    TriggerClientEvent("trailer:toggle", source)
end, {
    help = "Attach or detach a vehicle from a trailer",
})
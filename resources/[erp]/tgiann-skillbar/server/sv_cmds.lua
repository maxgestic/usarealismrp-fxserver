TriggerEvent('es:addCommand', 'erp', function(source, args, char, location)
    local id = args[2]
    TriggerClientEvent("erp:erp", source, id)
end, {
    help = "Send E-RP Request to Player!",
    params = {
        { name = "id", help = "ID of user to send request to" }
    }
})

TriggerEvent('es:addCommand', 'erpcancel', function(source, args, char, location)
    TriggerClientEvent("erp:erpcancel", source)
end, {
    help = "Revokes the permission of the permitted player!",
    params = {}
})

TriggerEvent('es:addCommand', 'p1', function(source, args, char, location)
    TriggerClientEvent("erp:p1", source)
end, {
    help = "Sex position 1",
    params = {}
})

TriggerEvent('es:addCommand', 'p2', function(source, args, char, location)
    TriggerClientEvent("erp:p2", source)
end, {
    help = "Sex position 2 (Car)",
    params = {}
})

TriggerEvent('es:addCommand', 'p3', function(source, args, char, location)
    TriggerClientEvent("erp:p3", source)
end, {
    help = "Sex position 3",
    params = {}
})

TriggerEvent('es:addCommand', 'p4', function(source, args, char, location)
    TriggerClientEvent("erp:p4", source)
end, {
    help = "Sex position 4 (Car)",
    params = {}
})

TriggerEvent('es:addCommand', 'p5', function(source, args, char, location)
    TriggerClientEvent("erp:p5", source)
end, {
    help = "Sex position 5 (Car)",
    params = {}
})

TriggerEvent('es:addCommand', 'p6', function(source, args, char, location)
    TriggerClientEvent("erp:p6", source)
end, {
    help = "Sex position 6 (Car)",
    params = {}
})

TriggerEvent('es:addCommand', 'p7', function(source, args, char, location)
    TriggerClientEvent("erp:p7", source)
end, {
    help = "Sex position 7 (Car)",
    params = {}
})
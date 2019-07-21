TriggerEvent('es:addCommand', 'notepad', function(source, args, char, location)
    TriggerClientEvent("notepad:toggle", source, source)
end, { help = "Open your notepad to write things in"})

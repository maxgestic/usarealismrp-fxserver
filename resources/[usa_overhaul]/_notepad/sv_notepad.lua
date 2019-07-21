TriggerEvent('es:addCommand', 'notepad', function(source, args, char, location)
    if char.hasItem("Notepad") then
        TriggerClientEvent("notepad:toggle", source, source)
    else
        TriggerClientEvent("usa:notify", source, "You need a notepad to use that!")
    end
end, { help = "Open your notepad to write things in"})

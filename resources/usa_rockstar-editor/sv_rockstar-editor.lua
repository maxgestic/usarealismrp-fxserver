TriggerEvent('es:addCommand', 'openeditor', function(src, args, char)
    print("opening r* editor for player: " .. src)
    TriggerClientEvent("rockstar-editor:open", src)
end, {
    help = "Open the R* Editor",
})

TriggerEvent('es:addCommand', 'record', function(src, args, char)
    print("args[1]: " .. args[2])
    args[2] = args[2]:lower()
    if args[2] ~= "start" and args[2] ~= "stop" and args[2] ~= "cancel" then
        TriggerClientEvent("usa:notify", src, "Usage: record [start | stop | cancel]", "^0Usage: record [start | stop | cancel]")
        return
    end
    TriggerClientEvent("rockstar-editor:record", src, args[2])
end, {
    help = "Start, stop, or cancel recording a clip for the R* Editor",
    params = {
		{ name = "option", help = "start | stop | cancel" }
	}
})
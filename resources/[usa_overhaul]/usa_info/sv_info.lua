TriggerEvent('es:addCommand', 'info', function(source, args, char)
	TriggerClientEvent('info:open', source)
end, { help = "Rules & Server Information" })

TriggerEvent('es:addCommand', 'info', function(source, args, user)
	TriggerClientEvent('info:open', source)
end, { help = "Rules & Server Information" })

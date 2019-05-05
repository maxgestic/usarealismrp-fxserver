TriggerEvent('es:addCommand', 'eup', function(source, args, user)
	TriggerClientEvent('eup:open', source)
end)
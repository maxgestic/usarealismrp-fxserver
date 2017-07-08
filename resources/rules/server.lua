TriggerEvent('es:addCommand', 'rules', function(source, args, user)
	TriggerClientEvent('rules:open', source)
end)

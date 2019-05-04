TriggerEvent('es:addGroupCommand', 'debug', 'superadmin', function(source, args, user)
	TriggerClientEvent('hud:enabledebug', source)
end, {
	help = "Toggle debug mode."
})
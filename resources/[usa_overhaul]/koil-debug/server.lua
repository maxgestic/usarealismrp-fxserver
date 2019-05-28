TriggerEvent('es:addGroupCommand', 'debug', 'owner', function(source, args, char)
	TriggerClientEvent('hud:enabledebug', source)
end, {
	help = "Toggle debug mode."
})
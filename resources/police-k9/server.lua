TriggerEvent('es:addJobCommand', 'k9', { "police", "sheriff", "ems", "fire" }, function(source, args, user)
	TriggerClientEvent("k9:transform", source)
end, {
	help = "Transform into a K9 (DO NOT USE UNLESS AUTHORIZED BY COMMAND STAFF)."
})

TriggerEvent('es:addCommand', 'hidetrunk', function(source, args, char)
	TriggerClientEvent('trunkhide:hideInNearestTrunk', source)
end, {
	help = "Hide or exit the nearest trunk."
})

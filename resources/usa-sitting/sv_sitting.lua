TriggerEvent('es:addCommand', 'sit', function(source, args, user)
	TriggerClientEvent('sit:sitOnNearest', source)
end, { help = "Sit on the nearest chair, seat, or bench (only compatable with certain seats)" })

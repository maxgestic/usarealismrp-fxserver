TriggerEvent('es:addCommand', 'sit', function(source, args, user)
	TriggerClientEvent("sit:sitOnNearest", source)
end, {help = "Sit on nearest thing"})

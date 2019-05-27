TriggerEvent('es:addCommand', 'sit', function(source, args, char)
	if char.get("jailTime") > 0 then return end
	TriggerClientEvent('sit:sitOnNearest', source)
end, { help = "Sit on the nearest chair, seat, or bench" })

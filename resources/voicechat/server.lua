TriggerEvent('es:addCommand', 'voip', function(source, args, user)
	TriggerClientEvent('voip', source, args[2])
end)

TriggerEvent('es:addCommand', 'talkingcircle', function(source, args, user)
	TriggerClientEvent('voip:toggleTalkingCircle', source)
end, {help = "Toggle talking cirlces (markers at feet when players speak)"})
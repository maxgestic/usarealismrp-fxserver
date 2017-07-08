TriggerEvent('es:addCommand', 'rappel', function(source, args, user)
	TriggerClientEvent("PH:rappel", source)
end)

TriggerEvent('es:addCommand', 'target', function(source, args, user)
	TriggerClientEvent("PH:toogleSpotlight", -1, source, tonumber(args[2]), true)
end)

RegisterServerEvent("PH:spotlightOff")
AddEventHandler("PH:spotlightOff", function(user)
	if user ~= -1 then
		TriggerClientEvent("PH:toogleSpotlight", -1, user, -1, false)
	else
		TriggerClientEvent("PH:toogleSpotlight", -1, source, -1, false)
	end
end)

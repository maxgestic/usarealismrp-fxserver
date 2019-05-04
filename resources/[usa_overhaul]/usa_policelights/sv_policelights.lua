RegisterServerEvent('policelights:requestSpotlight')
AddEventHandler('policelights:requestSpotlight', function(netVeh, direction, r, g, b)
	TriggerClientEvent('policelights:setSpotlight', -1, netVeh, direction, r, g, b)
end)

RegisterServerEvent('policelights:requestHeadlightColor')
AddEventHandler('policelights:requestHeadlightColor', function(netVeh, value)
	TriggerClientEvent('policelights:setHeadlightColor', -1, netVeh, value)
end)

TriggerEvent('es:addJobCommand', 'uclights', {'sheriff', 'police'}, function(source, args, user)
	TriggerClientEvent('policelights:enableLightsOnVehicle', source)
end, {
	help = "Enable undercover lights on non-police vehicles",
})


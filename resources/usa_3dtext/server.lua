RegisterServerEvent('display:shareDisplay')
AddEventHandler('display:shareDisplay', function(text, nbrLimit, factor2, maxDist, time, x)
	TriggerClientEvent('display:triggerDisplay', -1, source, text, nbrLimit, factor2, maxDist, time, x)
end)

RegisterServerEvent('display:shareDisplayBySource')
AddEventHandler('display:shareDisplayBySource', function(_source, text, nbrLimit, factor2, maxDist, time, x)
	TriggerClientEvent('display:triggerDisplay', -1, _source, text, nbrLimit, factor2, maxDist, time, x)
end)
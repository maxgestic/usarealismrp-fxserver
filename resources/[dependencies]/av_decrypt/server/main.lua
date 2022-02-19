RegisterServerEvent('thermite:efecto')
AddEventHandler('thermite:efecto', function(carga)
	TriggerClientEvent('thermite:bombaFx',-1, carga)
end)
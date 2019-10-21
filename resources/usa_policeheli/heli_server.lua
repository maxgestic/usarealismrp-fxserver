-- FiveM Heli Cam by mraes
-- Version 1.3 2017-06-12

RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	TriggerClientEvent('heli:spotlight', -1, source, state)
end)

RegisterServerEvent("heli:syncSpotlight")
AddEventHandler("heli:syncSpotlight", function(coords, dir)
	TriggerClientEvent("heli:updateSpotlight", -1, coords, dir)
end)
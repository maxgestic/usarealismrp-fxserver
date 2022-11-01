-- Events

RegisterNetEvent('usa_blackout:triggerBlackoutClient')
AddEventHandler('usa_blackout:triggerBlackoutClient', function(blackoutBool, carBool)
	print(blackoutBool, carBool)
	SetArtificialLightsState(blackoutBool)
	SetArtificialLightsStateAffectsVehicles(carBool)
end)

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('usa_blackout:sync')
end)
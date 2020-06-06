local loc = nil
local bank = nil

RegisterNetEvent('lockpick:openlockpick')
AddEventHandler('lockpick:openlockpick', function(location, bankLoc)
	if location then
		loc = location
	elseif bankLoc then
		bank = bankLoc
	end
	SetNuiFocus( true, true )
	SendNUIMessage({
		showPlayerMenu = 'open'
	})
	return
end)

RegisterNUICallback('lose', function()
	if loc then
		TriggerServerEvent('lockpick:removeBrokenPick', 'Lockpick')
	else
		TriggerServerEvent('lockpick:removeBrokenPick', 'Advanced Pick')
	end
end)

RegisterNUICallback('win', function()
	SetNuiFocus( false, false )
	SendNUIMessage({
		showPlayerMenu = 'close'
	})
	if loc then
		TriggerServerEvent('properties:lockpickSuccessful', loc)
	else
		TriggerEvent('doormanager:advancedSuccess')
	end
end)

RegisterNetEvent('lockpick:closehtml')
AddEventHandler('lockpick:closehtml', function()
	SetNuiFocus(false, false)
	SendNUIMessage({
		showPlayerMenu = 'close'
	})
	exports.globals:notify('Your lockpick broke!')
end)

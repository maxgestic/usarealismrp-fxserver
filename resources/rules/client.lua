local display = true

function displayRules()
	Citizen.CreateThread(function()
		TriggerEvent('rules:display', true)

		while display do
			Citizen.Wait(1)
			if (IsControlJustPressed(1, 51)) then
				display = false
				TriggerEvent('rules:display', false)
			end
			HideHudAndRadarThisFrame()
		end
	end)
end

RegisterNetEvent('rules:open')
AddEventHandler('rules:open', function()
	displayRules()
end)

RegisterNetEvent('rules:display')
AddEventHandler('rules:display', function(value)
	SendNUIMessage({
		type = "rules",
		display = value
	})

	display = value;

	if value then
		SetNuiFocus(true)
		DisableControlAction(0, 1, true) -- LookLeftRight
		DisableControlAction(0, 2, true) -- LookUpDown
		DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
	else
		SetNuiFocus(false)
		EnableControlAction(0, 1, true) -- LookLeftRight
		EnableControlAction(0, 2, true) -- LookUpDown
		EnableControlAction(0, 142, true) -- MeleeAttackAlternate
		EnableControlAction(0, 106, true) -- VehicleMouseControlOverride
	end
end)

RegisterNUICallback('accept', function(data, cb)
	TriggerEvent('rules:display', false)
	display = false
end)

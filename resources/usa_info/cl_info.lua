local display = true

function displayRules()
	Citizen.CreateThread(function()
		TriggerEvent('info:display', true)

		while display do
			Citizen.Wait(1)
			if IsControlJustPressed(1, 51) then
				display = false
				TriggerEvent('info:display', false)
			end
			HideHudAndRadarThisFrame()
		end
	end)
end

RegisterNetEvent('info:open')
AddEventHandler('info:open', function()
	displayRules()
end)

RegisterNetEvent('info:display')
AddEventHandler('info:display', function(value)
	SendNUIMessage({
		type = "info",
		display = value
	})

	display = value;

	if value then
		SetNuiFocus(true, true)
		DisableControlAction(0, 1, true) -- LookLeftRight
		DisableControlAction(0, 2, true) -- LookUpDown
		DisableControlAction(0, 142, true) -- MeleeAttackAlternate
		DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
	else
		SetNuiFocus(false, false)
		EnableControlAction(0, 1, true) -- LookLeftRight
		EnableControlAction(0, 2, true) -- LookUpDown
		EnableControlAction(0, 142, true) -- MeleeAttackAlternate
		EnableControlAction(0, 106, true) -- VehicleMouseControlOverride
	end
end)

RegisterNUICallback('accept', function(data, cb)
	TriggerEvent('info:display', false)
	display = false
	TriggerServerEvent("info:acceptedRulesConfirm")
end)

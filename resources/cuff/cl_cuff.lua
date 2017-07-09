local lPed
local isCuffed = false

RegisterNetEvent("Handcuff")
AddEventHandler("Handcuff", function()
	lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(100)
			end

			if IsEntityPlayingAnim(lPed, "mp_arresting", "idle", 3) then
				Citizen.Trace("ENTITY WAS ALREADY PLAYING ARRESTED ANIM, UNCUFFING")
				ClearPedSecondaryTask(lPed)
				SetEnableHandcuffs(lPed, false)
				FreezeEntityPosition(lPed, false)
				isCuffed = false
			else
				Citizen.Trace("ENTITY WAS NOT PLAYING ARRESTED ANIM, CUFFING")
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				FreezeEntityPosition(lPed, true)
				isCuffed = true
			end
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if isCuffed then
			DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 250, true)
			DisableControlAction(1, 263, true)
			DisableControlAction(1, 310, true)

			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)
			DisableControlAction(0, 63, false)
			DisableControlAction(0, 64, false)
			DisableControlAction(0, 59, false)
			DisableControlAction(0, 278, false)
			DisableControlAction(0, 279, false)
			DisableControlAction(0, 68, false)
			DisableControlAction(0, 69, false)
			DisableControlAction(0, 75, false)
			DisableControlAction(0, 76, false)
			DisableControlAction(0, 102, false)
			DisableControlAction(0, 81, false)
			DisableControlAction(0, 82, false)
			DisableControlAction(0, 83, false)
			DisableControlAction(0, 84, false)
			DisableControlAction(0, 85, false)
			DisableControlAction(0, 86, false)
			DisableControlAction(0, 106, false)
			DisableControlAction(0, 25, false)
		end
	end
end)

RegisterNetEvent("cuff:notify")
AddEventHandler("cuff:notify", function(msg)
	DrawCoolLookingNotification(msg)
end)

function DrawCoolLookingNotification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

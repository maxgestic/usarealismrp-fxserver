local lPed

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
			else
				Citizen.Trace("ENTITY WAS NOT PLAYING ARRESTED ANIM, CUFFING")
				TaskPlayAnim(lPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				FreezeEntityPosition(lPed, true)
			end
		end)
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

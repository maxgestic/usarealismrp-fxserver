phone = false
phoneId = 0
frontCam = false
local on = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNetEvent("camera:selfie")
AddEventHandler("camera:selfie", function()
	if not on then
		-- create phone:
		CreateMobilePhone(0)
		CellCamActivate(true, true)
		phone = true
		-- go into selfie mode:
		frontCam = true
		CellFrontCamActivate(frontCam)
		on = true
	else
		-- close phone:
		DestroyMobilePhone()
		phone = false
		CellCamActivate(false, false)
		if firstTime == true then 
			firstTime = false 
			Citizen.Wait(2500)
			displayDoneMission = true
		end
		on = false
		frontCam = false
	end
end)

Citizen.CreateThread(function()
DestroyMobilePhone()
	while true do
		Citizen.Wait(0)
			
		if phone == true then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end
			
	end
end)
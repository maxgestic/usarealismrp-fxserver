RegisterNetEvent("Handsup")
AddEventHandler("Handsup", function()
	local lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("random@mugging3")
			while not HasAnimDictLoaded("random@mugging3") do
				Citizen.Wait(100)
			end

			if IsEntityPlayingAnim(lPed, "random@mugging3", "handsup_standing_base", 3) then
				ClearPedSecondaryTask(lPed)
			else
				TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end
		end)
	end
end)

local handsUp = false
Citizen.CreateThread(function()
    while true do
        Wait(0)

		if GetLastInputMethod(2) then
	        if IsControlPressed(0, 73) then
	            if not handsUp then
					TriggerEvent("Handsup")

	                handsUp = true
	                while handsUp do
	                    Wait(0)
	                    if(IsControlPressed(0, 73) == false) then
	                        handsUp = false
	                    end
	                end
	            end
	        end
        end
    end
end)

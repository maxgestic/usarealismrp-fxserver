Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('hardcap:playerActivated')

			return
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if NetworkIsSessionStarted() then
            NetworkSessionSetMaxPlayers(0, 32)
            return
        end
    end
end)
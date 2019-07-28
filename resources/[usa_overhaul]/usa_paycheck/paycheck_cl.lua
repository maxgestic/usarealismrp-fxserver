local WAIT_TIME_MINUTES = 20

Citizen.CreateThread(function ()
	local last = GetGameTimer()
	while true do
		if GetGameTimer() - last >= WAIT_TIME_MINUTES * 60 * 1000 then
			TriggerServerEvent('paycheck:welfare')
			last = GetGameTimer()
		end
		Wait(10)
	end
end)
RegisterNetEvent("parachute:getparachute")
AddEventHandler('parachute:getparachute', function()
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
	SetPedComponentVariation(GetPlayerPed(-1), 5, 1, 0, 0)
end)

Citizen.CreateThread(function()
	local parachuteFreeFall = false
	while true do
		Citizen.Wait(0)
		if IsPedInParachuteFreeFall(GetPlayerPed(-1)) then
			parachuteFreeFall = true
		end
		if parachuteFreeFall and GetPedParachuteState(GetPlayerPed(-1)) > 0 then
			parachuteFreeFall = false
			Citizen.Wait(900)
			SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)
		end
	end
end)

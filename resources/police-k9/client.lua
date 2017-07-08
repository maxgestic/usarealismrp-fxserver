RegisterNetEvent("k9:transform")
AddEventHandler("k9:transform", function()
	TriggerEvent("chatMessage", "K9 Keeper", {255, 50, 50}, "Woof Woof");

	Citizen.CreateThread(function()
		local model = GetHashKey("a_c_coyote", _r)
		local model = 1126154828

		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
		SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
	    SetPedComponentVariation(GetPlayerPed(-1), 2, 11, 4, 2)
	    SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 5, 2)
	    SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 0, 2)
	    SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 2, 2)
	    SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 2)

		SetPedArmour(GetPlayerPed(-1), 100)
	end)
end)

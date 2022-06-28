RegisterNetEvent('admin:spectate')
AddEventHandler('admin:spectate', function(userS)
	user = userS
	spectate = not spectate

	if spectate then
		TriggerServerEvent("hide:blip", GetPlayerServerId(), true)
		Pmodel = GetEntityModel(GetPlayerPed(-1))

		local model = GetHashKey("mp_m_freemode_01", _r)
		setPedModel(model)

		pos = GetEntityCoords(GetPlayerPed(-1))
	else
		TriggerServerEvent("hide:blip", GetPlayerServerId(), false)
	end
end)

user = 0
spectate = false
pos = nil
Pmodel = nil
Citizen.CreateThread(function()
	while true do
		if spectate then
			local ped = GetPlayerPed(GetPlayerFromServerId(user))
			local myped = GetPlayerPed(-1)

			AttachEntityToEntity(myped, ped, 11816, 0.0, -1.0, 2.5, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			DetachEntity(GetPlayerPed(-1), true, false)

			if pos ~= nil then
				SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z+0.5, 1, 0, 0, 1)
				pos = nil

				if Pmodel ~= nil then
					setPedModel(Pmodel)
					Pmodel = nil
				end
			end
		end
		Citizen.Wait(0)
	end
end)

function setPedModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
end

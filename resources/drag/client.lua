otherid = 0
drag = false

RegisterNetEvent("drag:attemptToDragNearest")
AddEventHandler('drag:attemptToDragNearest', function()
	TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		if player.id ~= 0 then
			TriggerServerEvent("dr:dragPlayer", player.id)
		else
			TriggerEvent("usa:notify", "No player to drag!")
		end
	end)
end)

RegisterNetEvent("dr:drag")
AddEventHandler('dr:drag', function(pl)
	otherid = tonumber(pl)
	local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
	local myped = GetPlayerPed(-1)
	if ped ~= myped then
		if drag then
			DetachEntity(GetPlayerPed(-1), true, false)
		else
			AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end

		drag = not drag
	end
end)


function GetCurrentTargetCar()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

	--DrawMarker(4, entityWorld.x, entityWorld.y, entityWorld.z, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0, 0.0, 0, 1.5, 1.0, 1.25, 255, 255, 255, 200, 0, false, 0, 0)

    return vehicleHandle
end

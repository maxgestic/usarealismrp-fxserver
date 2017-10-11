local lPed

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

RegisterNetEvent("place")
AddEventHandler("place", function()
	lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then

		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
		local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB) -- vehicle in front of player

		if IsVehicleSeatFree(targetVehicle, 1) then
			SetPedIntoVehicle(lPed, targetVehicle, 1) -- place in back left seat
		elseif IsVehicleSeatFree(targetVehicle, 2) then
			SetPedIntoVehicle(lPed, targetVehicle, 2) -- place in back right seat
		end

        -- TODOO:
         -- DetachEntity(GetPlayerPed(-1), true, false)	 -- detach from player
        -- drag = false?

	end
end)

RegisterNetEvent("place:invalidCommand")
AddEventHandler("place:invalidCommand", function(msg)

	TriggerEvent("chatMessage", "SYSTEM",  {255, 180, 0}, msg)

end)

-- unseat
RegisterNetEvent('place:unseat')
AddEventHandler('place:unseat', function(targetPlayerId)
	local pos = GetEntityCoords(GetPlayerPed(targetPlayerId))
	RequestCollisionAtCoord(pos.x, pos.y, pos.z)
	while not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(0)
	end
	SetEntityCoords(GetPlayerPed(-1), pos)
	states.frozenPos = pos
end)

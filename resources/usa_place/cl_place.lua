function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

RegisterNetEvent("place:place")
AddEventHandler("place:place", function(frontSeat)
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then

		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
		local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB) -- vehicle in front of player
		if frontSeat and IsVehicleSeatFree(targetVehicle, 0) then
			SetPedIntoVehicle(playerPed, targetVehicle, 0) -- place in front right seat
		else
			if IsVehicleSeatFree(targetVehicle, 1) then
				SetPedIntoVehicle(playerPed, targetVehicle, 1) -- place in back left seat
			elseif IsVehicleSeatFree(targetVehicle, 2) then
				SetPedIntoVehicle(playerPed, targetVehicle, 2) -- place in back right seat
			end
		end

    -- try to prevent the car from locking when a person is placed inside (experimental):
    TriggerServerEvent("lock:setLocked", GetVehicleNumberPlateText(targetVehicle), false)
    SetVehicleDoorsLocked(targetVehicle, 1) -- unlock

        -- TODO0:
         -- DetachEntity(GetPlayerPed(-1), true, false)	 -- detach from player
        -- drag = false?

	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsControlPressed(0, 19) and IsControlJustPressed(0, 74) and not IsPedRagdoll(ped) and not IsEntityDead(ped) and DoesEntityExist(ped) and not IsPedSittingInAnyVehicle(ped) and not IsPedInMeleeCombat(ped) then
			TriggerServerEvent('cuff:checkWhitelistForPlace')
        elseif IsControlPressed(0, 19) and IsControlJustPressed(0, 182) and not IsPedRagdoll(ped) and not IsEntityDead(ped) and DoesEntityExist(ped) and not IsPedSittingInAnyVehicle(ped) and not IsPedInMeleeCombat(ped) then
			TriggerServerEvent('cuff:checkWhitelistForUnseat')
        end
    end
end)

RegisterNetEvent("place:invalidCommand")
AddEventHandler("place:invalidCommand", function(msg)

	TriggerEvent("chatMessage", "SYSTEM",  {255, 180, 0}, msg)

end)

-- unseat
RegisterNetEvent('place:unseat')
AddEventHandler('place:unseat', function(targetSource)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSource))
	local targetCoords = GetEntityCoords(targetPed)
	local offset = GetOffsetFromEntityInWorldCoords(targetPed, 1.0, 0.0, 0.5)
	TriggerEvent('trunkhide:exitTrunk', true)
	if Vdist(playerCoords, targetCoords) < 5.0 and IsPedInAnyVehicle(playerPed) then
		RequestCollisionAtCoord(targetCoords)
		while not HasCollisionLoadedAroundEntity(playerPed) do
			RequestCollisionAtCoord(targetCoords)
			Citizen.Wait(10)
		end
		SetEntityCoords(playerPed, offset)
	end
end)

RegisterNetEvent('place:attemptToPlaceNearest')
AddEventHandler('place:attemptToPlaceNearest', function()
	TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		if player then
			if tonumber(player.id) ~= 0 and IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(player.id))) then
				print('player found to place: '..player.id)
				TriggerServerEvent('display:shareDisplay', 'places person in vehicle', 2, 370, 10, 3000, true)
				TriggerServerEvent('place:placePerson', player.id)
			else
				TriggerEvent('usa:notify', "No target found to place!")
			end
		end
	end)
end)

RegisterNetEvent('place:attemptToUnseatNearest')
AddEventHandler('place:attemptToUnseatNearest', function()
	TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		if player then
			if tonumber(player.id) ~= 0 and IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(player.id))) then
				print('player found to unseat: '..player.id)
				TriggerServerEvent('display:shareDisplay', 'removes person from vehicle', 2, 370, 10, 3000, true)
				TriggerServerEvent('place:unseatPerson', player.id)
			else
				TriggerEvent('usa:notify', "No target found to unseat!")
			end
		end
	end)
end)

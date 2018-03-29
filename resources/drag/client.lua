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
	drag = not drag
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
		local myped = GetPlayerPed(-1)
		if drag then
			if ped ~= myped then
				Citizen.Trace("ped = " .. ped)
				Citizen.Trace("myped = " .. myped)
				AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				drag = false
			end
		else
			DetachEntity(GetPlayerPed(-1), true, false)
		end
		--[[
		-- stop dragging if far away
		local dragged_ped_coords = GetEntityCoords(myped, 1)
		local dragger_ped_coords = GetEntityCoords(ped, 1)
		if Vdist(dragged_ped_coords, dragger_ped_coords) > 20.0 then
			drag = false
		end
		--]]
	end
end)

-- new stuff below: --
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local target = GetCurrentTargetCar()
		playerId = 0
		playerName = ""
		for id = 0, 64 do
			if NetworkIsPlayerActive(id) then
				if GetPlayerPed(id) == target then
					playerId = GetPlayerServerId(id)
					playerName = GetPlayerName(id)
				end
			end
		end
		-- Citizen.Trace("target = " .. target)
		if target ~= nil then
			if IsControlJustPressed(1, 246) then -- Y = 246, E = 38
				--Citizen.Trace("E DETECTED!")
				--Citizen.Trace("target = " .. target)
				if playerId ~= 0 then
					Citizen.Trace("dragging playerid: " .. playerId)
					TriggerServerEvent("dr:drag", playerId)
				end
			end
		end
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

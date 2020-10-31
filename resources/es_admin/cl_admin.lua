local states = {}
local spectating = {}
states.frozen = false
states.frozenPos = nil

local KEYS = {
	SHIFT = 21,
	ALT = 19,
	N = 249
}

RegisterNetEvent("mini_admin:spectate")
AddEventHandler("mini_admin:spectate", function(target, targetName, spectator_name)

	local target_id = target

		local playerPed = GetPlayerPed(-1) -- yourself
		--Citizen.Trace("target before = " .. target)
		--Citizen.Trace("calling GetPlayerFromServerId on target...")
		target = GetPlayerFromServerId(target)
		--Citizen.Trace("target after = " .. target)
		--Citizen.Trace("calling GetPlayerPed() on target...")
		target = GetPlayerPed(target)
		--Citizen.Trace("target after = " .. target)
		if spectating.target == target then
			-- stop spectating and return
			local targetx,targety,targetz = table.unpack(GetEntityCoords(target, false))
			RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(false, target)
			spectating = {}
			TriggerServerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..spectator_name..' ['..GetPlayerServerId(PlayerId())..'] ^0 has stopped spectating ^2'..targetName..' ['..target_id..']^0.')
			return
		end
		enable = true
		if target == playerPed then enable = false end
		if(enable)then
			local targetx,targety,targetz = table.unpack(GetEntityCoords(target, false))
			RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(true, target)
			spectating = {
				target = target,
				status = true
			}
			TriggerServerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..spectator_name..' ['..GetPlayerServerId(PlayerId())..'] ^0 has began spectating ^2'..targetName..' ['..target_id..']^0.')
		else
			local targetx,targety,targetz = table.unpack(GetEntityCoords(target, false))
			RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(false, target)
			TriggerServerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..spectator_name..' ['..GetPlayerServerId(PlayerId())..'] ^0 has stopped spectating ^2'..targetName..' ['..target_id..']^0.')
		end

end)

RegisterNetEvent('es_admin:spawnVehicle')
AddEventHandler('es_admin:spawnVehicle', function(v)
	local carid = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 then
		RequestModel(carid)
		while not HasModelLoaded(carid) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)

		veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
		--SetVehicleAsNoLongerNeeded(veh)
		SetEntityAsMissionEntity(veh, true, true)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)

		TriggerEvent('persistent-vehicles/register-vehicle', veh)

		local vehicle_key = {
			name = "Key -- " .. GetVehicleNumberPlateText(veh),
			quantity = 1,
			type = "key",
			owner = "GOVT",
			make = "GOVT",
			model = "GOVT",
			plate = GetVehicleNumberPlateText(veh)
		}

		-- give key to owner
		TriggerServerEvent("garage:giveKey", vehicle_key)

	end
end)

RegisterNetEvent('es_admin:notifySound')
AddEventHandler('es_admin:notifySound', function()
	SetFlash(0, 0, 100, 100, 100)
	PlaySoundFrontend(-1,"Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
end)

RegisterNetEvent('es_admin:doHashes')
AddEventHandler('es_admin:doHashes', function(hashes)
	local done = 1
	Citizen.CreateThread(function()
		while done - 1 < #hashes do
			Citizen.Wait(50)
			TriggerServerEvent('es_admin:givePos', hashes[done] .. "=" .. GetHashKey(hashes[done]) .. "\n")
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Vehicles left: ' .. (#hashes - done) )
			done = done + 1
		end
	end)
end)

RegisterNetEvent('es_admin:getHash')
AddEventHandler('es_admin:getHash', function(h)
	TriggerEvent("chatMessage", "HASH", {255, 0, 0}, tostring(GetHashKey(h)))
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = GetPlayerPed(-1)

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
			if not IsEntityVisible(ped) then
					SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
					SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			--SetCharNeverTargetted(ped, false)
			SetPlayerInvincible(player, false)
	else

			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			--SetCharNeverTargetted(ped, true)
			SetPlayerInvincible(player, true)
			--RemovePtfxFromPed(ped)

			if not IsPedFatallyInjured(ped) then
					ClearPedTasksImmediately(ped)
			end
	end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(destination_server_id)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(destination_server_id))))
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:teleportUserByCoords')
AddEventHandler('es_admin:teleportUserByCoords', function(x, y, z)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = GetPlayerPed(-1)

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:givePosition')
AddEventHandler('es_admin:givePosition', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local heading = GetEntityHeading(PlayerPedId())
	local string = "{ x = " .. round(pos.x, 2) .. ", y = " .. round(pos.y, 2) .. ", z = " .. round(pos.z, 2) .. ", h = " ..math.floor(heading).. ".0 },\n"
	TriggerServerEvent('es_admin:givePos', string)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position saved to file.')
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

local noclip = false

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(name)
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(GetPlayerPed(-1), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerServerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..name..' ['..GetPlayerServerId(PlayerId())..'] ^0'..msg..' noclip mode^0.')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			SetEntityCoords(GetPlayerPed(-1), states.frozenPos)
		end
	end
end)

RegisterNetEvent("testing:spawnObject")
AddEventHandler("testing:spawnObject", function(obj)
	if type(obj) == "string" then
		obj = GetHashKey(obj)
	end
	print("spawning obj: " .. obj)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local prop = CreateObject(obj, pos.x, pos.y + 0.5, pos.z - 0.9, true, false, true)
end)

local heading = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(noclip)then
			SetEntityCoordsNoOffset(GetPlayerPed(-1),  noclip_pos.x,  noclip_pos.y,  noclip_pos.z,  0, 0, 0)

			if(IsControlPressed(1,  34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end
				SetEntityHeading(GetPlayerPed(-1),  heading)
			end
			if(IsControlPressed(1,  9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end
				SetEntityHeading(GetPlayerPed(-1),  heading)
			end
			if(IsControlPressed(1,  8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
			end
			if(IsControlPressed(1,  32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1,  27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, 1.0)
			end
			if(IsControlPressed(1,  173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, -1.0)
			end
		end
	end
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- noclip hot key --
Citizen.CreateThread(function()
	while true do
		if IsControlPressed(1,  KEYS.ALT) and IsControlPressed(1, KEYS.SHIFT) and IsControlJustPressed(1, KEYS.N) then 
			TriggerServerEvent("admin:checkGroupForNoClipHotkey")
		end
		Wait(10)
	end
end)

RegisterNetEvent("testtest")
AddEventHandler("testtest", function()
	local coords = GetEntityCoords(PlayerPedId())
	CreateObject(GetHashKey("hei_p_pre_heist_weed"), coords.x + 1.0, coords.y, coords.z + 0.5, 1, 1, 0)
end)

--[[
	bkr_prop_weed_01_small_01a
	bkr_prop_weed_01_small_01b
	bkr_prop_weed_01_small_01c

	bkr_prop_weed_med_01a
	bkr_prop_weed_med_01b

	bkr_prop_weed_lrg_01a
	bkr_prop_weed_lrg_01b
]]
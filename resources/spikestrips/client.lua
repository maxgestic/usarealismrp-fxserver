local SpawnedSpikes = {}
local SpikesSpawned = false


--[[ Looped Thread ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(PlayerId()), false)
			local vehiclePos = GetEntityCoords(vehicle, false)
			local spikes = GetClosestObjectOfType(vehiclePos.x, vehiclePos.y, vehiclePos.z, 75.0, GetHashKey("P_ld_stinger_s"), false, 1, 1)
			local spikesCoords = GetEntityCoords(spikes, false)
			local distance = Vdist(vehiclePos.x, vehiclePos.y, vehiclePos.z, spikesCoords.x, spikesCoords.y, spikesCoords.z)
			if distance <= 75.0 then
				CheckDistanceToStrips()
			end
		end
	end
end)

RegisterCommand("spawn", function(source, args, string)
	SpawnSpikes()
end, false)

RegisterNetEvent("Spikestrips:SpawnSpikes")
AddEventHandler("Spikestrips:SpawnSpikes", function(config, amount)
			for a = 1, amount do
				local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 3.0 * a + 0.5, 0.0)
				local plyHead = GetEntityHeading(GetPlayerPed(PlayerId()))
				local spike = CreateObject(GetHashKey("P_ld_stinger_s"), plyCoords.x, plyCoords.y, plyCoords.z, true, 1, true)
				local spikeHeight = GetEntityHeightAboveGround(spike)
				SetEntityCoords(spike, plyCoords.x, plyCoords.y, plyCoords.z - spikeHeight + 0.05, 0.0, 0.0, 0.0, 0.0)
				SetEntityHeading(spike, plyHead)
				SetEntityAsMissionEntity(spike, 1, 1)
				SetEntityCollision(spike, false, false)
				table.insert(SpawnedSpikes, spike)
				SpikesSpawned = true
			end
end)

RegisterNetEvent("Spikestrips:RemoveSpikes")
AddEventHandler("Spikestrips:RemoveSpikes", function()
	if SpikesSpawned then
		for i = 1, #SpawnedSpikes do
			local netId = NetworkGetNetworkIdFromEntity(SpawnedSpikes[i])

			NetworkRequestControlOfNetworkId(netId)
			while not NetworkHasControlOfNetworkId(netId) do
				Citizen.Wait(0)
				NetworkRequestControlOfNetworkId(netId)
			end

			local entity = NetworkGetEntityFromNetworkId(netId)

			DeleteEntity(entity)
			SpawnedSpikes[i] = nil
			SpikesSpawned = false
		end
	end
end)

function CheckDistanceToStrips()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(PlayerId()), false)
	FrontLeftTire(vehicle)
	FrontRightTire(vehicle)
	BackLeftTire(vehicle)
	BackRightTire(vehicle)
end

function FrontLeftTire(vehicle)
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lf"))
	local spikestrip = GetClosestObjectOfType(tirePosition.x, tirePosition.y, tirePosition.z, 15.0, GetHashKey("P_ld_stinger_s"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikestrip, false)
	local distance = Vdist(tirePosition.x, tirePosition.y, tirePosition.z, spikeCoords.x, spikeCoords.y, spikeCoords.z)

	if distance < 1.8 then
			print("bursting tire!")
			SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
	end

end

function FrontRightTire(vehicle)
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rf"))
	local spikestrip = GetClosestObjectOfType(tirePosition.x, tirePosition.y, tirePosition.z, 15.0, GetHashKey("P_ld_stinger_s"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikestrip, false)
	local distance = Vdist(tirePosition.x, tirePosition.y, tirePosition.z, spikeCoords.x, spikeCoords.y, spikeCoords.z)

	if distance < 1.8 then
			SetVehicleTyreBurst(vehicle, 1, false, 1000.0)
			--todo: add interact sound tire pop noise so people in the car hear it too
	end

end

function BackLeftTire(vehicle)
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lr"))
	local spikestrip = GetClosestObjectOfType(tirePosition.x, tirePosition.y, tirePosition.z, 15.0, GetHashKey("P_ld_stinger_s"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikestrip, false)
	local distance = Vdist(tirePosition.x, tirePosition.y, tirePosition.z, spikeCoords.x, spikeCoords.y, spikeCoords.z)

	if distance < 1.8 then
			SetVehicleTyreBurst(vehicle, 4, false, 1000.0)
			SetVehicleTyreBurst(vehicle , 2, false, 1000.0)
	end
end

function BackRightTire(vehicle)
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rr"))
	local spikestrip = GetClosestObjectOfType(tirePosition.x, tirePosition.y, tirePosition.z, 15.0, GetHashKey("P_ld_stinger_s"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikestrip, false)
	local distance = Vdist(tirePosition.x, tirePosition.y, tirePosition.z, spikeCoords.x, spikeCoords.y, spikeCoords.z)

	if distance < 1.8 then
			SetVehicleTyreBurst(vehicle, 5, false, 1000.0)
			SetVehicleTyreBurst(vehicle , 3, false, 1000.0)
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if SpikesSpawned then
			for i = 1, #SpawnedSpikes do
				FreezeEntityPosition(SpawnedSpikes[i], true)
			end
		end
	end
end)

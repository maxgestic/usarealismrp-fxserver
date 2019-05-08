local spikes = {}
local spikesDeployed = false
local deployingSpikes = true
local spikeHandle

--[[ Looped Thread ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) and spikesDeployed then
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			local vehiclePos = GetEntityCoords(playerVeh, false)
			local spikeHandle = GetClosestObjectOfType(vehiclePos, 75.0, GetHashKey("p_stinger_piece_01"), false, 1, 1)
			local spikeCoords = GetEntityCoords(spikeHandle, false)
			if Vdist(vehiclePos, spikeCoords) <= 75.0 then
				CheckDistanceToStrips()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if spikesDeployed then
			for i = 1, #spikes do
				FreezeEntityPosition(spikes[i], true)
			end
		end
	end
end)


RegisterNetEvent("stinger:spawnSpikes")
AddEventHandler("stinger:spawnSpikes", function(amount)
	if IsPedOnFoot(PlayerPedId()) then
		TriggerServerEvent('stinger:spikesDeployed', true)
		deployingSpikes = true
		FreezeEntityPosition(PlayerPedId(), true)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, false)
		for a = 1, amount do
			playSpikeDeployAnim()
			Citizen.Wait(800)
			for i = 1, 6 do
				local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.4, -2.2 + (3 * a) + (0.5 * i), 0.0)
				local plyHead = GetEntityHeading(GetPlayerPed(PlayerId()))
				local spike = CreateObject(GetHashKey("p_stinger_piece_01"), plyCoords, true, 1, true)
				local netid = ObjToNet(spike)
				SetNetworkIdExistsOnAllMachines(netid, true)
				SetNetworkIdCanMigrate(netid, false)
				local spikeHeight = GetEntityHeightAboveGround(spike)
				SetEntityCoords(spike, plyCoords.x, plyCoords.y, plyCoords.z - spikeHeight + 0.05, 0.0, 0.0, 0.0, 0.0)
				SetEntityHeading(spike, plyHead)
				SetEntityAsMissionEntity(spike, 1, 1)
				SetEntityCollision(spike, false, false)
				table.insert(spikes, netid)
				Citizen.Wait(150)
			end
		end
		FreezeEntityPosition(PlayerPedId(), false)
		deployingSpikes = false
	end
end)

RegisterNetEvent("stinger:deleteSpikes")
AddEventHandler("stinger:deleteSpikes", function()
	if IsPedOnFoot(PlayerPedId()) and not deployingSpikes then
		print("removing spikes!")
		playSpikeDeployAnim()
		Citizen.Wait(800)
		for i = #spikes, 1, -1 do
			DeleteEntity(NetToObj(spikes[i]))
			Citizen.Wait(50)
			table.remove(spikes, i)
		end
		TriggerServerEvent('stinger:spikesDeployed', false)
	end
end)

RegisterNetEvent('stinger:spikesDeployed')
AddEventHandler('stinger:spikesDeployed', function(deployed)
	spikesDeployed = deployed
end)

function CheckDistanceToStrips()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lf"))
	spikeHandle = GetClosestObjectOfType(tirePosition, 15.0, GetHashKey("p_stinger_piece_01"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikeHandle)
	if Vdist(spikeCoords, tirePosition) < 0.5 then
		SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
		SetEntityAsMissionEntity(spikeHandle, true, true )
	end
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rf"))
	spikeHandle = GetClosestObjectOfType(tirePosition, 15.0, GetHashKey("p_stinger_piece_01"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikeHandle)
	if Vdist(spikeCoords, tirePosition) < 0.5 then
		SetVehicleTyreBurst(vehicle, 1, false, 1000.0)
		SetEntityAsMissionEntity(spikeHandle, true, true )
	end
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lr"))
	spikeHandle = GetClosestObjectOfType(tirePosition, 15.0, GetHashKey("p_stinger_piece_01"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikeHandle)
	if Vdist(spikeCoords, tirePosition) < 0.5 then
		SetVehicleTyreBurst(vehicle, 4, false, 1000.0)
		SetVehicleTyreBurst(vehicle, 2, false, 1000.0)
		SetEntityAsMissionEntity(spikeHandle, true, true )
	end
	local tirePosition = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rr"))
	spikeHandle = GetClosestObjectOfType(tirePosition, 15.0, GetHashKey("p_stinger_piece_01"), false, 1, 1)
	local spikeCoords = GetEntityCoords(spikeHandle)
	if Vdist(spikeCoords, tirePosition) < 0.5 then
		SetVehicleTyreBurst(vehicle, 5, false, 1000.0)
		SetVehicleTyreBurst(vehicle, 3, false, 1000.0)
		SetEntityAsMissionEntity(spikeHandle, true, true )
	end
end

function playSpikeDeployAnim()
	Citizen.CreateThread(function()
		RequestAnimDict('weapons@projectile@sticky_bomb')
		while not HasAnimDictLoaded('weapons@projectile@sticky_bomb') do Wait(100) end
		TaskPlayAnim(PlayerPedId(), 'weapons@projectile@sticky_bomb', 'plant_floor', 8.0, 8.0, 0.5, 14, false)
		Citizen.Wait(1700)
		ClearPedTasks(PlayerPedId())
	end)
end


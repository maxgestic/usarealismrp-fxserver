RegisterNetEvent('usa_rp:playerLoaded')
AddEventHandler('usa_rp:playerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    exports.spawnmanager:forceRespawn()
    --exports.spawnmanager:setAutoSpawnCallback(function()
        --TriggerServerEvent('usa_rp:spawnPlayer')
    --end)
    NetworkSetTalkerProximity(10.0)
    Citizen.Trace("calling usa_rp:spawnPlayer!")
    TriggerServerEvent('usa_rp:spawnPlayer')
end)

RegisterNetEvent('usa_rp:spawn')
AddEventHandler('usa_rp:spawn', function(model, job, spawn, weapons)
	exports.spawnmanager:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, model = model, heading = 0.0}, function()
        -- do stuff to ped here after spawning
        if weapons then
            for i =1, #weapons do
                if type(weapons[i]) == "string" then
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                else -- table type most likely
                    GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                end
            end
        end
	end)
end)

-- ped/vehicle npcs
Citizen.CreateThread(function()
	while true do
		Wait(0)
		SetPedDensityMultiplierThisFrame(0.6)
		SetVehicleDensityMultiplierThisFrame(0.5)
	end
end)

-- no police npc / never wanted
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(),0,false)
            SetPlayerWantedLevelNow(PlayerId(),false)
            SetMaxWantedLevel(0)
        end
    end
end)

--[[ REDUCE NPC COUNT
Citizen.CreateThread(function()
    -- These natives do not have to be called everyframe.
    --SetGarbageTrucks(0)
    --SetRandomBoats(0)
    while true
    	do
    	-- These natives has to be called every frame.
    	SetVehicleDensityMultiplierThisFrame(0.2)
		--SetPedDensityMultiplierThisFrame(0.2)
		--SetRandomVehicleDensityMultiplierThisFrame(0.2)
		SetParkedVehicleDensityMultiplierThisFrame(0.6)
		SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2)

		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed)
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);

		Citizen.Wait(1)
	end

end)
--]]
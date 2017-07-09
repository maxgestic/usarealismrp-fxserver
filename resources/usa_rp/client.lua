RegisterNetEvent('usa_rp:playerLoaded')
AddEventHandler('usa_rp:playerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    exports.spawnmanager:forceRespawn()
    --exports.spawnmanager:setAutoSpawnCallback(function()
        --TriggerServerEvent('usa_rp:spawnPlayer')
    --end)
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

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            NetworkSessionSetMaxPlayers(0, 32)
            return
        end
    end
end)

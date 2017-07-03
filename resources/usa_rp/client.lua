local pauseMenu = false

RegisterNetEvent('usa_rp:playerLoaded')
AddEventHandler('usa_rp:playerLoaded', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    exports.spawnmanager:setAutoSpawnCallback(function()
        TriggerServerEvent('usa_rp:spawnPlayer')
    end)
end)

RegisterNetEvent('usa_rp:spawn')
AddEventHandler('usa_rp:spawn', function(model, job, spawn, weapons)
	exports.spawnmanager:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, model = model, heading = 0.0}, function()
        -- do stuff to ped here after spawning
        for i =1, #weapons do
            GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
        end
	end)
end)

-- Pause menu disable money display
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPauseMenuActive() and not pauseMenu then
            pauseMenu = true
            TriggerEvent('es:setMoneyDisplay', 0.0)
        elseif not IsPauseMenuActive() and pauseMenu then
            pauseMenu = false
            TriggerEvent('es:setMoneyDisplay', 1.0)
        end
    end
end)

-- ped/vehicle npcs
Citizen.CreateThread(function()
	while true do
		Wait(0)
		SetPedDensityMultiplierThisFrame(0.6)
		SetVehicleDensityMultiplierThisFrame(0.5)
	end
end)

-- wow money :o
AddEventHandler('es_rp:playerLoaded', function()
	SetMultiplayerBankCash()
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	Citizen.InvokeNative(0x0772DF77852C2E30, 0, 1)
	Citizen.InvokeNative(0x0772DF77852C2E30, 0, -1)
	Citizen.Trace("Enabled!\n")
end)

--[[
AddEventHandler('onClientMapStart', function()
  exports.spawnmanager:setAutoSpawn(true)
  exports.spawnmanager:forceRespawn()
  exports.spawnmanager:setAutoSpawnCallback(function()
      TriggerServerEvent('usa_rp:spawnPlayer')
  end)
end)
]]

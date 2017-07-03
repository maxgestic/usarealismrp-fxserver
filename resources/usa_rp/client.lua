RegisterNetEvent('usa_rp:playerLoaded')
AddEventHandler('usa_rp:playerLoaded', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    exports.spawnmanager:setAutoSpawnCallback(function()
        TriggerServerEvent('usa_rp:spawnPlayer')
    end)
end)

RegisterNetEvent('usa_rp:spawn')
AddEventHandler('usa_rp:spawn', function()
    x = 391.611
    y = -948.984
    z = 29.3978
    model = "s_m_y_sheriff_01"
	exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = model, heading = 0.0}, function()
        -- do stuff to ped here after spawning
	end)
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

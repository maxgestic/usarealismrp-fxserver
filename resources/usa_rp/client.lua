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
AddEventHandler('usa_rp:spawn', function(defaultModel, job, spawn, weapons, character)
	exports.spawnmanager:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, model = defaultModel, heading = 0.0}, function()
        -- give customized character
        if character.hash then
            local name, model
            model = tonumber(character.hash)
            Citizen.Trace("giving loading with customizations with hash = " .. model)
            Citizen.CreateThread(function()
                RequestModel(model)
                while not HasModelLoaded(model) do -- Wait for model to load
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
                -- ADD CUSTOMIZATIONS FROM CLOTHING STORE
                for key, value in pairs(character["components"]) do
                    SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
                end
                for key, value in pairs(character["props"]) do
                    SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
                end
                -- GIVE WEAPONS
                for i =1, #weapons do
                    if type(weapons[i]) == "string" then
                        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                    else -- table type most likely
                        GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                    end
                end
            end)
        else -- no custom character to load, just give weapons
            if weapons then
                for i =1, #weapons do
                    if type(weapons[i]) == "string" then
                        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
                    else -- table type most likely
                        GiveWeaponToPed(GetPlayerPed(-1), weapons[i].hash, 1000, false, false)
                    end
                end
            end
        end
        -- CHECK JAIL STATUS
        Citizen.Trace("calling checkJailedStatusOnPlayerJoin server function")
        TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
        -- check to see if player is banned (since on connect is flakey)
        TriggerServerEvent('mini:checkPlayerBannedOnSpawn')
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

--[[
--REDUCE NPC COUNT
Citizen.CreateThread(function()
    -- These natives do not have to be called everyframe.
    --SetGarbageTrucks(0)
    --SetRandomBoats(0)
    while true
    	do
    	-- These natives has to be called every frame.
    	SetVehicleDensityMultiplierThisFrame(0.2)
		SetPedDensityMultiplierThisFrame(0.4)
		SetRandomVehicleDensityMultiplierThisFrame(0.2)
		SetParkedVehicleDensityMultiplierThisFrame(0.2)
		SetScenarioPedDensityMultiplierThisFrame(0.4, 0.4)

		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed)
		--RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);

		Citizen.Wait(1)
	end

end)
--]]

-- NO DRIVE BY'S
local passengerDriveBy = false
Citizen.CreateThread(function()
	while true do
		Wait(1)
		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()

    exports.spawnmanager:setAutoSpawnCallback(function()
        TriggerServerEvent('playerSpawn')
        TriggerEvent('playerSpawn')
    end)
end)

-- Allows the server to spawn the player
RegisterNetEvent('es_example_gamemode:spawnPlayer')
AddEventHandler('es_example_gamemode:spawnPlayer', function(model, x, y, z, heading)
    --exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = model})
    exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = GetHashKey(model), heading = heading}, function()
		--SetEntityHealth(GetPlayerPed(-1), health)
		--SetPedArmour(GetPlayerPed(-1), armour)

		--for i in ipairs(weapons) do
			--GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weapons[i]), 1000, false, false)
		--end

	end)
end)

-- Remove wanted level
RegisterNetEvent('mini:disableWantedLevel')
AddEventHandler("mini:disableWantedLevel",function()
	SetPlayerWantedLevel(PlayerId(),0,false)
	SetPlayerWantedLevelNow(PlayerId(),false)
	SetMaxWantedLevel(0)
end)

RegisterNetEvent("mini:spawnClothingStoreNpcs")
AddEventHandler("mini:spawnClothingStoreNpcs", function()

    local clothingNpcs = {}
    local created = false
    local hash = GetHashKey("A_F_Y_Vinewood_01")
    local ped

    -- thread code stuff below was taken from an example on the wiki
    -- Create a thread so that we don't 'wait' the entire game
    Citizen.CreateThread(function()
        -- Request the model so that it can be spawned
        RequestModel(hash)

        -- Check if it's loaded, if not then wait and re-request it.
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(100)
        end
        -- Model loaded, continue

        if not created then

            ped = CreatePed(4, hash, -0.752956, 6510.64, 31.8778, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- paleto
            ped = CreatePed(4, hash, 1692.16, 4817.22, 42.0631, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- grape seed npc
            ped = CreatePed(4, hash, 1202.18, 2707.79, 38.2226, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- sandy shores npc 1
            ped = CreatePed(4, hash, 612.971, 2762.73, 42.0881, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- sandy shores npc 2
            ped = CreatePed(4, hash, -1095.84, 2712.23, 19.1078, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- route 68
            ped = CreatePed(4, hash, -3169.4, 1042.82, 20.8632, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- chumash, great ocean hwy
            ped = CreatePed(4, hash, -1448.61, -237.858, 49.8136, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 1
            ped = CreatePed(4, hash, -709.059, -151.475, 37.4151, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 2
            ped = CreatePed(4, hash, -1193.81, -766.964, 17.3163, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 3
            ped = CreatePed(4, hash, -165.07, -303.251, 39.7333, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 4
            ped = CreatePed(4, hash, 127.174, -224.259, 54.5578, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 5
            ped = CreatePed(4, hash, 422.92, -811.772, 29.4911, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 6
            ped = CreatePed(4, hash, -816.335, -1072.93, 11.3281, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 7
            ped = CreatePed(4, hash, 78.0717, -1387.25, 29.3761, 307.283 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]) -- vinewood 8

            created = true

        end

    end)

end)

-- weapon/vehicle store npcs
--CreatePed(4,1822107721, -330.803, 6085.742, 31.455, 216.796 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]), -- gun store
--CreatePed(4,68070371, 119.812, 6625.607, 31.960, 219.453 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]]), -- vehicle store

-- LOADS THE PLAYER OUT ON SPAWN WITH 3 WEAPONS AND MODEL FROM DB
RegisterNetEvent("mini:giveLoadout")
AddEventHandler("mini:giveLoadout", function(playerWeapons, playerModel)

	local name, hash, model

	Citizen.CreateThread(function()

        Citizen.Wait(2000)

        -- model
		if playerModel == nil or playerModel == "" then
			Citizen.Trace("skin was null.\n")
			TriggerEvent('rules:open')
			return
		end

		if string.match(playerModel, "_") then
			model = GetHashKey(playerModel)
		else
			model = tonumber(playerModel)
		end

        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            RequestModel(model)
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)

		-- weapons
		for i = 1, #playerWeapons do
			GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i], 1000, 0, false) -- name already is the hash
		end

    end)

end)

RegisterNetEvent("mini_gamemode:giveWeapons")
AddEventHandler("mini_gamemode:giveWeapons", function(playerWeapons)

	local name, hash

	Citizen.CreateThread(function()

        Citizen.Wait(1)

		-- weapons
		for i = 1, #playerWeapons do

			name = playerWeapons[i]

			if string.match(name, "_") then
				hash = GetHashKey(name)
				GiveWeaponToPed(GetPlayerPed(-1), hash, 1000, 0, false) -- get hash given name of weapon
			else
				GiveWeaponToPed(GetPlayerPed(-1), tonumber(name), 1000, 0, false) -- name already is the hash
			end

		end

    end)

end)

-- no police npc
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

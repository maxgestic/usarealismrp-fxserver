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
		SetPedDensityMultiplierThisFrame(0.8)
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

-- NO DRIVE BY'S
local passengerDriveBy = false
Citizen.CreateThread(function()
	while true do
		Wait(1)
		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
        --Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(car)) -- auto car clean up for unused vehicles
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

local bahamaMama = {
    entrance = {
        x = -1388.94,
        y = -585.919,
        z = 29.2195
    },
    exit = {
        x = -1387.47,
        y = -588.195,
        z = 29.3195
    }
}
-- bahama mama's
Citizen.CreateThread(function()
	while true do
		Wait(1)
        if GetDistanceBetweenCoords(bahamaMama.entrance.x, bahamaMama.entrance.y, bahamaMama.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 50 then
            DrawMarker(1, bahamaMama.entrance.x, bahamaMama.entrance.y, bahamaMama.entrance.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
            DrawMarker(1, bahamaMama.exit.x, bahamaMama.exit.y, bahamaMama.exit.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(bahamaMama.entrance.x, bahamaMama.entrance.y, bahamaMama.entrance.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
                DrawSpecialText("Press [ ~b~E~w~ ] to enter Bahama Mamas!")
                if IsControlPressed(0, 86) then
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), bahamaMama.exit.x+1.0, bahamaMama.exit.y, bahamaMama.exit.z)
                end
            elseif GetDistanceBetweenCoords(bahamaMama.exit.x, bahamaMama.exit.y, bahamaMama.exit.z,GetEntityCoords(GetPlayerPed(-1))) < 1.6 then
                DrawSpecialText("Press [ ~b~E~w~ ] to exit Bahama Mamas!")
                if IsControlPressed(0, 86) then
                    Citizen.Wait(500)
                    SetEntityCoords(GetPlayerPed(-1), bahamaMama.entrance.x+1.0, bahamaMama.entrance.y, bahamaMama.entrance.z)
                end
            end
        end
    end
end)

--[[------------------------------------------------------------------------
    Remove Reticle on ADS (Third Person)
------------------------------------------------------------------------]]--
local scopedWeapons = {
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    3342088282  -- WEAPON_MARKSMANRIFLE
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do
        if ( hash == v ) then
            return true
        end
    end
    return false
end

function ManageReticle()
    local ped = GetPlayerPed( -1 )
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local _, hash = GetCurrentPedWeapon( ped, true )
        if not HashInTable( hash ) then
            HideHudComponentThisFrame( 14 )
        end
    end
end

Citizen.CreateThread( function()
    while true do
        ManageReticle()
        Citizen.Wait( 0 )
    end
end )

-- spawn peds (strip club only atm)
local locations = {
    stripclub = {
        {x = 102.423, y = -1290.594, z = 28.2587, animDict = "mini@strip_club@private_dance@part1", animName = "priv_dance_p1", model = "CSB_Stripper_02", heading = (math.random(50, 360)) * 1.0},
        {x = 104.256, y = -1294.67, z = 28.2587, animDict = "mini@strip_club@private_dance@part3", animName = "priv_dance_p3", model = "CSB_Stripper_01", heading = (math.random(50, 360)) * 1.0},
        {x = 112.480, y = -1287.032, z = 27.586, animDict = "mini@strip_club@private_dance@part2", animName = "priv_dance_p2", model = "CSB_Stripper_01", heading = (math.random(50, 360)) * 1.0},
        {x = 113.111, y = -1287.755, z = 27.586, animDict = "mini@strip_club@private_dance@part1", animName = "priv_dance_p1", model = "S_F_Y_Stripper_02", heading = (math.random(50, 360)) * 1.0},
        {x = 113.375, y = -1286.546, z = 27.586, animDict = "mini@strip_club@private_dance@part1", animName = "priv_dance_p1", model = "S_F_Y_Stripper_01", heading = (math.random(50, 360)) * 1.0},
        {x = 129.442, y = -1283.407, z = 28.272, animDict = "missfbi3_party_d", animName = "stand_talk_loop_a_female", model = "S_F_Y_Bartender_01", heading = 122.471}
    }
}
local spawnedPeds = {}
Citizen.CreateThread(function()
	for _, location in pairs(locations) do
        for i = 1, #location do
            Wait(1000)
            local hash = GetHashKey(location[i].model)
            RequestModel(hash)
        	while not HasModelLoaded(hash) do
        		RequestModel(hash)
        		Citizen.Wait(0)
        	end
    		local ped = CreatePed(4, hash, location[i].x, location[i].y, location[i].z, location[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
            table.insert(spawnedPeds, ped)
            SetEntityCanBeDamaged(ped,false)
    		SetPedCanRagdollFromPlayerImpact(ped,false)
    		TaskSetBlockingOfNonTemporaryEvents(ped,true)
    		SetPedFleeAttributes(ped,0,0)
    		SetPedCombatAttributes(ped,17,1)
    		SetEntityInvincible(ped)
            RequestAnimDict(location[i].animDict)
            while not HasAnimDictLoaded(location[i].animDict) do
                Citizen.Wait(100)
            end
            TaskPlayAnim(ped, location[i].animDict, location[i].animName, 8.0, -8, -1, 7, 0, 0, 0, 0)
        end
	end
end)

Citizen.CreateThread(function()

    for i = 1, #spawnedPeds do
        TaskPlayAnim(spawnedPeds[i], location[i].animDict, location[i].animName, 8.0, -8, -1, 7, 0, 0, 0, 0)
        while true do
            Wait(1)
            if not IsEntityPlayingAnim(spawnedPeds[i], location[i].animDict, location[i].animName, 3) then
                RequestAnimDict(location[i].animDict)
                while not HasAnimDictLoaded(location[i].animDict) do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(spawnedPeds[i], location[i].animDict, location[i].animName, 8.0, -8, -1, 0, 0, 0, 0, 0)
            end
        end
    end

end)

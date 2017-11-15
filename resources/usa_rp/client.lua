local civilianSpawns = {
    --{x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
    --{x = 95.2552, y = -1310.8, z = 29.2921}, -- near strip club
    --{x = 10.6334, y = -718.769, z = 44.2174} -- pitts suggestion
    --{x = 434.14, y = -646.847, z = 28.7314}, -- daschound bus station 1
    --{x = 434.753, y = -629.007, z = 28.7186}, -- daschound hus station 2
    --{x = 412.16, y = -619.049, z = 28.7015}, -- daschound bus station 3
    --{x = -536.625, y = -218.624, z = 38.8497}, -- DMV spawn in LS
    --{x = 232.919, y = -880.539, z = 30.5921}, -- legion square
    --{x = 233.919, y = -880.539, z = 30.5921}, -- legion square
    --{x = 234.919, y = -880.539, z = 30.5921} -- legion square
    {x = -288.624, y = 6229.223, z = 31.454}, -- paleto (barber shop)
    {x = 178.346, y = 6636.780, z = 31.6}, -- paleto (gas station)
    {x = -391.130, y = 6216.655, z = 31.473} -- paleto (procopio dr)
    -- Meth Delivery -402.63 y 6316.12 z 28.95 heading 222.26 DONE
}

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
AddEventHandler('usa_rp:spawn', function(defaultModel, job, weapons, characters)
    if characters then
        print("size of characters = " .. #characters)
    end
    local spawn = {x = 0.0, y = 0.0, z = 0.0}
    spawn = civilianSpawns[math.random(1, #civilianSpawns)]
	exports.spawnmanager:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, model = defaultModel, heading = 0.0}, function()
        if not characters then
            print("player did not have a first character...")
            TriggerEvent("character:open", "new-character")
        else
            print("player did have a first character!")
            TriggerEvent("character:open", "home", characters)
        end
        --[[ CHECK JAIL STATUS
        Citizen.Trace("calling checkJailedStatusOnPlayerJoin server function")
        TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
        --]]
        -- CHECK BAN STATUS
        TriggerServerEvent('mini:checkPlayerBannedOnSpawn')
        --]]
	end)
end)

-- ped/vehicle npcs
Citizen.CreateThread(function()
	while true do
		Wait(0)
		SetPedDensityMultiplierThisFrame(0.8)
		SetVehicleDensityMultiplierThisFrame(0.3)
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

-- spawn peds
local locations = {
    stripclub = {
        {x = 102.423, y = -1290.594, z = 28.2587, animDict = "mini@strip_club@private_dance@part1", animName = "priv_dance_p1", model = "CSB_Stripper_02", heading = (math.random(50, 360)) * 1.0},
        {x = 104.256, y = -1294.67, z = 28.2587, animDict = "mini@strip_club@private_dance@part3", animName = "priv_dance_p3", model = "CSB_Stripper_01", heading = (math.random(50, 360)) * 1.0},
        {x = 112.480, y = -1287.032, z = 27.586, animDict = "mini@strip_club@private_dance@part2", animName = "priv_dance_p2", model = "CSB_Stripper_01", heading = (math.random(50, 360)) * 1.0},
        {x = 113.111, y = -1287.755, z = 27.586, animDict = "mini@strip_club@private_dance@part1", animName = "priv_dance_p1", model = "S_F_Y_Stripper_02", heading = (math.random(50, 360)) * 1.0},
        {x = 113.375, y = -1286.546, z = 27.586, animDict = "mini@strip_club@private_dance@part2", animName = "priv_dance_p2", model = "CSB_Stripper_02", heading = (math.random(50, 360)) * 1.0},
        {x = 129.442, y = -1283.407, z = 28.272, animDict = "missfbi3_party_d", animName = "stand_talk_loop_a_female", model = "S_F_Y_Bartender_01", heading = 122.471}
    },
    boatshop = {
        {x = -257.739, y = 6666.348, z = 1.3, animDict = "", animName = "", model = "CS_Fabien", heading = 236.9}
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

-- save player vehicle wheel position on exit?
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            veh = GetVehiclePedIsUsing(PlayerPedId())
            angle = GetVehicleSteeringAngle(veh)
            veh2 = GetPlayersLastVehicle()
            sped = GetEntitySpeed(veh)
            Citizen.Wait(20)
            if sped < 10 then
                SetVehicleSteeringAngle(veh2, angle)
            end
        end
    end
end)

-- player crouching
local crouched = false
Citizen.CreateThread( function()
    while true do
        Citizen.Wait( 1 )
        local ped = GetPlayerPed( -1 )
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
            if ( not IsPauseMenuActive() ) then
                if ( IsControlPressed( 1, 19 ) and IsControlJustPressed( 1, 173 ) and not IsPedInAnyVehicle(GetPlayerPed(-1), true)) then -- alt + downarrow
                    RequestAnimSet( "move_ped_crouched" )
                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
                        Citizen.Wait( 100 )
                    end
                    if ( crouched == true ) then
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true
                    end
                end
            end
        end
    end
end )

-- peds don't drop weapons
local pedindex = {}

function SetWeaponDrops() -- This function will set the closest entity to you as the variable entity.
    local handle, ped = FindFirstPed()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle) -- first param returns true while entities are found
    until not finished
    EndFindPed(handle)

    for peds,_ in pairs(pedindex) do
        if peds ~= nil then -- set all peds to not drop weapons on death.
            SetPedDropsWeaponsWhenDead(peds, false)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetWeaponDrops()
    end
end)

-- disable pistol whipping (weapon melee) ?
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	        DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

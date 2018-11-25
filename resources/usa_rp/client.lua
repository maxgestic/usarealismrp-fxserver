local default_voip = 8.5
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

------------------------------
-- FIRST LOAD / SPAWNING IN --
------------------------------

RegisterNetEvent('usa_rp:playerLoaded')
AddEventHandler('usa_rp:playerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    exports.spawnmanager:forceRespawn()
    NetworkSetTalkerProximity(default_voip)
    SetAudioFlag("DisableFlightMusic", 1)
    Citizen.Trace("calling usa_rp:spawnPlayer!")
    TriggerServerEvent('usa_rp:spawnPlayer')
end)

RegisterNetEvent('usa_rp:spawn')
AddEventHandler('usa_rp:spawn', function(defaultModel, job, weapons, characters)
  if characters then
   -- print("size of characters = " .. #characters)
  end
  local spawn = {x = 0.0, y = 0.0, z = 0.0}
  spawn = civilianSpawns[math.random(1, #civilianSpawns)]
  exports.spawnmanager:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, model = defaultModel, heading = 0.0}, function()
    if not characters then
      --print("player did not have a first character...")
      TriggerEvent("character:open", "new-character")
    else
      --print("player did have a first character!")
      TriggerEvent("character:open", "home", characters)
    end
    --[[ CHECK JAIL STATUS [moved]
    Citizen.Trace("calling checkJailedStatusOnPlayerJoin server function")
    TriggerServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
    --]]
    -- CHECK BAN STATUS
    TriggerServerEvent('mini:checkPlayerBannedOnSpawn')
  end)
end)

-------------------
-- RANDOM THINGS --
-------------------
-- Pause Menu Title --
function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'USA REALISM RP - HTTPS://USARRP.NET')
end)


 --ped/vehicle npcs
Citizen.CreateThread(function()
	while true do
		Wait(0)

		--SetPedDensityMultiplierThisFrame(1.0)
		SetVehicleDensityMultiplierThisFrame(0.8) -- npc vehicle amount

		--local playerPed = GetPlayerPed(-1)
		--local pos = GetEntityCoords(playerPed)
		--RemoveVehiclesFromGeneratorsInArea(pos['x'] - 1500.0, pos['y'] - 1500.0, pos['z'] - 1500.0, pos['x'] + 1500.0, pos['y'] + 1500.0, pos['z'] + 1500.0);

	end
end)

-- no police npc / never wanted
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(),0,false)
            SetPlayerWantedLevelNow(PlayerId(),false)
            SetMaxWantedLevel(0)
        end
    end
end)

-- NO DRIVE BY'S
local passengerDriveBy = true
Citizen.CreateThread(function()
	while true do
		Wait(100)
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
    black_market = {
        {x = -2166.786, y = 5197.684, z = 15.880, animDict = "", animName = "", model = "G_M_Y_SALVABOSS_01", heading = 122.471, scenario = "WORLD_HUMAN_SMOKING"}
    },
    illegal_weapon_extra_shop = {
      {x = 181.4, y = 2792.8, z = 45.7, animDict = "", animName = "", model = "G_M_Y_SALVABOSS_01", heading = 302.471, scenario = "WORLD_HUMAN_SMOKING"}
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
        		Citizen.Wait(100)
        	end
    		local ped = CreatePed(4, hash, location[i].x, location[i].y, location[i].z, location[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
            table.insert(spawnedPeds, ped)
            SetEntityCanBeDamaged(ped,false)
    		SetPedCanRagdollFromPlayerImpact(ped,false)
    		TaskSetBlockingOfNonTemporaryEvents(ped,true)
    		SetPedFleeAttributes(ped,0,0)
    		SetPedCombatAttributes(ped,17,1)
            if not location[i].scenario then
                RequestAnimDict(location[i].animDict)
                while not HasAnimDictLoaded(location[i].animDict) do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(ped, location[i].animDict, location[i].animName, 8.0, -8, -1, 7, 0, 0, 0, 0)
            else
                TaskStartScenarioInPlace(ped, location[i].scenario, 0, 1)
            end
        end
	end
end)

-- save player vehicle wheel position on exit?
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
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

----------------------
-- player crouching --
----------------------
local crouched = false
local KEY_1 = 19 -- alt
local KEY_2 = 173 -- down arrow
local clipset = "move_ped_crouched"
Citizen.CreateThread( function()
  while true do
    Citizen.Wait( 10 )
    local ped = GetPlayerPed( -1 )
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
      if ( not IsPauseMenuActive() ) then
        if ( IsControlPressed( 1, KEY_1 ) and IsControlJustPressed( 1, KEY_2 ) and not IsPedInAnyVehicle(GetPlayerPed(-1), true)) then
          RequestAnimSet( clipset )
          while ( not HasAnimSetLoaded( clipset ) ) do
            Citizen.Wait( 100 )
          end
          if ( crouched == true ) then
            ResetPedMovementClipset( ped, 0 )
            crouched = false
          elseif ( crouched == false ) then
            SetPedMovementClipset( ped, clipset, 0.25 )
            crouched = true
          end
        end
      end
    end
  end
end)

----------------------------------
-- stop seat shuffling in vehicles
----------------------------------
local antiShuffleEnabled = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and antiShuffleEnabled then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)


------------------------------------
-- V E H I C L E  C O N T R O L S --
-- roll windows [usage: /rollw]   --
------------------------------------
local windowup = true
RegisterNetEvent("RollWindow")
AddEventHandler('RollWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then
            --SetEntityAsMissionEntity( playerCar, true, true )
			if ( windowup ) then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				--TriggerEvent('chatMessage', '', {255,0,0}, 'Windows down')
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				--TriggerEvent('chatMessage', '', {255,0,0}, 'Windows up')
				windowup = true
			end
		end
	end
end )

local last_car = 0

RegisterNetEvent("veh:openDoor")
AddEventHandler("veh:openDoor", function(index)
   -- print("opening door with index = " .. index)
    local playerPed = GetPlayerPed(-1)
        local playerCar = GetVehiclePedIsIn(playerPed, true)
        if playerCar ~= 0 then
          last_car = playerCar
        else
          playerCar = last_car
        end
        if index == "trunk" then
            --print("index was trunk!")
            SetVehicleDoorOpen(playerCar, 5, true, true)
        elseif index == "hood" then
            SetVehicleDoorOpen(playerCar, 4, true, true)
        elseif index == "fl" then
            SetVehicleDoorOpen(playerCar, 0, true, true)
        elseif index == "fr" then
            SetVehicleDoorOpen(playerCar, 1, true, true)
        elseif index == "bl" then
            SetVehicleDoorOpen(playerCar, 2, true, true)
        elseif index == "br" then
        SetVehicleDoorOpen(playerCar, 3, true, true)
        elseif index == "ambulance" then
            SetVehicleDoorOpen(playerCar, 2, true, true)
            SetVehicleDoorOpen(playerCar, 3, true, true)
        end
end)

RegisterNetEvent("veh:shutDoor")
AddEventHandler('veh:shutDoor', function(index)
    --print("inside shut door!")
    local playerPed = GetPlayerPed(-1)
        local playerCar = GetVehiclePedIsIn(playerPed, false)
        if playerCar ~= 0 then
          last_car = playerCar
        else
          playerCar = last_car
        end
        if index == "trunk" then
            SetVehicleDoorShut(playerCar, 5, false)
        elseif index == "hood" then
            SetVehicleDoorShut(playerCar, 4, false)
        elseif index == "fl" then
            SetVehicleDoorShut(playerCar, 0, false)
        elseif index == "fr" then
            SetVehicleDoorShut(playerCar, 1, false)
        elseif index == "bl" then
            SetVehicleDoorShut(playerCar, 2, false)
        elseif index == "br" then
        SetVehicleDoorShut(playerCar, 3, false)
        elseif index == "ambulance" then
            SetVehicleDoorShut(playerCar, 2, false)
            SetVehicleDoorShut(playerCar, 3, false)
        end
end)

-- void SET_VEHICLE_NEEDS_TO_BE_HOTWIRED(Vehicle vehicle, BOOL toggle);

-- engine specific --
local engineIsOn = true
local lastVehicle = nil

RegisterNetEvent("veh:toggleEngine")
AddEventHandler('veh:toggleEngine', function(status)
  local playerPed = GetPlayerPed(-1)
  if IsPedInAnyVehicle(playerPed, false) and lastVehicle and tonumber(lastVehicle) ~= 0 then
    --local playerCar = GetVehiclePedIsIn(playerPed, false)
    --lastVehicle = GetVehiclePedIsIn(playerPed, false)
    if GetPedInVehicleSeat(lastVehicle, -1) == playerPed then
      if status == "on" then
        --TriggerServerEvent("vehicle:checkForKey", GetVehicleNumberPlateText(targetVehicle))
        if GetVehicleEngineHealth(lastVehicle) > 360 and  GetVehicleFuelLevel(lastVehicle) > 0.9 then
          SetVehicleUndriveable(lastVehicle, false)
          SetVehicleEngineOn(lastVehicle, true, false, false)
          engineIsOn = true
        else
          exports.globals:notify("Your vehicle is disabled! Can't turn the engine on.")
        end
      elseif status == "off" then
        SetVehicleEngineOn(lastVehicle, false, false, false)
        engineIsOn = false
        SetVehicleUndriveable(lastVehicle, true)
        --TriggerEvent("vehicle:setEngineStatus", false)
      else
        if GetIsVehicleEngineRunning(lastVehicle) then
          SetVehicleEngineOn(lastVehicle, false, false, false)
          engineIsOn = false
          SetVehicleUndriveable(lastVehicle, true)
        else
          if GetVehicleEngineHealth(lastVehicle) > 360 then
            SetVehicleUndriveable(lastVehicle, false)
            SetVehicleEngineOn(lastVehicle, true, false, false)
            engineIsOn = true
          else
            exports.globals:notify("Your vehicle is disabled! Can't turn the engine on.")
          end
        end
      end
    end
  end
end)

local policeVehicles = {
    1171614426, -- ambulance
    1127131465, -- fbi
    -1647941228, -- fbi2
    1938952078, -- firetruck
    2046537925, -- police
    -1627000575, -- police2
    1912215274, -- police3
    -1973172295, -- police4
    0x9C32EB57, -- Police5
    0xB2FF98F0, -- police 6
    0xC4B53C5B, -- police 7
    0xD0AF544F, -- police 8
    -34623805, -- policeb
    741586030, -- pranger
    -1205689942, -- riot
	-672516475, -- unmarked9
	-1960928017, -- unmarked8
	-59441254, -- unmarked7 (slicktop)
	-1663942570, -- unmarked6
	1109330673, -- unmarked4
	-1285460620, -- unmarked3
	1383443358 -- unmarked1

}

Citizen.CreateThread(function()
  while true do
    Wait(5)
    ----------------------
    -- set last vehicle --
    ----------------------
    local me = GetPlayerPed(-1)
    if IsPedInAnyVehicle(me, false) then
      local veh = GetVehiclePedIsIn(me, false)
      if GetPedInVehicleSeat(veh, -1) == me then
        if lastVehicle ~= veh then
          lastVehicle = veh
        end
      end
    end
    --------------------------------------
    -- adjust engine status accordingly --
    --------------------------------------
    if lastVehicle and tonumber(lastVehicle) ~= 0 then
      if GetVehicleEngineHealth(lastVehicle) > 360 then
        if engineIsOn and not GetIsVehicleEngineRunning(lastVehicle) and GetVehicleFuelLevel(lastVehicle) > 0.9 then
          --for i = 1, #policeVehicles do
            --if IsVehicleModel(lastVehicle, policeVehicles[i]) then
          SetVehicleEngineOn(lastVehicle, true, true, true)
          SetVehicleUndriveable(lastVehicle, false)
              --break
            --end
          --end
        elseif not engineIsOn and GetIsVehicleEngineRunning(lastVehicle) then
          SetVehicleEngineOn(lastVehicle, false, false, false)
          SetVehicleUndriveable(lastVehicle, true)
        end
      end
    end
  end
end)

--------------------------------------
-- increase tazer gun stun duration --
--------------------------------------
local tiempo = 8000 -- in miliseconds >> 1000 ms = 1s

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
		    SetPedMinGroundTimeForStungun(GetPlayerPed(-1), tiempo)
		end
	end
end)

------------------------------------
-- remove vehicle weapon rewards  --
------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(10)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

-----------------------
-- UTILITY FUNCTIONS --
-----------------------
RegisterNetEvent("usa:notify")
AddEventHandler("usa:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

local playing_anim = nil
RegisterNetEvent("usa:playAnimation")
AddEventHandler("usa:playAnimation", function(animDict, animName, speed, speedMult, duration, flag, playbackRate, lockX, lockY, lockZ, actualDuration)
    local ped = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(ped, 1) then
      -- load animation
      RequestAnimDict(animDict)
      while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
      end
      TaskPlayAnim(ped, animDict, animName, speed, speedMult, duration, flag, playbackRate, lockX, lockY, lockZ)
      playing_anim = {
          dict = animDict,
          name = animName
      }
      if actualDuration then
          Wait(actualDuration * 1000)
          if not IsPedInAnyVehicle(ped) then
              ClearPedTasksImmediately(ped)
          end
          StopAnimTask(ped, animDict, animName, 1.0)
      end
  end
end)

RegisterNetEvent("usa:playSound")
AddEventHandler("usa:playSound", function(soundParams)
  -- play start up / shut off sound
  PlaySoundFrontend(table.unpack(soundParams))
end)

RegisterNetEvent("usa:playScenario")
AddEventHandler("usa:playScenario", function(scenario)
    TaskStartScenarioInPlace(GetPlayerPed(-1), scenario, 0, 1)
end)

RegisterNetEvent("usa:heal")
AddEventHandler("usa:heal", function(amount)
	local me = GetPlayerPed(-1)
	local curr_hp = GetEntityHealth(me)
	SetEntityHealth(me, curr_hp + amount)
end)

-- prevent falling through vehicle when eating/drink and entering vehicle:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
    --print("trying to enter: " .. GetVehiclePedIsTryingToEnter(PlayerPedId(GetPlayerPed(-1))))
		if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(GetPlayerPed(-1)))) then
      --ClearPedSecondaryTask(GetPlayerPed(-1))
      if playing_anim then
        StopAnimTask(GetPlayerPed(-1), playing_anim.dict, playing_anim.name, 1.0)
      end
		end
	end
end)

RegisterNetEvent("usa:equipWeapon")
AddEventHandler("usa:equipWeapon", function(weapon)
  -- todo: store ammo count on weapon object
  if weapon.name ~= "Jerry Can" then
    GiveWeaponToPed(GetPlayerPed(-1), weapon.hash, 100, false, true)
    if weapon.components then
      if #weapon.components > 0 then
        for x = 1, #weapon.components do
          GiveWeaponComponentToPed(GetPlayerPed(-1), weapon.hash, GetHashKey(weapon.components[x]))
        end
      end
    end
    if weapon.tint then
      SetPedWeaponTintIndex(GetPlayerPed(-1), weapon.hash, weapon.tint)
    end
  else
    --print("equipping jerry can! giving ammo!")
    -- give more ammo if jerry can --
    --print("max ammo: " .. GetMaxAmmoInClip(GetPlayerPed(-1), weapon.hash, 1))
    SetPedAmmo(GetPlayerPed(-1), weapon.hash, math.random(1000, 4500))
  end
end)

RegisterNetEvent("usa:dropWeapon")
AddEventHandler("usa:dropWeapon", function(weapon_hash)
	--print("typeof weapon_hash: " .. type(weapon_hash))
  RemoveWeaponFromPed(GetPlayerPed(-1), weapon_hash) -- right params?
  --SetPedDropsWeapon(weapon_hash) -- or this? or both?
end)

RegisterNetEvent("usa:loadCivCharacter")
AddEventHandler("usa:loadCivCharacter", function(character, playerWeapons)
  Citizen.CreateThread(function()
    local model
    if not character.hash then -- does not have any customizations saved
      --print("did not find character.hash!")
      model = -408329255 -- some random black dude with no shirt on, lawl
    else
      --print("found a character hash!")
      model = character.hash
    end
    RequestModel(model)
    while not HasModelLoaded(model) do -- Wait for model to load
      Citizen.Wait(100)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    -- give model customizations if available
    if character.hash then
      for key, value in pairs(character["components"]) do
        SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
      end
      for key, value in pairs(character["props"]) do
        SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
      end
    end
    -- add any tattoos if they have any --
    if character.tattoos then
      for i = 1, #character.tattoos do
        ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
      end
    else
      --print("no tattoos!!!")
    end
    -- add any barber shop customizations if any --
    if character.head_customizations then
      --print("barber shop customizations existed!")
      local head = character.head_customizations
      local ped = GetPlayerPed(-1)
      SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
      -- facial stuff like beards and ageing and what not --
      for i = 1, #head.other do
        SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
        if head.other[i][2] ~= 255 then
          if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
            SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
          elseif i == 6 or i == 9 then -- blush, lipstick
            SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
          elseif i == 14 then -- hair
            --print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
            SetPedComponentVariation(ped, 2, head.other[i][2], GetNumberOfPedTextureVariations(ped,2, 0), 2)
            SetPedHairColor(ped, head.other[i][4], head.other[i][4])
          end
        end
      end
    else
      print("no barber shop customizations!")
    end
    -- give weapons
    if playerWeapons then
      for i = 1, #playerWeapons do
        print("playerWeapons[i].hash = " .. playerWeapons[i].hash)
        GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
      end
    end
  end)
end)

RegisterNetEvent("usa:setPlayerComponents")
AddEventHandler("usa:setPlayerComponents", function(character)
  local ped = GetPlayerPed(-1)
  -- set model and clothing --
  if character.hash then
    if character.hash == GetHashKey("mp_m_freemode_01") or character.hash == GetHashKey("mp_f_freemode_01") then
      -- set clothing --
      for key, value in pairs(character["components"]) do
        SetPedComponentVariation(ped, tonumber(key), value, character["componentstexture"][key], 0)
      end
      -- set props --
      for key, value in pairs(character["props"]) do
        SetPedPropIndex(ped, tonumber(key), value, character["propstexture"][key], true)
      end
      -- set tattoos --
      ClearPedDecorations(GetPlayerPed(-1))
      if character.tattoos then
        for i = 1, #character.tattoos do
          ApplyPedOverlay(ped, GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
        end
      end
      -- set barbershop customizations --
      if character.head_customizations then
        print("player had barber shop customizations! applying!")
        local head = character.head_customizations
        SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
        -- facial stuff like beards and ageing and what not --
        for i = 1, #head.other do
          SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
          if head.other[i][2] ~= 255 then
            if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
              SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
            elseif i == 6 or i == 9 then -- blush, lipstick
              SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
            elseif i == 14 then -- hair
              print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
              SetPedComponentVariation(ped, 2, head.other[i][2], GetNumberOfPedTextureVariations(ped,2, 0), 2)
              SetPedHairColor(ped, head.other[i][4], head.other[i][4])
            end
          end
        end
      else
        print("no barber customizations!")
        -- set default values --
        -- default head & skin details --
        local p1, p2 = 0, 0
        if(GetEntityModel(ped) == -1667301416) then -- female
          p1, p2 = 27
        end
        local old_head = {
          parent1 = p1,
          parent3 = 25,
          parent2 = p2,
          skin1 = 0,
          skin3 = 20,
          skin2 = 0,
          mix1 = 0.5,
          mix2 = 0.5,
          mix3 = 0.0,
          isParent = false,
          other = {
            {"Blemishes", 255, 23},
            {"Facial Hair", 255, 28, 0},
            {"Eyebrows", 255, 33, 0},
            {"Ageing", 255, 14},
            {"Makeup", 255, 74},
            {"Blush", 255, 6, 0},
            {"Complexion", 255, 11},
            {"Sun Damage", 255, 10},
            {"Lipstick", 255, 9, 0},
            {"Moles/Freckles", 255, 17},
            {"Chest Hair", 255, 16, 0},
            {"Body Blemishes", 255, 11},
            {"Add Body Blemishes", 255, 1},
            {"Hair", 0, 100, 0}
          }
        }
        SetPedHeadBlendData(ped, old_head.parent1, old_head.parent2, old_head.parent3, old_head.skin1, old_head.skin2, old_head.skin3, old_head.mix1, old_head.mix2, old_head.mix3, false) -- needed to apply head overlays like facial hair
        for i = 1, #old_head.other do
          SetPedHeadOverlay(ped, i - 1, 255, 1.0)
          --[[
          if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
            SetPedHeadOverlayColor(ped, i - 1, 1, old_head.other[i][3])
          elseif i == 6 or i == 9 then -- blush, lipstick
            SetPedHeadOverlayColor(ped, i - 1, 2, old_head.other[i][3])
          end
          --]]
        end
      end
    else
      -- non-MP model --
      Citizen.CreateThread(function()
				RequestModel(character.hash)
				while not HasModelLoaded(character.hash) do
					Citizen.Wait(100)
				end
				SetPlayerModel(PlayerId(), character.hash)
				SetPedRandomComponentVariation(GetPlayerPed(-1), true)
				SetModelAsNoLongerNeeded(character.hash)
			end)
    end
  else
    -- set default --
    Citizen.CreateThread(function()
      local model = GetHashKey("a_m_y_skater_01")
      RequestModel(model)
      while not HasModelLoaded(model) do
        Citizen.Wait(100)
      end
      SetPlayerModel(PlayerId(), model)
      SetPedRandomComponentVariation(GetPlayerPed(-1), true)
      SetModelAsNoLongerNeeded(model)
    end)
  end
end)

RegisterNetEvent("usa:getNumberInput")
AddEventHandler("usa:getNumberInput", function(isCallbackServerEvent, eventName)
    Citizen.CreateThread( function()
            DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
            while true do
                if ( UpdateOnscreenKeyboard() == 1 ) then
                    local input_amount = GetOnscreenKeyboardResult()
                    if ( string.len( input_amount ) > 0 ) then
                        local amount = tonumber( input_amount )
                        if ( amount > 0 ) then
                            -- todo: prevent decimals
                            -- trigger server event to remove money
                            amount = math.floor(amount)
                            if not isCallbackServerEvent then
                                TriggerEvent(eventName)
                            else
                                TriggerServerEvent(eventName, amount)
                            end
                        end
                        break
                    else
                        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
                    end
                elseif ( UpdateOnscreenKeyboard() == 2 ) then
                    break
                end
            Citizen.Wait( 0 )
        end
    end )
end)

RegisterNetEvent("usa:getClosestPlayer")
AddEventHandler("usa:getClosestPlayer", function(range, cb)
	local id, name, dist = GetClosestPlayerInfo(range)
  local player = {
    id = id,
    name = name,
    dist = dist
  }
  cb(player)
end)

function GetClosestPlayerInfo(range)
	local closestDistance = 0
	local closestPlayerServerId = 0
	local closestName = ""
	for x = 0, 64 do
		if NetworkIsPlayerActive(x) then
			targetPed = GetPlayerPed(x)
			targetPedCoords = GetEntityCoords(targetPed, false)
			playerPedCoords = GetEntityCoords(GetPlayerPed(-1), false)
			distanceToTargetPed = Vdist(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			if targetPed ~= GetPlayerPed(-1) then
				if distanceToTargetPed < 10 then
					if closestDistance == 0 then
						closestDistance = distanceToTargetPed
						closestPlayerServerId = GetPlayerServerId(x)
						closestName = GetPlayerName(x)
						hitHandlePed = GetPlayerPed(x)
						--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
						--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
					else
						if distanceToTargetPed <= closestDistance then
							closestDistance = distanceToTargetPed
							closestPlayerServerId = GetPlayerServerId(x)
							closestName = GetPlayerName(x)
							hitHandlePed = GetPlayerPed(x)
							--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
							--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
						end
					end
				end
			end
		end
	end
	return closestPlayerServerId, closestName, closestDistance
end

--
-- MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--

--TODO: chance for big boom when making meth

local INPUT_KEY = 38 -- E

local meth = {
    peds = {
        {x = 705.34, y = 4185.25, z = 40.7858, name = "meth_supplies_ped", model = "U_M_O_TAPHILLBILLY"},
        {x = 2724.68, y = 4143.52, z = 43.97, name = "meth_supplies_ped_quality", model = 'A_M_M_HILLBILLY_01'}
    },
    suppliesProduce = "Pseudoephedrine",
    suppliesProduceQuality = 'Red Phosphorus',
    suppliesProcess = "Meth Rock",
    suppliesProcessQuality = "Blue Meth Rock",
    pedIsBusy = false,
    processingMeth = false,
    producingMeth = false,
    methToProcess = nil,
    methIngredients = {}
}

local peds = {}


-- JOB HANDLING
Citizen.CreateThread(function()
    local cooldown = GetGameTimer()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        DrawText3D(996.50, -3200.201, -36.19, 5, '[E] - Exit')
        DrawText3D(-121.95, 1918.01, 197.43, 5, '[E] - Enter')
        DrawText3D(704.62, 4185.3, 40.70, 5, '[E] - Buy Pseudoephedrine (~g~$300.00~w~)')
        DrawText3D(2724.06, 4143.56, 43.99, 5, '[E] - Buy Red Phosphorus (~g~$500.00~w~)')
        DrawText3D(1012.29, -3194.89, -38.99, 5, '[E] - Cook Meth')
        DrawText3D(2434.78, 4964.29, 42.34, 5, '[E] - Package Meth')
        if IsControlJustPressed(0, INPUT_KEY) then
            if GetDistanceBetweenCoords(playerCoords, 996.90, -3200.701, -36.39, true) < 0.7 then
                DoorTransition(playerPed, -121.23, 1918.45, 197.33, 270.0)
            elseif GetDistanceBetweenCoords(playerCoords, -121.23, 1918.45, 197.33, true) < 0.7 then
                DoorTransition(playerPed, 996.90, -3200.701, -36.39, 270.0)
            elseif GetDistanceBetweenCoords(playerCoords, 704.62, 4185.3, 40.70, true) < 3 and not meth.pedIsBusy and GetGameTimer() - cooldown > 2000 then -- purchase supplies
                TriggerServerEvent("methJob:checkUserMoney", meth.suppliesProduce)
                cooldown = GetGameTimer()
            elseif GetDistanceBetweenCoords(playerCoords, 1012.29, -3194.89, -38.99, true) < 3 and not meth.producingMeth and GetGameTimer() - cooldown > 2000 then -- produce meth rocks
                TriggerServerEvent("usa_rp:checkUserJobSupplies", meth.suppliesProduce)
                TriggerServerEvent('usa_rp:checkUserJobSupplies', meth.suppliesProduceQuality)
                cooldown = GetGameTimer()
            elseif GetDistanceBetweenCoords(playerCoords, 2434.78, 4964.29, 42.34, true) < 3 and not meth.processingMeth and GetGameTimer() - cooldown > 2000 then -- process/package meth rocks
                TriggerServerEvent("usa_rp:checkUserJobSupplies", meth.suppliesProcess, meth.suppliesProcessQuality)
                cooldown = GetGameTimer()
            elseif GetDistanceBetweenCoords(playerCoords, 2724.06, 4143.56, 43.99, true) < 3 and not meth.pedIsBusy and GetGameTimer() - cooldown > 2000 then -- purchase quality supplies
                TriggerServerEvent('methJob:checkUserMoney', meth.suppliesProduceQuality)
                cooldown = GetGameTimer()
            end
        end
        if meth.producingMeth and GetDistanceBetweenCoords(playerCoords, 1012.29, -3194.89, -38.99, true) > 6 then -- too far from being able to process
            --Citizen.Trace("you stopped cooking meth! too far!")
            print('returning chemicals')
            TriggerEvent("usa_rp:notify", "You went ~y~out of range~w~.")
            if meth.producingMeth then
                for k = 1, #meth.methIngredients do
                    TriggerServerEvent("usa_rp:giveChemicals", meth.methIngredients[k])
                end
                meth.methIngredients = {}
            end
            meth.producingMeth = false
        elseif meth.processingMeth and GetDistanceBetweenCoords(playerCoords, 2434.78, 4964.29, 42.34, true) > 6 then 
            TriggerEvent("usa_rp:notify", "You went ~y~out of range~w~.")
            if meth.processingMeth then
                TriggerServerEvent("usa_rp:giveRock", meth.methToProcess)
                meth.methToProcess = nil
            end
            meth.processingMeth = false
        end
    end
end)

-- thread code stuff below was taken from an example on the wiki
-- Create a thread so that we don't 'wait' the entire game
Citizen.CreateThread(function()
    -- Spawn the peds
    for j = 1, #meth.peds do
        local hash = GetHashKey(meth.peds[j].model)
        -- Request the model so that it can be spawned
        RequestModel(hash)
        -- Check if it's loaded, if not then wait and re-request it.
        while not HasModelLoaded(hash) do
	        Citizen.Wait(100)
        end
         -- Model loaded, continue
        local x = meth.peds[j].x
        local y = meth.peds[j].y
        local z = meth.peds[j].z

        --Citizen.Trace("spawned in ped # " .. i)
        local ped = CreatePed(4, hash, x, y, z, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        SetEntityCanBeDamaged(ped,false)
        SetPedCanRagdollFromPlayerImpact(ped,false)
        TaskSetBlockingOfNonTemporaryEvents(ped,true)
        SetPedFleeAttributes(ped,0,0)
        SetPedCombatAttributes(ped,17,1)
        -- add to peds collection
        table.insert(peds, {name = meth.peds[j].name, handle = ped})
    end
end)

RegisterNetEvent("usa_rp:notify")
AddEventHandler("usa_rp:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("usa_rp:returnPedToStartPosition")
AddEventHandler("usa_rp:returnPedToStartPosition", function(pedType)
    for i =1, #peds do
        if pedType == peds[i].name then
            TaskGoStraightToCoord(peds[i].handle, meth.peds[i].x, meth.peds[i].y, meth.peds[i].z, 2, -1)
            SetBlockingOfNonTemporaryEvents(peds[i].handle, false)
            meth.pedIsBusy = false
        end
    end
end)

RegisterNetEvent("usa_rp:doesUserHaveJobSupply")
AddEventHandler("usa_rp:doesUserHaveJobSupply", function(hasJobSupply, supplyName, supplyName2)
    if hasJobSupply then
        if supplyName == meth.suppliesProduce or supplyName == meth.suppliesProduceQuality then
            table.insert(meth.methIngredients, supplyName)
            print('inserted item: '..supplyName)
            meth.producingMeth = true
        elseif supplyName == meth.suppliesProcess or supplyName == meth.suppliesProcessQuality then
            meth.processingMeth = true
            meth.methToProcess = supplyName
        end
    else
        if supplyName == meth.suppliesProduce then
            for i = 1, #meth.methIngredients do
                if meth.methIngredients[i] == meth.suppliesProduce then
                    return
                end
            end
            TriggerEvent('usa_rp:notify', 'You do not have any ~y~Pseudoephedrine~s~!')
        elseif supplyName == meth.suppliesProcess or supplyName == meth.suppliesProcessQuality and supplyName2 == meth.suppliesProcess or supplyName2 == meth.suppliesProcessQuality then
            TriggerEvent('usa_rp:notify', 'You do not have any ~y~Meth Rocks~s~!')
        end
    end
end)

RegisterNetEvent("methJob:getSupplies")
AddEventHandler("methJob:getSupplies", function(supplyType)
    if supplyType == meth.suppliesProduce then
        for i = 1, #peds do
            if peds[i].name == "meth_supplies_ped" then
                meth.pedIsBusy = true
                TaskGoStraightToCoord(peds[i].handle, 711.15, 4185.45, 41.08, 2, -1) -- pier by Grapeseed
                SetBlockingOfNonTemporaryEvents(peds[i].handle, false)
                TriggerServerEvent("usa_rp:startTimer", "meth_supplies_ped")
                local sounds = {
                  {sound = "Shout_Threaten_Ped", param = "Speech_Params_Force_Shouted_Critical"},
                  {sound = "Shout_Threaten_Gang", param = "Speech_Params_Force_Shouted_Critical"},
                  {sound = "Generic_Hi", param = "Speech_Params_Force"}
                }
                local random_sound = sounds[math.random(1, tonumber(#sounds))]
                PlayAmbientSpeech1(peds[i].handle, random_sound.sound, random_sound.param)
            end
        end
    elseif supplyType == meth.suppliesProduceQuality then
        for i = 1, #peds do
            if peds[i].name == "meth_supplies_ped_quality" then
                meth.pedIsBusy = true
                TaskGoStraightToCoord(peds[i].handle, 2728.645, 4141.98, 44.28, 2, -1) -- off-road on E Joshua Road
                SetBlockingOfNonTemporaryEvents(peds[i].handle, false)
                TriggerServerEvent("usa_rp:startTimer", "meth_supplies_ped_quality")
                local sounds = {
                  {sound = "Shout_Threaten_Ped", param = "Speech_Params_Force_Shouted_Critical"},
                  {sound = "Shout_Threaten_Gang", param = "Speech_Params_Force_Shouted_Critical"},
                  {sound = "Generic_Hi", param = "Speech_Params_Force"}
                }
                local random_sound = sounds[math.random(1, tonumber(#sounds))]
                PlayAmbientSpeech1(peds[i].handle, random_sound.sound, random_sound.param)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if meth.producingMeth then
            beginTime = GetGameTimer()
            animDict = "timetable@jimmy@ig_1@idle_a"
            animName = "hydrotropic_bud_or_something"
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(100)
            end
            TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
            while GetGameTimer() - beginTime < 30000 do
                Citizen.Wait(0)
                if meth.producingMeth then
                    DrawTimer(beginTime, 30000, 1.42, 1.475, 'COOKING')
                    if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, animName, 3) then
                        TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
                    end
                else
                    print("player stopped gathering! breaking from for loop!")
                    break
                end
            end
            local explosion = math.random()
            if explosion > 0.98 then
                AddExplosion(GetEntityCoords(PlayerPedId()), 9, 1.0, true, false, 1.0)
                local lastStreetHASH = GetStreetNameAtCoord(-121.95, 1918.01, 197.43)
                local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                TriggerServerEvent('911:MethExplosion', -121.95, 1918.01, 197.43, lastStreetNAME)
            end
            ClearPedTasksImmediately(GetPlayerPed(-1))
            StopAnimTask(GetPlayerPed(-1), animDict,animName, false)
            --print('Animation stopped!')
            methProduced = {
                name = "Meth Rock",
                type = "drug",
                legality = "illegal",
                quantity = 2,
                weight = 4,
                objectModel = 'bkr_prop_meth_scoop_01a'
              }
            if meth.producingMeth then
                meth.producingMeth = false
                for i = 1, #meth.methIngredients do
                    --print(meth.methIngredients[i])
                    if meth.methIngredients[i] == 'Red Phosphorus' then
                        --print('found the red Phosphorus')
                        methProduced.name = "Blue Meth Rock"
                    end
                end
                --print(methProduced.name)
                meth.methIngredients = {}
                TriggerServerEvent("usa_rp:giveItem", methProduced)
                Citizen.Trace("giving meth to player!")
            end
        elseif meth.processingMeth then
            beginTime = GetGameTimer()
            animDict = "timetable@jimmy@ig_1@idle_a"
            animName = "hydrotropic_bud_or_something"
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Citizen.Wait(100)
            end
            TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
            while GetGameTimer() - beginTime < 5000 do
                Citizen.Wait(0)
                DrawTimer(beginTime, 5000, 1.42, 1.475, 'PACKAGING')
                if meth.processingMeth then
                    if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, animName, 3) then
                        TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49 , 0, 0, 0, 0)
                    end
                else
                    print('player stopped processing! breaking from for loop!')
                    break
                end
            end
            ClearPedTasksImmediately(GetPlayerPed(-1))
            StopAnimTask(GetPlayerPed(-1), animDict, animName, false)
            processedMeth = {
                name = 'Packaged Meth',
                type = 'drug',
                legality = 'illegal',
                quantity = 1,
                weight = 4,
                objectModel = 'bkr_prop_meth_smallbag_01a'
              }
            if meth.processingMeth then
                meth.processingMeth = false
                if meth.methToProcess == 'Blue Meth Rock' then
                    processedMeth.name = 'Packaged Blue Meth'
                    meth.methToProcess = nil
                end
                --print(methProduced.name)
                TriggerServerEvent("usa_rp:giveItem", processedMeth)
                Citizen.Trace("giving meth to player!")
            end
        end
    Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, distance, text)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 470
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

function PlayDoorAnimation()
    while ( not HasAnimDictLoaded( 'anim@mp_player_intmenu@key_fob@' ) ) do
        RequestAnimDict( 'anim@mp_player_intmenu@key_fob@' )
        Citizen.Wait( 0 )
  end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, -1, 48)
end

function DoorTransition(playerPed, x, y, z, heading)
  PlayDoorAnimation()
  DoScreenFadeOut(500)
  Wait(500)
  RequestCollisionAtCoord(x, y, z)
  SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true)
  SetEntityHeading(playerPed, heading)
  while not HasCollisionLoadedAroundEntity(playerPed) do
      Citizen.Wait(100)
      SetEntityCoords(playerPed, x, y, z, 1, 0, 0, 1)
  end
  TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.5)
  Wait(2000)
  DoScreenFadeIn(500)
end

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end
--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--


local jobs = {
    {
        name = "Meth",
        peds = {
            {x = 70.0828, y = 3745.53, z = 39.7858, name = "supplies_ped", model = "G_M_Y_Lost_03"},
            {x = -402.63, y = 6316.12, z = 28.95, name = "methdropoff_ped_1", model = "G_M_Y_SalvaGoon_02"}
        },
        jobSupplies = "Suspicious Chemicals",
        started = false,
        locations = {
            {name="Meth Supply Pickup", x = 70.0828, y = 3745.53, z = 38.6858},
            {name="Meth Lab",  x = 1389.28, y = 3604.6, z = 38.1},
            {name="Meth Dropoff 1", x = -402.63, y = 6316.12, z = 27.95}
        }
    }
}

local peds = {}

local onJob = false
local gathering = false
local gatheringJob = ""

local animDict = ""
local animName = ""

local activeDropoffDestinationCoords = {x = 0.0, y = 0.0}

local pedIsBusy = false

-- thread code stuff below was taken from an example on the wiki
-- Create a thread so that we don't 'wait' the entire game
Citizen.CreateThread(function()
    -- Spawn the peds
    for i = 1, #jobs do
        for j = 1, #jobs[i].peds do
            local hash = GetHashKey(jobs[i].peds[j].model)
	        -- Request the model so that it can be spawned
	        RequestModel(hash)
	        -- Check if it's loaded, if not then wait and re-request it.
	        while not HasModelLoaded(hash) do
		        RequestModel(hash)
		        Citizen.Wait(0)
	        end
	         -- Model loaded, continue
            local x = jobs[i].peds[j].x
            local y = jobs[i].peds[j].y
            local z = jobs[i].peds[j].z

            --Citizen.Trace("spawned in ped # " .. i)
            local ped = CreatePed(4, hash, x, y, z, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
            SetEntityCanBeDamaged(ped,false)
            SetPedCanRagdollFromPlayerImpact(ped,false)
            TaskSetBlockingOfNonTemporaryEvents(ped,true)
            SetPedFleeAttributes(ped,0,0)
            SetPedCombatAttributes(ped,17,1)
            SetEntityInvincible(ped)
            -- add to peds collection
            if x == 70.0828 then
                table.insert(peds, {name = "meth_supplies_ped", handle = ped})
            end
        end
	end
end)

RegisterNetEvent("usa_rp:notify")
AddEventHandler("usa_rp:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

RegisterNetEvent("usa_rp:setWaypoint")
AddEventHandler("usa_rp:setWaypoint", function(coords)
    ClearGpsPlayerWaypoint()
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNetEvent("usa_rp:returnPedToStartPosition")
AddEventHandler("usa_rp:returnPedToStartPosition", function(pedType)
    for i =1, #peds do
        if pedType == peds[i].name then
            TaskGoStraightToCoord(peds[i].handle, jobs[1].peds[1].x, jobs[1].peds[1].y, jobs[1].peds[1].z, 2, -1)
            SetBlockingOfNonTemporaryEvents(peds[i].handle, false)
            pedIsBusy = false
        end
    end
end)

-- TODO: update to allow for multiple jobs, add a paramter for which job need coords for
RegisterNetEvent("usa_rp:doesUserHaveJobSupply")
AddEventHandler("usa_rp:doesUserHaveJobSupply", function(hasJobSupply)
    if hasJobSupply then
        --Citizen.Trace("user had job supply!")
        -- todo: check what type of job to continue within
        -- for now, just continue the meth job (since it's the only one atm)
        jobs[1].started = true
        onJob = true
        gatheringJob = "Meth"
        gathering = true
        Citizen.Trace("job started!")
    else
        --Citizen.Trace("user did not have job supply!")
        TriggerEvent("usa_rp:notify", "~y~You don't have the appropriate supplies! ~w~A waypoint has been set to get them.")
        ClearGpsPlayerWaypoint()
        SetNewWaypoint(jobs[1].locations[1].x,jobs[1].locations[1].y) -- meth supply pick up
        --Citizen.Trace("waypoint set!")
    end
end)

-- Draw Markers
Citizen.CreateThread(function ()
	while true do
        for i = 1, #jobs do
            -- check distance for any of the locations required for the jobs being < 3 in distance
            for j = 1, #jobs[i].locations do
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs[i].locations[j].x, jobs[i].locations[j].y, jobs[i].locations[j].z, true ) < 40 then
                    DrawMarker(1, jobs[i].locations[j].x, jobs[i].locations[j].y, jobs[i].locations[j].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 255, 102, 255, 90, 0, 0, 2, 0, 0, 0, 0)
                end
            end
        end
        if gatheringJob == "Meth" and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs[1].locations[2].x, jobs[1].locations[2].y, jobs[1].locations[2].z, true ) > 6 then
            --Citizen.Trace("you stopped cooking meth! too far!")
            TriggerEvent("usa_rp:notify", "You went ~y~out of range~w~.")
            gathering = false
            gatheringJob = ""
            jobs[1].started = false
            onJob = false
            TriggerServerEvent("usa_rp:giveChemicals")
        end
		Citizen.Wait(0)
    end
end)

-- help handle job animations
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
        if not onJob then
            for i = 1, #jobs do
                -- check distance for any of the locations required for the jobs being < 3 in distance
                for j = 1, #jobs[i].locations do
            		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs[i].locations[j].x, jobs[i].locations[j].y, jobs[i].locations[j].z, true ) < 3 then
                        if jobs[i].locations[j].name == "Meth Lab" then
                            drawTxt('Press ~g~E~s~ to start creating meth',0,1,0.5,0.8,0.6,255,255,255,255)
                            if IsControlJustPressed(1, 38) then -- 38 = E
                                --Citizen.Trace("checking if user has meth supplies!")
                                TriggerServerEvent("usa_rp:checkUserJobSupplies", jobs[i].jobSupplies)
                                --[[ not needed here
                                jobs[i].started = true
                                onJob = true
                                gatheringJob = "Meth"
                                gathering = true
                                Citizen.Trace("job started!")
                                --]]
                            end
                        elseif jobs[i].locations[j].name == "Meth Supply Pickup" then
                            drawTxt('Press ~g~E~s~ to buy the supplies needed to create meth',0,1,0.5,0.8,0.6,255,255,255,255)
                            if IsControlJustPressed(1, 38) and not pedIsBusy then -- 38 = E
                                TriggerServerEvent("methJob:checkUserMoney", 400)
                            end
                        elseif jobs[i].locations[j].name == "Meth Dropoff 1" then
                            drawTxt('Press ~g~E~s~ to sell your meth!',0,1,0.5,0.8,0.6,255,255,255,255)
                            if IsControlJustPressed(1, 38) then -- 38 = E
                                Citizen.Trace("remove/decrement meth and give user money!")
                                TriggerServerEvent("usa_rp:sellItem", jobs[i])
                            end
                        end
                    else
                        -- not close to a blip
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("methJob:getSupplies")
AddEventHandler("methJob:getSupplies", function()
    for i = 1, #peds do
        if peds[i].name == "meth_supplies_ped" then
            local walkToCoords = {x = 66.77, y = 3759.16, z = 39.7337}
            pedIsBusy = true
            --Citizen.Trace("Found meth supplier ped! do animation now...")
            TaskGoStraightToCoord(peds[i].handle, walkToCoords.x, walkToCoords.y, walkToCoords.z, 2, -1)
            SetBlockingOfNonTemporaryEvents(peds[i].handle, false)
            -- start timer
            TriggerServerEvent("usa_rp:startTimer", "meth_supplies_ped")
        end
    end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

Citizen.CreateThread(function()
    while true do
        if gathering then
            if gatheringJob == "Meth" then
                animDict = "timetable@jimmy@ig_1@idle_a"
                animName = "hydrotropic_bud_or_something"
                TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
                for i = 1, 75 do
                    if gathering then
                        if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, animName, 3) then
            				RequestAnimDict(animDict)
            				while not HasAnimDictLoaded(animDict) do
            					Citizen.Wait(100)
            				end
                            if gathering then
            				    TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
                            end
            			end
                        Citizen.Wait(1000)
                    else
                        print("player stopped gathering! breaking from for loop!")
                        break
                    end
                end
                ClearPedSecondaryTask(GetPlayerPed(-1))
                StopAnimTask(GetPlayerPed(-1), animDict, animName, false)
                if gathering then
                    -- give meth
                    local meth = {
                        name = "Meth",
                        type = "drug",
                        legality = "illegal",
                        quantity = 3
                    }
                    Citizen.Trace("giving meth to player!")
                    TriggerServerEvent("usa_rp:giveItem", meth)
                    onJob = false
                    gathering = false
                    gatheringJob = ""
                end
            end
        end
        Citizen.Wait(0)
    end
end)

--
--
-- extra
---
--

-- getting drunk / high effect
function Toxicated()
   TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
   Citizen.Wait(5000)
   DoScreenFadeOut(1000)
   Citizen.Wait(1000)
   ClearPedTasksImmediately(GetPlayerPed(-1))
   SetTimecycleModifier("spectator5")
   SetPedMotionBlur(GetPlayerPed(-1), true)
   SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
   SetPedIsDrunk(GetPlayerPed(-1), true)
   DoScreenFadeIn(1000)
 end

 function reality()
   Citizen.Wait(50000)
   DoScreenFadeOut(1000)
   Citizen.Wait(1000)
   DoScreenFadeIn(1000)
   ClearTimecycleModifier()
   ResetScenarioTypesEnabled()
   ResetPedMovementClipset(GetPlayerPed(-1), 0)
   SetPedIsDrunk(GetPlayerPed(-1), false)
   SetPedMotionBlur(GetPlayerPed(-1), false)
   -- Stop the mini mission
   Citizen.Trace("Going back to reality\n")
 end

 -- end drunk / high effect

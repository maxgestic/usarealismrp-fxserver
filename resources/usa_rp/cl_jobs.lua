--
--  MADE BY MINIPUNCH
-- A player will get close to a designated blip on the map within this script, press "E", and begin gathering.
-- This same concept within the script will handle all aspects of a job from getting supplies, processing, to selling, etc.
--


local jobs = {
    {name = "Meth", blip = { x = 1389.28, y = 3604.6, z = 38.1, sprite = 499, color = 75}, suppliesPickupLocation = {x = 2.60566, y = 3731.42, z = 39.7324}, started = false}
}

local alreadyOnAJob = false
local gathering = false
local gatheringJob = ""

local animDict = ""
local animName = ""

RegisterNetEvent("usa_rp:notify")
AddEventHandler("usa_rp:notify", function(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end)

-- TODO: update to allow for multiple jobs, add a paramter for which job need coords for
RegisterNetEvent("usa_rp:doesUserHaveJobSupply")
AddEventHandler("usa_rp:doesUserHaveJobSupply", function(hasJobSupply)
    if hasJobSupply then
        Citizen.Trace("user had job supply!")
    else
        Citizen.Trace("user did not have job supply!")
        TriggerEvent("usa_rp:notify", "~y~You don't have the appropriate supplies! ~w~A waypoint has been set to get them.")
        ClearGpsPlayerWaypoint()
        SetNewWaypoint(jobs[1].suppliesPickupLocation.x,jobs[1].suppliesPickupLocation.y)
        Citizen.Trace("waypoint set!")
    end
end)

-- job blips
Citizen.CreateThread(function()
    for i=1,#jobs do
    	local blip = AddBlipForCoord(jobs[i].blip.x, jobs[i].blip.y, jobs[i].blip.z)
    	SetBlipSprite(blip, jobs[i].blip.sprite)
    	SetBlipDisplay(blip, 4)
    	SetBlipScale(blip, 0.9)
    	SetBlipColour(blip, jobs[i].blip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
    	AddTextComponentString(jobs[i].name)
    	EndTextCommandSetBlipName(blip)
    end
end)

-- help handle job animations
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
        if not alreadyOnAJob then
            for i = 1, #jobs do
                -- draw meth job marker
                DrawMarker(1, jobs[i].blip.x,jobs[i].blip.y,jobs[i].blip.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 255, 102, 255, 90, 0, 0, 2, 0, 0, 0, 0)
                -- check distance for jobs
        		   if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs[i].blip.x, jobs[i].blip.y, jobs[i].blip.z, true ) < 3 then
                    if jobs[i].name == "Meth" then
                        drawTxt('Press ~g~E~s~ to start creating meth',0,1,0.5,0.8,0.6,255,255,255,255)
                        if IsControlJustPressed(1, 38) then -- 38 = E
                            Citizen.Trace("checking if user has meth supplies!")
                            local prerequisite = "Meth Supplies"
                            TriggerServerEvent("usa_rp:checkUserJobSupplies", prerequisite)
                            --[[
                            jobs[i].started = true
                            alreadyOnAJob = true
                            gatheringJob = "Meth"
                            gathering = true
                            Citizen.Trace("job started!")
                            --]]
                        end
                    end
                else
                    -- not close to a blip
                end
            end
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

Citizen.CreateThread(function()
    while true do
        if gathering then
            if gatheringJob == "Meth" then
                animDict = "timetable@jimmy@ig_1@idle_a"
                animName = "hydrotropic_bud_or_something"
                TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
                for i = 1, 60 do
                    if not IsEntityPlayingAnim(GetPlayerPed(-1), animDict, animName, 3) then
        				RequestAnimDict(animDict)
        				while not HasAnimDictLoaded(animDict) do
        					Citizen.Wait(100)
        				end
        				TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 8.0, -8, -1, 49, 0, 0, 0, 0)
        			end
                    Citizen.Wait(1000)
                end
                alreadyOnAJob = false
                gathering = false
                gatheringJob = ""
                ClearPedSecondaryTask(GetPlayerPed(-1))
                StopAnimTask(GetPlayerPed(-1), animDict, animName, false)
                -- give meth
                local meth = {
                    name = "Meth",
                    type = "drug",
                    legality = "illegal",
                    quantity = 1
                }
                Citizen.Trace("giving meth to player!")
                TriggerServerEvent("usa_rp:giveItem", meth)
            end
        end
        Citizen.Wait(0)
    end
end)

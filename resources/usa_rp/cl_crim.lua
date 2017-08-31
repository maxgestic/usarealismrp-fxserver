-- x = -1221.84, -908.512, z = 12.3264 ped
-- x = -1222.79, y = -906.859, z = 12.3263 front of ped (where player robs from)

local peds = {
    {x = -1221.84, y = -908.512, z = 12.3264}
}

local robbing = false

-- spawn ped
local hash = GetHashKey("A_M_M_Polynesian_01")
-- thread code stuff below was taken from an example on the wiki
-- Create a thread so that we don't 'wait' the entire game
Citizen.CreateThread(function()
	-- Request the model so that it can be spawned
	RequestModel(hash)
	-- Check if it's loaded, if not then wait and re-request it.
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Citizen.Wait(0)
	end
	-- Model loaded, continue
	-- Spawn the peds
	for i = 1, #peds do
		Citizen.Trace("spawned in ped # " .. i)
		local ped = CreatePed(4, hash, peds[i].x, peds[i].y, peds[i].z, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetEntityInvincible(ped)
	end
end)

RegisterNetEvent("crim:notify")
AddEventHandler("crim:notify", function(message)
    DrawNotification(message)
end)


RegisterNetEvent("crim:checkIsPedArmedForRobbery")
AddEventHandler("crim:checkIsPedArmedForRobbery", function()
    local waitTime = 5000
    local armed = IsPedArmed(GetPlayerPed(-1), 7)
    if armed then
        Citizen.Trace("player is armed and is ready to rob")
        robbing = true
        TriggerServerEvent("crim:startRobbery", waitTime)
    else
        Citizen.Trace("player is not armed and is not ready to rob")
    end
end)

RegisterNetEvent("crim:checkRange")
AddEventHandler("crim:checkRange", function()
    local rewardAmount = 1000
    local armed = IsPedArmed(GetPlayerPed(-1), 7)
    if getPlayerDistanceFromCoords(peds[1].x, peds[1].y, peds[1].z) < 5 and armed then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("test")
        DrawNotification(0,1)
        TriggerServerEvent("crim:playerWasInRange", rewardAmount)
    else

    end
end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

local admitted = false
local hospitalCoords = {x = 354.032, y = -589.411, z = 42.415}
local releaseCoords = {x = 304.785, y = -591.046, z = 42.4919}

RegisterNetEvent("ems:notify")
AddEventHandler("ems:notify", function(time, reason)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("HOSPITALIZED\n~y~Time:~w~ "..time.." hours\n~y~Reason: ~w~"..reason)
    DrawNotification(0,1)
end)

RegisterNetEvent("ems:admitPatient")
AddEventHandler("ems:admitPatient", function()
    lPed = GetPlayerPed(-1)
    SetEntityCoords(GetPlayerPed(-1), hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1) -- tp to hospital
    admitted = true
end)

RegisterNetEvent("ems:releasePatient")
AddEventHandler("ems:releasePatient", function()
    lPed = GetPlayerPed(-1)
    SetEntityCoords(GetPlayerPed(-1), releaseCoords.x, releaseCoords.y, releaseCoords.z, 1, 0, 0, 1) -- tp to hospital
    admitted = false
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if admitted and getPlayerDistanceFromCoords(hospitalCoords.x, hospitalCoords.y, hospitalCoords.z) > 8 then
            SetEntityCoords(GetPlayerPed(-1), hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1)
        end
    end
end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

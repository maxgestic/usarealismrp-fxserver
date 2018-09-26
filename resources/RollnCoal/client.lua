local time = 5 -- how long the particle lasts
local SIZE = 1.0
local particleDict = "core"
local particleName = "ent_amb_generator_smoke"
local bone = "exhaust"
local key = 20

-- [EFFECTS FROM CORE ONLY]
-- veh_exhaust_truck_rig [size = 3.0]
-- ent_amb_smoke_general [size = 1.0]
-- ent_amb_generator_smoke [size = 1.0]

--[[
    Vehicle Classes
0: Compacts
1: Sedans
2: SUVs
3: Coupes
4: Muscle
5: Sports Classics
6: Sports
7: Super
8: Motorcycles
9: Off-road
10: Industrial
11: Utility
12: Vans
13: Cycles
14: Boats
15: Helicopters
16: Planes
17: Service
18: Emergency
19: Military
20: Commercial
21: Trains
]]

local car_net = nil
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(PlayerId())
        local vehicle = GetVehiclePedIsIn(ped, false)
        --local class = GetVehicleClass(vehicle)

       if IsPedInAnyVehicle(ped, false) then

        --if class == 9 or class == 10 then -- Add more classes allowed to use it
        if ValidVehicle(vehicle) then

            if  IsControlJustPressed(1, key) and IsPedTheDriver(vehicle, ped) then

                RequestNamedPtfxAsset(particleDict)
                while not HasNamedPtfxAssetLoaded(particleDict) do
                    Citizen.Wait(10)
                end

                local netid = VehToNet(vehicle)

                SetNetworkIdExistsOnAllMachines(netid, 1)
                NetworkSetNetworkIdDynamic(netid, 0)
                SetNetworkIdCanMigrate(netid, 0)
                car_net = netid
                TriggerServerEvent("Smoke:SyncStartParticles", car_net)

            elseif IsControlJustPressed(1, key) then
                    print ("You cannot do this as passenger")
                end
            end

        end
    end
end)

RegisterNetEvent("Smoke:StartParticles")
AddEventHandler("Smoke:StartParticles", function(carid)
    local entity = NetToVeh(carid)

    local part = GetWorldPositionOfEntityBone(entity, bone)

    local loopAmount = 250

    local particleEffects = {}

    for x=0,loopAmount do

        UseParticleFxAssetNextCall(particleDict)

        local particle = StartParticleFxLoopedOnEntityBone(particleName, entity, part.x, part.y, part.z, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(entity, bone), SIZE, false, false, false)

        SetParticleFxLoopedEvolution(particle, particleName, SIZE, 0)

        table.insert(particleEffects, 1, particle)
        Citizen.Wait(0)
    end

    Citizen.Wait(time)
    for _,particle in pairs(particleEffects) do
        StopParticleFxLooped(particle, true)
    end
end)

function IsPedTheDriver(vehicle, ped)
    local driverPed = GetPedInVehicleSeat(vehicle, -1)
    if driverPed == ped then
        return true
    else
        return false
    end
end

function ValidVehicle(veh)
    if GetEntityModel(veh) == GetHashKey("slamvan") then
        return true
    elseif GetEntityModel(veh) == GetHashKey("slamvan2") then
        return true
    elseif GetEntityModel(veh) == GetHashKey("sandking") then
        return true
    elseif GetEntityModel(veh) == GetHashKey("sandking2") then
        return true
    elseif GetEntityModel(veh) == GetHashKey("guardian") then
        return true
    else
        return false
    end
end

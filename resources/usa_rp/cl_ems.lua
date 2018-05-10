local admitted = false
local hospitalCoords = {x = 354.032, y = -589.411, z = 42.415}
--local releaseCoords = {x = 304.785, y = -591.046, z = 42.4919} -- LS
local releaseCoords = {
    {x = -240.10, y = 6324.22, z = 32.43}, -- paleto
    {x = 307.63, y = -593.948, z = 42.2919}, -- LS
    {x = 1814.914, y = 3685.767, z = 34.224} -- sandy
}
local healStations = {
    {x = 307.63, y = -593.948, z = 42.2919}, -- LS
    {x = -380.562, y = 6119.039, z = 30.631}, -- PALETO FD
    {x = -247.546, y = 6331.111, z = 31.426} -- PALETO HOSPITAL
}

RegisterNetEvent("ems:notify")
AddEventHandler("ems:notify", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end)

RegisterNetEvent("ems:notifyHospitalized")
AddEventHandler("ems:notifyHospitalized", function(time, reason)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("HOSPITALIZED\n~y~Time:~w~ "..time.." hours\n~y~Reason: ~w~"..reason)
    DrawNotification(0,1)
end)

local closest_release = nil
local closest_distance = 9999999999999999

RegisterNetEvent("ems:admitPatient")
AddEventHandler("ems:admitPatient", function()
    --get release location
    for i = 1, #releaseCoords do
        if getPlayerDistanceFromCoords(releaseCoords[i].x, releaseCoords[i].y, releaseCoords[i].z) < closest_distance then
            closest_distance = getPlayerDistanceFromCoords(releaseCoords[i].x, releaseCoords[i].y, releaseCoords[i].z)
            closest_release = releaseCoords[i]
        end
    end
    -- admit
    lPed = GetPlayerPed(-1)
    RequestCollisionAtCoord(hospitalCoords.x, hospitalCoords.y, hospitalCoords.z)
    SetEntityCoords(GetPlayerPed(-1), hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1) -- tp to hospital
    admitted = true
    -- remove any blindfolds/tied hands
    TriggerEvent("crim:untieHands", GetPlayerServerId(PlayerId()))
    TriggerEvent("crim:blindfold", false, true)
end)

RegisterNetEvent("ems:releasePatient")
AddEventHandler("ems:releasePatient", function()
    lPed = GetPlayerPed(-1)
    RequestCollisionAtCoord(closest_release.x, closest_release.y, closest_release.z)
    SetEntityCoords(GetPlayerPed(-1), closest_release.x, closest_release.y, closest_release.z, 1, 0, 0, 1) -- tp to hospital
    admitted = false
    closest_release = nil
    closest_distance = 999999999999
end)

RegisterNetEvent("ems:healPlayer")
AddEventHandler("ems:healPlayer", function()
    local ped = GetPlayerPed(-1)
    SetEntityHealth(ped, 200)
    TriggerEvent("ems:notify", "Your health has been restored!")
end)

-- inspect wounds:
--[[
    IS_THIS_MODEL_A_BICYCLE
    IS_THIS_MODEL_A_BIKE
    IS_THIS_MODEL_A_BOAT
    IS_THIS_MODEL_A_CAR
    IS_THIS_MODEL_A_HELI
    IS_THIS_MODEL_A_PLANE
    IS_THIS_MODEL_A_QUADBIKE
    IS_THIS_MODEL_A_TRAIN
]]
--[[
    GetWeaponDamageType() return values:
    0=unknown (or incorrect weaponHash)
    1= no damage (flare,snowball, petrolcan)
    2=melee
    3=bullet
    4=force ragdoll fall
    5=explosive (RPG, Railgun, grenade)
    6=fire(molotov)
    8=fall(WEAPON_HELI_CRASH)
    10=electric
    11=barbed wire
    12=extinguisher
    13=gas
    14=water cannon(WEAPON_HIT_BY_WATER_CANNON)
]]
-- todo: add a distance check?
RegisterNetEvent("EMS:inspect")
AddEventHandler("EMS:inspect", function(responder_id)
    local me = GetPlayerPed(-1)
    if IsPedDeadOrDying(me) then
        -- get cause of death:
        local death_cause = GetPedCauseOfDeath(me)
        local damage_type = GetWeaponDamageType(death_cause)
        local killer = GetPedKiller(me)
        local entity_type = GetEntityType(killer)
        print("entity_type: " .. entity_type)
        print("killer: " .. killer)
        print("cause of death: " .. death_cause)
        print("damage type: " .. damage_type)
        -- notify responder of injuries:
        TriggerServerEvent("EMS:notifyResponderOfInjuries", responder_id, entity_type, damage_type, death_cause)
    else 
        print("not dead!")
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        for i = 1, #healStations do
            DrawMarker(1, healStations[i].x, healStations[i].y, healStations[i].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
            if getPlayerDistanceFromCoords(healStations[i].x, healStations[i].y, healStations[i].z) < 3 then
                DrawSpecialText("Press [~b~E~w~] to restore your health ($500)!")
                if IsControlJustPressed(1, 38) then -- 38 = E
                    TriggerServerEvent("ems:checkPlayerMoney")
                end
            end
        end
        if admitted and getPlayerDistanceFromCoords(hospitalCoords.x, hospitalCoords.y, hospitalCoords.z) > 8 then
            SetEntityCoords(GetPlayerPed(-1), hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1)
        end
    end
end)

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

function IsHashSomeVehicle(hash)
    local is_veh = false
    if IsThisModelABicycle(hash) then is_veh = true end
    if IsThisModelABike(hash) then is_veh = true end
    if IsThisModelABoat(hash) then is_veh = true end
    if IsThisModelACar(hash) then is_veh = true end
    if IsThisModelAHeli(hash) then is_veh = true end
    if IsThisModelAPlane(hash) then is_veh = true end
    if IsThisModelAQuadbike(hash) then is_veh = true end
    if IsThisModelATrain(hash) then is_veh = true end
    print("returning is_veh: " .. tostring(is_veh))
    return is_veh
end
local admitted = false
local hospitalCoords = {x = 354.032, y = -589.411, z = 42.415}
--local releaseCoords = {x = 304.785, y = -591.046, z = 42.4919} -- LS
local releaseCoords = {
    {x = -240.10, y = 6324.22, z = 32.43}, -- paleto
    {x = 307.63, y = -593.948, z = 42.2919}, -- LS
    {x = 1814.914, y = 3685.767, z = 34.224}, -- sandy
    {x = 1690.7, y = 2591.9, z = 45.8}, -- bolingbroke prison
    {x = 308.1, y = -1434.7,  z = 29.9}, -- davis
    {x = 360.3, y = -548.9, z = 28.8} -- pillbox hill
}
local healStations = {
    {x = 307.63, y = -593.948, z = 42.2919}, -- LS
    {x = -380.562, y = 6119.039, z = 30.631}, -- PALETO FD
    {x = -247.546, y = 6331.111, z = 31.426}, -- PALETO HOSPITAL
    {x = 308.1, y = -1434.7,  z = 29.9}, -- davis
    {x = 360.3, y = -548.9, z = 28.8} -- pillbox hill
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
    Wait(1000)
    SetEntityCoords(lPed, hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1) -- tp to hospital
    while not HasCollisionLoadedAroundEntity(lPed) do
        Citizen.Wait(100)
        SetEntityCoords(lPed, hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 1, 0, 0, 1) -- tp to hospital
    end
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

RegisterNetEvent("EMS:inspectNearestPed")
AddEventHandler("EMS:inspectNearestPed", function(responder_id)
  local mycoords = GetEntityCoords(GetPlayerPed(-1))
  for ped in exports.globals:EnumeratePeds() do
    if IsPedDeadOrDying(ped) then
      local pedcoords = GetEntityCoords(ped)
      if Vdist(pedcoords.x, pedcoords.y, pedcoords.z, mycoords.x, mycoords.y, mycoords.z) < 5.0 then
        local death_cause = GetPedCauseOfDeath(ped)
        local damage_type = GetWeaponDamageType(death_cause)
        local killer = GetPedKiller(ped)
        local entity_type = GetEntityType(killer)
        TriggerServerEvent("EMS:notifyResponderOfInjuries", responder_id, entity_type, damage_type, death_cause)
        return
      end
    end
  end
  exports.globals:notify("No injured person found!")
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        for i = 1, #healStations do
            DrawMarker(27, healStations[i].x, healStations[i].y, healStations[i].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
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

local DiffTrigger = 0.25
local MinSpeed    = 13.0 --THIS IS IN m/s
local speedBuffer  = {}
local velBuffer    = {}
local wasInCar     = false
beltOn = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        collectgarbage()
    end
end) -- Fix RAM leaks by collecting garbage


Citizen.CreateThread(function()
    local alarmtimes = 0
    while true do
        Citizen.Wait(3000)
        local ped = GetPlayerPed(-1)
        if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsBeltVehicle(GetVehiclePedIsIn(ped, false)) and not IsEntityDead(ped) and GetEntitySpeed(GetVehiclePedIsIn(ped, false))*2.236936 >= 15 and alarmtimes < 3 and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == GetPlayerPed(-1) and not beltOn then
            alarmtimes = alarmtimes + 1
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'seatbelt-alarm', 0.1)
            Citizen.Wait(1000)
        elseif (not IsPedInAnyVehicle(ped, false) or beltOn) then
            alarmtimes = 0
        end
    end
end)

IsCar = function(veh)
            local vc = GetVehicleClass(veh)
            return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end

Fwv = function (entity)
            local hr = GetEntityHeading(entity) + 90.0
            if hr < 0.0 then hr = 360.0 + hr end
            hr = hr * 0.0174533
            return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while true do

        local ped = PlayerPedId()
        local car = GetVehiclePedIsIn(ped)

        if car ~= 0 and (wasInCar or IsCar(car)) then

            wasInCar = true

            if beltOn then DisableControlAction(0, 75, true) end

            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)

            if speedBuffer[2] ~= nil
               and GetEntitySpeedVector(car, true).y > 1.0
               and speedBuffer[1] > 5.0
               and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * DiffTrigger)
               and GetPedInVehicleSeat(car, 1) ~= GetPlayerPed(-1)
               and GetPedInVehicleSeat(car, 2) ~= GetPlayerPed(-1)
               and IsBeltVehicle(car) then
               local damagedEngine = GetVehicleEngineHealth(car)-speedBuffer[1]*40
               if damagedEngine < 0 then damagedEngine = -4000.0 end
               if GetPedInVehicleSeat(car, -1) == ped then
                SetVehicleEngineHealth(car, damagedEngine)
                if math.random() > 0.7 then
                    local tyreBursted = math.random(1, 2)
                    SetVehicleTyreBurst(car, tyreBursted, true, 1000.0)
                end
               end
               if not beltOn and speedBuffer[1] > MinSpeed then
                    ShakeStrength = GetEntitySpeed(car)/15

                    local co = GetEntityCoords(ped)
                    local fw = Fwv(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                    SetEntityHealth(ped, (GetEntityHealth(ped)-50))
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeStrength)
                    SetPedToRagdoll(ped, 100000, 1000, 000, 0, 0, 0)
                end

            end

            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)

            if IsControlJustReleased(0, 311) and GetLastInputMethod(0) and (GetPedInVehicleSeat(car, -1) == ped or GetPedInVehicleSeat(car, 0) == ped) then
                beltOn = not beltOn
                TriggerServerEvent('hud:getBelt', beltOn)
                TriggerServerEvent('display:shareDisplay', 'clicks seatbelt', 2, 470, 10, 3000)
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'seatbelt-click', 0.2)
                print('Belt toggle: '..tostring(beltOn))
            end

        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local roll = GetEntityRoll(vehicle)
        if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
            DisableControlAction(2,59,true) -- Disable left/right
            DisableControlAction(2,60,true) -- Disable up/down
        end
    end
end)

RegisterNetEvent('usa:repairVeh')
AddEventHandler('usa:repairVeh', function(target_vehicle)
    if not target_vehicle then target_vehicle = getVehicleInFrontOfUser() end
    print(target_vehicle)
    local dict = "mini@repair"
    local playerPed = PlayerPedId()
    if target_vehicle ~= 0 then
        if GetVehicleEngineHealth(target_vehicle) < 850.0 or IsAnyVehicleTireBursted(target_vehicle) then
            TriggerServerEvent('usa:removeRepairKit')
            SetVehicleDoorOpen(target_vehicle, 4, false, false)
            local beginTime = GetGameTimer()
            while GetGameTimer() - beginTime < 16000 do
                Citizen.Wait(1)
                DrawTimer(beginTime, 16000, 1.42, 1.475, 'REPAIRING')
                if not IsEntityPlayingAnim(playerPed, dict, 'fixing_a_player', 3) then
                    RequestAnimDict(dict)
                    TaskPlayAnim(playerPed, dict, "fixing_a_player", 8.0, 1.0, -1, 15, 1.0, 0, 0, 0)
                end
            end
            SetVehicleUndriveable(target_vehicle, false)
            SetVehicleEngineHealth(target_vehicle, 800.0)
            FixAllTires(target_vehicle)
            ClearPedTasks(playerPed)
            Citizen.Wait(500)
            SetVehicleDoorShut(target_vehicle, 4, false)
        else
            exports.globals:notify("Repairs not needed!")
        end
    else
        exports.globals:notify("Vehicle not found!")
    end
end)

function IsBeltVehicle(vehicle)
    if GetVehicleClass(vehicle) ~= 8
    and GetVehicleClass(vehicle) ~= 13
    and GetVehicleClass(vehicle) ~= 14
    and GetVehicleClass(vehicle) ~= 15
    and GetVehicleClass(vehicle) ~= 16
    and GetVehicleClass(vehicle) ~= 19
    and GetVehicleClass(vehicle) ~= 21
     then
        return true
    else
        return false
    end
end

function IsAnyVehicleTireBursted(veh)
    if IsVehicleTyreBurst(veh, 0, false) then return true end
    if IsVehicleTyreBurst(veh, 1, false) then return true end
    if IsVehicleTyreBurst(veh, 2, false) then return true end
    if IsVehicleTyreBurst(veh, 3, false) then return true end
    if IsVehicleTyreBurst(veh, 4, false) then return true end
    return false
end

function FixAllTires(veh)
    SetVehicleTyreFixed(veh, 0)
    SetVehicleTyreFixed(veh, 1)
    SetVehicleTyreFixed(veh, 2)
    SetVehicleTyreFixed(veh, 3)
    SetVehicleTyreFixed(veh, 4)
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

function getVehicleInFrontOfUser()
    local playerped = GetPlayerPed(-1)
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

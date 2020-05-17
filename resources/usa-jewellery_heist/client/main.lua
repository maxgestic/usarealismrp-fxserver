-- STAGE 1 - Thermite the electronic locks to gain access to the doors.
local thermite_loc = {-607.29, -245.78, 50.24}
local thermite_success = false
Citizen.CreateThread(function()
    while true do
        local x,y,z = table.unpack(thermite_loc)
        if nearMarker(x,y,z) and not IsEntityDead(GetPlayerPed(-1)) and  not thermite_success then
            DrawText3D(x,y,z,  5, '[E] - Rig Thermite')
            if IsControlJustPressed(0, 38) and not IsEntityDead(GetPlayerPed(-1)) then
                TriggerServerEvent("jewelleryheist::beginRobbery");
                TriggerServerEvent('jewelleryheist:doesUserHaveThermiteToUse')
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent('jewelleryheist:doesUserHaveThermiteToUse')
AddEventHandler('jewelleryheist:doesUserHaveThermiteToUse', function(hasProduct) -- action of selling to the ped spawned
    if hasProduct then
       TriggerEvent('doormanager:thermiteDoor')
    else
        TriggerEvent('usa:notify', 'You do not have any ~y~Thermite~s~!')
    end
end)

-- STAGE 2 - ROB THIS MOFUGGA

local smash_n_grab = {
    {x = -628.0, y = -233.83, z = 38.06, robbed = false},  {x = -626.86, y = -233.0, z = 38.06, robbed = false},  {x = -624.66, y = -230.9, z = 38.06, robbed = false}, {x = -624.12, y = -228.11, z = 38.06, robbed = false}, {x = -624.88, y = -227.88, z = 38.06, robbed = false},
    {x = -623.84, y = -227.17, z = 38.06, robbed = false}, {x = -620.47, y = -226.66, z = 38.06, robbed = false}, {x = -619.66, y = -227.83, z = 38.06, robbed = false}, {x = -618.31, y = -229.46, z = 38.06, robbed = false}, {x = -617.68, y = -230.49, z = 38.06, robbed = false},
    {x = -619.51, y = -230.55, z = 38.06, robbed = false}, {x = -619.19, y = -233.72, z = 38.06, robbed = false}, {x = -620.28, y = -234.39, z = 38.06, robbed = false}, {x = -620.06, y = -233.37, z = 38.06, robbed = false}, {x = -623.05, y = -233.12, z = 38.06, robbed = false},
    {x = -625.63, y = -237.73, z = 38.06, robbed = false}, {x = -626.65, y = -238.41, z = 38.06, robbed = false}, {x = -625.9, y = -234.73, z = 38.06, robbed = false}, {x = -626.83, y = -235.45, z = 3.06}, {x = -621.14, y = -228.32, z = 38.06, robbed = false},
    {x = -626.92, y = -235.47, z = 38.06, robbed = false},
}

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for k in pairs(smash_n_grab) do
            local pid = PlayerPedId()
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, smash_n_grab[k].x, smash_n_grab[k].y, smash_n_grab[k].z)
            if dist < 0.5 and not smash_n_grab[k].robbed then
                if IsControlJustPressed(1,51) then
                    local beginTime = GetGameTimer()
                    RequestAnimDict("missheist_jewel@first_person")
                    while (not HasAnimDictLoaded("missheist_jewel@first_person")) do Citizen.Wait(0) end
                    while GetGameTimer() - beginTime < 6 * 1000 do
                        if not IsEntityPlayingAnim(pid, "missheist_jewel@first_person", "smash_case_e", 3) then
                            TaskPlayAnim(pid, "missheist_jewel@first_person", "smash_case_e", 8.0, 1.0, -1, 11, 1.0, false, false, false)
                        end
                        DrawTimer(beginTime, 6 * 1000, 1.42, 1.475, 'Stealing Jewelry')
                        Citizen.Wait(1)
                    end
                    ClearPedTasks(pid)
                    TriggerServerEvent('jewelleryheist:stolengoods', source)
                    smash_n_grab[k].robbed = true
                end
            end
        end
    end
end)

-- Stage 3 if not caught, sell the stolen goods!
local purchaser = 'g_m_y_mexgoon_01'
local purchase_location = {334.39, -2058.19, 20.94, 325.57}

local NPCHandle = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z = table.unpack(purchase_location)
        if Vdist(playerCoords, x, y, z) < 40 then
            if not NPCHandle then
                RequestModel(GetHashKey(purchaser))
                while not HasModelLoaded(purchaser) do
                    RequestModel(purchaser)
                    Wait(1)
                end
                NPCHandle = CreatePed(0, purchaser, x, y, z, 0.1, false, false) -- need to add distance culling
                SetEntityCanBeDamaged(NPCHandle,false)
                SetPedCanRagdollFromPlayerImpact(NPCHandle,false)
                SetBlockingOfNonTemporaryEvents(NPCHandle,true)
                SetPedFleeAttributes(NPCHandle,0,0)
                SetPedCombatAttributes(NPCHandle,17,1)
            end
        else
            if NPCHandle then
                DeletePed(NPCHandle)
                NPCHandle = nil
            end
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local x,y,z = table.unpack(purchase_location)
        if nearMarker(x,y,z) then
            DrawText3D(x,y,z,  5, '[E] - Sell Stolen Goods')
            promptSale(location)
        end
        Wait(0)
    end
end)

function promptSale()
    if IsControlJustPressed(0, 38) then
        TriggerServerEvent('jewelleryheist:doesUserHaveGoodsToSell')
    end
end

RegisterNetEvent('jewelleryheist:doesUserHaveGoodsToSell')
AddEventHandler('jewelleryheist:doesUserHaveGoodsToSell', function(hasProduct) -- action of selling to the ped spawned
    if hasProduct then
        local beginTime = GetGameTimer()
        while GetGameTimer() - beginTime < 5 * 1000 do
            DrawTimer(beginTime, 5 * 1000, 1.42, 1.475, 'Selling Jewelry')
            DisableControlAction(0, 244, true) -- 244 = M key (interaction menu / inventory)
            DisableControlAction(0, 38, true) -- prevent spam clicking
            Citizen.Wait(1)
        end
        TriggerServerEvent("jewelleryheist:sellstolengoods", source)
    else
        TriggerEvent('usa:notify', 'You do not have any ~y~Stolen Goods~s~!')
    end
end)

-- EXTRA HELPERS
function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 200, true)
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 1 and zDist < 1)
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false,truee)
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
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
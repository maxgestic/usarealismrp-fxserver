local currentlyAdmitted = false
local currentBed = nil
local hospitalCoords = vector3(354.032, -589.411, 42.415)

RegisterNetEvent("ems:hospitalize")
AddEventHandler("ems:hospitalize", function(bed, index)
    local playerPed = PlayerPedId()
    if index then
        TriggerServerEvent('ems:occupyBed', index)
    end
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    RequestCollisionAtCoord(hospitalCoords)
    Citizen.Wait(1000)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.3)
    SetEntityCoords(playerPed, hospitalCoords) -- tp to hospital
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Citizen.Wait(100)
        SetEntityCoords(playerPed, hospitalCoords) -- tp to hospital
    end
    Citizen.Wait(2000)
    TriggerEvent("crim:untieHands", GetPlayerServerId(PlayerId()))
    TriggerEvent("crim:blindfold", false, true)
    TriggerEvent('injuries:checkin')
    currentlyAdmitted = true
    if bed then
        currentBed = bed
        bx, by, bz = table.unpack(currentBed.coords)
        ActivateBed(bx, by, bz, currentBed.model)
    else
        DoScreenFadeIn(1000)
    end
    Citizen.Wait(20000)
    currentlyAdmitted = false
    TriggerEvent('usa:showHelp', 'You have been treated.')
end)

RegisterNetEvent('ems:admitMe')
AddEventHandler('ems:admitMe', function(bed, reasonForAdmission)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    if Vdist(playerCoords, hospitalCoords) < 50 then
        TriggerEvent('ems:hospitalize', bed)
        TriggerEvent("chatMessage", '^3^*[HOSPITAL] ^r^7You have been admitted to the hospital. (' .. reasonForAdmission .. ')')
    end
end)

RegisterNetEvent('ems:getNearestBedIndex')
AddEventHandler('ems:getNearestBedIndex', function(hospitalBeds)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for i = 1, #hospitalBeds do
        local x, y, z = table.unpack(hospitalBeds[i].objCoords)
        if Vdist(playerCoords, x, y, z) < 1.2 and not currentBed and not hospitalBeds[i].occupied then
            TriggerServerEvent('ems:occupyBed', i)
            currentBed = hospitalBeds[i]
            ActivateBed(x, y, z, hospitalBeds[i].objModel)
            -- enter bed
        end
    end
end)

function ActivateBed(x, y, z, model)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local bedObject = GetClosestObjectOfType(x, y, z, 1.0, model, false, false, false)
        local x, y, z = table.unpack(GetEntityCoords(bedObject))
        local rx, ry, rz = table.unpack(GetEntityRotation(bedObject))
        SetEntityCoords(playerPed, x, y, z + 0.3)
        local dict = 'anim@mp_bedmid@left_var_04'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
        DoScreenFadeIn(1000)
        --TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_bedmid@left_var_02' , 'f_sleep_l_loop_bighouse' ,8.0, 1.0, -1, 1, 1.0, false, false, false )
        while currentBed do
            Citizen.Wait(1)
            if not currentlyAdmitted then
                DrawTxt(0.965, 1.455, 1.0, 1.0, 0.40, 'Press ~g~E~s~ to leave bed', 255, 255, 255, 255)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('ems:resetBed')
                    FreezeEntityPosition(playerPed, false)
                    TaskPlayAnim(playerPed, dict, 'f_getout_l_bighouse', 8.0, -1, -1, 1, 1.0, false, false, false)
                    Citizen.Wait(2000)
                    SetEntityCollision(bedObject, false)
                    Citizen.Wait(2500)
                    SetEntityCollision(bedObject, true)
                    ClearPedTasks(playerPed)
                    currentBed = nil
                    return
                end
            end
            TaskPlayAnimAdvanced(playerPed, dict, 'f_sleep_l_loop_bighouse', x, y+0.05, z+0.8, rx, ry, rz-180.0, 1.0, 1.0, -1, 1, 0.0, false, false)
            FreezeEntityPosition(playerPed, true)
        end
    end)
end

  DoScreenFadeIn(1000)
function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
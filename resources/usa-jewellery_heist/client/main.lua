-- STAGE 1 - Thermite the electronic locks to gain access to the doors.
local thermite_loc = {-607.29, -245.78, 50.24}
local thermite_success = false
local doorList = {
    [1] = { ["objName"] = "p_jewel_door_l", ["x"]= -631.91, ["y"]= -237.19,["z"]= 38.06,["locked"]= true},
}

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for i = 1, #doorList do
            local playerCoords = GetEntityCoords( GetPlayerPed(-1) )
            local closeDoor = GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 1.0, GetHashKey(doorList[i]["objName"]), false, false, false)
            local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)

            if(playerDistance < 1) then
                if IsControlJustPressed(1,51) then
                    if doorList[i]["locked"] == true then
                        TriggerServerEvent("doormanager:s_openDoor", i)
                    else
                        TriggerServerEvent("doormanager:s_closeDoor", i)
                    end
                end
            else
                FreezeEntityPosition(closeDoor, doorList[i]["locked"])
            end
        end
    end
end)

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
        local success_thermite = math.random()
        if success_thermite < 0.6 then
            StartEntityFire(GetPlayerPed(-1))
        else
            notify('success!')
            local mycoords = GetEntityCoords(GetPlayerPed(-1), false)
            local x, y, z = table.unpack(mycoords)
            local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
            local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
            TriggerServerEvent("911:JewelleryRobbery", x, y, z, lastStreetNAME)
            for i = 1, #doorList do
                doorList[i]['locked'] = false
                FreezeEntityPosition(unlockDoor, doorList[i]['locked'])
                thermite_success = true
                Wait(3000)
                TriggerEvent('usa:notify', 'Once you have collected the goods head to Jamestown and locate the buyer!')
            end
        end
        TriggerServerEvent("jewelleryheist:thermite", source)
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
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, smash_n_grab[k].x, smash_n_grab[k].y, smash_n_grab[k].z)
            if dist < 0.5 and not smash_n_grab[k].robbed then
                if IsControlJustPressed(1,51) then
                    pleaseHold('Stealing Jewellery', 6000, 'missheist_jewel@first_person', 'smash_case_e')
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


Citizen.CreateThread(function()
    spawnPed(purchaser, purchase_location)
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

function spawnPed(ped, location)
    RequestModel(GetHashKey(ped))
    while not HasModelLoaded(ped) do
        RequestModel(ped)
        Citizen.Wait(1)
    end
    local x,y,z = table.unpack(location)
    local purchasee = CreatePed(0, ped, x, y, z, 0.1, true, false)
    SetEntityAsMissionEntity(purchasee, true, true)
end

function promptSale()
    if IsControlJustPressed(0, 38) then
        TriggerServerEvent('jewelleryheist:doesUserHaveGoodsToSell')
    end
end

RegisterNetEvent('jewelleryheist:doesUserHaveGoodsToSell')
AddEventHandler('jewelleryheist:doesUserHaveGoodsToSell', function(hasProduct) -- action of selling to the ped spawned
    if hasProduct then
        pleaseHold('Selling Stolen Goods', 10000, 'missheist_agency2aig_13', 'pickup_briefcase_upperbody')
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

function pleaseHold(label, time, animation, anim)
    TriggerEvent("mythic_progressbar:client:progress", {
        name = "unique_action_name",
        duration = time,
        label = label,
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = animation,
            anim = anim,
            flags = 20,
        },
        prop = {
            model = "prop_paper_bag_small",
        }
    }, function(status)
        if not status then
            -- Do Something If Event Wasn't Cancelled
        end
    end)
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
local on = false
local alreadyAskedForGaugeData = false
local lastFetchedMaxNitroLevel = nil
local NITRO_KEY = 21 -- shift

function toggleGuageDisplay(enable)
    on = enable
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "enableui",
        enable = on
    })
end

Citizen.CreateThread(function()
    while true do
        local me = PlayerPedId()
        local veh = GetVehiclePedIsIn(me)
        
        if not alreadyAskedForGaugeData and veh and veh ~= 0 then
            local vehPlate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("nitro-gauge:fetchGuageData", vehPlate)
            alreadyAskedForGaugeData = true
        elseif alreadyAskedForGaugeData and (not veh or veh == 0) then
            alreadyAskedForGaugeData = false
            if on then
                toggleGuageDisplay(false)
            end
        end

        Wait(350)
    end
end)

Citizen.CreateThread(function()
    while true do
        
        if on and IsControlPressed(0, NITRO_KEY) then
            local me = PlayerPedId()
            local veh = GetVehiclePedIsIn(me)
            SendNUIMessage({
                type = "setGaugeData",
                current = GetNitroFuelLevel(veh),
                max = lastFetchedMaxNitroLevel
            })
        end

        Wait(200)
    end
end)

RegisterNetEvent("nitro-gauge:setGaugeData")
AddEventHandler("nitro-gauge:setGaugeData", function(current, max)
    local me = PlayerPedId()
    local veh = GetVehiclePedIsIn(me)
    if current ~= -1 then
        if not on then
            toggleGuageDisplay(true)
        end
        SendNUIMessage({
            type = "setGaugeData",
            current = current,
            max = max
        })
        lastFetchedMaxNitroLevel = max
        InitNitroFuel(veh)
        SetNitroFuelLevel(veh, current)
    end
end)
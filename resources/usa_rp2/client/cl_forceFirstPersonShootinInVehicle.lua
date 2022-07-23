local LEFT_CLICK = 24

local modeBeforeChange = nil

function forceFirstPerson(ped)
    if modeBeforeChange == nil then
        modeBeforeChange = GetFollowVehicleCamViewMode()
        SetFollowVehicleCamViewMode(4)
        if IsPedOnAnyBike(ped) then
            SetCamViewModeForContext(2, 4)
        end
    end
end

function undoFirstPerson(ped)
    SetFollowVehicleCamViewMode(modeBeforeChange)
    if IsPedOnAnyBike(ped) then
        SetCamViewModeForContext(2, modeBeforeChange)
    end
    modeBeforeChange = nil
end

Citizen.CreateThread(function()
    local lastPedWeSetConfigFor = 0
    local WEAPON_UNARMED_HASH = `WEAPON_UNARMED`
    while true do
        local me = PlayerPedId()
        if me ~= lastPedWeSetConfigFor then
            SetPedConfigFlag(me, 184, true)
            lastPedWeSetConfigFor = me
        end
        if IsPedInAnyVehicle(me) then
            local selectedPedWeapon = GetSelectedPedWeapon(me)
            if IsPedDoingDriveby(me) then
                forceFirstPerson(me)
            elseif IsControlPressed(0, LEFT_CLICK) then
                local veh = GetVehiclePedIsIn(me)
                if me ~= GetPedInVehicleSeat(veh, -1) then -- not in driver seat
                    forceFirstPerson(me)
                end
            elseif modeBeforeChange ~= nil then
                undoFirstPerson(me)
            end
        end
        Wait(1)
    end
end)
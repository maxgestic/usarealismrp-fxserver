local LEFT_CLICK = 24

local modeBeforeChange = nil

function forceFirstPerson()
    if modeBeforeChange == nil then
        modeBeforeChange = GetFollowVehicleCamViewMode()
        SetFollowVehicleCamViewMode(4)
    end
end

function undoFirstPerson()
    SetFollowVehicleCamViewMode(modeBeforeChange)
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
            if IsPlayerFreeAiming(PlayerId()) and selectedPedWeapon ~= WEAPON_UNARMED_HASH then
                forceFirstPerson()
            elseif IsControlPressed(0, LEFT_CLICK) and selectedPedWeapon ~= WEAPON_UNARMED_HASH then
                local veh = GetVehiclePedIsIn(me)
                if me ~= GetPedInVehicleSeat(veh, -1) then -- not in driver seat
                    forceFirstPerson()
                end
            elseif modeBeforeChange ~= nil then
                undoFirstPerson()
            end
        end
        Wait(1)
    end
end)
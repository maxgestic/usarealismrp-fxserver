RegisterNUICallback('escape', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
end)

RegisterNUICallback('showPhone', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    TriggerEvent("phone:openPhone")
end)

Citizen.CreateThread(function()
    while true do
        if menuEnabled then
            DisableControlAction(29, 241, menuEnabled) -- scroll up
            DisableControlAction(29, 242, menuEnabled) -- scroll down
            DisableControlAction(0, 1, menuEnabled) -- LookLeftRight
            DisableControlAction(0, 2, menuEnabled) -- LookUpDown
            DisableControlAction(0, 142, menuEnabled) -- MeleeAttackAlternate
            DisableControlAction(0, 106, menuEnabled) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)

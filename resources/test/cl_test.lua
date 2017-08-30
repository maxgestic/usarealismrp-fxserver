RegisterNUICallback('escape', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
end)

RegisterNUICallback('showPhone', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    TriggerServerEvent("interaction:checkForPhone")
end)

RegisterNUICallback('loadInventory', function(data, cb)
    Citizen.Trace("inventory loading...")
    TriggerServerEvent("interaction:loadInventoryForInteraction")
end)

RegisterNUICallback('setVoipLevel', function(data, cb)
    TriggerEvent("test:escapeFromCSharp")
    --Citizen.Trace("setting voice level = " .. data.level)
    local YELL, NORMAL, WHISPER = 0,1,2
    local selected = data.level
    if selected == YELL then
        TriggerEvent("voip", "yell")
    elseif selected == NORMAL then
        TriggerEvent("voip","default")
    elseif selected == WHISPER then
        TriggerEvent("voip","whisper")
    end
end)

RegisterNetEvent("interaction:playerHadPhone")
AddEventHandler("interaction:playerHadPhone", function()
    TriggerEvent("phone:openPhone")
end)

RegisterNetEvent("interaction:inventoryLoaded")
AddEventHandler("interaction:inventoryLoaded", function(inventory, weapons, licenses)
    Citizen.Trace("inventory loaded...")
    SendNUIMessage({
        type = "inventoryLoaded",
        inventory = inventory,
        weapons = weapons,
        licenses = licenses
    })
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

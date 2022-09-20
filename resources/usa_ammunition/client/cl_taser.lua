local taserModel = GetHashKey("WEAPON_STUNGUN")

local taserCartridgeUsed = true

RegisterNetEvent("usa-taser:enable")
AddEventHandler("usa-taser:enable", function(status)
    taserCartridgeUsed = not status
    local me = PlayerPedId()
    SetPlayerCanDoDriveBy(me, status)
    DisablePlayerFiring(me, not status)
    if status then
        SetAmmoInClip(me, taserModel, 1)
    else
        SetAmmoInClip(me, taserModel, 0)
    end
end)

Citizen.CreateThread(function()

    while true do

        local me = PlayerPedId()

        if IsPedShooting(me) then
            if GetSelectedPedWeapon(me) == taserModel then
                taserCartridgeUsed = true
                SetAmmoInClip(me, taserModel, 0)
            end
        end

        if taserCartridgeUsed then
            if GetSelectedPedWeapon(me) == taserModel then
                SetPlayerCanDoDriveBy(me, false)
                DisablePlayerFiring(me, true)
            end
        end

        Wait(1)
    end
end)
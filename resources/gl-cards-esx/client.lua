local DEFAULT_CARD_DRAW_TIME = 15000

RegisterNetEvent('gl-cards:drawNui')
AddEventHandler('gl-cards:drawNui',function(cardSrc)
    SetDisplayCard(not display, cardSrc)
    local start = GetGameTimer()
    while GetGameTimer() - start < DEFAULT_CARD_DRAW_TIME do
        Wait(1)
    end
    SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("main", function(data)
    SetDisplay(false)
    return
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool, cardSrc)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        cardSrc = cardSrc
    })
end

function SetDisplayCard(bool, cardSrc)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "display",
        status = bool,
        cardSrc = cardSrc
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
            control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

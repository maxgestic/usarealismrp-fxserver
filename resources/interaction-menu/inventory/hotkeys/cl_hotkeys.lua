local KEYS = nil

local currentSelectedSlot = nil

local SCROLL_DISABLED = true

local HOTKEYS_ENABLED = true

RegisterNetEvent("hotkeys:enable")
AddEventHandler("hotkeys:enable", function(value)
    HOTKEYS_ENABLED = value
end)

RegisterNetEvent("hotkeys:setCurrentSlotPassive")
AddEventHandler("hotkeys:setCurrentSlotPassive", function(slot)
    if type(slot) == "number" and slot >= 1 and slot <= 4 or type(slot) == "nil" then
        currentSelectedSlot = slot
    end
end)

-- async thread to load key table from globals resource --
Citizen.CreateThread(function()
    while not KEYS do
        KEYS = exports.globals:GetKeys()
        Wait(1000)
    end
end)

-- Completely disable default GTA 5 weapon wheel --
Citizen.CreateThread(function()
    while true do
        if KEYS then
            DisableControlAction(24, KEYS.TAB, true)
        end
        Wait(1)
    end
end)

-- Handle 1, 2, 3, 4, TAB, SCROLL WHEEL UP/DOWN hot keys --
Citizen.CreateThread(function()
    while true do
        if KEYS then
            if HOTKEYS_ENABLED then
                if GetLastInputMethod(0) and not IsPlayerFreeAiming(PlayerId()) then -- keyboard only / not aiming
                    -- cycle through slots keys --
                    if IsDisabledControlJustPressed(24, KEYS.TAB) then
                        local WEAPON_UNARMED = -1569615261
                        GiveWeaponToPed(PlayerPedId(), WEAPON_UNARMED, 1000, false, true)
                        currentSelectedSlot = nil
                        exports["usa_holster"]:handleHolsterAnim()
                    elseif not SCROLL_DISABLED and IsControlJustPressed(0, KEYS.SCROLL_DOWN) then
                        if currentSelectedSlot == nil then
                            currentSelectedSlot = 1
                        else
                            if currentSelectedSlot + 1 > 4 then
                                currentSelectedSlot = 1
                            else
                                currentSelectedSlot = currentSelectedSlot + 1
                            end
                        end
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    elseif not SCROLL_DISABLED and IsControlJustPressed(0, KEYS.SCROLL_UP) then
                        if currentSelectedSlot == nil  then
                            currentSelectedSlot = 4
                        else
                            if currentSelectedSlot - 1 <= 0 then
                                currentSelectedSlot = 4
                            else
                                currentSelectedSlot = currentSelectedSlot - 1
                            end
                        end
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    -- direct slot hotkey --
                    elseif IsDisabledControlJustPressed(24, KEYS.ONE) then
                        currentSelectedSlot = 1
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    elseif IsDisabledControlJustPressed(24, KEYS.TWO) then
                        currentSelectedSlot = 2
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    elseif IsDisabledControlJustPressed(24, KEYS.THREE) then
                        currentSelectedSlot = 3
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    elseif IsDisabledControlJustPressed(24, KEYS.FOUR) then
                        currentSelectedSlot = 4
                        TriggerServerEvent("interaction:hotkeyPressed", currentSelectedSlot)
                    end
                end
            end
        end
        Wait(1)
    end
end)
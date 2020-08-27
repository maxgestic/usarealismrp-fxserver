local KEYS = nil

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

-- Handle 1, 2, 3, TAB, SCROLL WHEEL UP/DOWN hot keys --
Citizen.CreateThread(function()
    while true do
        if KEYS then
            if GetLastInputMethod(0) then -- keyboard only
                -- cycle through slots keys --
                if IsDisabledControlJustPressed(24, KEYS.TAB) then
                    --local WEAPON_UNARMED = 0xA2719263
                    --GiveWeaponToPed(PlayerPedId(), WEAPON_UNARMED, 0, false, true)
                elseif IsControlJustPressed(0, KEYS.SCROLL_UP) then
                    print("scroll up detected")
                elseif IsControlJustPressed(0, KEYS.SCROLL_DOWN) then
                    print("scroll down detected")
                -- direct slot hotkey --
                elseif IsDisabledControlJustPressed(24, KEYS.ONE) then
                    TriggerServerEvent("interaction:hotkeyPressed", 1)
                elseif IsDisabledControlJustPressed(24, KEYS.TWO) then
                    TriggerServerEvent("interaction:hotkeyPressed", 2)
                elseif IsDisabledControlJustPressed(24, KEYS.THREE) then
                    TriggerServerEvent("interaction:hotkeyPressed", 3)
                end
            end
        end

        Wait(1)
    end
end)
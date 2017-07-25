local MAX_PLAYER_WEAPON_COUNT = 3
local confiscatedWeapons = {}

RegisterNetEvent("police:confiscateWeapons")
AddEventHandler("police:confiscateWeapons", function()
        -- confiscate player's weapons
        Citizen.Trace("inside of police:confiscateBestWeapon")
        local playerPed = GetPlayerPed(-1)
        for i = 1, MAX_PLAYER_WEAPON_COUNT do
            print("i = " .. i)
            Citizen.Trace("IsPedArmed? = " .. tostring(IsPedArmed(playerPed,7)))
            --if IsPedArmed(playerPed, 7) then
                local bestPedWeapon = GetBestPedWeapon(playerPed, false)
                Citizen.Trace("typeof bestPedWeapon = " .. type(bestPedWeapon))
                Citizen.Trace("removing and storing best ped weapon = " .. bestPedWeapon)
                table.insert(confiscatedWeapons, bestPedWeapon)
                Citizen.Trace("# of confiscatedWeapons = " .. #confiscatedWeapons)
                RemoveWeaponFromPed(playerPed, bestPedWeapon)
            --end
        end
end)

RegisterNetEvent("police:rearm")
AddEventHandler("police:rearm", function()
    local playerPed = GetPlayerPed(-1)
    -- re arm player
    for i = 1, #confiscatedWeapons do
        local weapon = confiscatedWeapons[i]
        print("giving weapon to player: " .. weapon)
        GiveWeaponToPed(playerPed, weapon, 60, false, true)
    end
end)

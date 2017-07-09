local civilianSpawns = {
    --{x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
    --{x = 95.2552, y = -1310.8, z = 29.2921} -- near strip club
    {x = 10.6334, y = -718.769, z = 44.2174}
}

AddEventHandler('es:playerLoaded', function(source, user)
    local money = user.getMoney()
    local bank = user.getBank()
    print("Player " .. GetPlayerName(source) .. " has loaded.")
    print("Money:" .. money)
    user.displayMoney(money)
    user.displayBank(bank)
    TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    print("inside of usa_rp:spawnPlayer!")
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local model = user.getModel()
        local job = user.getJob()
        local weapons = {}
        local spawn = {x = 0, y = 0, z = 0}
        if job == "civ" then
            spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
            weapons = user.getWeapons()
            if not weapons then
                weapons = {}
            end
        elseif job == "sheriff" then
            spawn.x = 451.255
            spawn.y = -992.41
            spawn.z = 30.6896
            weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        elseif job == "ems" then
            -- davis fire station
            spawn.x =  207.106
            spawn.y = -1641.45
            spawn.z = 29.8
            weapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        else
            spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
            weapons = {}
        end
        if weapons then
            print("#weapons = " .. #weapons)
        else
            print("user has no weapons")
        end
        print("spawning with player model = " .. model)
        TriggerClientEvent("usa_rp:spawn", userSource, model, job, spawn, weapons)
    end)
end)

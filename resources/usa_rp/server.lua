local civilianSpawns = {
   {x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
   {x = 95.2552, y = -1310.8, z = 29.2921} -- near strip club
}

AddEventHandler('es:playerLoaded', function(source, user)
    print("player loaded!")
    local money = user.get("money")
    user.displayMoney(money)
    TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    print("inside of usa_rp:spawnPlayer!")
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local model = user.get("model")
        local job = user.get("job")
        local weapons = {}
        local spawn = {x = 0, y = 0, z = 0}
        if job == "civ" then
            spawn.x = 391.611
            spawn.y = -948.984
            spawn.z = 29.3978
            weapons = user.get("weapons")
        elseif job == "sheriff" then
            spawn.x = 451.255
            spawn.y = -992.41
            spawn.z = 30.6896
            weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        elseif job == "ems" then
            spawn.x =  360.31
            spawn.y = -590.445
            spawn.z = 28.6563
            weapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        end
        print("#weapons = " .. #weapons)
        TriggerClientEvent("usa_rp:spawn", source, model, job, spawn, weapons)
    end)
end)

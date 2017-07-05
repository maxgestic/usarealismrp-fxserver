local civilianSpawns = {
   {x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
   {x = 95.2552, y = -1310.8, z = 29.2921} -- near strip club
}

AddEventHandler('es:playerLoaded', function(source, user)
    print("player loaded with getMoney = " .. user.getMoney() .. "!")
    print("player loaded with getBank = " .. user.getBank() .. "!")
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            print("player loaded with result.money = " .. result.money .. "!")
            print("player loaded with result.bank = " .. result.bank .. "!")
            user.displayMoney(result.money)
            user.displayBank(result.bank)
            TriggerClientEvent('usa_rp:playerLoaded', userSource)
        end)
    end)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            print("docid = " .. docid)
            local model = result.model
            if not model then
                print("not model!")
                model = "a_m_y_skater_01"
            end
            local job = result.job
            if not job then
                print("not job!")
                job = "civ"
            end
            local weapons = {}
            print("inside of usa_rp:spawnPlayer!")
            TriggerEvent('es:getPlayerFromId', userSource, function(user)
                local spawn = {x = 0, y = 0, z = 0}
                if job == "civ" then
                    spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
                    weapons = result.weapons
                    if not weapons then
                        weapons = {}
                    end
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
                else
                    spawn = civilianSpawns[math.random(1,#civilianSpawns)] -- choose random spawn if civilian
                    weapons = {}
                end
                if weapons then
                    print("#weapons = " .. #weapons)
                else
                    print("user has no weapons")
                end
                print("calling usa_rp:spawn with model = " .. model)
                print("job = " .. job)
                print("spawn.x = " .. spawn.x)
                TriggerClientEvent("usa_rp:spawn", userSource, model, job, spawn, weapons)
            end)
        end)
    end)
end)

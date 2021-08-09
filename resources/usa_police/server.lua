local DB_NAME = "sasp-outfits"

exports.globals:PerformDBCheck("usa_police", DB_NAME)

local JOB_NAME = "sheriff"

local armoryItems = {
    { name = "First Aid Kit", price = 25, weight = 10 },
    { name = "Fire Extinguisher", type = "weapon", hash = 101631238, price = 100, weight = 20 },
    { name = "Flare", type = "weapon", hash = 1233104067, price = 200, weight = 5 },
    { name = "Tear Gas", type = "weapon", hash = -1600701090, price = 300, weight = 5 },
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 25, weight = 4 },
    { name = "Nightstick", type = "weapon", hash = 1737195953, price = 100, weight = 4 },
    { name = "Glock", type = "weapon", hash = 1593441988, price = 300, weight = 5 },
    { name = "Heavy Pistol", type = "weapon", hash = GetHashKey("WEAPON_HEAVYPISTOL"), price = 450, weight = 7 },
    { name = "Stun Gun", type = "weapon", hash = 911657153, price = 400, weight = 5 },
    { name = "SMG", type = "weapon", hash = 736523883, price = 750, weight = 25 },
    { name = "SMG MK2", type = "weapon", hash = 0x78A97CD0, price = 750, weight = 20 },
    { name = "MK2 Pump Shotgun", type = "weapon", hash = 1432025498, price = 700, weight = 25 },
    { name = "MK2 Carbine Rifle", type = "weapon", hash = 4208062921, price = 700, weight = 25, minRank = 2 },
    { name = "Sniper Rifle", type = "weapon", hash = 100416529, price = 2000, weight = 30, minRank = 2 },
    { name = "Spike Strips", price = 700 },
    { name = "Police Radio", price = 300, type = "misc", weight = 5, notStackable = true },
    { name = "Stretcher", price = 400, type = "misc", weight = 35, invisibleWhenDropped = true },
    { name = "9mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
    { name = ".45 Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
    { name = "Empty .45 Mag [18]", type = "magazine", price = 50, weight = 3, receives = ".45", MAX_CAPACITY = 18, currentCapacity = 0 },
    { name = "Empty 9mm Mag [12]", type = "magazine", price = 50, weight = 3, receives = "9mm", MAX_CAPACITY = 12, currentCapacity = 0 },
    { name = "Empty 9mm Mag [30]", type = "magazine", price = 50, weight = 3, receives = "9mm", MAX_CAPACITY = 30, currentCapacity = 0 },
    { name = "12 Gauge Shells", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
    { name = "7.62mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 10 },
    { name = "Empty 7.62mm Mag [10]", type = "magazine", price = 50, weight = 3, receives = "7.62mm", MAX_CAPACITY = 10, currentCapacity = 0 },
    { name = "5.56mm Bullets", type = "ammo", price = 50, weight = 0.5, quantity = 20 },
    { name = "Empty 5.56mm Mag [30]", type = "magazine", price = 50, weight = 3, receives = "5.56mm", MAX_CAPACITY = 30, currentCapacity = 0 },
    { name = "MK2 Carbine Rifle", type = "weapon", hash = 4208062921, price = 700, weight = 25, minRank = 2 },
}

for i = 1, #armoryItems do
	armoryItems[i].legality = "legal"
	if armoryItems[i].type == "weapon" then
		armoryItems[i].serviceWeapon = true
        armoryItems[i].notStackable = true
	end
    if armoryItems[i].type == "magazine" then
        armoryItems[i].notStackable = true
    end
	if not armoryItems[i].quantity then
		armoryItems[i].quantity = 1
	end
end

RegisterServerEvent("police:loadArmoryItems")
AddEventHandler("police:loadArmoryItems", function()
    TriggerClientEvent("police:loadArmoryItems", source, armoryItems)
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'whitelist' then
        local playerId = tonumber(table.remove(args, 1))
        local wl_type = table.remove(args, 1)
        local rank = tonumber(table.remove(args, 1)) -- 0 for unwhitelist, remove whitelist
        --RconPrint(type)
        if not GetPlayerName(playerId) then
            RconPrint("\nError: player with id #" .. playerId .. " does not exist!")
            CancelEvent()
            return
        elseif not wl_type then
            RconPrint("\nYou must enter a whitelist type: police or  ems")
            CancelEvent()
            return
        elseif not rank then
            RconPrint("\nYou must enter a rank for that player: 0 to un-whitelist. 1 is probationary deputy, 7 is max.")
            CancelEvent()
            return
        end

        if wl_type == "police" then
            local char = exports["usa-characters"]:GetCharacter(playerId)
            if rank > 0 then
                char.set("policeRank", rank)
                RconPrint("DEBUG: " .. playerId .. "'s police rank has been set to: " .. rank .. "!")
                TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for police, rank: " .. rank)
            else
                char.set("policeRank", 0)
                char.set("job", "civ")
                RconPrint("DEBUG: " .. playerId .. " un-whitelisted as police.")
            end
        elseif wl_type == "ems" then
            local char = exports["usa-characters"]:GetCharacter(playerId)
            if rank > 0 then
                char.set("emsRank", rank)
                RconPrint("DEBUG: " .. playerId .. "'s EMS rank has been set to: " .. rank .. "!")
                TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for EMS, rank: " .. rank)
            else
                char.set("emsRank", 0)
                char.set("job", "civ")
                RconPrint("DEBUG: " .. playerId .. " un-whitelisted as EMS.")
            end
        elseif wl_type == "da" then
            local char = exports["usa-characters"]:GetCharacter(playerId)
            if rank > 0 then
                char.set("daRank", rank)
                RconPrint("DEBUG: " .. playerId .. "'s DA rank has been set to: " .. rank .. "!")
                TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for EMS, rank: " .. rank)
            else
                char.set("daRank", 0)
                char.set("job", "civ")
                RconPrint("DEBUG: " .. playerId .. " un-whitelisted as DA.")
            end
        elseif wl_type == "judge" then
            local char = exports["usa-characters"]:GetCharacter(playerId)
            if rank > 0 then
                char.set("judgeRank", rank)
                RconPrint("DEBUG: " .. playerId .. "'s judge rank has been set to: " .. rank .. "!")
                TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for judge, rank: " .. rank)
            else
                char.set("judgeRank", 0)
                char.set("job", "civ")
                RconPrint("DEBUG: " .. playerId .. " un-whitelisted as judge.")
            end
        elseif wl_type == "realtor" then
            local char = exports["usa-characters"]:GetCharacter(playerId)
            if rank > 0 then
                char.set("realtorRank", rank)
                RconPrint("DEBUG: " .. playerId .. "'s realtor rank has been set to: " .. rank .. "!")
                TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for realtor, rank: " .. rank)
            else
                char.set("realtorRank", 0)
                char.set("job", "civ")
                RconPrint("DEBUG: " .. playerId .. " un-whitelisted as realtor.")
            end
        elseif wl_type == "corrections" then
            if not GetPlayerName(playerId) or not tonumber(rank) then
                RconPrint("Error: bad format!")
                return
            end
            local target_ident = GetPlayerIdentifiers(playerId)[1]
            TriggerEvent('es:exposeDBFunctions', function(GetDoc)
                GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , target_ident, function(result)

                    local char = exports["usa-characters"]:GetCharacter(playerId)
                    local employee = {
                        identifier = target_ident,
                        name = char.getFullName(),
                        rank = tonumber(rank)
                    }

                    if type(result) ~= "boolean" then -- exists (table)
                        GetDoc.updateDocument("correctionaldepartment", result._id, {rank = employee.rank}, function()
                            RconPrint("Rank updated to: " .. employee.rank)
                            RconPrint("\nEmployee " .. employee.name .. "updated, rank: " .. employee.rank .. "!")
                            --loadDOCEmployees()
                            TriggerEvent("doc:refreshEmployees") -- TODO: CREATE HANDLER FOR THIS EVENT in prisonfive/server.lua
                        end)
                    else -- did not exist already, create doc
                        GetDoc.createDocument("correctionaldepartment", employee, function()
                            -- notify:
                            RconPrint("Employee " .. employee.name .. "created, rank: " .. employee.rank .. "!")
                            -- refresh employees:
                            --loadDOCEmployees()
                            TriggerEvent("doc:refreshEmployees")
                        end)
                    end
                end)
            end)
        elseif wl_type:lower() == "eventplanner" then
            local c = exports["usa-characters"]:GetCharacter(playerId)
            c.set("eventPlannerRank", rank)
            RconPrint("DEBUG: " .. playerId .. "'s event planner rank is now " .. rank)
        end
        CancelEvent()
    end
end)

TriggerEvent('es:addCommand', 'whitelist', function(source, args, char)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    local user_group = user.getGroup()
    local user_rank = 0
    local playerId = tonumber(args[2])
    local type = string.lower(args[3])
    local rank = tonumber(args[4])
    local playerName = GetPlayerName(playerId)
    if type == "ems" then
        user_rank = tonumber(char.get("emsRank"))
    elseif type == "police" then
        user_rank = tonumber(char.get("policeRank"))
    elseif type == "da" then
        user_rank = char.get("daRank")
        if user_rank then
            user_rank = tonumber(user_rank)
        else
            user_rank = 0
        end
    end

    if user_group == "admin" or user_group == "superadmin" or user_group == "owner" then
        user_rank = 999999 -- so admins can use /whitelist
    end

    if user_rank < 5 then
        TriggerClientEvent("usa:notify", source, "Error: must be ranked as 5 or above to set permissions!")
        return
    elseif rank > user_rank then
        print("Error: can't set a person's rank to something higher than your own!")
        TriggerClientEvent("usa:notify", source, "Error: can't set a person's rank to something higher than your own!")
        return
    elseif not playerName then
        print("Error: player with id #" .. playerId .. " does not exist!")
        TriggerClientEvent("usa:notify", source, "Error: player with id #" .. playerId .. " does not exist!")
        return
    elseif not type then
        print("You must enter a whitelist type: police, ems or da")
        TriggerClientEvent("usa:notify", source, "You must enter a whitelist type: police or ems")
        return
    elseif not rank then
        print("You must enter a whitelist status for that player: true or false")
        TriggerClientEvent("usa:notify", source, "You must enter a rank for that player: 0 to un-whitelist. 1 is lowest, 7 is max.")
        return
    end
    local target = exports["usa-characters"]:GetCharacter(playerId)
    if rank > 0 then
        if type == "police" then
            target.set("policeRank", rank)
        elseif type == "ems" then
            target.set("emsRank", rank)
        elseif type == "da" then
            target.set("daRank", rank)
        end
        TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been whitelisted for " .. type .. ", rank: " .. rank)
    else
        if type == "police" then
            target.set("policeRank", 0)
        elseif type == "ems" then
            target.set("emsRank", 0)
        elseif type == "da" then
            target.set("daRank", 0)
        end
        local user_job = target.get("job")
        if user_job == "ems" or user_job == "fire" or user_job == "sheriff" then
            target.set("job", "civ")
        end
        TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been un-whitelisted for " .. type)
    end
end, {
    help = "Set a person's police, EMS or DA rank.",
    params = {
        { name = "id", help = "The player's server ID #" },
        { name = "type", help = "'police', 'ems' or 'da'" },
        { name = "rank", help = "0 to remove whitelist, 1 for lowest, 7 is max permissions" }
    }
})

RegisterServerEvent("policestation2:checkWhitelistForLockerRoom")
AddEventHandler("policestation2:checkWhitelistForLockerRoom", function()
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerGameLicense = ""
    local char = exports["usa-characters"]:GetCharacter(source)
    local job = char.get("job")
    if char.get("policeRank") > 0 then
        TriggerClientEvent("policestation2:isWhitelisted", source)
    else
        TriggerClientEvent("usa:notify", source, "~y~You are not whitelisted for POLICE. Apply at https://www.usarrp.net.")
    end
end)

RegisterServerEvent("policestation2:checkWhitelistForArmory")
AddEventHandler("policestation2:checkWhitelistForArmory", function()
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerGameLicense = ""
    local char = exports["usa-characters"]:GetCharacter(source)
    local job = char.get("job")
    if (char.get("policeRank") > 0 and job == "sheriff") or job == "corrections" then
        TriggerClientEvent("policestation2:showArmoury", source)
    else
        TriggerClientEvent("usa:notify", source, "~y~You are not on duty for POLICE. Apply at https://www.usarrp.net.")
    end
end)

RegisterServerEvent("policestation2:requestPurchase")
AddEventHandler("policestation2:requestPurchase", function(index)
    local usource = source
    local weapon = armoryItems[index]
    if weapon.name == "Spike Strips" then
        TriggerEvent("spikestrips:equip", true, usource) -- true = pay required
    else
        local char = exports["usa-characters"]:GetCharacter(usource)
        local rank = char.get("policeRank")
        if weapon.minRank then
            if rank < weapon.minRank then
                TriggerClientEvent("usa:notify", usource, "Not high enough rank, need to be: " .. weapon.minRank)
                return
            end
        end
        if char.canHoldItem(weapon) then
            local user_money = char.get("money")
            if user_money - armoryItems[index].price >= 0 then
                local timestamp = os.date("*t", os.time())
                weapon.serialNumber = exports.globals:generateID()
                weapon.uuid = weapon.serialNumber
                local weaponDB = {}
                weaponDB.name = weapon.name
                weaponDB.serialNumber = weapon.uuid
                weaponDB.ownerName = char.getFullName()
                weaponDB.ownerDOB = char.get('dateOfBirth')
                weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
                local attachments = GetWeaponAttachments(weapon.name)
                weaponDB.components = attachments
                weapon.components = attachments
                char.giveItem(weapon, (weapon.quantity or 1))
                char.removeMoney(armoryItems[index].price)
                TriggerClientEvent("mini:equipWeapon", usource, armoryItems[index].hash, attachments, false) -- equip
                TriggerClientEvent('usa:notify', usource, 'Purchased: ~y~'..weapon.name..'\n~s~Price: ~y~$'..armoryItems[index].price)
                TriggerEvent('es:exposeDBFunctions', function(couchdb)
                    couchdb.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
                        if success then
                            print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
                        else
                            print("* Error: Weapon failed to be created!! *")
                        end
                    end)
                end)
            else
                TriggerClientEvent("usa:notify", usource, "Not enough money!")
            end
        else
            TriggerClientEvent("usa:notify", usource, "Inventory is full!")
        end
    end
end)

RegisterServerEvent("policestation2:saveOutfit")
AddEventHandler("policestation2:saveOutfit", function(character, slot)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("job") == "sheriff" then
        TriggerEvent('es:exposeDBFunctions', function(db)
            local docID = char.get("_id") .. "-" .. slot
            db.createDocumentWithId(DB_NAME, character, docID, function(ok)
                if ok then
                    TriggerClientEvent("usa:notify", src, "Outfit in slot "..slot.." has been saved.")
                else
                    db.updateDocument(DB_NAME, docID, character, function(ok)
                        if ok then
                            TriggerClientEvent("usa:notify", src, "Outfit in slot "..slot.." has been updated.")
                        else 
                            TriggerClientEvent("usa:notify", src, "Error saving outfit")
                        end
                    end)
                end
            end)
        end)
    else
        TriggerClientEvent("usa:notify", source, "You must be on-duty to save a uniform.")
    end
end)

RegisterServerEvent("policestation2:loadOutfit")
AddEventHandler("policestation2:loadOutfit", function(slot)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("policeRank") > 0 then
        local docID = char.get("_id") .. "-" .. slot
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.getDocumentById(DB_NAME, docID, function(outfit)
                TriggerClientEvent("policestation2:setCharacter", src, outfit)
                if char.get("job") ~= 'sheriff' then
                    char.set("job", "sheriff")
                    TriggerEvent('job:sendNewLog', src, JOB_NAME, true)
                end
                TriggerClientEvent('interaction:setPlayersJob', src, 'sheriff')
                TriggerEvent("eblips:add", {name = char.getName(), src = src, color = 3})
            end)
        end)
    else
        DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
    end
end)

RegisterServerEvent("policestation2:offduty")
AddEventHandler("policestation2:offduty", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    --RemovePoliceWeapons(char)
    local playerWeapons = char.getWeapons() -- give back their civ weapons
    TriggerClientEvent('interaction:setPlayersJob', source, 'civ')
    TriggerClientEvent("policestation2:setciv", source, char.get("appearance"), playerWeapons)
    char.set("job", "civ")
    TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
    TriggerEvent("eblips:remove", source)
    TriggerClientEvent("radio:unsubscribe", source)
end)

RegisterServerEvent("police:buyFAK")
AddEventHandler("police:buyFAK", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local FAK = {
        name = "First Aid Kit",
        price = 50,
        type = "misc",
        quantity = 1,
        legality = "legal",
        weight = 15,
        objectModel = "v_ret_ta_firstaid",
        blockedInPrison = true
    }
    if char.canHoldItem(FAK) then
        if char.get("money") >= FAK.price then
            char.removeMoney(FAK.price)
            char.giveItem(FAK)
        else
            TriggerClientEvent("usa:notify", source, "Not enough money! Need $" .. FAK.price)
        end
    else
        TriggerClientEvent("usa:notify", source, "Inventory full!")
    end
end)

function GetWeaponAttachments(name)
    local attachments = {}
    if name == "MK2 Carbine Rifle" then
        table.insert(attachments, 'COMPONENT_AT_SIGHTS')
        table.insert(attachments, 'COMPONENT_AT_AR_FLSH')
        table.insert(attachments, 'COMPONENT_AT_AR_AFGRIP_02')
        --table.insert(attachments, 'COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ')
        table.insert(attachments, 'COMPONENT_AT_CR_BARREL_02')
        table.insert(attachments, 'COMPONENT_AT_MUZZLE_06')
    elseif name == "MK2 Pump Shotgun" then
        table.insert(attachments, 'COMPONENT_AT_SIGHTS')
        table.insert(attachments, 'COMPONENT_AT_AR_FLSH')
        --table.insert(attachments, 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT')
    elseif name == "Glock" then
        table.insert(attachments, 0x359B7AAE)
    elseif name == "SMG MK2" then
        table.insert(attachments, "COMPONENT_AT_AR_FLSH")
        table.insert(attachments, "COMPONENT_AT_SIGHTS_SMG")
    end
    return attachments
end

function RemovePoliceWeapons(char)
    local weps = char.getWeapons()
    for i = #weps, 1, -1 do
        if weps[i].serviceWeapon then
            char.removeItemWithField("serialNumber", weps[i].serialNumber)
            local src = char.get("source")
            if src then
                TriggerClientEvent("interaction:equipWeapon", src, weps[i], false) -- to test
            end
        end
    end
end
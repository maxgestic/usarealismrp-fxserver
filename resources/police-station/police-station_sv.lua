-- this command is to get your cop weapons back after dying
TriggerEvent('es:addCommand', 'loadout', function(source, args, user)

   weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}

   if user.getJob() == "sheriff" then
       TriggerClientEvent("policeStation:giveWeapons", source, weapons)
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3You have been given a sheriff's deputy loadout.")
   else
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Only sheriff deputies are allowed to use /loadout!")
   end

end)

RegisterServerEvent("policeStation:toggleUCDuty")
AddEventHandler("policeStation:toggleUCDuty", function(modelName)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getJob() == "civ" then
            TriggerClientEvent("policeStation:giveSheriffLoadout", userSource, modelName)
            user.setJob("sheriff")
        end
    end)
end)

RegisterServerEvent("policeStation:toggleDuty")
AddEventHandler("policeStation:toggleDuty", function(gender)
    local userSource = source
		TriggerEvent('es:getPlayerFromId', userSource, function(user)
			if user.getJob() == "civ" then
                local sheriffModel
        		-- chosen gender for sheriff
        		if gender == "male" then
        			sheriffModel = "S_M_Y_Sheriff_01"
        		else
        			sheriffModel = "S_F_Y_Sheriff_01"
        		end
                user.setJob("sheriff")
        		TriggerClientEvent("policeStation:giveSheriffLoadout", userSource, sheriffModel)
			end
		end)
end)

RegisterServerEvent("policeStation:giveCivStuff")
AddEventHandler("policeStation:giveCivStuff", function()
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getWeapons()
        TriggerClientEvent("policeStation:giveCivLoadout", userSource, user.getModel(), playerWeapons)
        user.setJob("civ")
        TriggerClientEvent("gps:removeGov", userSource, user)
        TriggerClientEvent("gps:removeAllEMSReq", userSource)
        TriggerEvent("es:getPlayers", function(pl)
            local users = {}
            for k, v in pairs(pl) do
                TriggerEvent("es:getPlayerFromId", k, function(user)
                    if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
                        table.insert(users, user.identifier)
                    end
                end)
            end
            TriggerClientEvent("gps:removeGov", userSource, users)
        end)
    end)
end)

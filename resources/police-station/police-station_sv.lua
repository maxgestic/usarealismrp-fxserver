local whitelistedPolice = {
	{name = "minipunch", identifier = "steam:1100001007a8797", permission = 1}
}

RegisterServerEvent("policeStation:checkWhitelist")
AddEventHandler("policeStation:checkWhitelist", function()
    local identifier = GetPlayerIdentifiers(source)[1]
    for i = 1, #whitelistedPolice do
        if identifier == whitelistedPolice[i].identifier then
            TriggerClientEvent("policeStation:isWhitelisted", source)
            return
        end
    end
    -- not whitelistedPolice
    TriggerClientEvent("policeStation:notify", source, "You must apply for police/ems at ~y~usarrp.enjin.com!")
end)

-- this command is to get your cop weapons back after dying
TriggerEvent('es:addCommand', 'loadout', function(source, args, user)

   weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}

   if user.getJob() == "sheriff" or user.getJob() == "police" or user.getJob() == "cop" then
       TriggerClientEvent("policeStation:giveWeapons", source, weapons)
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3You have been given a sheriff's deputy loadout.")
   else
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Only sheriff deputies are allowed to use /loadout!")
   end

end)

RegisterServerEvent("policeStation:toggleUCDuty")
AddEventHandler("policeStation:toggleUCDuty", function(modelName)
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getJob() ~= "sheriff" or user.getJob() ~= "cop" or user.getJob() ~= "police" then
            TriggerClientEvent("policeStation:giveSheriffLoadout", userSource, modelName)
            user.setJob("sheriff")
        end
    end)
end)

RegisterServerEvent("policeStation:toggleDuty")
AddEventHandler("policeStation:toggleDuty", function(gender)
    local userSource = source
		TriggerEvent('es:getPlayerFromId', userSource, function(user)
			if user.getJob() ~= "sheriff" or user.getJob() ~= "cop" or user.getJob() ~= "police" then
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
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getWeapons()
        TriggerClientEvent("policeStation:giveCivLoadout", userSource, user.getCharacters(), playerWeapons)
        user.setJob("civ")
    end)
end)

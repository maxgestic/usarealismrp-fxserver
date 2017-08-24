local whitelistedPolice = {
	{name = "minipunch", identifier = "steam:1100001007a8797", permission = 1},
	    {name = "clickcrackboom", identifier = "steam:110000112944617", permission = 1},
	    {name = "Josh Stevens", identifier = "steam:11000011704283b", permission = 1},
	    {name = "Kube", identifier = "steam:11000010270ddb4", permission = 1},
	    {name = "Gavin Tan", identifier = "steam:1100001072f82e3", permission = 1},
		{name = "Hack", identifier = "steam:11000010b19ad35", permission = 1},
		{name = "Bert W.", identifier = "steam:1100001050af13a", permission = 1},
		{name = "totaleclipsed", identifier = "steam:1100001054d6790", permission = 1},
		{name = "Matt Lentz", identifier = "steam:110000106d47d14", permission = 1},
		{name = "agome", identifier = "steam:11000010f138f99", permission = 1},
		{name = "Michael Rodgers", identifier = "steam:110000105daec2a", permission = 1},
		{name = "Drevv", identifier = "steam:110000105c526a5", permission = 1},
		{name = "Gray", identifier = "steam:110000106acc08a", permission = 1},
		{name = "Nova", identifier = "steam:11000010722541c", permission = 1},
		{name = "Nova", identifier = "ip:178.149.138.10", permission = 1},
		{name = "bj barnes", identifier = "steam:11000010a24a999", permission = 1},
		{name = "Matt Ross", identifier = "steam:11000010bbe4cf5", permission = 1},
		{name = "John Freeman", identifier = "steam:110000102cb45c3", permission = 1},
		{name = "Ricky Golden", identifier = "steam:110000116400335", permission = 1},
		{name = "Miles Long", identifier = "steam:11000010051a482", permission = 1},
		{name = "K. Kronin", identifier = "steam:110000106ead96b", permission = 1},
		{name = "Swayam Cann", identifier = "steam:11000010724bbe7", permission = 1},
		{name = "Kyro", identifier = "steam:11000010570d923", permission = 1},
		{name = "K. Winter", identifier = "steam:11000010f82515f", permission = 1},
		{name = "Caropot", identifier = "steam:1100001068b91d0", permission = 1},
		{name = "Burrito", identifier = "steam:11000010a980508", permission = 1}, -- burrito
		{name = "BlackieChan", identifier = "steam:1100001011cf039", permission = 1}, -- blackie
		{name = "K. Moretti", identifier = "steam:11000010fcdb628", permission = 1},
		{name = "H. Thompson", identifier = "steam:110000104ba5d42﻿", permission = 1},
		{name = "H. Thompson", identifier = "license:f67a2a4034b8d2981e217fc66fa4dd35b393e0a5﻿", permission = 1},
		{name = "Elliptic Feedz", identifier = "steam:11000010c74c95e", permission = 1},
		{name = "Don Jones", identifier = "steam:1100001161c0ea1", permission = 1},
		{name = "Lucas", identifier = "steam:110000107be0c37", permission = 1},
		{name = "Eddie Newman", identifier = "steam:110000119d48b33", permission = 1},
		{name = "Tonio Newman", identifier = "ip:84.212.154.83", permission = 1},
		{name = "William Harus", identifier = "steam:110000106443607", permission = 1},
		{name = "Justin Evans", identifier = "steam:110000101938a57", permission = 1},
		{name = "Garrett", identifier = "steam:1100001012bb9c2", permission = 1},
		{name = "sikkkkk", identifier = "steam:110000119fd39af", permission = 1},
		{name = "Russ Smith", identifier = "steam:11000010b2956ce", permission = 1},
		{name = "Marcus", identifier = "steam:110000106ef7f61", permission = 1},
		{name = "vGojira(matt taylor)", identifier = "steam:110000107b27e2f", permission = 1},
		{name = "Henk Mason", identifier = "steam:11000010a62bc8f", permission = 1},
		{name = "Jeff Saggot", identifier = "steam:11000010a03362d", permission = 1},
		{name = "M. Henderson", identifier = "steam:11000010305ad16", permission = 1},
		{name = "N. Patton", identifier = "steam:1100001086cbfc4", permission = 1},
		{name = "T. Williams (tarrew)", identifier = "steam:110000106ea286b", permission = 1},
		{name = "K. Moretti", identifier = "steam:11000010fcdb628", permission = 1},
		{name = "Jay Smiths", identifier = "license:a6477200f8c0e0c9e0f53fe43c4336d731a7fbfb", permission = 1},
		{name = "Kodak Drucci", identifier = "steam:11000010c4a86e6", permission = 1},
		{name = "Brian Orian", identifier = "license:4b6ff175a02cdc955ebba7c17713c23209cc99dd", permission = 1},
		{name = "Danny McNulty (Matty_g)", identifier = "steam:1100001085db067", permission = 1}
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

   weapons = {"WEAPON_BZGAS", "WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}

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

-- add rcon command for white listing:
AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'whitelist' then
        local playerId = table.remove(args, 1)
        local type = table.concat(args, ' ')

		if tonumber(playerId) ~= nil and type then
	        if type == "police" then
				local identifier = GetPlayerIdentifiers(playerId)[1]
				local person = {
					name = GetPlayerName(playerId),
					identifier = tostring(identifier),
					permission = 1
				}
				print("whitelisting player for police, identifier: " .. person.identifier)
				table.insert(whitelistedPolice, person)
			end
		end

        CancelEvent()
    end
end)

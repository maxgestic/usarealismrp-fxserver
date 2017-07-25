local whitelistedPolice = {
	{name = "minipunch", identifier = "steam:1100001007a8797", permission = 1},
	    {name = "Ice", identifier = "steam:11000010ef3c3f3", permission = 1},
	    {name = "Jamie", identifier = "steam:110000102f857d7", permission = 1},
	    {name = "Cleveland", identifier = "steam:1100001031a189c", permission = 1},
	    {name = "William Clinton", identifier = "steam:110000107d0b777", permission = 1},
	    {name = "clickcrackboom", identifier = "steam:110000112944617", permission = 1},
	    {name = "Don Haynes", identifier = "steam:1100001007f2ab8", permission = 1},
	    {name = "Tim", identifier = "steam:110000105e9e6f1", permission = 1},
	    {name = "Josh Stevens", identifier = "steam:11000011704283b", permission = 1},
	    {name = "Tasha Crist", identifier = "steam:11000010a8aa0cb", permission = 1},
	    {name = "Jimmy Johnston", identifier = "steam:110000106b1b899", permission = 1},
	    {name = "Radisma", identifier = "steam:1100001002896c7", permission = 1},
	    {name = "Kube", identifier = "steam:11000010270ddb4", permission = 1},
	    {name = "Brian Gotti", identifier = "steam:11000010e17f439", permission = 1},
	    {name = "Robert Hopkins", identifier = "steam:110000108c66bca", permission = 1},
	    {name = "Mason Hughes", identifier = "steam:110000100867a7c", permission = 1},
	    {name = "Jack Goffe", identifier = "steam:11000010f727d73", permission = 1},
	    {name = "Gavin Tan", identifier = "steam:1100001072f82e3", permission = 1},
	    {name = "Anthony Anderson", identifier = "steam:110000106506ca4", permission = 1},
	    {name = "John Hopkins", identifier = "steam:1100001140f8e8f", permission = 1},
		{name = "Tyrosien", identifier = "steam:1100001006ecc6f", permission = 1},
		{name = "Hack", identifier = "steam:11000010b19ad35", permission = 1},
		{name = "Bert W.", identifier = "steam:1100001050af13a", permission = 1},
		{name = "Rikky", identifier = "steam:110000103c23bbb", permission = 1},
		{name = "totaleclipsed", identifier = "steam:1100001054d6790", permission = 1},
		{name = "Matt Lentz", identifier = "steam:110000106d47d14", permission = 1},
		{name = "agome", identifier = "steam:11000010f138f99", permission = 1},
		{name = "Michael Rodgers", identifier = "steam:110000105daec2a", permission = 1},
		{name = "Drevv", identifier = "steam:110000105c526a5", permission = 1},
		{name = "Gray", identifier = "steam:110000106acc08a", permission = 1},
		{name = "Rez", identifier = "steam:11000010a188938", permission = 1}
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
    local userSource = source
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

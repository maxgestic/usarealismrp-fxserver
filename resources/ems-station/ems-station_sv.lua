local whitelist = {}

function stringSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent("ems:checkWhitelist")
AddEventHandler("ems:checkWhitelist", function()
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerGameLicense = ""
    for i = 1, #playerIdentifiers do
        if string.find(playerIdentifiers[i], "license:") then
            playerGameLicense = playerIdentifiers[i]
        end
    end
    for j = 1, #whitelist do
        if playerGameLicense == whitelist[j] then
            TriggerClientEvent("ems:playerWasWhitelisted", source)
            return
        end
    end
    TriggerClientEvent("chatMessage", source, "", {}, "^3You are not whitelisted for EMS. Apply at ^5usarrp.enjin.com^0.")
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'whitelist' then
        local playerId = table.remove(args, 1)
        local type = table.concat(args, ' ')

        if not GetPlayerName(playerId) then
            RconPrint("\nError: player with id #" .. playerId .. " does not exist!")
            CancelEvent()
            return
        end

        if type == "ems" then
            local ids = GetPlayerIdentifiers(playerId)
            if ids then
                for i = 1, #ids do
                    if string.find(ids[i], "license:") then
							updateWhitelist(ids[i])
                            addToWhitelistRoster("("..GetPlayerName(playerId).."::"..ids[i]..")")
                            RconPrint("\nWhitelisted player " .. GetPlayerName(playerId) .. " for EMS!")
                            CancelEvent()
                            return
						end
                end
            end
        else
            RconPrint("\nHelp: whitelist [id] [type] where [type] can be 'ems' or 'police'")
        end

        RconPrint("\nError: failed to whitelist player " .. GetPlayerName(playerId) .. " for EMS.")
        CancelEvent()
    end
end)

function addToWhitelistRoster(addItem)
	content = LoadResourceFile(GetCurrentResourceName(), "whitelist-roster.txt")
	if string.len(content) > 1 then
		content = content.."|"..addItem
	else
		content = content..""..addItem
	end
	SaveResourceFile("ems-station", "whitelist-roster.txt", content, -1)
end

function updateWhitelist(addItem)
	whitelist = {}
	content = LoadResourceFile(GetCurrentResourceName(), "whitelist.txt")
	if not addItem then
		for index,value in ipairs(mysplit(content, "|")) do
			whitelist[index] = value
		end
	else
		if string.len(content) > 1 then
			content = content.."|"..addItem
		else
			content = content..""..addItem
		end
		for index,value in ipairs(mysplit(content, "|")) do
			whitelist[index] = value
		end
	end
	SaveResourceFile("ems-station", "whitelist.txt", content, -1)
end

updateWhitelist()

RegisterServerEvent("emsStation:toggleDuty")
AddEventHandler("emsStation:toggleDuty", function(params)
    local splitParams = stringSplit(params,":")
    local gender = splitParams[1]
    local type = splitParams[2]
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerJob = user.getJob()
        -- give appropriate loadout
        if playerJob ~= ("fire" or "ems") then
            local emsModel
            local newJob
            -- chosen gender for sheriff
            if gender == "male" then
                if type == "paramedic" then
                    emsModel = "S_M_M_Paramedic_01"
                    newJob = "ems"
                else
                    emsModel = "S_M_Y_Fireman_01"
                    newJob = "fire"
                end
            else
                emsModel = "S_F_Y_Scrubs_01"
                newJob = "ems"
            end
            user.setJob(newJob)
            TriggerClientEvent("emsStation:giveEmsLoadout", userSource, emsModel)
            print("setting job = " .. newJob)
        end
    end)
end)

RegisterServerEvent("emsStation:giveCivStuff")
AddEventHandler("emsStation:giveCivStuff", function()
    -- get player job
    local userSource = tonumber(source)
    local character, playerWeapons, playerJob
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        playerJob = user.getJob()
        if playerJob ~= "civ" then
            character = user.getCharacters()
            playerWeapons = user.getWeapons()
            user.setJob("civ")
            TriggerClientEvent("emsStation:changeSkin", userSource, character, playerWeapons)
            print("setting job = civ")
        end
    end)
end)

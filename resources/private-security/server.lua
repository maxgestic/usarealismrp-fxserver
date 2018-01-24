AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'whitelist' then
        local playerId = table.remove(args, 1)
        local type = table.remove(args, 1)
        local status = table.remove(args, 1)
		--RconPrint(type)
        if not GetPlayerName(playerId) then
            RconPrint("\nError: player with id #" .. playerId .. " does not exist!")
            CancelEvent()
            return
        elseif not type then
            RconPrint("\nYou must enter a whitelist type: police, ems or security")
            CancelEvent()
            return
        elseif not status then
            RconPrint("\nYou must enter a whitelist status for that player: true or false")
            CancelEvent()
            return
        end
        if type == "security" then
			TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
				if(user)then
                    if status == "true" then
              user.setActiveCharacterData("securityRank", 1)
    					RconPrint("DEBUG: " .. playerId .. " whitelisted for Private Security")
    					--TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {255, 255, 255}, "You have been whitelist as EMS")
                    else
                        user.setActiveCharacterData("securityRank", 0)
                        user.setActiveCharacterData("job", "civ")
    					RconPrint("DEBUG: " .. playerId .. " un-whitelisted for Private Security")
                    end
				end
			end)
        end
        --RconPrint("\nError: failed to whitelist player " .. GetPlayerName(playerId) .. " for POLICE.")
        CancelEvent()
    end
end)

RegisterServerEvent("job-private-sec:checkWhitelist")
AddEventHandler("job-private-sec:checkWhitelist", function()
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getActiveCharacterData("securityRank") > 0 then
			TriggerClientEvent("job-private-sec:isWhitelisted", userSource)
		else
			TriggerClientEvent("job-private-sec:notify", userSource, "~y~You are not whitelisted for Private Security. Apply at ~b~usarrp.enjin.com~w~.")
		end
	end)

end)

function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
	end
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

RegisterServerEvent("job-private-sec:onduty")
AddEventHandler("job-private-sec:onduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getActiveCharacterData("job") ~= "security" then
            user.setActiveCharacterData("job", "security")
        end
    end)
end)

RegisterServerEvent("job-private-sec:offduty")
AddEventHandler("job-private-sec:offduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getActiveCharacterData("weapons")
        TriggerClientEvent("job-private-sec:setciv", userSource, user.getCharacters(), playerWeapons)
        user.setActiveCharacterData("job", "civ")
    end)
end)

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
            RconPrint("\nYou must enter a whitelist type: police or  ems")
            CancelEvent()
            return
        elseif not status then
            RconPrint("\nYou must enter a whitelist status for that player: true or false")
            CancelEvent()
            return
        end

        if type == "police" then
			TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
				if(user)then
                    if status then
    					user.setPoliceRank(1)
    					RconPrint("DEBUG: " .. playerId .. " whitelisted as LSPD")
    					TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "You have been whitelisted for LSPD")
                    else
                        user.setPoliceRank(0)
                        RconPrint("DEBUG: " .. playerId .. " un-whitelisted as LSPD")
                    end
				end
			end)
        end

        --RconPrint("\nError: failed to whitelist player " .. GetPlayerName(playerId) .. " for POLICE.")
        CancelEvent()
    end
end)

RegisterServerEvent("policestation2:checkWhitelist")
AddEventHandler("policestation2:checkWhitelist", function(clientevent)
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getPoliceRank() > 0 then
			--TriggerClientEvent("policestation2:isWhitelisted", userSource)
			if clientevent == "policestation2:showArmoury" then
				if user.getJob() == "sheriff" or user.getJob() == "cop" then
					TriggerClientEvent(clientevent, userSource)
				else
					TriggerClientEvent("policestation2:notify", userSource, "You need to be ~r~10-8 ~w~ to access LSPD armoury.")
				end
			else
				TriggerClientEvent(clientevent, userSource)
			end
		else
			TriggerClientEvent("policestation2:notify", userSource, "~y~You are not whitelisted for POLICE. Apply at ~b~usarrp.enjin.com~w~.")
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

RegisterServerEvent("policestation2:saveasdefault")
AddEventHandler("policestation2:saveasdefault", function(character)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getJob() == "sheriff" or user.getJob() == "cop" then
			--user.setCharacters(character)
			--print("PLAYER MODEL SAVED")
			user.setPoliceCharacter(character)
			TriggerClientEvent("policestation2:notify", userSource, "Default ~b~LSPD~w~ uniform saved.")
			--TriggerEvent("mini:giveMeMyWeaponsPlease")
		else
			TriggerClientEvent("policestation2:notify", userSource, "You need to be ~r~10-8~w~ to save default uniform.")
		end
	end)
end)

RegisterServerEvent("policestation2:loadDefaultUniform")
AddEventHandler("policestation2:loadDefaultUniform", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		character = user.getPoliceCharacter()
		TriggerClientEvent("policestation2:setCharacter", userSource, character)
		TriggerClientEvent("policestation2:giveDefaultLoadout", userSource)
		user.setJob("sheriff")
	end)
end)



RegisterServerEvent("policestation2:onduty")
AddEventHandler("policestation2:onduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getJob() ~= "sheriff" or user.getJob() ~= "cop" or user.getJob() ~= "police" then
            user.setJob("sheriff")
        end
    end)
end)

RegisterServerEvent("policestation2:offduty")
AddEventHandler("policestation2:offduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getWeapons()
        TriggerClientEvent("policestation2:setciv", userSource, user.getCharacters(), playerWeapons)
        user.setJob("civ")
    end)
end)

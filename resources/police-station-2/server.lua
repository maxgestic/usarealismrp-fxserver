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
          if status == "true" then
              user.setActiveCharacterData("policeRank", 1)
    					RconPrint("DEBUG: " .. playerId .. " whitelisted as LSPD")
    					TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {0, 0, 0}, "You have been whitelisted for LSPD")
                    else
                        user.setActiveCharacterData("policeRank", 0)
						user.setActiveCharacterData("job", "civ")
                        RconPrint("DEBUG: " .. playerId .. " un-whitelisted as LSPD")
          end
				end
			end)
        end

        --RconPrint("\nError: failed to whitelist player " .. GetPlayerName(playerId) .. " for POLICE.")
        CancelEvent()
    end
end)

TriggerEvent('es:addCommand', 'whitelist', function(source, args, user)
    local user_group = user.getGroup()
    if user_group ~= "admin" and user_group ~= "superadmin" and user_group ~= "owner" then return end
    local playerId = tonumber(args[2])
    local type = args[3]
    local status = args[4]
    local playerName = GetPlayerName(playerId)
    if not playerName then
        print("Error: player with id #" .. playerId .. " does not exist!")
        TriggerClientEvent("usa:notify", source, "Error: player with id #" .. playerId .. " does not exist!")
        return
    elseif not type then
        print("You must enter a whitelist type: police or  ems")
        TriggerClientEvent("usa:notify", source, "You must enter a whitelist type: police or ems")
        return
    elseif not status then
        print("You must enter a whitelist status for that player: true or false")
        TriggerClientEvent("usa:notify", source, "You must enter a whitelist status for that player: true or false")
        return
    end
    TriggerEvent('es:getPlayerFromId', playerId, function(targetUser)
      if targetUser then
        if status == "true" then
          if type == "police" then
            targetUser.setActiveCharacterData("policeRank", 1)
          elseif type == "ems" then
            targetUser.setActiveCharacterData("emsRank", 1)
          end
          TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been whitelisted for " .. type)
        else
          if type == "police" then
            targetUser.setActiveCharacterData("policeRank", 0)
          elseif type == "ems" then
            targetUser.setActiveCharacterData("emsRank", 0)
          end
          local user_job = targetUser.getActiveCharacterData("job")
          if user_job == "ems" or user_job == "fire" or user_job == "sheriff" then
            targetUser.setActiveCharacterData("job", "civ")
          end
          TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been un-whitelisted for " .. type)
        end
      end
    end)
end)

RegisterServerEvent("policestation2:checkWhitelist")
AddEventHandler("policestation2:checkWhitelist", function(clientevent)
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getActiveCharacterData("policeRank") > 0 then
			--TriggerClientEvent("policestation2:isWhitelisted", userSource)
			if clientevent == "policestation2:showArmoury" then
      local user_job = user.getActiveCharacterData("job")
				if user_job == "sheriff" or user_job == "cop" then
					TriggerClientEvent(clientevent, userSource)
				else
					TriggerClientEvent("policestation2:notify", userSource, "You need to be ~r~10-8 ~w~ to access LSPD armoury.")
				end
			else
				TriggerClientEvent(clientevent, userSource)
			end
		else
			TriggerClientEvent("policestation2:notify", userSource, "~y~You are not whitelisted for POLICE. Apply at ~b~https://www.usarrp.net~w~.")
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
    local user_job = user.getActiveCharacterData("job")
		if user_job == "sheriff" or user_job == "cop" then
			--user.setCharacters(character)
			--print("PLAYER MODEL SAVED")
			user.setPoliceCharacter(character) -- this is right... right??
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
    user.setActiveCharacterData("job", "sheriff")
	end)
end)

RegisterServerEvent("policestation2:onduty")
AddEventHandler("policestation2:onduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
      local user_job = user.getActiveCharacterData("job")
        if user_job ~= "sheriff" or user_job ~= "cop" or user_job ~= "police" then
            user.setActiveCharacterData("job", "sheriff")
        end
    end)
end)

RegisterServerEvent("policestation2:offduty")
AddEventHandler("policestation2:offduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getActiveCharacterData("weapons")
        local chars = user.getCharacters()
        for i = 1, #chars do
          if chars[i].active == true then
              print("found matching active character for off duty!")
            TriggerClientEvent("policestation2:setciv", userSource, chars[i].appearance, playerWeapons) -- need to test
            break
          end
        end
        user.setActiveCharacterData("job", "civ")
    end)
end)

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
        if type == "ems" then
			TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
				if(user)then
                    if status then
    					user.setEMSRank(1)
    					RconPrint("DEBUG: " .. playerId .. " whitelisted for EMS")
    					--TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "You have been whitelist as EMS")
                    else
                        user.setEMSRank(0)
    					RconPrint("DEBUG: " .. playerId .. " un-whitelisted for EMS")
                    end
				end
			end)
        end
        --RconPrint("\nError: failed to whitelist player " .. GetPlayerName(playerId) .. " for POLICE.")
        CancelEvent()
    end
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        if user.getJob() ~= "ems" then
            user.setJob("ems")
        end
    end)
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerWeapons = user.getWeapons()
        TriggerClientEvent("emsstation2:setciv", userSource, user.getCharacters(), playerWeapons)
        user.setJob("civ")
    end)
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function(clientevent)
	local playerIdentifiers = GetPlayerIdentifiers(source)
	local playerGameLicense = ""
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user.getEMSRank() > 0 then
			--TriggerClientEvent("policestation2:isWhitelisted", userSource)
			TriggerClientEvent(clientevent, userSource)
		else
			TriggerClientEvent("emsstation2:notify", userSource, "~y~You are not whitelisted for EMS. Apply at ~b~usarrp.enjin.com~w~.")
		end
	end)

end)

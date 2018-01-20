RegisterServerEvent('chatCommandEntered')
RegisterServerEvent('chatMessageEntered')

AddEventHandler('chatMessageEntered', function(name, color, message)
    --print("message = " .. message)
    if message == "" or message == " " then CancelEvent() return end
    if not name or not color or not message or #color ~= 3 then
        return
    end
    local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)

		if user then

            local job = user.getActiveCharacterData("job")

			if(job == "cop") then

				name = "Police | " .. name
				color = {2, 111, 218}

			elseif job == "sheriff" then

				name = "Deputy | " .. name
				color = {2, 111, 218}

			elseif job == "highwaypatrol" then

				name = "Highway Patrol | " .. name
				color = {102, 153, 255}

			elseif(job == "ems") then

				name = "EMS | " .. name
				color = {255, 51, 153}

			elseif(job == "fire") then

				name = "Fire Department | " .. name
				color = {255, 0, 0}

			end

		else

			print("ERROR GETTING USER BY ID")

		end

	end)

    TriggerEvent('chatMessage', userSource, name, message)

    if not WasEventCanceled() then
        local args = mysplit(message, " ")
        local firstWord = string.lower(args[1])
        if firstWord == "/tweet" then
          local message = "Please use your cell phone to send a tweet!"
          TriggerClientEvent("usa:notify", userSource, message)
        elseif firstWord == "/me" then
            print("/me detected!")
            print("msg = " .. table.concat(args, " "))
            table.remove(args, 1)
            TriggerEvent('altchat:localChatMessage', userSource, "^6* " .. name .. " " .. table.concat(args, " "))
        elseif firstWord == "/showbadge" then
            table.remove(args, 1)
        	message = table.concat(args, " ")
        	--TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.")
        	--TriggerClientEvent('chatMessage', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source)
        	TriggerEvent("es:getPlayerFromId", userSource, function(user)
        		if(user)then
              local user_rank = user.getActiveCharacterData("policeRank")
        			if user_rank > 0 then
        				local policeRanks = {
        					"Probationary Officer" ,
        					"Police Officer 1" ,
        					"Police Officer 2" ,
        					"Sergaent" ,
        					"Lieutenant" ,
        					"Captain" ,
        					"Deputy Chief" ,
        					"Chief of Police"
        				}
        				TriggerEvent('altchat:localChatMessage', userSource, "^6* " .. name .. " shows Badge.")
        				TriggerEvent('altchat:localChatMessage', userSource, "^6[ID] ^2Name: ^4" .. name .. " ^0- ^2Rank: ^4" .. policeRanks[user_rank])
        			else
        				TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "^3You're not whitelisted to use the command.")
        			end
        		end
        	end)
        elseif firstWord == "/showid" then
            table.remove(args, 1)
            TriggerEvent('altchat:localChatMessage', userSource, "^6* " .. name .. " shows ID.")
            TriggerEvent('altchat:localChatMessage', userSource, "^6[ID] ^2Name: ^4" .. name .. " ^0- ^2SSN: ^4" .. userSource)
        elseif firstWord == "/ad" then
            table.remove(args, 1)
            TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. name, {171, 67, 227}, table.concat(args, " "))
        else
            TriggerClientEvent('chatMessage', -1, "[OOC] - " .. name .. " (" .. userSource .. ")", {255, 255, 221}, message)
        end
    end

    print(name .. ': ' .. message)
end)

-- player join messages
AddEventHandler('playerActivated', function()
    TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(userSource) .. ' joined.')
end)

AddEventHandler('playerDropped', function(reason)
    --TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(userSource) ..' left (' .. reason .. ')')
	TriggerEvent("gps:removeEMSReqLookup")
end)

-- say command handler
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "say" then
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', -1, 'console', { 0, 0x99, 255 }, msg)
        RconPrint('CONSOLE: ' .. msg .. "\n")

        CancelEvent()
    end
end)

-- tell command handler
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "tell" then
        local target = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', tonumber(target), 'console', { 0, 0x99, 255 }, msg)
        RconPrint('CONSOLE: ' .. msg .. "\n")

        CancelEvent()
    end
end)

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

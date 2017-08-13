RegisterServerEvent('chatCommandEntered')
RegisterServerEvent('chatMessageEntered')

AddEventHandler('chatMessageEntered', function(name, color, message)
    print("message = " .. message)
    if not name or not color or not message or #color ~= 3 then
        return
    end
    local userSource = source
	TriggerEvent('es:getPlayerFromId', userSource, function(user)

		if user then

            local job = user.getJob()

			if(job == "cop") then

				name = "Police | " .. name
				color = {2, 111, 218}

			elseif job == "sheriff" then

				name = "Officer | " .. name
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
        TriggerClientEvent('chatMessage', -1, name, color, message)
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

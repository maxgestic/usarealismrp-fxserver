RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

-- open and clear new log file --
os.remove("C:/wamp/www/log.txt")

local LOG_FILE

AddEventHandler('_chat:messageEntered', function(name, color, message, location)
	if not name or not color or not message or #color ~= 3 then
		return
	end

	local userSource = source
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			local job = user.getActiveCharacterData("job")
			if(job == "cop") then
				name = "LSPD | " .. name
				color = {2, 111, 218}
			elseif job == "sheriff" then
				name = "BCSO | " .. name
				color = {2, 111, 218}
			elseif job == "highwaypatrol" then
				name = "Highway Patrol | " .. name
				color = {102, 153, 255}
			elseif job == "ems" then
				name = "EMS | " .. name
				color = {255, 51, 153}
			elseif job == "fire" then
				name = "Fire Department | " .. name
				color = {255, 0, 0}
			end
		else
			print("ERROR GETTING USER BY ID")
		end

		---------------------------------
		-- write to admin log LOG_FILE --
		---------------------------------
		LOG_FILE = io.open("C:/wamp/www/log.txt", "a")
		io.output(LOG_FILE)
		io.write(name .. " [" .. GetPlayerName(userSource) .. " / " .. GetPlayerIdentifiers(userSource)[1] .. "]" .. ': ' .. message .. "\r\n")
		io.close(LOG_FILE)

	TriggerEvent('chatMessageLocation', userSource, name, message, location)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessageLocation', -1, "[OOC] - " .. name .. " (" .. userSource .. ")",  { 255, 255, 255 }, message, location)
	end

	print(name .. " (" .. GetPlayerName(userSource) .. ") " .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
	local name = GetPlayerName(source)

	TriggerEvent('chatMessage', source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
	end

	CancelEvent()
end)

RegisterCommand('say', function(source, args, rawCommand)
	TriggerClientEvent('chatMessage', -1, (source == 0) and 'Government' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

-- test this
RegisterServerEvent("chat:sendToLogFile")
AddEventHandler("chat:sendToLogFile", function(source, message)
	local player = exports["essentialmode"]:getPlayerFromId(source)
	LOG_FILE = io.open("C:/wamp/www/log.txt", "a")
	io.output(LOG_FILE)
	io.write("[" .. GetPlayerName(source) .. " (#" .. source .. ") / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
	io.close(LOG_FILE)
end)

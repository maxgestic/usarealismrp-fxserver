RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

local LOG_FILE_NAME = "/var/www/html/log.txt"

-- open and clear new log file --
os.remove(LOG_FILE_NAME)

local LOG_FILE

AddEventHandler('_chat:messageEntered', function(name, color, message, location)
	if not name or not color or not message or #color ~= 3 then
		return
	end

	local char = exports["usa-characters"]:GetCharacter(source)
		if char then
			local job = char.get("job")
			if job == "cop" then
				name = "LSPD | " .. name
				color = {2, 111, 218}
			elseif job == "sheriff" then
				name = "SASP | " .. name
				color = {2, 111, 218}
			elseif job == "corrections" then
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
		end

		---------------------------------
		-- write to admin log LOG_FILE --
		---------------------------------
		LOG_FILE = io.open(LOG_FILE_NAME, "a")
		io.output(LOG_FILE)
		io.write(name .. " [" .. GetPlayerName(source) .. " / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
		if type(LOG_FILE) == "userdata" then -- userdata == FILE*
			io.close(LOG_FILE)
		end

	TriggerEvent('chatMessageLocation', source, name, message, location)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessageLocation', -1, "[Local OOC] - " .. name .. " (" .. source .. ")",  { 255, 255, 255 }, message, location, 50)
	end

	print(name .. " (" .. GetPlayerName(source) .. ") " .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
	local name = GetPlayerName(source)

	TriggerEvent('chatMessage', source, name, '/' .. command)

	CancelEvent()
end)

RegisterCommand('say', function(source, args, rawCommand)
	if source == 0 then
		TriggerClientEvent('chatMessage', -1, 'Government', { 255, 255, 255 }, rawCommand:sub(5))
	end
end)

-- test this
RegisterServerEvent("chat:sendToLogFile")
AddEventHandler("chat:sendToLogFile", function(source, message)
	LOG_FILE = io.open(LOG_FILE_NAME, "a")
	io.output(LOG_FILE)
	io.write("[" .. GetPlayerName(source) .. " (#" .. source .. ") / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
	if type(LOG_FILE) == "userdata" then -- userdata == FILE*
		io.close(LOG_FILE)
	end
end)

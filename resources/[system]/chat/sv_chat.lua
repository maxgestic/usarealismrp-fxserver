RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

-- remove last log file if it existed, only keep track of one for now  --
local LOG_FILE = io.open(exports["usa_rp2"]:GetLogFilePath(), "a")
if LOG_FILE then
	os.remove(exports["usa_rp2"]:GetLogFilePath())
	LOG_FILE = nil
end

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
		if not LOG_FILE then
			LOG_FILE = io.open("C:/wamp/www/log.txt", "a")
		end
		if LOG_FILE then
			io.output(LOG_FILE)
			io.write(name .. " [" .. GetPlayerName(source) .. " / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
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

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
	end

	CancelEvent()
end)

RegisterCommand('say', function(source, args, rawCommand)
	TriggerClientEvent('chatMessage', -1, (source == 0) and 'Government' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

RegisterServerEvent("chat:sendToLogFile")
AddEventHandler("chat:sendToLogFile", function(source, message)
	if not LOG_FILE then
		LOG_FILE = io.open(exports["usa_rp2"]:GetLogFilePath(), "a")
	end
	if LOG_FILE then
		io.output(LOG_FILE)
		io.write("[" .. GetPlayerName(source) .. " (#" .. source .. ") / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
		io.close(LOG_FILE)
	end
end)

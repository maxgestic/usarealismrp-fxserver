RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

local CUSTOM_LOG_ENABLED = false

local LOG_FILE_NAME = "/var/www/html/log.txt"

if CUSTOM_LOG_ENABLED then
	-- open and clear new log file --
	os.remove(LOG_FILE_NAME)
end

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
			elseif job == "sasp" then
				name = "SASP | " .. name
				color = {2, 111, 218}
			elseif job == "bcso" then
				name = "BCSO | " .. name
				color = {2, 111, 218}
			elseif job == "corrections" then
				name = "Corrections | " .. name
				color = {2, 111, 218}
			elseif job == "ems" then
				name = "EMS | " .. name
				color = {255, 51, 153}
			elseif job == "fire" then
				name = "Fire Department | " .. name
				color = {255, 0, 0}
			end
		end

		if CUSTOM_LOG_ENABLED then
			---------------------------------
			-- write to admin log LOG_FILE --
			---------------------------------
			LOG_FILE = io.open(LOG_FILE_NAME, "a")
			io.output(LOG_FILE)
			io.write(name .. " [" .. GetPlayerName(source) .. " / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
			if type(LOG_FILE) == "userdata" then -- userdata == FILE*
				io.close(LOG_FILE)
			end
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
	if CUSTOM_LOG_ENABLED then
		LOG_FILE = io.open(LOG_FILE_NAME, "a")
		io.output(LOG_FILE)
		io.write("[" .. GetPlayerName(source) .. " (#" .. source .. ") / " .. GetPlayerIdentifiers(source)[1] .. "]" .. ': ' .. message .. "\r\n")
		if type(LOG_FILE) == "userdata" then -- userdata == FILE*
			io.close(LOG_FILE)
		end
	end
end)

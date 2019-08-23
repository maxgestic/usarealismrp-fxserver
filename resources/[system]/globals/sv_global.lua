function sendLocalActionMessageChat(message, location, range)
	-- set default range
	if not range then
		range = 30
	end

	--TriggerClientEvent("globals:startActionMessage", -1, message, range, src)

	TriggerClientEvent(
		'chatMessageLocation',
		-1,
		"",
		{255, 240, 240},
		message,
		location,
		range
	)
end

function sendLocalActionMessage(_source, text, maxDist, time)
	if not maxDist then maxDist = 10.0 end
	if not time then time = 3000 end
	TriggerClientEvent("globals:startActionMessage", -1, _source, text, maxDist, time)
end

function notifyPlayersWithJobs(target_jobs, msg)
	exports["usa-characters"]:GetCharacters(function(players)
		if not players then
			return
		end
		for id, player in pairs(players) do
			if id and player then
				local job = player.get("job")
				for i = 1, #target_jobs do
					if job == target_jobs[i] then
						TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
					end
				end
			end
		end
	end)
end

function notifyPlayersWithJob(target_job, msg)
 	exports["usa-characters"]:GetCharacters(function(players)
		if not players then
			return
		end
		for id, player in pairs(players) do
			if id and player then
				local job = player.get("job")
				if job == target_job then
					TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
				end
			end
		end
	end)
end

function setJob(src, job)
	exports["usa-characters"]:SetCharacterField(src, "job", job)
	TriggerClientEvent("usa:notify", src, "Job set to: " .. job)
end

TriggerEvent('es:addGroupCommand', 'setjob', 'owner', function(source, args, char)
	setJob(source, args[2])
end, {
	help = "DEBUG: SET YOUR JOB"
})


exports("PerformDBCheck", function(scriptName, db, doneFunc)
	PerformHttpRequest("http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. "/" .. db .. "/_compact", function(err, rText, headers)
	end, "POST", "", {["Content-Type"] = "application/json", Authorization = "Basic " .. exports["essentialmode"]:getAuth()})

	PerformHttpRequest("http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. "/" .. db, function(err, rText, headers)
		if err == 0 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		elseif err == 412 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		elseif err == 401 then
			print("------------------------------------------------------------------------------------------------")
			print("--- Error detected in authentication, please take a look at config.lua inside essentialmode. ---")
			print("------------------------------------------------------------------------------------------------")
		elseif err == 201 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		else
			print("------------------------------------------------------------------------------------------------")
			print("--- Unknown error detected ( " .. err .. " ): " .. rText)
			print("------------------------------------------------------------------------------------------------")
		end
		-- Function to execute when finished checking DB --
		if doneFunc then
			doneFunc()
		end
	end, "PUT", "", {Authorization = "Basic " .. exports["essentialmode"]:getAuth()})
end)

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

RegisterServerEvent("globals:send3DText")
AddEventHandler("globals:send3DText", function(msg)
	sendLocalActionMessage(source, msg)
end)

function GetHoursFromTime(time)
	return math.floor(os.difftime(os.time(), time) / (60 * 60))
end

function SendDiscordLog(webhookUrl, msg)
    PerformHttpRequest(webhookUrl, function(err, text, headers)
    end, "POST", json.encode({
		content = msg
		--[[
        embeds = {
            {
                description = (msg or "No Message"),
                color = (color or 524288),
                author = {
                    name = (title or "No Title")
                }
            }
		}
		--]]
    }), { ["Content-Type"] = 'application/json' })
end
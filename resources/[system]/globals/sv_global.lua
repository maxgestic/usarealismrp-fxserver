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
		{171, 67, 227},
		message,
		location,
		range
	)
end

function sendLocalActionMessage(src, message, range)
	-- set default range
	if not range then
		range = 30
	end

	TriggerClientEvent("globals:startActionMessage", -1, message, range, src)

		--[[
		TriggerClientEvent(
		'chatMessageLocation',
		-1,
		"",
		{171, 67, 227},
		message,
		location,
		range
	)
	--]]
end

function notifyPlayersWithJobs(target_jobs, msg)
 	TriggerEvent("es:getPlayers", function(players)
		if not players then
			return
		end

		for id, player in pairs(players) do
			if id and player then
				local job = player.getActiveCharacterData("job")
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
 	TriggerEvent("es:getPlayers", function(players)
		if not players then
			return
		end

		for id, player in pairs(players) do
			if id and player then
				local job = player.getActiveCharacterData("job")
				if job == target_job then
					TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
				end
			end
		end
	end)
end

function setJob(src, job)
	local user = exports["essentialmode"]:getPlayerFromId(src)
	if user then
		user.setActiveCharacterData("job", job)
		TriggerClientEvent("usa:notify", src, "Job set to: " .. job)
		print("job set!")
	end
end

TriggerEvent('es:addGroupCommand', 'setjob', 'owner', function(source, args, user)
	setJob(source, args[2])
end, {
	help = "DEBUG: SET YOUR JOB"
})

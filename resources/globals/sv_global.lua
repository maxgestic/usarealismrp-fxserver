function notifyPlayersWithJobs(target_jobs, msg)
  TriggerEvent("es:getPlayers", function(players)
		if players then
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
		end
	end)
end

function notifyPlayersWithJob(target_job, msg)
  TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local job = player.getActiveCharacterData("job")
					if job == target_job then
						TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
					end
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
  if user.getGroup() == "owner" then
    setJob(source, args[2])
  end
end, {
	help = "DEBUG: SET YOUR JOB"
})

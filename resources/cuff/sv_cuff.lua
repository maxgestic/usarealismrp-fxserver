TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff" }, function(source, args, user, location)
	local userSource = tonumber(source)
	--local tPID = tonumber(args[2])
	--if GetPlayerName(tPID) then
		TriggerClientEvent("cuff:attemptToCuffNearest", userSource)
		--TriggerClientEvent("cuff:Handcuff", tPID)
		-- play anim:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
		TriggerClientEvent('chatMessageLocation', -1, "", {255, 0, 0}, " ^6" .. user.getActiveCharacterData("fullName") .. " handcuffs person.", location)
	--end
end, {help = "Cuff the nearest player."})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id)
	local usource = source
	TriggerEvent("es:getPlayerFromId", usource, function(user)
		playerJob = user.getActiveCharacterData("job")
		if playerJob == "sheriff" or
			playerJob == "cop" then
			print("cuffing player with id: " .. id)
			TriggerClientEvent("cuff:Handcuff", tonumber(id), GetPlayerName(usource))
		end
	end)
end)

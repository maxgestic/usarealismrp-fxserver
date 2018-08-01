TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff", "corrections" }, function(source, args, user, location)
	local userSource = tonumber(source)
	if args[2] then -- id was passed as param
		local tPID = tonumber(args[2])
		if GetPlayerName(tPID) then
			TriggerClientEvent("cuff:Handcuff", tPID)
		end
	else -- no ID, find nearest person to target
		TriggerClientEvent("cuff:attemptToCuffNearest", userSource)
	end
		-- play anim:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
		local msg = user.getActiveCharacterData("fullName") .. " handcuffs person."
		exports["globals"]:sendLocalActionMessage(msg, location)
end, {help = "Cuff the nearest player.", id = "ID # (Optional)"})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id)
	local usource = source
	TriggerEvent("es:getPlayerFromId", usource, function(user)
		playerJob = user.getActiveCharacterData("job")
		if playerJob == "sheriff" or playerJob == "cop" or playerJob == "corrections" then
			print("cuffing player with id: " .. id)
			TriggerClientEvent("cuff:Handcuff", tonumber(id), GetPlayerName(usource))
		end
	end)
end)

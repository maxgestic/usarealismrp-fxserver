TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff" }, function(source, args, user, location)
	local userSource = tonumber(source)
	local tPID = tonumber(args[2])
	if GetPlayerName(tPID) then
		TriggerClientEvent("cuff:Handcuff", tPID)
		-- play anim:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
		TriggerClientEvent('chatMessageLocation', -1, "", {255, 0, 0}, " ^6" .. user.getActiveCharacterData("fullName") .. " handcuffs person.", location)
	end
end, {
	help = "Cuff a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

RegisterServerEvent("cuff:Handcuff")
AddEventHandler("cuff:Handcuff", function(id)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		playerJob = user.getActiveCharacterData("job")
		if playerJob == "sheriff" or
			playerJob == "cop" then
			print("cuffing player with id: " .. id)
			TriggerClientEvent("cuff:Handcuff", tonumber(id), GetPlayerName(source))
		end
	end)
end)

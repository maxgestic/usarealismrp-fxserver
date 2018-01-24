TriggerEvent('es:addJobCommand', 'cuff', { "police", "sheriff" }, function(source, args, user)
	local userSource = tonumber(source)
	if args[2] ~= nil then
		local tPID = tonumber(args[2])
		TriggerClientEvent("cuff:Handcuff", tPID)
		-- play anim:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 2)
	end
end, {
	help = "Cuff a player",
	params = {
		{ name = "id", help = "Players ID" }
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

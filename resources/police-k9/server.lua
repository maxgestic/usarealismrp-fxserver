TriggerEvent('es:addCommand', 'k9', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" or user_job == "police" or user_job == "ems" then
		TriggerClientEvent("k9:transform", source)
	else
		TriggerClientEvent("chatMessage", source, "K9 Keeper", {255, 50, 50}, "You're not authorized to have access to the K9's");
	end
end)

TriggerEvent('es:addCommand', 'k9', function(source, args, user)
	-- m. lentz = steam:110000106d47d14
	if user.getJob() == "sheriff" or user.getJob() == "police" or user.getJob() == "ems" then
		TriggerClientEvent("k9:transform", source)
	else
		TriggerClientEvent("chatMessage", source, "K9 Keeper", {255, 50, 50}, "You're not authorized to have access to the K9's");
	end
end)

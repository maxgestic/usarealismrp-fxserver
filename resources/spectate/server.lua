TriggerEvent('es:addCommand', 'spectate', function(source, args, user)
	local user_group = user.getGroup()
	if user_group == "superadmin" or user_group == "owner" or user_group == "admin" then
		TriggerClientEvent('admin:spectate', source, tonumber(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
	end
end)

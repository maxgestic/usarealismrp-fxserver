TriggerEvent('es:addCommand', 'spectate', function(source, args, user)
	if user.group.group == "superadmin" or user.group.group == "owner" or user.group.group == "admin" then
		TriggerClientEvent('admin:spectate', source, tonumber(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
	end
end)

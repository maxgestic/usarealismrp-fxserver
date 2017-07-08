-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'text', function(source, args, user)

	local targetPlayer = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local msg = table.concat(args, " ")

	if msg and targetPlayer and type(targetPlayer) ~= "number" then
		TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
	else
		TriggerClientEvent("pm:help", source)
	end

end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'TEXT', function(source, args, user)

	local targetPlayer = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local msg = table.concat(args, " ")

	if msg and targetPlayer and type(targetPlayer) ~= "number" then
		TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
	else
		TriggerClientEvent("pm:help", source)
	end

end)

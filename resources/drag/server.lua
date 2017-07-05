TriggerEvent('es:addCommand', 'drag', function(source, args, user)

	local argument = args[2] -- player id to check license

	if argument == nil or type(tonumber(argument)) == nil then
	
		TriggerClientEvent("chatMessage", source, "SYSTEM", { 0, 141, 155 }, "example: /drag <id>")
		
	else 
			
		if(GetPlayerName(tonumber(argument)))then
			if argument == source then
				TriggerClientEvent('chatMessage', source, "SYSTEM", { 0, 141, 155 }, "You cannot drag yourself!")
			else
				TriggerClientEvent("dr:drag", tonumber(argument), source)
			end
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", { 0, 141, 155 }, "Incorrect Player ID")
		end		
	end
end)
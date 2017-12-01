TriggerEvent('es:addCommand', 'drag', function(source, args, user)
	if user then
		if user.getJob() == "sheriff" or user.getJob() == "cop" or user.getJob() == "ems" or user.getJob() == "fire" or user.getGroup() == "mod" or user.getGroup() == "admin" then
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
		else
			print("wrong job for drag")
			-- wrong job
		end
		--print("user nil for drag")
		-- user did not exist
	end
end)

RegisterServerEvent("dr:dragPlayer")
AddEventHandler("dr:dragPlayer", function(id)
	TriggerClientEvent("dr:drag", tonumber(id), source)
end)

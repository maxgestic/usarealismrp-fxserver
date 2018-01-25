TriggerEvent('es:addCommand', 'drag', function(source, args, user)
	if user then
		local userJob = user.getActiveCharacterData("job")
		local userGroup = user.getGroup()
		local argument = args[2] -- player id to check license
		if userJob == "sheriff" or userJob == "cop" or userJob == "ems" or userJob == "fire" then
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
			if argument == nil or type(tonumber(argument)) == nil then
				TriggerClientEvent("chatMessage", source, "SYSTEM", { 0, 141, 155 }, "example: /drag <id>")
			else
				TriggerClientEvent("crim:areHandsTied", tonumber(argument), source, tonumber(argument), "drag")
			end
		end
		--print("user nil for drag")
		-- user did not exist
	end
end, {
	help = "Drag a tied up or handcuffed player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

RegisterServerEvent("dr:dragPlayer")
AddEventHandler("dr:dragPlayer", function(id)
	TriggerClientEvent("dr:drag", tonumber(id), source)
end)

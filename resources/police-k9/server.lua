TriggerEvent('es:addCommand', 'k9', function(source, args, user)
	-- tim
	-- agome
	if GetPlayerIdentifiers(source)[1] == "steam:110000105e9e6f1" or GetPlayerIdentifiers(source)[1] == "steam:11000010f138f99" then
		TriggerClientEvent("k9:transform", source)
	else
		TriggerClientEvent("chatMessage", source, "K9 Keeper", {255, 50, 50}, "You're not authorized to have access to the K9's");
	end
end)

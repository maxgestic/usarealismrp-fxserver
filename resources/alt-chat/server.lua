TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {255, 255, 255}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
end)

-- 

TriggerEvent('es:addCommand', 'ad', function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. user.getActiveCharacterData("fullName"), {171, 67, 227}, table.concat(args, " "))
end, {help = "boardcast an advertisement", params = {{name = "message", help = "Broadcast an advertisement."}}})

TriggerEvent('es:addCommand', 'me', function(source, args, user, location)
	table.remove(args,1)
	TriggerClientEvent('chatMessageLocation', -1, "", {}, " ^6" .. user.getActiveCharacterData("fullName") .. " " .. table.concat(args, " "), location)
end, {help = "talk as an action", params = {{name = "message", help = "Talk as an action."}}})

TriggerEvent('es:addCommand', 'showid', function(source, args, user, location)
	table.remove(args, 1)
	message = table.concat(args, " ")
	TriggerClientEvent('chatMessageLocation', -1, "", {255, 0, 0}, " ^6" .. GetPlayerName(source) .. " shows ID.", location)
	TriggerClientEvent('chatMessageLocation', -1, "[ID]", {171, 67, 227}, "^2Name: ^4" .. GetPlayerName(source) .. " ^0- ^2SSN: ^4" .. source, location)
end, {help = "show your id to an officer"})
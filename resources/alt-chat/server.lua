TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {255, 255, 255}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
end)

TriggerEvent('es:addCommand', 'ad', function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. user.getActiveCharacterData("fullName"), {171, 67, 227}, table.concat(args, " "))
end, {help = "Send an advertisement.", params = {{name = "message", help = "the advertisement"}}})

TriggerEvent('es:addCommand', 'anonad', function(source, args, user)
	local umoney = user.getActiveCharacterData("money")
	if umoney > 200 then
		table.remove(args, 1)
		TriggerClientEvent('chatMessage', -1, "[Advertisement]", {171, 67, 227}, table.concat(args, " "))
		user.setActiveCharacterData("money", umoney - 200)
	else
		TriggerClientEvent("usa:notify", source, "You don't have enough money!")
	end
end, {help = "Send an anonymous advertisement. ($200)", params = {{name = "message", help = "the advertisement"}}})

TriggerEvent('es:addCommand', 'me', function(source, args, user, location)
	table.remove(args,1)
	local msg = table.concat(args, " ")
	exports["globals"]:sendLocalActionMessage(source, msg)
	exports["globals"]:sendLocalActionMessageChat(user.getActiveCharacterData("fullName") .. " " .. msg, location)
end, {help = "Talk as yourself doing an action.", params = {{name = "message", help = "the action"}}})

TriggerEvent('es:addCommand', 'showid', function(source, args, user, location)
	showid(source, user, location)
end, {help = "Present your identifcation card / DL."})

TriggerEvent('es:addCommand', 'id', function(source, args, user, location)
	showid(source, user, location)
end, {help = "Present your identifcation card / DL."})

function showid(src, u, location)
	local char_name = u.getActiveCharacterData("fullName")
	local dob = u.getActiveCharacterData("dateOfBirth")
	exports["globals"]:sendLocalActionMessage(src, "Shows ID.")
	local msg = "^0*[ID]^r ^2Name: ^4" .. char_name .. " ^0- ^2SSN: ^4" .. src .. " ^0 - ^2DOB: ^4" .. dob
	exports["globals"]:sendLocalActionMessageChat(msg, location)
end

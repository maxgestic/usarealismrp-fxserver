TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {255, 255, 255}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
end)

TriggerEvent('es:addCommand', 'ad', function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. user.getActiveCharacterData("fullName"), {171, 67, 227}, table.concat(args, " "))
end, {help = "Send a server-wide advertisement.", params = {{name = "message", help = "the advertisement"}}})

TriggerEvent('es:addCommand', 'me', function(source, args, user, location)
	table.remove(args,1)
	local msg = "^0* " .. user.getActiveCharacterData("fullName") .. " " .. table.concat(args, " ")
	exports["globals"]:sendLocalActionMessage(msg, location)
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
	exports["globals"]:sendLocalActionMessage(char_name .. " shows ID.", location)
	local msg = "^0*[ID]^r ^2Name: ^4" .. char_name .. " ^0- ^2SSN: ^4" .. src .. " ^0 - ^2DOB: ^4" .. dob
	exports["globals"]:sendLocalActionMessage(msg, location)
end

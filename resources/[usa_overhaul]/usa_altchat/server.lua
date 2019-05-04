TriggerEvent('es:addCommand', '911', function(source, args, user)
	TriggerClientEvent('chatMessage', tonumber(source), "", {255, 255, 255}, "^3/911 is no longer a usable command, buy a phone from the general store and use it to call 911.")
end)

TriggerEvent('es:addCommand', 'ad', function(source, args, user)
	local inventory = user.getActiveCharacterData('inventory')
	for i = 1, #inventory do
		local item = inventory[i]
		if string.find(item.name, 'Phone') then
			table.remove(args, 1)
			TriggerClientEvent('chatMessage', -1, "[Advertisement] - " .. user.getActiveCharacterData("fullName"), {171, 67, 227}, table.concat(args, " "))
			return
		end
	end
	TriggerClientEvent('usa:notify', source, 'You do not have a cell phone!')
end, {help = "Send an advertisement.", params = {{name = "message", help = "the advertisement"}}})

local lastAnonAdAuthor = nil
TriggerEvent('es:addCommand', 'anonad', function(source, args, user)
	local umoney = user.getActiveCharacterData("money")
	if umoney >= 200 then
		local inventory = user.getActiveCharacterData('inventory')
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, 'Phone') then
				table.remove(args, 1)
				TriggerClientEvent('chatMessage', -1, "[Advertisement]", {171, 67, 227}, table.concat(args, " "))
				user.setActiveCharacterData("money", umoney - 200)
				lastAnonAdAuthor = "(#" .. source .. ") " .. user.getActiveCharacterData("fullName")
				return
			end
		end
		TriggerClientEvent('usa:notify', source, 'You do not have a cell phone!')
	else
		TriggerClientEvent("usa:notify", source, "You don't have enough money!")
	end
end, {help = "Send an anonymous advertisement. ($200)", params = {{name = "message", help = "the advertisement"}}})

TriggerEvent('es:addGroupCommand', 'lastanonad', 'mod', function(source, args, user)
	if lastAnonAdAuthor then
		TriggerClientEvent('chatMessage', source, "SYSTEM", {171, 67, 227}, "The last anon ad was sent by: " .. lastAnonAdAuthor)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {171, 67, 227}, "There is no last anon ad author recorded.")
	end
end, {
	help = "Find out who sent the last anonymous advertisement"
})

TriggerEvent('es:addCommand', 'me', function(source, args, user, location)
	table.remove(args,1)
	local msg = table.concat(args, " ")
	TriggerEvent('display:shareDisplayBySource', source, msg, 5, 370, 10, 8000, true)
end, {help = "Talk as yourself doing an action.", params = {{name = "message", help = "the action"}}})

TriggerEvent('es:addCommand', 'showid', function(source, args, user, location)
	showid(source, user, location)
end, {help = "Present your identification card / DL."})

TriggerEvent('es:addJobCommand', 'fakeid', {'sheriff', 'police'}, function(source, args, user, location)
	if user.getActiveCharacterData("policeRank") < 4 then
        TriggerClientEvent("usa:notify", source, "Not high enough rank!")
        return
    end
	local fullName = args[2] ..' '.. args[3]
	local dob = args[4] ..'-'.. args[5] ..'-'.. args[6]
	exports["globals"]:sendLocalActionMessage(src, "shows ID")
	local msg = "^4^*[STATE ID]^0 Name: ^r" .. fullName .. " ^4^*|^0 SSN: ^r" .. source .. " ^4^*| ^0DOB: ^r" .. dob
	exports["globals"]:sendLocalActionMessageChat(msg, location)
end, {
	help = "Present a fake identification card.",
	params = {
		{ name = "first name", help = "first name to show on ID" },
		{ name = "last name", help = "last name to show on ID" },
		{ name = "dob year", help = "date of birth year to show on ID" },
		{ name = "dob month", help = "date of birth month to show on ID" },
		{ name = "dob day", help = "date of birth day to show on ID" }
	}
})

TriggerEvent('es:addCommand', 'id', function(source, args, user, location)
	showid(source, user, location)
end, {help = "Present your identification card / DL."})

function showid(src, u, location)
	local char_name = u.getActiveCharacterData("fullName")
	local dob = u.getActiveCharacterData("dateOfBirth")
	exports["globals"]:sendLocalActionMessage(src, "shows ID")
	local msg = "^4^*[STATE ID]^0 Name: ^r" .. char_name .. " ^4^*|^0 SSN: ^r" .. src .. " ^4^*| ^0DOB: ^r" .. dob
	exports["globals"]:sendLocalActionMessageChat(msg, location)
end

RegisterServerEvent("phone:deleteContact")
AddEventHandler("phone:deleteContact", function(data)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") and item.number == data.phone then
				local contacts = item.contacts
				print("phone found!")
				for j = 1, #contacts do
					local contact = contacts[j]
					if contact.number == data.numberToDelete then
						print("matching contact found to delete!")
						table.remove(contacts, j)
						print("contact removed from table!")
						inventory[i].contacts = contacts
						user.setActiveCharacterData("inventory", inventory)
						print("contact removed!")
						for k = 1, #inventory[i].contacts do
							print("inventory[i].contacts[k].first = " .. inventory[i].contacts[k].first)
						end
						return
					end
				end
				return
			end
		end
	end)
end)

RegisterServerEvent("phone:getContacts")
AddEventHandler("phone:getContacts", function(number)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") and item.number == number then
				local contacts = item.contacts
				print("retrieved contacts!")
				TriggerClientEvent("phone:loadedContacts", userSource, contacts)
				return
			end
		end
	end)
end)

RegisterServerEvent("phone:addContact")
AddEventHandler("phone:addContact", function(data)
	local userSource = tonumber(source)
	local sourcePhone = data.source
	local newContact = {
		number = data.number,
		first = data.first,
		last = data.last
	}
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") and item.number == sourcePhone then
				local contacts = item.contacts
				table.insert(inventory[i].contacts, newContact)
				user.setActiveCharacterData("inventory", inventory)
				print("contact saved!")
				return
			end
		end
	end)
end)

RegisterServerEvent("phone:send911Message")
AddEventHandler("phone:send911Message", function(data, dont_send_msg, no_caller_id)
	local help_online  = false
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			local player_job = player.getActiveCharacterData("job")
			if player_job == "ems" or player_job == "sheriff" or player_job == "police" then
				if no_caller_id then
					TriggerClientEvent('chatMessage', playerSource, "911", {255, 20, 10}, message .. " (" .. data.location .. ")")
					TriggerClientEvent("phone:notify", playerSource, "~r~911:\n~w~"..message)
				else
					TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message .. " (" .. data.location .. ")")
					TriggerClientEvent("phone:notify", playerSource, "~r~911 (Caller: # ".. userSource .. "):\n~w~"..message)
				end
				help_online = true
			end
		end
		if not dont_send_msg then
			if help_online then
				TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "^3911^0 was notified!")
				TriggerClientEvent("usa:notify", userSource, "~r~911~w~ was notified!")
			else
				TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "Sorry, there is no one on duty to help!")
				TriggerClientEvent("usa:notify", userSource, "Sorry, there is no one on duty to help!")
			end
		end
	end)
end)

RegisterServerEvent("phone:sendTaxiMessage")
AddEventHandler("phone:sendTaxiMessage", function(data)
	local tow_online = false
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getActiveCharacterData("job") == "taxi" then
				TriggerClientEvent('chatMessage', playerSource, "Taxi Requested! (Caller: #" .. userSource .. ")", {251, 229, 5}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", playerSource, "~y~TAXI REQUEST (Caller: # ".. userSource .. "):\n~w~"..message)
				tow_online = true
			end
		end
		if tow_online then
			TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "A ^3taxi^0 has been notified!")
			TriggerClientEvent("usa:notify", userSource, "A ~y~taxi ~w~has been notified!")
		else
			TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "Sorry, there is no one on duty as taxi!")
			TriggerClientEvent("usa:notify", userSource, "~y~Sorry, there is no one on duty as taxi!")
		end
	end)
end)

RegisterServerEvent("phone:sendTowMessage")
AddEventHandler("phone:sendTowMessage", function(data)
	local tow_online = false
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getActiveCharacterData("job") == "tow" then
				TriggerClientEvent('chatMessage', playerSource, "Tow Requested! (Caller: #" .. userSource .. ")", {118, 120, 251}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", playerSource, "~y~TOW REQUEST (Caller: # ".. userSource .. "):\n~w~"..message)
				tow_online = true
			end
		end
		if tow_online then
			TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "A ^3tow truck^0 has been notified!")
			TriggerClientEvent("usa:notify", userSource, "A ~y~tow truck~w~ has been notified!")
		else
			TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "Sorry, no one is on duty as tow!")
			TriggerClientEvent("usa:notify", userSource, "~y~Sorry, no one is on duty as tow!")
		end
	end)
end)

RegisterServerEvent("phone:sendTweet")
AddEventHandler("phone:sendTweet", function(data)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if user then
			local name = user.getActiveCharacterData("fullName")
			TriggerClientEvent('chatMessage', -1, "[TWEET] - " .. name, {29,161,242}, data.message)
		end
	end)
end)


RegisterServerEvent("phone:sendTextToPlayer")
AddEventHandler("phone:sendTextToPlayer", function(data)
	local userSource = tonumber(source)
	if type(tonumber(data.toNumber)) == "number" then --Check if phone number is valid
		print(data.toNumber .. "is a number")
		---------------
		-- VARIABLES --
		---------------
		local toNumber = tonumber(data.toNumber)
		local fromNumber = tonumber(data.fromNumber)
		local toPlayer = 0
		local fromPlayer = userSource
		local toName = "Unknown"
		local fromName = data.fromName
		local messageSent = false
		local msg = data.message
		local from = "Undefined" -- what is displayed for the name of the sender of a text

		---------------------------------------------------------------------------------------------------------
		-- Check all online players' inventories for a cell phone item with a phone number equal to 'toNumber' --
		-- toNumber: the field passed in from the number field in the phone GUI
		---------------------------------------------------------------------------------------------------------
		TriggerEvent("es:getPlayers", function(players)
			local allPlayers = players
			if allPlayers then
				for id, player in pairs(allPlayers) do
					if id and player then
						print("searching inventory items of player at: " .. id .. " for a cell phone with toNumber")
						local inventory = player.getActiveCharacterData("inventory")
						if inventory then
							--//Check entire user inventory for toNumber phone
							for j = 1, #inventory do
								if inventory[j] then
									-- check for a matching phone number in player items
									if string.find(inventory[j].name, "Cell Phone") and tonumber(inventory[j].number) == tonumber(toNumber) then
										print("phone found with toNumber...")
										-- phone found with toNumber
										convoExistedForUser = false
										toPlayer = tonumber(id)
										--toName = inventory[j].owner
										-- Add conversation to and from phone
										item = inventory[j]
										-- Check for existing conversation with fromNumber
										for x = 1, #item.conversations do
											local conversation = item.conversations[x]
											-- does this phone already have a conversation with that phone number?
											if conversation.partnerId == fromNumber then
												print("Player #" .. toPlayer .. " had existing convo with partnerId = " .. fromNumber)
												-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
												if getNameFromContacts(item, fromNumber) then
													from = getNameFromContacts(item, fromNumber)
												else
													from = fromNumber
												end
												local message = {
													timestamp = os.date("%c", os.time()),
													from = from,
													--to = item.owner,
													to = "Me",
													message = msg
												}
												if #inventory[j].conversations[x].messages > 15 then table.remove(inventory[j].conversations[x].messages, 1) print("removed message! maxed out!") end
												table.insert(inventory[j].conversations[x].messages, message)
												player.setActiveCharacterData("inventory", inventory)
												convoExistedForUser = true
												TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
												TriggerClientEvent("swayam:notification", tonumber(toPlayer), from, msg, "CHAR_DEFAULT")
												messageSent = true
												print("matching convo found for player receiving text!")
												--TriggerClientEvent("swayam:notification", toPlayer, "From Someone", "Some Message", "CHAR_DEFAULT")
												--return
												break
											end
										end
										if not convoExistedForUser then
											print("no convo found for users! creating and inserting now!")
											-- no previous converstaion with that partner, create new one
											-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
											if getNameFromContacts(item, fromNumber) then
												from = getNameFromContacts(item, fromNumber)
												print("name set for from field!!")
											else
												from = fromNumber
												print("name not set for from field!!")
											end
											print("creating text message...")
											print("from = " .. from)
											print("to = 'Me'")
											print("msg = " .. msg)
											local message = {
												timestamp = os.date("%c", os.time()),
												from = from,
												--to = item.owner,
												to = "Me",
												message = msg
											}
											print("creating conversation...")
											print("partnerName = " .. fromName)
											print("partnerId = " .. fromNumber)
											local conversation = {
												partnerName = from,
												partnerId = fromNumber,
												messages = {message}
											}
											table.insert(inventory[j].conversations, 1, conversation) -- insert at front
											player.setActiveCharacterData("inventory", inventory)
											TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
											TriggerClientEvent("swayam:notification", tonumber(toPlayer), from, msg, "CHAR_DEFAULT")
											--TriggerClientEvent("swayam:notification", tonumber(toPlayer), "From Someone", "Some Message", "CHAR_DEFAULT")
											messageSent = true
											print("convo inserted!")
											--return
										end
									end
								end
							end
						end
					end
				end
			end
		end)
		print("SECOND HALF! INSERTING MSG INTO SENDING PLAYER CELL PHONE")
		if messageSent == true then
			print("messageSent = true!")
			convoExistedForUser = false
			TriggerEvent('es:getPlayerFromId', tonumber(userSource), function(user)
				local inventory = user.getActiveCharacterData("inventory")
				for j = 1, #inventory do
					if tonumber(inventory[j].number) == tonumber(fromNumber) then
						print("found matching fromNumber!")
						item = inventory[j]
						for x = 1, #item.conversations do
							local conversation = item.conversations[x]
							if conversation.partnerId == toNumber then
								print("player already had a conversation with that toNumber!")
								-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
								if getNameFromContacts(item, toNumber) then
									toName = getNameFromContacts(item, toNumber)
									print("name set for from toName!!")
								else
									toName = toNumber
									print("name not set for from toName!!")
								end
								print("creating text message...")
								print("from = Me")
								print("to = " .. toName)
								print("msg = " .. msg)
								local message = {
									timestamp = os.date("%c", os.time()),
									from = "Me",
									to = toName,
									message = msg
								}
								if #inventory[j].conversations[x].messages > 15 then table.remove(inventory[j].conversations[x].messages, 1) print("removed message! maxed out!") end
								table.insert(inventory[j].conversations[x].messages, message)
								user.setActiveCharacterData("inventory", inventory)
								convoExistedForUser = true
								print("convo also existed for the user who sent the text message!")
							end
						end
						if not convoExistedForUser then
							print("no convo found for users! creating and inserting now!")
							-- no previous converstaion with that partner, create new one
							-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
							if getNameFromContacts(item, toNumber) then
								toName = getNameFromContacts(item, toNumber)
								print("name set for from toName!!")
							else
								toName = toNumber
								print("name not set for from toName!!")
							end
							print("creating text message...")
							print("from = Me")
							print("to = " .. toName)
							print("msg = " .. msg)
							local message = {
								timestamp = os.date("%c", os.time()),
								from = "Me",
								to = toName,
								message = msg
							}
							print("creating conversation...")
							print("partnerName = " .. toName)
							print("partnerId = " .. toNumber)
							local conversation = {
								partnerName = toName,
								partnerId = toNumber,
								messages = {message}
							}
							table.insert(inventory[j].conversations, 1, conversation) -- insert at front
							user.setActiveCharacterData("inventory", inventory)
							print("convo inserted!")
						end
					end
				end
			end)
		else
			TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Number does not exist or out of coverage area. Please check the number and try again.", "CHAR_MP_DETONATEPHONE")
		end
	else -- Phone number is invalid
		TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Please check the number and try again.", "CHAR_MP_DETONATEPHONE")
	end
end)

RegisterServerEvent("phone:checkForPhone")
AddEventHandler("phone:checkForPhone", function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == "Cell Phone" then
				TriggerClientEvent("phone:openPhone", source)
				return
			end
		end
		-- at this point, the player has no cell phone
		TriggerClientEvent("chatMessage", source, "", {}, "^3You do not own a cell phone!")
		print("found no cell phone on player! not opening cell phone ui!")
	end)
end)

RegisterServerEvent("phone:loadMessages")
AddEventHandler("phone:loadMessages", function(number)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local conversationsToSendToPhone = {}
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") and item.number == number then
				local conversations = item.conversations
				if conversations then
					print("loaded phone conversations with #: " .. #conversations)

					for j = 1, 10 do
						--print("inserted convo #" .. j)
						table.insert(conversationsToSendToPhone, conversations[j])
					end

					TriggerClientEvent("phone:loadedMessages", source, conversationsToSendToPhone)
				end
			end
		end
	end)
end)

RegisterServerEvent("phone:getMessagesWithThisId")
AddEventHandler("phone:getMessagesWithThisId", function(targetId)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") then
				local conversations = item.conversations
				for x = 1, #conversations do
					print("checking conversation #" .. x)
					if conversations[x].partnerId == tonumber(targetId) then
						print("found matching conversation for id: " .. targetId)
						print("#conversations[x].messages = " .. #(conversations[x].messages))
						TriggerClientEvent("phone:loadedMessagesFromId", userSource, conversations[x].messages, targetId)
						return
					end
				end
				-- no matching conversation found
			end
		end
		-- no cell phone found
	end)
end)

--//To test phone:sendTextToPlayer args[2] = message, args[3] = toNumber, args[4] = fromNumber, args[5] = fromName
TriggerEvent('es:addCommand', 'testsms', function(source, args, user)
	if user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
		if args[2] and args[3] and args[4] and args[5] then
			data = {
				message = args[2],
				id = args[3],
				fromId = args[4],
				fromName = args[5]
			}
			TriggerEvent("phone:sendTextToPlayer", source, data)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "USAGE: /testsms message toNumber fromNumber fromName")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You're not authorized to use this command!")
	end
end)

-- P1: phone item
-- P2: phone number
function getNameFromContacts(phone, number)
	local contacts = phone.contacts
	-- look through contact list for matching phone number
	print("#contacts in phone passed in = " .. #contacts)
	for i = 1, #contacts do
		if tonumber(contacts[i].number) == number then
			print("matching number found in contacts!")
			-- return name of contact with that phone number
			return (contacts[i].first .. " " .. contacts[i].last)
		end
	end
	-- at this point, no match was found in contacts for that number
	print("no match was found for name in contacts! returning nil!")
	return nil
end

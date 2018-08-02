--# by: minipunch
--# for USA REALISM rp
--# Phone script to make phone calls and send texts in game with GUI phone
--# requires database(s): "phones"

function CreateNewPhone(phone)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.createDocumentWithId("phones", phone, phone.number, function(success)
			if success then
				print("* Phone created!! *")
			else
				print("* Error: phone failed to be createb!! *")
			end
		end)
	end)
end

function GetPhoneFromDatabaseByNumber(src, number, cb)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.getDocumentByRow("phones", "number" , number, function(result)
			if result then
				print("found in DB: " .. result.number)
				cb(result)
			else
				print("Error retrieving phone. Not found in cache or DB.")
				if src then
					CreateNewPhoneFromExisting(src, number, function(new_phone)
						print("* Phone created!  *")
						cb(new_phone)
					end)
				end
			end
		end)
	end)
end

function SavePhoneWithNumber(number, phone)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.getDocumentByRow("phones", "number", number, function(result)
			if result then
				couchdb.updateDocument("phones", result._id, phone, function()
					print("* Phone updated in DB! *")
				end)
			else
				print("* Error saving phone to DB. Result was nil *")
			end
		end)
	end)
end

function UpdatePhoneWithNumber(number, row, data)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.getDocumentByRow("phones", "number", number, function(result)
			if result then
				couchdb.updateDocument("phones", result._id, {[row] = data}, function()
					print("* Phone updated in DB! *")
				end)
			else
				print("* Error saving phone to DB. Result was nil *")
			end
		end)
	end)
end

function CreateNewPhoneFromExisting(src, number, cb)
	local user = exports["essentialmode"]:getPlayerFromId(src)
	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		if string.find(inventory[i].name, "Cell Phone") and inventory[i].number == number then
			print("Found matching phone to transfer data from...")
			inventory[i].conversations = {}
			CreateNewPhone(inventory[i])
			inventory[i].contacts = {}
			user.setActiveCharacterData("inventory", inventory)
			print("Phone data transfer complete!")
			cb(inventory[i])
		end
	end
end

RegisterServerEvent("phone:getPhone")
AddEventHandler("phone:getPhone", function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local inv = user.getActiveCharacterData("inventory")
	for i = 1, #inv do
		if string.find(inv[i].name, "Cell Phone") then
			TriggerClientEvent("phone:openPhone", source, inv[i])
			return
		end
	end
end)

RegisterServerEvent("phone:deleteContact")
AddEventHandler("phone:deleteContact", function(data)
	GetPhoneFromDatabaseByNumber(source, data.phone, function(phone)
		for i = 1, #phone.contacts do
			local contact = phone.contacts[i]
			if contact.number == data.numberToDelete then
				print("Deleting contact: " .. data.numberToDelete)
				table.remove(phone.contacts, i)
				UpdatePhoneWithNumber(data.phone, "contacts", phone.contacts)
				return
			end
		end
	end)
end)

RegisterServerEvent("phone:getContacts")
AddEventHandler("phone:getContacts", function(number)
	local usource = source
	GetPhoneFromDatabaseByNumber(source, number, function(phone)
		if phone then
			TriggerClientEvent("phone:loadedContacts", usource, phone.contacts)
		else
			print("* Error loading phone to get contacts! *")
		end
	end)
end)

RegisterServerEvent("phone:addContact")
AddEventHandler("phone:addContact", function(data)
	GetPhoneFromDatabaseByNumber(source, data.source, function(phone)
		if phone then
			local newContact = {
				number = data.number,
				first = data.first,
				last = data.last
			}
			table.insert(phone.contacts, newContact)
			UpdatePhoneWithNumber(data.source, "contacts", phone.contacts)
			print("* Contact added! *")
		else
			print("* Error getting phone to add contact! *")
		end
	end)
end)

RegisterServerEvent("phone:send911Message")
AddEventHandler("phone:send911Message", function(data, dont_send_msg, no_caller_id, intended_emergency_type)
	local help_online  = false
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			local player_job = player.getActiveCharacterData("job")
			if intended_emergency_type then
				if player_job == intended_emergency_type then
					if no_caller_id then
						TriggerClientEvent('chatMessage', playerSource, "911", {255, 20, 10}, message .. " (" .. data.location .. ")")
						TriggerClientEvent("phone:notify", playerSource, "~r~911:\n~w~"..message)
					else
						TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message .. " (" .. data.location .. ")")
						TriggerClientEvent("phone:notify", playerSource, "~r~911 (Caller: # ".. userSource .. "):\n~w~"..message)
					end
					help_online = true
					-- set temp blip
					TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
				end
			else
				if player_job == "sheriff" or player_job == "ems" or player_job == "fire" then
					if no_caller_id then
						TriggerClientEvent('chatMessage', playerSource, "911", {255, 20, 10}, message .. " (" .. data.location .. ")")
						TriggerClientEvent("phone:notify", playerSource, "~r~911:\n~w~"..message)
					else
						TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message .. " (" .. data.location .. ")")
						TriggerClientEvent("phone:notify", playerSource, "~r~911 (Caller: # ".. userSource .. "):\n~w~"..message)
					end
					help_online = true
					-- set temp blip
					TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
				end
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
				-- set temp blip
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
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
				-- set temp blip
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
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
		local user = exports["essentialmode"]:getPlayerFromId(source)
		if user then
			local name = "@" .. user.getActiveCharacterData("firstName") .. "_" .. user.getActiveCharacterData("lastName")
			name = string.lower(name)
			TriggerClientEvent('chatMessage', -1, "[TWEET] - " .. name, {29,161,242}, data.message)
		end
end)

-- request phone call (p2p voice)
RegisterServerEvent("phone:requestCall")
AddEventHandler("phone:requestCall", function(numbers)
	local caller_source = source
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					--print("searching inventory items of player at: " .. id .. " for a cell phone with target_phone_number")
					local inventory = player.getActiveCharacterData("inventory")
					if inventory then
						--//Check entire user inventory for toNumber phone
						for j = 1, #inventory do
							if inventory[j] then
								-- check for a matching phone number in player items
								if string.find(inventory[j].name, "Cell Phone") and inventory[j].number == numbers.phone_number then
									print("phone found with toNumber...")
									print("requesting phone call...")
									GetPhoneFromDatabaseByNumber(caller_source, numbers.phone_number, function(phone)
										local caller_name = getNameFromContacts(phone, numbers.from_number)
										if caller_name then print("caller_name: " .. caller_name) else print("caller with # " .. numbers.from_number .. " not found in contacts!") caller_name = numbers.from_number end
										TriggerClientEvent("swayam:notification", id, "Whiz Wireless", "~y~Incoming call from:~w~ " .. caller_name, "CHAR_MP_DETONATEPHONE")
										TriggerClientEvent("phone:requestCallPermission", id, numbers.phone_number, caller_source, caller_name)
									end)
								end
							end
						end
					end
				end
			end
		end
	end)
end)

-- when a player responds to an inbound call:
RegisterServerEvent("phone:respondedToCall")
AddEventHandler("phone:respondedToCall", function(accepted, phone_number, caller_source, caller_name, isBusy)
	local user_source = source
	if accepted then
		TriggerClientEvent("phone:startCall", user_source, phone_number, caller_source)
		TriggerClientEvent("phone:startCall", caller_source, phone_number, user_source)
		TriggerClientEvent("swayam:notification", user_source, "Whiz Wireless", "Call ~g~started~w~!", "CHAR_MP_DETONATEPHONE")
		TriggerClientEvent("swayam:notification", caller_source, "Whiz Wireless", "Call ~g~started~w~!", "CHAR_MP_DETONATEPHONE")
	else
		if not isBusy then
			TriggerClientEvent("swayam:notification", user_source, "Whiz Wireless", "You ~y~rejected~w~ the phone call!", "CHAR_MP_DETONATEPHONE")
			TriggerClientEvent("swayam:notification", caller_source, "Whiz Wireless", "Person ~y~rejected~w~ your phone call!", "CHAR_MP_DETONATEPHONE")
		else
			TriggerClientEvent("swayam:notification", user_source, "Whiz Wireless", "Caller " .. caller_name .. " has been put on ~y~hold~w~.", "CHAR_MP_DETONATEPHONE")
			TriggerClientEvent("swayam:notification", caller_source, "Whiz Wireless", "Person is already on a call.", "CHAR_MP_DETONATEPHONE")
		end
	end
end)

-- notify on phone call hang up
RegisterServerEvent("phone:endedCall")
AddEventHandler("phone:endedCall", function(partner_source)
	print("caller_source: " .. partner_source)
	if partner_source ~= source then
		TriggerClientEvent("phone:endCall", tonumber(partner_source))
	else
		print("partner_source was == source!")
	end
end)

RegisterServerEvent("phone:sendTextToPlayer")
AddEventHandler("phone:sendTextToPlayer", function(data)
	local userSource = tonumber(source)
	if type(tonumber(data.toNumber)) == "number" then --Check if phone number is valid
		---------------
		-- VARIABLES --
		---------------
		local toNumber = data.toNumber
		local fromNumber = data.fromNumber
		local toPlayer = 0
		local fromPlayer = userSource
		local toName = "Unknown"
		local fromName = data.fromName
		local msg = data.message
		local from = "Undefined1" -- what is displayed for the name of the sender of a text

		---------------------------------------------------------------------------------------------------------
		-- Check all online players' inventories for a cell phone item with a phone number equal to 'toNumber' --
		-- toNumber: the field passed in from the number field in the phone GUI
		---------------------------------------------------------------------------------------------------------
		-- send message to phone --
		convoExistedForUser = false

		GetPhoneFromDatabaseByNumber(nil, toNumber, function(target_phone)
			if target_phone then
				----------------------------------------
				-- see if conversation already exists --
				----------------------------------------
				for x = 1, #target_phone.conversations do
					local conversation = target_phone.conversations[x]
					if conversation.partnerId == fromNumber then
						---------------------------------------------
						-- convert to name in contact if available --
						---------------------------------------------
						from = getNameFromContacts(target_phone, fromNumber)
						print("from: " .. from)
						-----------------------
						-- construct message --
						-----------------------
						local message = {
							timestamp = os.date("%c", os.time()),
							from = from,
							to = "Me",
							message = msg
						}
						-----------------------
						-- insert into convo --
						-----------------------
						table.insert(target_phone.conversations[x].messages, message)
						UpdatePhoneWithNumber(toNumber, "conversations", target_phone.conversations)
						convoExistedForUser = true
						break
					end
				end
				if not convoExistedForUser then
					from = getNameFromContacts(target_phone, fromNumber)
					print("from: " .. from)
					local message = {
						timestamp = os.date("%c", os.time()),
						from = from,
						to = "Me",
						message = msg
					}
					local conversation = {
						partnerName = from,
						partnerId = fromNumber,
						messages = {message}
					}
					table.insert(target_phone.conversations, 1, conversation) -- insert at front
					UpdatePhoneWithNumber(toNumber, "conversations", target_phone.conversations)
				end
				SendTextReceiveNotification(toNumber, from, msg)
			else
				exports.globals:notify("Error sending text. Could not find target phone!")
				print("* Error sending text. Could not find target phone *")
				return
			end
		end)
		-- SECOND HALF! INSERTING MSG INTO SENDING PLAYER CELL PHONE --
		convoExistedForUser = false
		GetPhoneFromDatabaseByNumber(userSource, fromNumber, function(item)
			for x = 1, #item.conversations do
				local conversation = item.conversations[x]
				if conversation.partnerId == toNumber then
					--print("player already had a conversation with that toNumber!")
					-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
					from = getNameFromContacts(item, toNumber)
					print("creating text message...")
					local message = {
						timestamp = os.date("%c", os.time()),
						from = "Me",
						to = toName,
						message = msg
					}
					table.insert(item.conversations[x].messages, message)
					UpdatePhoneWithNumber(fromNumber, "conversations", item.conversations)
					convoExistedForUser = true
					TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
				end
			end
			if not convoExistedForUser then
				print("no convo found for users! creating and inserting now!")
				-- no previous converstaion with that partner, create new one
				-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
				from = getNameFromContacts(item, toNumber)
				print("creating text message...")
				local message = {
					timestamp = os.date("%c", os.time()),
					from = "Me",
					to = toName,
					message = msg
				}
				print("creating conversation...")
				local conversation = {
					partnerName = toName,
					partnerId = toNumber,
					messages = {message}
				}
				table.insert(item.conversations, 1, conversation) -- insert at front
				UpdatePhoneWithNumber(fromNumber, "conversations", item.conversations)
				TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
			end
		end)
	else -- Phone number is invalid
		TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Please check the number and try again.", "CHAR_MP_DETONATEPHONE")
	end
end)

function SendTextReceiveNotification(toNumber, from, msg)
	TriggerEvent("es:getPlayers", function(players)
		local allPlayers = players
		if allPlayers then
			for id, player in pairs(allPlayers) do
				if id and player then
					-- search inventory items of player at [id] for a cell phone with toNumber --
					local inventory = player.getActiveCharacterData("inventory")
					if inventory then
						-- Check entire user inventory for toNumber phone --
						for j = 1, #inventory do
							if inventory[j].name and inventory[j].number then
								-- check for a matching phone number in player items
								if string.find(inventory[j].name, "Cell Phone") and inventory[j].number == toNumber then
									TriggerClientEvent("chatMessage", id, "", {}, "^3Message Received (" .. from .. "):^0 " .. msg)
									TriggerClientEvent("swayam:notification", id, from, msg, "CHAR_DEFAULT")
									return
								end
							end
						end
					end
				end
			end
		end
	end)
end

RegisterServerEvent("phone:loadMessages")
AddEventHandler("phone:loadMessages", function(number)
	local usource = source
	GetPhoneFromDatabaseByNumber(usource, number, function(phone)
		local conversationsToSendToPhone = {}
		if phone then
			for i = 1, 10 do
				if phone.conversations[i] then
					--print("adding conversation from db: #" .. i)
					table.insert(conversationsToSendToPhone, phone.conversations[i])
				else
					break
				end
			end
			TriggerClientEvent("phone:loadedMessages", usource, conversationsToSendToPhone)
		else
			print("* Error retrieving phone to load messages from! *")
		end
	end)
end)

RegisterServerEvent("phone:getMessagesWithThisId")
AddEventHandler("phone:getMessagesWithThisId", function(targetId, sourcePhone)
	local usource = source
	-- load phone --
	GetPhoneFromDatabaseByNumber(usource, sourcePhone, function(phone)
		-- load conversation messages with specified ID --
		local conversations = phone.conversations
		for x = 1, #conversations do
			if conversations[x].partnerId == targetId then
				TriggerClientEvent("phone:loadedMessagesFromId", usource, conversations[x].messages, targetId)
				return
			end
		end
	end)
end)

-- P1: phone item
-- P2: phone number
function getNameFromContacts(phone, number)
	local contacts = phone.contacts
	-- look through contact list for matching phone number
	print("#contacts in phone passed in = " .. #contacts)
	for i = 1, #contacts do
		if string.find(contacts[i].number, number) then
			print("matching number found in contacts!")
			-- return name of contact with that phone number
			return (contacts[i].first .. " " .. contacts[i].last)
		end
	end
	-- at this point, no match was found in contacts for that number
	print("no match was found for name in contacts! returning number!")
	return number
end

-- show phone number command --
TriggerEvent('es:addCommand', 'phonenumber', function(source, args, user, location)
	local userSource = tonumber(source)
		local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if string.find(item.name, "Cell Phone") then
				local msg = "^0" .. user.getActiveCharacterData("fullName") .. " writes down number: " .. item.number
				exports["globals"]:sendLocalActionMessage(msg, location)
			end
		end
end, { help = "Write down your phone number(s) for those around you."})

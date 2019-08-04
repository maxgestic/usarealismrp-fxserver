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
			end
		end)
	end)
end

function SavePhoneWithNumber(number, phone)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.updateDocument("phones", number, phone, function()
			print("* Phone updated in DB! *")
		end)
	end)
end

function UpdatePhoneWithNumber(number, row, data)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.updateDocument("phones", number, {[row] = data}, function()
			print("* Phone updated in DB! *")
		end)
	end)
end

RegisterServerEvent("phone:getPhone")
AddEventHandler("phone:getPhone", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local phone = char.getItem("Cell Phone")
	if phone then
		TriggerClientEvent("phone:openPhone", source, phone)
	else
		TriggerClientEvent("usa:notify", source, "You have no cell phone!")
	end
end)

RegisterServerEvent("phone:deleteContact")
AddEventHandler("phone:deleteContact", function(data)
	-- query for phone contacts --
	local endpoint = "/phones/_design/phoneFilters/_view/getContactsByNumber"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseJson = json.decode(responseText)
			if responseJson.rows then
				local contacts = responseJson.rows[1].value
				for i = 1, #contacts do
					local contact = contacts[i]
					if contact.number == data.numberToDelete then
						table.remove(contacts, i)
						UpdatePhoneWithNumber(data.phone, "contacts", contacts)
						return
					end
				end
			end
		end
	end, "POST", json.encode({
		keys = { data.phone }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("phone:getContacts")
AddEventHandler("phone:getContacts", function(number)
	local usource = source
	-- query for phone contacts --
	local endpoint = "/phones/_design/phoneFilters/_view/getContactsByNumber"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local data = json.decode(responseText)
			if data.rows then
				if data.rows[1] then
					if data.rows[1].value then
						local contacts = data.rows[1].value
						TriggerClientEvent("phone:loadedContacts", usource, contacts)
					end
				end
			end
		end
	end, "POST", json.encode({
		keys = { number }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("phone:addContact")
AddEventHandler("phone:addContact", function(data)
	-- query for phone contacts --
	local endpoint = "/phones/_design/phoneFilters/_view/getContactsByNumber"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseJson = json.decode(responseText)
			if responseJson.rows then
				local contacts = responseJson.rows[1].value
				local newContact = {
					number = data.number,
					first = data.first,
					last = data.last
				}
				table.insert(contacts, newContact)
				UpdatePhoneWithNumber(data.source, "contacts", contacts)
				print("* Contact added! *")
			end
		end
	end, "POST", json.encode({
		keys = { data.source }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("phone:sendTaxiMessage")
AddEventHandler("phone:sendTaxiMessage", function(data)
	local taxi_online = false
	local message = data.message
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			if char.get("job") == "taxi" then
				TriggerClientEvent('chatMessage', id, "Taxi Requested! (Caller: #" .. source .. ")", {251, 229, 5}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", id, "~y~TAXI REQUEST (Caller: # ".. source .. "):\n~w~"..message)
				taxi_online = true
				-- set temp blip
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
			end
		end
		if taxi_online then
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "A ^3taxi^0 has been notified!")
			TriggerClientEvent("usa:notify", source, "A ~y~taxi ~w~has been notified!")
		else
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Sorry, there is no one on duty as taxi!")
			TriggerClientEvent("usa:notify", source, "~y~Sorry, there is no one on duty as taxi!")
		end
	end)
end)

RegisterServerEvent("phone:sendTowMessage")
AddEventHandler("phone:sendTowMessage", function(data)
	local tow_online = false
	local message = data.message
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			if char.get("job") == "tow" then
				TriggerClientEvent('chatMessage', id, "Tow Requested! (Caller: #" .. source .. ")", {118, 120, 251}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", id, "~y~TOW REQUEST (Caller: # ".. source .. "):\n~w~"..message)
				tow_online = true
				-- set temp blip
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
			end
		end
		if tow_online then
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "A ^3tow truck^0 has been notified!")
			TriggerClientEvent("usa:notify", source, "A ~y~tow truck~w~ has been notified!")
		else
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Sorry, no one is on duty as tow!")
			TriggerClientEvent("usa:notify", source, "~y~Sorry, no one is on duty as tow!")
		end
	end)
end)

RegisterServerEvent("phone:sendTweet")
AddEventHandler("phone:sendTweet", function(data)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char then
		local name = "@" .. char.get("name").first .. "_" .. char.get("name").last
		name = string.lower(name)
		TriggerClientEvent('chatMessage', -1, "[TWEET] - " .. name, {29,161,242}, data.message)
		TriggerEvent("chat:sendToLogFile", source, "[TWEET] - " .. name .. ": " .. data.message)
	end
end)

TriggerEvent('es:addCommand','tweet', function(source, args, char)
	TriggerClientEvent('usa:notify', source, 'Use a cell phone to tweet!')
end, {
	help = "Send a tweet.", params = {{name = "message", help = "the tweet"}}
})

-- request phone call (p2p voice)
RegisterServerEvent("phone:requestCall")
AddEventHandler("phone:requestCall", function(data)
	local caller_source = source
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			local savedId = id
			local p = char.getItemWithField("number", data.phone_number)
			if p then
				-- query for phone contacts --
				local endpoint = "/phones/_design/phoneFilters/_view/getContactsByNumber"
				local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
				PerformHttpRequest(url, function(err, responseText, headers)
					if responseText then
						local dbResponse = json.decode(responseText)
						if dbResponse.rows and dbResponse.rows[1] and dbResponse.rows[1].value then
							local contacts = dbResponse.rows[1].value
							local caller_name = getNameFromContacts(contacts, data.from_number)
							if caller_name then print("caller_name: " .. caller_name) else print("caller with # " .. data.from_number .. " not found in contacts!") caller_name = data.from_number end
							TriggerClientEvent("swayam:notification", savedId, "Whiz Wireless", "~y~Incoming call from:~w~ " .. caller_name, "CHAR_MP_DETONATEPHONE")
							TriggerClientEvent("phone:requestCallPermission", savedId, data.phone_number, caller_source, caller_name, data.channel)
						end
					end
				end, "POST", json.encode({
					keys = { data.phone_number }
				}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
			end
		end
	end)
end)

-- when a player responds to an inbound call:
RegisterServerEvent("phone:respondedToCall")
AddEventHandler("phone:respondedToCall", function(channel, accepted, phone_number, caller_source, caller_name, isBusy)
	print("responded to call, requested on channel: " .. channel)
	local user_source = source
	if accepted then
		TriggerClientEvent("phone:startCall", user_source, phone_number, caller_source, channel)
		TriggerClientEvent("phone:startCall", caller_source, phone_number, user_source, channel)
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
AddEventHandler("phone:endedCall", function(partner_source, channel)
	print("caller_source: " .. partner_source)
	if partner_source ~= source then
		TriggerClientEvent("phone:endCall", tonumber(partner_source), channel)
		TriggerClientEvent("phone:endCall", source, channel)
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
						--print("from: " .. from)
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
						if #target_phone.conversations[x].messages > 20 then table.remove(target_phone.conversations[x].messages, 1) end -- temporary until messages separated into own DB
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
					--print("creating text message...")
					local message = {
						timestamp = os.date("%c", os.time()),
						from = "Me",
						to = toName,
						message = msg
					}
					if #item.conversations[x].messages > 20 then table.remove(item.conversations[x].messages, 1) end -- temporary until messages separated into own DB
					table.insert(item.conversations[x].messages, message)
					UpdatePhoneWithNumber(fromNumber, "conversations", item.conversations)
					convoExistedForUser = true
					TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Your message has been sent!", "CHAR_MP_DETONATEPHONE")
				end
			end
			if not convoExistedForUser then
				--print("no convo found for users! creating and inserting now!")
				-- no previous converstaion with that partner, create new one
				-- see if that number is in this phone's contact list, if so set the from sender name to the readable name
				from = getNameFromContacts(item, toNumber)
				toName = getNameFromContacts(item, fromNumber)
				--print("creating text message...")
				local message = {
					timestamp = os.date("%c", os.time()),
					from = "Me",
					to = toName,
					message = msg
				}
				--print("creating conversation...")
				local conversation = {
					partnerName = toName,
					partnerId = toNumber,
					messages = {message}
				}
				table.insert(item.conversations, 1, conversation) -- insert at front
				UpdatePhoneWithNumber(fromNumber, "conversations", item.conversations)
				TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Your message has been sent.", "CHAR_MP_DETONATEPHONE")
			end
		end)
	else -- Phone number is invalid
		TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Please check the number and try again.", "CHAR_MP_DETONATEPHONE")
	end
end)

function SendTextReceiveNotification(toNumber, from, msg)
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			if char.getItemWithField("number", toNumber) then
				TriggerClientEvent("chatMessage", id, "", {}, "^3Text <" .. from .. ">:^0 " .. msg)
				TriggerClientEvent("swayam:notification", id, from, msg, "CHAR_DEFAULT")
			end
		end
	end)
end

RegisterServerEvent("phone:loadMessages")
AddEventHandler("phone:loadMessages", function(number)
	local usource = source
	-- query for phone contacts --
	local endpoint = "/phones/_design/phoneFilters/_view/getConversationsByNumber"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local data = json.decode(responseText)
			if data.rows and data.rows[1] and data.rows[1].value then
				local conversations = data.rows[1].value
				TriggerClientEvent("phone:loadedMessages", usource, conversations)
			end
		end
	end, "POST", json.encode({
		keys = { number }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("phone:getMessagesWithThisId")
AddEventHandler("phone:getMessagesWithThisId", function(targetId, sourcePhone)
	local usource = source
	-- load phone --
	-- query for phone contacts --
	local endpoint = "/phones/_design/phoneFilters/_view/getConversationsByNumber"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local data = json.decode(responseText)
			if data.rows and data.rows[1] and data.rows[1].value then
				local conversations = data.rows[1].value
				for x = 1, #conversations do
					if conversations[x].partnerId == targetId then
						TriggerClientEvent("phone:loadedMessagesFromId", usource, conversations[x].messages, targetId)
						return
					end
				end
			end
		end
	end, "POST", json.encode({
		keys = { sourcePhone }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

-- P1: phone item
-- P2: phone number
function getNameFromContacts(phone, number)
	local contacts = phone
	if phone.contacts then
		contacts = phone.contacts
	end
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

RegisterServerEvent("phone:showPhoneNumber")
AddEventHandler("phone:showPhoneNumber", function(location)
	local inventory = exports["usa-characters"]:GetCharacterField(source, "inventory")
	local hasPhone = false
	for i = 0, (inventory.MAX_CAPACITY - 1) do
		if inventory.items[tostring(i)] then
			local item = inventory.items[tostring(i)]
			if string.find(item.name, "Cell Phone") then
				local msg = "Person with SSN "..source.." writes down number: " .. item.number
				exports["globals"]:sendLocalActionMessageChat(msg, location)
				exports["globals"]:sendLocalActionMessage(source, "writes down number: " .. item.number)
				hasPhone = true
			end
		end
	end
	if not hasPhone then
		TriggerClientEvent("usa:notify", source, "You have no cell phone!")
	end
end)

-- show phone number command --
TriggerEvent('es:addCommand', 'phonenumber', function(source, args, char, location)
	local inventory = char.get("inventory")
	local hasPhone = false
	for i = 0, (inventory.MAX_CAPACITY - 1) do
		if inventory.items[tostring(i)] then
			local item = inventory.items[tostring(i)]
			if string.find(item.name, "Cell Phone") then
				local msg = "Person with SSN "..source.." writes down number: " .. item.number
				exports["globals"]:sendLocalActionMessageChat(msg, location)
				exports["globals"]:sendLocalActionMessage(source, "writes down number: " .. item.number)
				hasPhone = true
			end
		end
	end
	if not hasPhone then
		TriggerClientEvent("usa:notify", source, "You have no cell phone!")
	end
end, { help = "Write down your phone number(s) for those around you."})

-- PERFORM FIRST TIME DB CHECK--
exports["globals"]:PerformDBCheck("usa-phone", "phones")

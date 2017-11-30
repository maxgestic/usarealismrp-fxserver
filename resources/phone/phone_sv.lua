-- phone gui
TriggerEvent('es:addCommand', 'phone', function(source, args, user)
	TriggerClientEvent("phone:openPhone", source)
end)

RegisterServerEvent("phone:send911Message")
AddEventHandler("phone:send911Message", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			local player_job = player.getActiveCharacterData("job")
			if player_job == "ems" or player_job == "sheriff" or player_job == "police" then
				TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message)
				TriggerClientEvent("phone:notify", playerSource, "~r~911 (Caller: # ".. userSource .. "):\n~w~"..message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "^3911^0 was notified!")
	end)
end)

RegisterServerEvent("phone:sendEmsMessage")
AddEventHandler("phone:sendEmsMessage", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			local player_job = player.getActiveCharacterData("job")
			if player_job == "ems" or player_job == "sheriff" or player_job == "police" then
				TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message)
				TriggerClientEvent("phone:notify", playerSource, "~r~911 (Caller: # ".. userSource .. "):\n~w~"..message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "^3EMS^0 has been notified!")
	end)
end)

RegisterServerEvent("phone:sendTaxiMessage")
AddEventHandler("phone:sendTaxiMessage", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getActiveCharacterData("job") == "taxi" then
				TriggerClientEvent('chatMessage', playerSource, "Taxi Requested! (Caller: #" .. userSource .. ")", {251, 229, 5}, message)
				TriggerClientEvent("phone:notify", playerSource, "~y~TAXI REQUEST (Caller: # ".. userSource .. "):\n~w~"..message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "A ^3taxi^0 has been notified!")
	end)
end)

RegisterServerEvent("phone:sendTowMessage")
AddEventHandler("phone:sendTowMessage", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getActiveCharacterData("job") == "tow" then
				TriggerClientEvent('chatMessage', playerSource, "Tow Requested! (Caller: #" .. userSource .. ")", {118, 120, 251}, message)
				TriggerClientEvent("phone:notify", playerSource, "~y~TOW REQUEST (Caller: # ".. userSource .. "):\n~w~"..message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "A ^3tow truck^0 has been notified!")
	end)
end)

RegisterServerEvent("phone:sendTextToPlayer")
AddEventHandler("phone:sendTextToPlayer", function(source, data) -- Need to remove source before deploying to public server
	local userSource = tonumber(source)
	if type(tonumber(data.id)) == "number" then --Check if phone number is valid

		print(data.id .. "is a number")
		local toNumber = tonumber(data.id)
		local fromNumber = tonumber(data.fromId)
		local toPlayer = 0
		local fromPlayer = userSource
		local toName = "Unknown"
		local fromName = data.fromName
		local messageSent = false
		local msg = data.message

		--//Check all users for toNumber phone in their inventory
		TriggerEvent("es:getPlayers", function(players)
			local allPlayers = players
			--for i = 1, #allPlayers do
			if allPlayers then
                for id, player in pairs(allPlayers) do
                    if id and player then
				print("allPlayers[i] aka id = " .. id)

				--TriggerEvent('es:getPlayerFromId', tonumber(allPlayers[i]), function(user)
					local inventory = player.getActiveCharacterData("inventory")

					--//Check entire user inventory for toNumber phone
					for j = 1, #inventory do
						print("Checking " .. inventory[j].name)
		                if tonumber(inventory[j].number) == tonumber(toNumber) then
		                	toPlayer = tonumber(id)
		                	toName = inventory[j].owner
		                	-- Add conversation to and from phone
		                	item = inventory[j]

		                	--//Check toNumber phone to see if conversation exist with fromNumber
		                	for x = 1, #item.conversations do
								local conversation = item.conversations[x]
								if conversation.partnerId == fromNumber then
									local message = {
										timestamp = os.date("%c", os.time()),
										from = fromName,
										to = item.owner,
										message = msg
									}
									table.insert(inventory[j].conversations[x].messages, message)
									player.setActiveCharacterData("inventory", inventory)
									convoExistedForUser = true
									TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
									TriggerClientEvent("swayam:notification", tonumber(toPlayer), fromName, msg, "CHAR_DEFAULT")
									messageSent = true
									--TriggerClientEvent("swayam:notification", toPlayer, "From Someone", "Some Message", "CHAR_DEFAULT")
									return
								end
							end
							if not convoExistedForUser then
								print("no convo found for users! creating and inserting now!")
								-- no previous converstaion with that partner, create new one
								local message = {
									timestamp = os.date("%c", os.time()),
									from = fromName,
									to = item.owner,
									message = msg
								}
								local conversation = {
									partnerName = fromName,
									partnerId = fromNumber,
									messages = {message}
								}
								table.insert(inventory[j].conversations, 1, conversation) -- insert at front
								player.setActiveCharacterData("inventory", inventory)
								TriggerClientEvent("swayam:notification", userSource, "Whiz Wireless", "Message Sent.", "CHAR_MP_DETONATEPHONE")
								TriggerClientEvent("swayam:notification", tonumber(toPlayer), fromName, msg, "CHAR_DEFAULT")
								--TriggerClientEvent("swayam:notification", tonumber(toPlayer), "From Someone", "Some Message", "CHAR_DEFAULT")
								messageSent = true
								print("convo inserted!")
								return
							end

		                end
		            end
		        --end)
			end
		end)
		if messageSent == true then
			convoExistedForUser = false
			TriggerEvent('es:getPlayerFromId', tonumber(userSource), function(user)
				local inventory = user.getActiveCharacterData("inventory")
				for j = 1, #inventory do
					print("Checking " .. inventory[j].name)
					if tonumber(inventory[j].number) == tonumber(fromNumber) then
						item = inventory[j]
						for x = 1, #item.conversations do
							local conversation = item.conversations[x]
							if conversation.partnerId == toNumber then
								local message = {
								timestamp = os.date("%c", os.time()),
								from = fromName,
								to = toName,
								message = msg
							}
							table.insert(inventory[j].conversations[x].messages, message)
							user.setActiveCharacterData("inventory", inventory)
							convoExistedForUser = true
							end
						end
						if not convoExistedForUser then
						print("no convo found for users! creating and inserting now!")
							-- no previous converstaion with that partner, create new one
							local message = {
								timestamp = os.date("%c", os.time()),
								from = fromName,
								to = toName,
								message = msg
							}
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

--
RegisterServerEvent("phone:loadMessages")
AddEventHandler("phone:loadMessages", function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local conversationsToSendToPhone = {}
		local inventory = user.getActiveCharacterData("inventory")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == "Cell Phone" then
				local conversations = item.conversations
				if conversations then
					print("loaded conversations with #: " .. #conversations)

					for j = 1, 10 do
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
			if item.name == "Cell Phone" then
				local conversations = item.conversations
				for x = 1, #conversations do
					if conversations[x].partnerId == targetId then
						print("found matching conversation for player id: " .. targetId)
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

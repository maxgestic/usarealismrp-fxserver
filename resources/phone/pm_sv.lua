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

-- TODO: allow this event handler to send text messages when data.id == an identifier (instead of ID #)
RegisterServerEvent("phone:sendTextToPlayer")
AddEventHandler("phone:sendTextToPlayer", function(data)
	-- TODO: see if data.id == any online player's identifier, if so then convert it to that players server ID and set data.id = to it
	if string.find(data.id, "steam:") or string.find(data.id, "ip:") or string.find(data.id, "license:") then
		local allPlayers = GetPlayers()
		for i = 1, #allPlayers do
			print("allPlayers[i] = " .. allPlayers[i])
			local playerIdentifiers = GetPlayerIdentifiers(allPlayers[i])
			for j = 1, #playerIdentifiers do
				if string.find(playerIdentifiers[j], data.id) then
					print("matching identifier found! sending text to this player")
					data.id = allPlayers[i]
				end
			end
		end
	end
	local userSource = tonumber(source)
	print("userSource = " .. userSource)
	local userIdent = GetPlayerIdentifiers(userSource)[1]
	local targetPlayer = tonumber(data.id)
	if not targetPlayer then return end
	print("targetPlayer = " .. targetPlayer)
	local targetPlayerName = GetPlayerName(targetPlayer)
	print("targetPlayerName = " .. targetPlayerName)
	local userPlayerName = GetPlayerName(userSource)
	print("userPlayerName = " .. userPlayerName)
	local targetPlayerIdent = GetPlayerIdentifiers(targetPlayer)[1]
	local msg = data.message
	if msg and targetPlayer then
		TriggerClientEvent("chatMessage", userSource, "", {}, "Text message sent!") -- message send confirmation
		TriggerClientEvent("chatMessage", targetPlayer, "", {}, userPlayerName .. " just texted you!") -- message recieve confirmation
		TriggerClientEvent("phone:notify", targetPlayer, "~y~"..userPlayerName .. "~w~ just texted you!")
		--TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
		-- store in user's phone
		TriggerEvent("es:getPlayerFromId", userSource, function(user)
			local convoExistedForUser = false
			local inventory = user.getActiveCharacterData("inventory")
			for i = 1, #inventory do
				local item = inventory[i]
				if item.name == "Cell Phone" then
					for x = 1, #item.conversations do
						local conversation = item.conversations[x]
						if conversation.partnerId == targetPlayerIdent then
							print("found an existing conversation with partner! adding message to it...")
							--local partner = conversation.partner
							--local toMessages = conversation.toMessages
							--local fromMessages = conversation.fromMessages
							local message = {
								timestamp = os.date("%c", os.time()),
								from = GetPlayerName(userSource),
								to = targetPlayerName,
								message = msg
							}
							table.insert(inventory[i].conversations[x].messages, message)
							user.setActiveCharacterData("inventory", inventory)
							convoExistedForUser = true
						end
					end
					if not convoExistedForUser then
						print("no convo found for users! creating and inserting now!")
						-- no previous converstaion with that partner, create new one
						local message = {
							timestamp = os.date("%c", os.time()),
							from = GetPlayerName(userSource),
							to = targetPlayerName,
							message = msg
						}
						local conversation = {
							partnerName = targetPlayerName,
							partnerId = targetPlayerIdent,
							messages = {message}
						}
						table.insert(inventory[i].conversations, 1, conversation) -- insert at front
						user.setActiveCharacterData("inventory", inventory)
						print("convo inserted!")
					end
				end
			end
			-- no cell phone
			-- ADD TO SECOND PLAYER DB:
			if targetPlayer ~= userSource then -- stop from duplicating the message if sending message to self (like for testing)
				-- target player data update
				TriggerEvent("es:getPlayerFromId", targetPlayer, function(user)
					local convoExistedForUser = false
					local inventory = user.getActiveCharacterData("inventory")
					for i = 1, #inventory do
						local item = inventory[i]
						if item.name == "Cell Phone" then
							for x = 1, #item.conversations do
								local conversation = item.conversations[x]
								if conversation.partnerId ==  userIdent then
									print("found an existing conversation with partner again! adding message to it...")
									--local partner = conversation.partner
									--local toMessages = conversation.toMessages
									--local fromMessages = conversation.fromMessages
									local message = {
										timestamp = os.date("%c", os.time()),
										from = GetPlayerName(userSource),
										to = targetPlayerName,
										message = msg
									}
									table.insert(inventory[i].conversations[x].messages, message)
									user.setActiveCharacterData("inventory", inventory)
									convoExistedForUser = true
								end
							end
							if not convoExistedForUser then
								-- no previous converstaion with that partner, create new one
								local message = {
									timestamp = os.date("%c", os.time()),
									from = GetPlayerName(userSource),
									to = targetPlayerName,
									message = msg
								}
								local conversation = {
									partnerName = GetPlayerName(userSource),
									partnerId = GetPlayerIdentifiers(userSource)[1],
									messages = {message}
								}
								table.insert(inventory[i].conversations, conversation)
								user.setActiveCharacterData("inventory", inventory)
							end
						end
					end
					-- no cell phone
				end)
			end
		end)
	else
		TriggerClientEvent("pm:help", userSource)
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

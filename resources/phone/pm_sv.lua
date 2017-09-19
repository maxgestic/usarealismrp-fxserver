--[[ Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'text', function(source, args, user)

	local targetPlayer = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local msg = table.concat(args, " ")

	if msg and targetPlayer and type(targetPlayer) ~= "number" then
		TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
	else
		TriggerClientEvent("pm:help", source)
	end

end)
--]]
--[[ Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'TEXT', function(source, args, user)

	local targetPlayer = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local msg = table.concat(args, " ")

	if msg and targetPlayer and type(targetPlayer) ~= "number" then
		TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
	else
		TriggerClientEvent("pm:help", source)
	end

end)
--]]

-- phone gui
TriggerEvent('es:addCommand', 'phone', function(source, args, user)
	TriggerClientEvent("phone:openPhone", source)
end)

RegisterServerEvent("phone:sendPoliceMessage")
AddEventHandler("phone:sendPoliceMessage", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getJob() == "ems" or player.getJob() == "sheriff" or player.getJob() == "police" then
				TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "^3Police^0 has been notified!")
	end)
end)

RegisterServerEvent("phone:sendEmsMessage")
AddEventHandler("phone:sendEmsMessage", function(data)
	local userSource = tonumber(source)
	local message = data.message
	TriggerEvent('es:getPlayers', function(players)
		for id, player in pairs(players) do
			local playerSource = id
			if player.getJob() == "ems" or player.getJob() == "sheriff" or player.getJob() == "police" then
				TriggerClientEvent('chatMessage', playerSource, "911 (Caller: #" .. userSource .. ")", {255, 20, 10}, message)
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
			if player.getJob() == "taxi" then
				TriggerClientEvent('chatMessage', playerSource, "Taxi Requested! (Caller: #" .. userSource .. ")", {251, 229, 5}, message)
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
			if player.getJob() == "tow" then
				TriggerClientEvent('chatMessage', playerSource, "Tow Requested! (Caller: #" .. userSource .. ")", {118, 120, 251}, message)
			end
		end
		TriggerClientEvent('chatMessage', userSource, "", {0, 0, 0}, "A ^3tow truck^0 has been notified!")
	end)
end)

RegisterServerEvent("phone:sendTextToPlayer")
AddEventHandler("phone:sendTextToPlayer", function(data)
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
		--TriggerClientEvent("pm:sendMessage", targetPlayer, GetPlayerName(source), msg)
		-- store in user's phone
		TriggerEvent("es:getPlayerFromId", userSource, function(user)
			local convoExistedForUser = false
			local inventory = user.getInventory()
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
							user.setInventory(inventory)
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
						user.setInventory(inventory)
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
					local inventory = user.getInventory()
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
									user.setInventory(inventory)
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
								user.setInventory(inventory)
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
		local inventory = user.getInventory()
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
		local inventory = user.getInventory()
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
		local inventory = user.getInventory()
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == "Cell Phone" then
				local conversations = item.conversations
				for x = 1, #conversations do
					if conversations[x].partnerId == targetId then
						print("found matching conversation for player id: " .. targetId)
						print("#conversations[x].messages = " .. #(conversations[x].messages))
						TriggerClientEvent("phone:loadedMessagesFromId", userSource, conversations[x].messages)
						return
					end
				end
				-- no matching conversation found
			end
		end
		-- no cell phone found
	end)
end)

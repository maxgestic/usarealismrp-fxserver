local civSkins = {
		"a_m_m_beach_01",
		"a_m_m_bevhills_01",
		"a_m_m_bevhills_02",
		"a_m_m_business_01",
		"a_m_m_eastsa_01",
		"a_m_m_eastsa_02",
		"a_m_m_farmer_01",
		"a_m_m_genfat_01",
		"a_m_m_golfer_01",
		"a_m_m_hillbilly_01",
		"a_m_m_indian_01",
		"a_m_m_mexcntry_01",
		"a_m_m_paparazzi_01",
		"a_m_m_tramp_01",
		"a_m_y_hiker_01",
		"a_m_y_genstreet_01",
		"a_m_m_socenlat_01",
		"a_m_m_og_boss_01",
		"a_f_y_tourist_02",
		"a_f_y_tourist_01",
		"a_f_y_soucent_01",
		"a_f_y_scdressy_01",
		"a_m_y_cyclist_01",
		"a_m_y_golfer_01",
		"S_M_M_Linecook",
		"S_M_Y_Barman_01",
		"S_M_Y_BusBoy_01",
		"S_M_Y_Waiter_01",
		"A_M_Y_StBla_01",
		"A_M_M_Tennis_01",
		"A_M_Y_BreakDance_01",
		"A_M_Y_SouCent_03",
		"S_M_M_Bouncer_01",
		"S_M_Y_Doorman_01",
		"A_F_M_Tramp_01"
}

AddEventHandler('es:playerLoaded', function(source, user)
		local money = user.getActiveCharacterData("money")
		print("Player " .. GetPlayerName(source) .. " has loaded.")
		if money then
				print("Money:" .. money)
				--user.setActiveCharacterData("money", money) -- set money GUI in top right (?)
		else
				print("new player, default money!")
		end
		TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
	print("inside of usa_rp:spawnPlayer!")
	local userSource = tonumber(source)
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local characters = user.getCharacters()
		local job = user.getActiveCharacterData("job")
		if job then
			print("user.getActiveCharacterData('job') = " .. job)
		end
		local weapons = user.getActiveCharacterData("weapons")
		local model = civSkins[math.random(1,#civSkins)]
		if weapons then
			if #weapons > 0 then
				print("#weapons = " .. #weapons)
			else
				print("user has no weapons")
			end
		end
		user.setActiveCharacterData("job", "civ")

		-- todo: remove unused passed in parameters below??
		TriggerClientEvent("usa_rp:spawn", userSource, model, job, weapons, characters)
	--end)
end)

RegisterServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
AddEventHandler("usa_rp:checkJailedStatusOnPlayerJoin", function(id)
	if id then source = id end
	print("inside of checkJailedStatusOnPlayerJoin event handler...")
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			if user.getActiveCharacterData("jailtime") > 0 then
				TriggerClientEvent("jail:jail", userSource)
				exports["globals"]:notifyPlayersWithJobs({"corrections"}, "^3INFO: ^0" .. user.getActiveCharacterData("fullName") .. " has woken up from a nap.")
			end
		end
	--end)
end)

-- V E H I C L E  C O N T R O L S
TriggerEvent('es:addCommand', 'rollw', function(source, args, user)
	TriggerClientEvent("RollWindow", source)
end, {
	help = "Roll the windows down"
})

TriggerEvent('es:addCommand', 'open', function(source, args, user)
	if args[2] then
		print("opening " .. args[2])
		TriggerClientEvent("veh:openDoor", source, args[2])
		--TriggerClientEvent("usa:notify", source, "test")
	end
end, {
	help = "Open a door",
	params = {
		{ name = "door", help = "hood, trunk, fl, fr, bl, br, ambulance" }
	}
})

TriggerEvent('es:addCommand', 'close', function(source, args, user)
	if args[2] then
		TriggerClientEvent("veh:shutDoor", source, args[2])
	end
end, {
	help = "Shut a door",
	params = {
		{ name = "door", help = "hood, trunk, fl, fr, bl, br, ambulance" }
	}
})

TriggerEvent('es:addCommand', 'shut', function(source, args, user)
	if args[2] then
		TriggerClientEvent("veh:shutDoor", source, args[2])
	end
end, {
	help = "Shut a door",
	params = {
		{ name = "door", help = "hood, trunk, fl, fr, bl, br, ambulance" }
	}
})

TriggerEvent('es:addCommand', 'shuffle', function(source, args, user)
	TriggerClientEvent("usa:shuffleSeats", source)

end, {
	help = "Shuffle seats in a vehicle"
})

TriggerEvent('es:addCommand', 'bl', function(source, args, user)
	TriggerClientEvent("usa:toggleBrakelight", source)
end, {
	help = "Toggle your vehicle idle brakelights"
})

-- R O L L  D I C E
TriggerEvent('es:addCommand', 'roll', function(source, args, user, location)
	local max = tonumber(args[2])
	if max then
		print("rolling " .. max)
		local roll = math.random(1, max)
		local msg = "rolls a " .. roll .. " out of " .. max 
		exports["globals"]:sendLocalActionMessageChat(msg, location)
		exports["globals"]:sendLocalActionMessage(source, msg)
	end
end, {
	help = "Roll a random number.",
	params = {
		{ name = "max", help = "The max number to roll" }
	}
})

-- U T I L I T Y  F U N C T I O N S
RegisterServerEvent("usa:checkPlayerMoney")
AddEventHandler("usa:checkPlayerMoney", function(activity, amount, callbackEventName, isServerEvent, takeMoney)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_money = user.getActiveCharacterData("money")
		if user_money >= amount then
			if takeMoney then
				user.setActiveCharacterData("money", user_money - amount)
			end
			if isServerEvent then
				TriggerEvent(callbackEventName)
			else
				TriggerClientEvent(callbackEventName, userSource)
			end
		else
			TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to " .. activity .. "!")
		end
	--end)
end)

-- see if user has item in Inventory:
-- if player has it, return it
-- if not, return nil
RegisterServerEvent("usa:getPlayerItem")
AddEventHandler("usa:getPlayerItem", function(from_source, item_name, callback)
	print("inside usa:getPlayerItem!")
	print("from_source: " .. from_source)
	local userSource = tonumber(from_source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_inventory = user.getActiveCharacterData("inventory")
		for i = 1, #user_inventory do
			local item = user_inventory[i]
			if item then
				if string.find(item.name, item_name) then
					print("found item in inventory, returning it!")
					callback(item)
					return
				end
			end
		end
		print("did not find inventory item with name: " .. item_name)
		-- not found if here, return nil:
		callback(nil)
	--end)
end)

-- see if user has item in Inventory:
-- if player has it, return it
-- if not, return nil
RegisterServerEvent("usa:getPlayerItems")
AddEventHandler("usa:getPlayerItems", function(from_source, item_names, callback)
	print("inside usa:getPlayerItem!")
	print("from_source: " .. from_source)
	local userSource = tonumber(from_source)
	local return_items = {}
	local found = false
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_inventory = user.getActiveCharacterData("inventory")
		for i = 1, #user_inventory do
			local item = user_inventory[i]
			if item then
				for x = 1, #item_names do
					if string.find(item.name, item_names[x]) then
						print("found item in inventory, returning it!")
						table.insert(return_items, item)
						--callback(item)
						--return
						found = true
						break
					end
				end
			end
		end
		if found then
			callback(return_items)
		else
			print("did not find inventory items")
			-- not found if here, return nil:
			callback(nil)
		end
	--end)
end)

-- assumes quantity provided is less than or equal to_remove_item.quantity
RegisterServerEvent("usa:removeItem")
AddEventHandler("usa:removeItem", function(to_remove_item, quantity, from_source)
	print("inside usa:removeItem!")
	if from_source then source = from_source end
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_inventory = user.getActiveCharacterData("inventory")
		local user_weapons = user.getActiveCharacterData("weapons")
		local user_licenses = user.getActiveCharacterData("licenses")
		--print("checking inventory items...")
		for a = 1, #user_inventory do
			local item = user_inventory[a]
			--print("checking item: " .. item.name)
			if item.name == to_remove_item.name then
				if to_remove_item.quantity - quantity <= 0 then -- assumes quantity provided is less than or equal to to_remove_item.quantity
					print("found a matching inventory item for usa:removeItem! removing: " .. item.name)
					table.remove(user_inventory, a)
					user.setActiveCharacterData("inventory", user_inventory)
				else
					print("found a matching inventory item for usa:removeItem! decrementing: " .. item.name)
					user_inventory[a].quantity = user_inventory[a].quantity - quantity
					user.setActiveCharacterData("inventory", user_inventory)
				end
				return
			end
		end
		--print("checking license items...")
		for b = 1, #user_licenses do
			local item = user_licenses[b]
			--print("checking item: " .. item.name)
			if item.name == to_remove_item.name then
				print("found a matching license for usa:removeItem! removing: " .. item.name)
				if item.quantity == 1 then
					table.remove(user_licenses, b)
					user.setActiveCharacterData("licenses", user_licenses)
				else
					user_licenses[b].quantity = item.quantity - 1
					user.setActiveCharacterData("licenses", user_licenses)
				end
				return
			end
		end
		--print("checking weapon items...")
		for c = 1, #user_weapons do
			local item = user_weapons[c]
			--print("checking item: " .. item.name)
			if item.name == to_remove_item.name then
				print("found a matching weapon for usa:removeItem! removing: " .. item.name)
				if item.quantity - quantity <= 0 then
					table.remove(user_weapons, c)
					user.setActiveCharacterData("weapons", user_weapons)
					-- drop weapon --
					TriggerClientEvent("usa:dropWeapon", userSource, item.hash)
				else
					user_weapons[c].quantity = item.quantity - quantity
					user.setActiveCharacterData("weapons", user_weapons)
				end
				return
			end
		end
	--end)
end)

RegisterServerEvent("usa:insertItem")
AddEventHandler("usa:insertItem", function(to_insert_item, quantity, player_source, cb)
	print("inside usa:insertItem!")
	if player_source then source = player_source end
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		to_insert_item.quantity = quantity
		if user.getCanActiveCharacterHoldItem(to_insert_item) then
			if to_insert_item.type == "license" then
				print("inserting/incrementing license item!")
				-- insert into licenses
				local user_licenses = user.getActiveCharacterData("licenses")
				for i = 1, #user_licenses do
					local item = user_licenses[i]
					if item.name == to_insert_item.name then
						print("quantity increased for license item!")
						user_licenses[i].quantity = user_licenses[i].quantity + quantity
						user.setActiveCharacterData("licenses", user_licenses)
						if cb then cb(true) end
						return
					end
				end
				print("license inserted!")
				-- not in licenses already. insert:
				to_insert_item.quantity = quantity
				table.insert(user_licenses, to_insert_item)
				user.setActiveCharacterData("licenses", user_licenses)
				if cb then cb(true) end
			elseif to_insert_item.type == "weapon" then
				print("inserting/incrementing weapon item!")
				-- insert into weapons, assuming that we've checked that player had < 3 weapons
				local user_weapons = user.getActiveCharacterData("weapons")
				--[[
				for i = 1, #user_weapons do
					local item = user_weapons[i]
					if item.name == to_insert_item.name then
						print("quantity increased for weapon item!")
						user_weapons[i].quantity = user_weapons[i].quantity + quantity
						user.setActiveCharacterData("weapons", user_weapons)
						if cb then cb(true) end
						return
					end
				end
				--]]
				print("weapon inserted!")
				-- not in weapons already. insert:
				to_insert_item.quantity = quantity
				table.insert(user_weapons, to_insert_item)
				user.setActiveCharacterData("weapons", user_weapons)
				TriggerClientEvent("usa:equipWeapon", userSource, to_insert_item)
				if cb then cb(true) end
			else
				--print("inserting/incrementing inventory item!")
				--print("to_insert_item.name: " .. to_insert_item.name)
				-- insert into inventory
				local user_inventory = user.getActiveCharacterData("inventory")
				--print("#user_inventory: " .. #user_inventory)
				for z = 1, #user_inventory do
					local item = user_inventory[z]
					--print("checking item name for match: " .. item.name)
					if item.name == to_insert_item.name then
						print("quantity increased for inventory item!")
						user_inventory[z].quantity = user_inventory[z].quantity + quantity
						user.setActiveCharacterData("inventory", user_inventory)
						if cb then cb(true) end
						return
					end
				end
				print("inventory item inserted!")
				-- not in inventory already. insert:
				to_insert_item.quantity = quantity
				table.insert(user_inventory, to_insert_item)
				user.setActiveCharacterData("inventory", user_inventory)
				if cb then cb(true) end
			end
		else
			TriggerClientEvent("usa:notify", userSource, "Inventory full.")
			if cb then cb(false) end
		end
	--end)
end)

RegisterServerEvent("usa:loadCivCharacter")
AddEventHandler("usa:loadCivCharacter", function(id)
	local usource = source
	if id then usource = id end
	local player = exports["essentialmode"]:getPlayerFromId(usource)
	local chars = player.getCharacters()
	for i = 1, #chars do
		if chars[i].active == true then
			TriggerClientEvent("usa:loadCivCharacter", usource, chars[i].appearance, chars[i].weapons)
			return
		end
	end
end)

RegisterServerEvent("usa:loadPlayerComponents")
AddEventHandler("usa:loadPlayerComponents", function(id)
	local usource = source
	if id then usource = id end
	local player = exports["essentialmode"]:getPlayerFromId(usource)
	local chars = player.getCharacters()
	for i = 1, #chars do
		if chars[i].active == true then
			TriggerClientEvent("usa:setPlayerComponents", usource, chars[i].appearance)
			return
		end
	end
end)

RegisterServerEvent("usa:notifyStaff")
AddEventHandler("usa:notifyStaff", function(msg)
	sendMessageToModsAndAdmins(msg)
end)

function sendMessageToModsAndAdmins(msg)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						TriggerClientEvent("chatMessage", id, "", {}, msg)
					end
				end
			end
		end
	end)
end

TriggerEvent('es:addJobCommand', 'impound', { "police", "sheriff", "ems", "corrections" }, function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "Impound a vehicle." })

TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "(Delete) Impound a vehicle." })

RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local playerJob = user.getActiveCharacterData("job")
	local userGroup = user.getGroup()
	if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or userGroup == "owner" or userGroup == "admin" or userGroup == "mod" or userGroup == "superadmin" then
		if plate then
			-- update impounded status of vehicle in DB --
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				couchdb.updateDocument("vehicles", tostring(plate), { impounded = true }, function()
					-- done impounding vehicle --
				end)
			end)
		end
	else
		TriggerClientEvent("impound:notify", userSource, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
	end
end)

local jobsToLog = {
	'sheriff',
	'ems',
	'doctor',
	'police',
	'corrections'
}


RegisterServerEvent('job:sendNewLog')
AddEventHandler('job:sendNewLog', function(source, job, isOnDuty)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local userName = user.getActiveCharacterData('fullName')

	local reason = 'User signed on-duty'
	local color = 47156
	local author = 'User is On-Duty'
	if not isOnDuty then
		reason = 'User signed off-duty'
		color = 13565952
		author = 'User is Off-Duty'
	end

	local url = 'https://discordapp.com/api/webhooks/564121193058140160/pVOc_BO6_SGstdaVFI0DS-IMkD8Gz2Gd9ZLJpWGnXa3qdbfWWE0tG88jg7RDPq0CmGDo'
	PerformHttpRequest(url, function(err, text, headers)
		if text then
			print(text)
		end
	end, "POST", json.encode({
		embeds = {
			{
				color = color,

				author = {
					name = author
				},

				fields = {
			        {
			          name = "Identifier 1",
			          value = GetPlayerIdentifier(source),
			          inline = true
			        },
			        {
			          name = "Identifier 2",
			          value = userName,
			          inline = true
			        },
			        {
			          name = "Identifier 3",
			          value = GetPlayerName(source),
			          inline = true
			        },
			        {
			          name = "Job",
			          value = job,
			          inline = true
			        },
			        {
			          name = "Reason",
			          value = reason,
			          inline = true
			        },
		      	},

		      	footer = {
			        text = os.date('%m-%d-%Y %H:%M:%S', os.time()) .. ' PDT' 
			    }
			}
		},
	}), { ["Content-Type"] = 'application/json' })
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user then
		local userJob = user.getActiveCharacterData('job')
		local userName = user.getActiveCharacterData('fullName')
		for i = 1, #jobsToLog do
			if jobsToLog[i] == userJob then
				local url = 'https://discordapp.com/api/webhooks/564121193058140160/pVOc_BO6_SGstdaVFI0DS-IMkD8Gz2Gd9ZLJpWGnXa3qdbfWWE0tG88jg7RDPq0CmGDo'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							author = {
								name = 'User is Off-Duty'
							},

							fields = {
						        {
						          name = "Identifier 1",
						          value = GetPlayerIdentifier(source),
						          inline = true
						        },
						        {
						          name = "Identifier 2",
						          value = userName,
						          inline = true
						        },
						        {
						          name = "Identifier 3",
						          value = GetPlayerName(source),
						          inline = true
						        },
						        {
						          name = "Job",
						          value = userJob,
						          inline = true
						        },
						        {
						          name = "Reason",
						          value = 'User left the server',
						          inline = true
						        },
					      	},

					      	footer = {
						        text = os.date('%m-%d-%Y %H:%M:%S', os.time()) .. ' PDT' 
						    }
						}
					},
				}), { ["Content-Type"] = 'application/json' })
			end
		end
	end
end)

function commandsText(source)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "1) ^3/myjob <msg>^0 - see who you are currently employed with")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "5) ^3/id^0 - Show your ID")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "6) ^3/report <msg>^0 - report someone (include id)")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "6) ^3/help <msg>^0 - request help from a staff member (or respond to whisper)")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "7) ^3/me <msg>^0 - talks as yourself doing an action")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "8) ^3/givecash [id] [amount]^0 - to give cash")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "9) ^3/ad <msg>^0 - create an advertisement")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "10) ^3To send a tweet, buy a cell phone from the general store")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "11) ^3M^0 - open interaction menu")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "12) ^Hold ^2F3^0 to open the players list, see ID #'s'")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "13) ^3Press ^2F2^0 to toggle your voip range")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "14) ^3Press ^2U^0 to lock/unlock vehicles")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "15) ^3/open [option]^0 options: hood, trunk, fr, fl, br, bl, ambulance")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "16) ^3/close [option]^0 options: hood, trunk, fr, fl, br, bl, ambulance")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "17) ^3/engine - toggle your engine on and off")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "17) ^3B^0 to toggle your seat belt")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "18) Open chat with '^3T^0' then use ^3Page Up^0 to scroll up")
end

-- end util functions / start commands

TriggerEvent('es:addCommand', 'commands', function(source, args, user)
	commandsText(source)
end, {help = "Show some server commands. (Full list on website)"})

TriggerEvent('es:addCommand', 'discord', function(source, args, user)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "Discord: https://discord.me/usarrp")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^3Join the discord channel to keep up with the community! If that link doesn't work, visit the website.")
end, {help = "View the server's discord link."})
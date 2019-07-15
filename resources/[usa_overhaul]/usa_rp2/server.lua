local FIRST_AID_KIT_FEE = 80

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
	if GetPlayerName(source) then
		print("Player " .. GetPlayerName(source) .. " has loaded.")
	end
	TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
	local model = civSkins[math.random(1,#civSkins)]
	TriggerClientEvent("usa_rp:spawn", source, model)
end)


RegisterServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
AddEventHandler("usa_rp:checkJailedStatusOnPlayerJoin", function(id)
	if id then source = id end
	local time = exports["usa-characters"]:GetCharacterField(source, "jailTime")
	local name = exports["usa-characters"]:GetCharacterField(source, "name")
	local fullName = name.first .. " " .. name.middle .. " " .. name.last
	if time > 0 then
		TriggerClientEvent("jail:jail", source)
		exports["globals"]:notifyPlayersWithJobs({"corrections"}, "^3INFO: ^0" .. fullName .. " has woken up from a nap.")
	end
end)

RegisterServerEvent("hospital:buyFirstAidKit")
AddEventHandler("hospital:buyFirstAidKit", function()
	local kit = {
		name = "First Aid Kit",
		price = FIRST_AID_KIT_FEE,
		type = "misc",
		quantity = 1,
		legality = "legal",
		weight = 15,
		objectModel = "v_ret_ta_firstaid",
		blockedInPrison = true
	}
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("money") >= FIRST_AID_KIT_FEE then
		if not char.canHoldItem(kit) then
			TriggerClientEvent("usa:notify", source, "Inventory full!")
			return
		end
		char.giveItem(kit)
		char.removeMoney(FIRST_AID_KIT_FEE)
		TriggerClientEvent("usa:notify", source, "Here is your first aid kit!")
	else
		TriggerClientEvent("usa:notify", source, "Not enough money! Need $" .. FIRST_AID_KIT_FEE .. "")
	end
end)

-- V E H I C L E  C O N T R O L S
TriggerEvent('es:addCommand', 'rollw', function(source, args, char)
	TriggerClientEvent("RollWindow", source)
end, {
	help = "Roll the windows down"
})

TriggerEvent('es:addCommand', 'open', function(source, args, char)
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

TriggerEvent('es:addCommand', 'close', function(source, args, char)
	if args[2] then
		TriggerClientEvent("veh:shutDoor", source, args[2])
	end
end, {
	help = "Shut a door",
	params = {
		{ name = "door", help = "hood, trunk, fl, fr, bl, br, ambulance" }
	}
})

TriggerEvent('es:addCommand', 'shut', function(source, args, char)
	if args[2] then
		TriggerClientEvent("veh:shutDoor", source, args[2])
	end
end, {
	help = "Shut a door",
	params = {
		{ name = "door", help = "hood, trunk, fl, fr, bl, br, ambulance" }
	}
})

TriggerEvent('es:addCommand', 'shuffle', function(source, args, char)
	TriggerClientEvent("usa:shuffleSeats", source)

end, {
	help = "Shuffle seats in a vehicle"
})

TriggerEvent('es:addCommand', 'bl', function(source, args, char)
	TriggerClientEvent("usa:toggleBrakelight", source)
end, {
	help = "Toggle your vehicle idle brakelights"
})

-- R O L L  D I C E
RegisterServerEvent("usa:rollDice")
AddEventHandler("usa:rollDice", function(location, max)
	if max then
		local roll = math.random(1, max)
		local chatMsg = "Person with SSN " .. source .. " rolls a " .. roll .. " out of " .. max
		local msg3D = "Rolls a " .. roll .. " out of " .. max
		exports["globals"]:sendLocalActionMessageChat(chatMsg, location)
		exports["globals"]:sendLocalActionMessage(source, msg3D)
	end
end)

TriggerEvent('es:addCommand', 'roll', function(source, args, char, location)
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
	local user_money = exports["usa-characters"]:GetCharacterField(source, "money")
	if user_money >= amount then
		if takeMoney then
			exports["usa-characters"]:SetCharacterField(source, "money", user_money - amount)
		end
		if isServerEvent then
			TriggerEvent(callbackEventName)
		else
			TriggerClientEvent(callbackEventName, source)
		end
	else
		TriggerClientEvent("usa:notify", source, "Sorry, you don't have enough money to " .. activity .. "!")
	end
end)

-- see if user has item in Inventory:
-- if player has it, return it
-- if not, return nil
RegisterServerEvent("usa:getPlayerItem")
AddEventHandler("usa:getPlayerItem", function(from_source, item_name, callback)
	local char = exports["usa-characters"]:GetCharacter(tonumber(from_source))
	local item = char.getItem(item_name)
	if item then
		callback(item)
	else
		callback(nil)
	end
end)

-- see if user has item in Inventory:
-- if player has it, return it
-- if not, return nil
RegisterServerEvent("usa:getPlayerItems")
AddEventHandler("usa:getPlayerItems", function(from_source, item_names, callback)
	local return_items = {}
	local found = false
	local char = exports["usa-characters"]:GetCharacter(tonumber(from_source))
	for i = 1, #item_names do
		local item = char.getItem(item_names[i])
		if item then
			table.insert(return_items, item)
			found = true
		end
	end
	if found then
		callback(return_items)
	else
		callback(nil)
	end
end)

-- assumes quantity provided is less than or equal to_remove_item.quantity
RegisterServerEvent("usa:removeItem")
AddEventHandler("usa:removeItem", function(to_remove_item, quantity)
	local char = exports["usa-characters"]:GetCharacter(source)
	char.removeItem(to_remove_item, quantity)
end)

RegisterServerEvent("usa:insertItem")
AddEventHandler("usa:insertItem", function(to_insert_item, quantity, player_source, cb)
	local usource = source
	if player_source then
		usource = tonumber(player_source)
	end
	local char = exports["usa-characters"]:GetCharacter(usource)
	to_insert_item.quantity = quantity
	if char.canHoldItem(to_insert_item) then
		char.giveItem(to_insert_item)
		if cb then
			cb(true)
		end
	else
		TriggerClientEvent("usa:notify", usource, "Inventory full.")
		if cb then
			cb(false)
		end
	end
end)

RegisterServerEvent("usa:loadCivCharacter")
AddEventHandler("usa:loadCivCharacter", function(id)
	local usource = source
	if id then usource = id end
	local char = exports["usa-characters"]:GetCharacter(usource)
	local appearance = char.get("appearance")
	local weapons = char.getWeapons()
	TriggerClientEvent("usa:loadCivCharacter", usource, appearance, weapons)
end)

RegisterServerEvent("usa:loadPlayerComponents")
AddEventHandler("usa:loadPlayerComponents", function(id)
	local usource = source
	if id then usource = id end
	local appearance = exports["usa-characters"]:GetCharacterField(usource, "appearance")
	TriggerClientEvent("usa:setPlayerComponents", usource, appearance)
end)

TriggerEvent('es:addJobCommand', 'impound', { "police", "sheriff", "ems", "corrections", "dai" }, function(source, args, char)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "Impound a vehicle." })

TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, args, char)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "(Delete) Impound a vehicle." })

RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local userGroup = user.getGroup()
	local playerJob = exports["usa-characters"]:GetCharacterField(source, "job")
	if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or userGroup == "owner" or userGroup == "admin" or userGroup == "mod" or userGroup == "superadmin" then
		if plate then
			-- update impounded status of vehicle in DB --
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				couchdb.updateDocument("vehicles", plate, { impounded = true }, function()
					-- done impounding vehicle --
				end)
			end)
		end
	else
		TriggerClientEvent("impound:notify", source, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
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
	local char = exports["usa-characters"]:GetCharacter(source)
	local userName = char.getFullName()

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
	local char = exports["usa-characters"]:GetCharacter(source)
	if char then
		local userJob = char.get('job')
		local userName = char.getFullName()
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
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "17) ^3K^0 to toggle your seat belt")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "18) Open chat with '^3T^0' then use ^3Page Up^0 to scroll up")
end

-- end util functions / start commands

TriggerEvent('es:addCommand', 'commands', function(source, args, char)
	commandsText(source)
end, {help = "Show some server commands. (Full list on website)"})

TriggerEvent('es:addCommand', 'discord', function(source, args, char)
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "Discord: https://discord.me/usarrp")
	TriggerClientEvent("chatMessage", source, "", {255, 255, 255}, "^3Join the discord channel to keep up with the community! If that link doesn't work, visit the website.")
end, {help = "View the server's discord link."})

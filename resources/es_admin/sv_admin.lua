local permission = {
	kick = 1,
	ban = 4
}

local bans = {}

-- Adding custom groups called owner, inhereting from superadmin. (It's higher then superadmin). And moderator, higher then user but lower then admin
TriggerEvent("es:addGroup", "owner", "superadmin", function(group) end)
TriggerEvent("es:addGroup", "superadmin", "admin", function(group) end)
TriggerEvent("es:addGroup", "admin", "mod", function(group) end)
TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- staff pvt msg someone
TriggerEvent('es:addGroupCommand', 'whisper', 'mod', function(source, args, user)
	local target = tonumber(args[2])
	table.remove(args, 1)
	table.remove(args, 1)
	local message = table.concat(args, " ")
	if GetPlayerName(target) then
		TriggerClientEvent('chatMessage', source, "STAFF to (" .. GetPlayerName(target) .. ")", {90, 90, 60}, message)
		TriggerClientEvent('chatMessage', target, "STAFF (" .. GetPlayerName(source) .. ")", {90, 90, 60}, message)
	end
end, {
	help = "Send a message directly to a player.",
	params = {
		{ name = "id", help = "Player's id" },
		{ name = "message", help = "Staff message to player" }
	}
})

-- staff chat
TriggerEvent('es:addGroupCommand', 'staff', 'mod', function(source, args, user)
	local userGroup = user.getGroup()
	local staffId = tonumber(source)
	table.remove(args, 1) -- remove "/staff" from what the user enters into chat box
	local message = table.concat(args, " ") -- get all the remaining words separated by spaces the user enters into chat box
	if not message then
		TriggerClientEvent("chatMessage", tonumber(source), "", {}, "^2Usage: ^0/staff [message]")
		return
	end
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						TriggerClientEvent("chatMessage", id, "", {}, "^2STAFF:^0 "..GetPlayerName(staffId).." [#"..staffId.."]")
						TriggerClientEvent("chatMessage", id, "", {}, "^2MESSAGE:^0 " .. message)
					end
				end
			end
		end
	end)
end, {
	help = "Talk to other staff members directly.",
	params = {
		{ name = "message", help = "Message to send" }
	}
})

TriggerEvent('es:addCommand', 'report', function(source, args, user)
	local reporterId = tonumber(source)
	local reportedId = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local message = table.concat(args, " ")
	if not message or not reportedId then
		TriggerClientEvent("chatMessage", tonumber(source), "", {}, "^3Usage: ^0/report [id] [reason]")
		return
	end
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						TriggerClientEvent("chatMessage", id, "", {}, "^3****")
						TriggerClientEvent("chatMessage", id, "", {}, "^3REPORT FROM:^0 "..GetPlayerName(reporterId).." [#"..reporterId.."]")
						TriggerClientEvent("chatMessage", id, "", {}, "^3MESSAGE:^0 " .. reportedId .. " " .. message)
						TriggerClientEvent("chatMessage", id, "", {}, "^3****")
					end
				end
			end
		end
	end)
end, {
	help = "Report a player",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "message", help = "Reason for the report" }
	}
})

-- Append a message
function appendNewPos(msg)
	local file = io.open('resources/[essential]/es_admin/positions.txt', "a")
	newFile = msg
	file:write(newFile)
	file:flush()
	file:close()
end

-- Do them hashes
function doHashes()
  lines = {}
  for line in io.lines("resources/[essential]/es_admin/input.txt") do
  	lines[#lines + 1] = line
  end

  return lines
end


RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
	appendNewPos(str)
end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "mod", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
end, {
	help = "Move freely around the map."
})

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
	local userSource = source
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])

		-- User permission check
		TriggerEvent("es:getPlayerFromId", player, function(target)

			local reason = args
			table.remove(reason, 1)
			table.remove(reason, 1)
			if(#reason == 0)then
				reason = "kicked"
			else
				reason = table.concat(reason, " ")
			end
			-- send discord message
			local targetPlayerName = target.getActiveCharacterData("firstName") .. " " .. target.getActiveCharacterData("lastName")
			local allPlayerIdentifiers = GetPlayerIdentifiers(player)
			-- send discord message
			local desc = "**Character Name:** " .. targetPlayerName
			desc = desc .. "\n**Steam Name:** " .. GetPlayerName(player)
			for i = 1, #allPlayerIdentifiers do
				desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
			end
			desc = desc .. " \n**Reason:** " ..reason:gsub("Kicked: ", "").. " \n**Kicked By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())

			local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
					PerformHttpRequest(url, function(err, text, headers)
						if text then
							print(text)
						end
					end, "POST", json.encode({
						embeds = {
							{
								description = desc,
								color = 16777062,
								author = {
									name = "User Kicked From The Server"
								}
							}
						}
					}), { ["Content-Type"] = 'application/json' })

			sendMessageToModsAndAdmins(GetPlayerName(player) .. " has been kicked (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^3kicked^0 (" .. reason .. ")")
			DropPlayer(player, reason)
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, {
	help = "Kick a player.",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "message", help = "Reason for the kick (INCLUDE YOUR NAME)" }
	}
})

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
	 table.insert(t, a[i])
  end

  return t
end

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "mod", function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "ANNOUNCEMENT", {255, 0, 0}, "" .. table.concat(args, " "))
end, {
	help = "Send a server-wide message.",
	params = {
		{ name = "message", help = "message to send" }
	}
})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])

		-- User permission check
		TriggerEvent("es:getPlayerFromId", player, function(target)

			if(frozen[player])then
				frozen[player] = false
			else
				frozen[player] = true
			end

			TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

			local state = "unfrozen"
			if(frozen[player])then
				state = "frozen"
			end

			TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have been " .. state .. " by ^2" .. GetPlayerName(source))
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been " .. state)
			TriggerEvent('es:getPlayers', function(players)
				if players then
					-- notify all admins/mods
					for id, adminOrMod in pairs(players) do
						if id and adminOrMod then
							local adminOrModGroup = adminOrMod.getGroup()
							if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
								TriggerClientEvent('chatMessage', id, "", {255, 255, 255}, "Player ^2" .. user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName") .. "^0 froze " .. GetPlayerName(player))
							end
						end
					end
				end
			end)
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, {
	help = "Freeze a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])

		-- User permission check
		TriggerEvent("es:getPlayerFromId", player, function(target)

			TriggerClientEvent('es_admin:teleportUser', target.get('source'), user.getCoords().x, user.getCoords().y, user.getCoords().z)

			TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have brought by ^2" .. GetPlayerName(source))
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been brought")
			TriggerEvent('es:getPlayers', function(players)
				if players then
					-- notify all admins/mods
					for id, adminOrMod in pairs(players) do
						if id and adminOrMod then
							local adminOrModGroup = adminOrMod.getGroup()
							if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
								TriggerClientEvent('chatMessage', id, "", {255, 255, 255}, "Player ^2" .. GetPlayerName(player) .. "^0 has been brought by " .. GetPlayerName(source))
							end
						end
					end
				end
			end)
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, {
	help = "Bring a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])

		-- User permission check
		TriggerEvent("es:getPlayerFromId", player, function(target)

			TriggerClientEvent('es_admin:slap', player)

			TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have slapped by ^2" .. GetPlayerName(source))
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been slapped")
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, {
	help = "Slap a player / Make them fly into the air (TROLL DO NOT USE IN RP)",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if args[2] == "pd" then
		local pdCoords = {x=-447.256 , y=6000.667 , z=30.686}
		TriggerClientEvent('es_admin:teleportUser', source, pdCoords.x, pdCoords.y, pdCoords.z)
		return
	elseif args[2] == "c" or args[2] == "coords" then
		TriggerClientEvent('es_admin:teleportUser', source, tonumber(args[3]), tonumber(args[4]), tonumber(args[5]))
		return
	elseif args[2] == "wp" then
		TriggerClientEvent("swayam:gotoWP", source)
		return
	elseif args[2] == "fd" then
		local pdCoords = {x=-366.30380249023, y=6102.0532226563, z=35.439697265625}
		TriggerClientEvent('es_admin:teleportUser', source, pdCoords.x, pdCoords.y, pdCoords.z)
		return
	elseif args[2] == "247" then
		local pdCoords = {}
		TriggerClientEvent('es_admin:teleportUser', source, pdCoords.x, pdCoords.y, pdCoords.z)
		return
	elseif args[2] == "fd" then
		local pdCoords = {}
		TriggerClientEvent('es_admin:teleportUser', source, pdCoords.x, pdCoords.y, pdCoords.z)
		return
	end
	if tonumber(args[2]) ~= nil then
		if GetPlayerName(tonumber(args[2])) then
			local player = tonumber(args[2])

			TriggerEvent("es:getPlayerFromId", player, function(target)
				if (target) then

					TriggerClientEvent('es_admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)

					TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have been teleported to by ^2" .. GetPlayerName(source))
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Teleported to player ^2" .. GetPlayerName(player) .. "")
					TriggerEvent('es:getPlayers', function(players)
						if players then
							-- notify all admins/mods
							for id, adminOrMod in pairs(players) do
								if id and adminOrMod then
									local adminOrModGroup = adminOrMod.getGroup()
									if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
										TriggerClientEvent('chatMessage', id, "", {255, 255, 255}, "Player ^2" .. GetPlayerName(source) .. "^0 teleported to " .. GetPlayerName(player))
									end
								end
							end
						end
					end)
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
	end
end, {
	help = "Teleport to player or location.",
	params = {
		{ name = "id", help = "Player's ID or warp ID" }
	}
})

-- Kill yourself
TriggerEvent('es:addGroupCommand', 'die', "admin", function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
	TriggerClientEvent('chatMessage', source, "", {0,0,0}, "^1^*You killed yourself.")
end, {
	help = "Commit suicide."
})

-- Killing
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:kill', player)

				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have been killed by ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been killed.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, {
	help = "Kill a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])

		TriggerEvent("es:getPlayerFromId", player, function(target)
			TriggerClientEvent('es_admin:crash', player)
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been crashed.")
		end)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, {
	help = "Crash a player's game.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, {
	help = "Save pos to txt"
})

TriggerEvent('es:addGroupCommand', 'car', 'superadmin', function(source, args, user)
	TriggerClientEvent('es_admin:spawnVehicle', source, args[2])
end, {
	help = "Spawn a car (not to be abused, we are watching..)",
	params = {
		{ name = "model", help = "Model of the car" }
	}
})

TriggerEvent('es:addGroupCommand', 'spectate', 'mod', function(source, args, user)
	local userSource = tonumber(source)
	local targetPlayer = tonumber(args[2])
	if not targetPlayer then return end
	TriggerClientEvent("mini_admin:spectate", userSource, targetPlayer, GetPlayerName(targetPlayer), user.getActiveCharacterData("fullName"))
end, {
	help = "Spectate a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "unban" then
		local identifierToUnban = args[1]
		if not identifierToUnban then RconPrint("Usage: unban [identifier] ") CancelEvent() return end
		for i = 1, #bans do
			local bannedPlayer = bans[i]
			local identifiers = bannedPlayer.identifiers
			local docid = bannedPlayer._id
			local docRev = bannedPlayer._rev
			if identifiers then
				for j = 1, #identifiers do
					if string.sub(identifiers[j],1,20) == string.sub(identifierToUnban,1,20) then
						--RconPrint("\nfound a matching identifer to unban for "..bannedPlayer.name.."!")
						-- found a match, unban
						PerformHttpRequest("http://127.0.0.1:5984/bans/"..docid.."?rev="..docRev, function(err, rText, headers)
							if err == 0 then
								RconPrint("\nrText = " .. rText)
								RconPrint("\nerr = " .. err)
							else
								fetchAllBans()
							end
						end, "DELETE", "", {["Content-Type"] = 'application/json'})
						RconPrint("\nPlayer "..bannedPlayer.name.." has been unbanned!")
						CancelEvent()
						return
					end
				end
			else 
			
			end
		end
		RconPrint("\nNo match found for identifier: " .. identifierToUnban .. "!")
		CancelEvent()
	elseif commandName == "freeze" then
		if(GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

				local state = "unfrozen"
				if(frozen[player])then
					state = "frozen"
				end
				RconPrint("You froze player " .. GetPlayerName(player) .. ".")
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have been " .. state .. " by ^2an admin.")
				TriggerEvent('es:getPlayers', function(players)
					if players then
						-- notify all admins/mods
						for id, adminOrMod in pairs(players) do
							if id and adminOrMod then
								local adminOrModGroup = adminOrMod.getGroup()
								if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
									TriggerClientEvent('chatMessage', id, "", {255, 255, 255}, "The server console^0 froze " .. GetPlayerName(player))
								end
							end
						end
					end
				end)
			end)
		else
			RconPrint("INVALID PLAYER ID!")
		end
	elseif commandName == "ban" then
		RconPrint("BAN COMMAND CALLED FROM RCON!")
		if #args < 2 then
			RconPrint("Usage: ban [user-id] [reason]\n")
			CancelEvent()
			return
		end
		RconPrint("banning player = " .. GetPlayerName(tonumber(args[1])))
		RconPrint("\nid = " .. args[1])
		-- ban player
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = tonumber(args[1])
			local targetPlayerName = GetPlayerName(targetPlayer)
			table.remove(args, 1) -- remove id
			local reason = table.concat(args, " ")
			local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
			RconPrint("\nPlayer Identifiers:")
			for i = 1, #allPlayerIdentifiers do
				RconPrint("\n#"..i..": " .. allPlayerIdentifiers[i])
			end
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			-- character name:
			local player = exports["essentialmode"]:getPlayerFromId(targetPlayer)
			local char_name = player.getActiveCharacterData("fullName")
			-- send discord message
			local desc = "**Character Name:** " .. char_name
			desc = desc .. "\n**Steam Name:** " .. targetPlayerName
			for i = 1, #allPlayerIdentifiers do
				desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
			end
			desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
			local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			-- update db
			GetDoc.createDocument("bans",  {char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				-- drop player from session
				--print("banning player with endpoint: " .. GetPlayerEP(targetPlayer))
				DropPlayer(targetPlayer, "Banned: " .. reason)
				-- refresh lua table of bans for this resource
				fetchAllBans()
			end)
		end)
	elseif commandName == "banid" then
		-- see if input was correct --
		RconPrint("BANID COMMAND CALLED FROM RCON!")
		if #args < 4 then
			RconPrint("Usage: banid [steam:123456789] [first name] [last name] [reason]\n")
			CancelEvent()
			return
		end
		-- enter player into ban table --
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = args[1]
			local allPlayerIdentifiers = {}
			table.insert(allPlayerIdentifiers, targetPlayer)
			local targetPlayerName = args[2] .. " " .. args[3]
			table.remove(args, 1) -- remove id
			table.remove(args, 1) -- remove fname
			table.remove(args, 1) -- remove lname
			local reason = table.concat(args, " ")
			RconPrint("\nPlayer Identifier: " .. args[1])
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(targetPlayerName .. " has been ^1banned^0 (" .. reason .. ").")
			-- update db --
			GetDoc.createDocument("bans",  {char_name = "?", name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				-- refresh lua table of bans for this resource --
				fetchAllBans()
				-- send discord message --
				local desc = "\n**Name:** " .. targetPlayerName
				desc = desc .. "\n**Identifier:** " .. targetPlayer
				desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
				local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			end)
		end)
	elseif commandName == "tempbanid" then
		-- see if input was correct --
		RconPrint("TEMPBANID COMMAND CALLED FROM RCON!")
		if #args < 4 then
			RconPrint("Usage: tempbanid [steam:123456789] [time] [first name] [last name] [reason]\n")
			RconPrint("Note: if you don't know the first or last name just put an 'x' or '?' in place of it\n")
			CancelEvent()
			return
		end
		-- enter player into ban table --
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = args[1]
			local time = tonumber(args[2])
			local allPlayerIdentifiers = {}
			table.insert(allPlayerIdentifiers, targetPlayer)
			local targetPlayerName = args[3] .. " " .. args[4]
			table.remove(args, 1) -- remove id
			table.remove(args, 1) -- remove time
			table.remove(args, 1) -- remove fname
			table.remove(args, 1) -- remove lname
			local reason = table.concat(args, " ")
			RconPrint("\nPlayer Identifier: " .. args[1])
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(targetPlayerName .. " has been ^1banned^0 (" .. reason .. ").")
			-- update db --
			GetDoc.createDocument("bans",  {time = os.time(), duration = time, char_name = "?", name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				-- refresh lua table of bans for this resource --
				fetchAllBans()
				-- send discord message --
				local desc = "\n**Name:** " .. targetPlayerName
				desc = desc .. "\n**Identifier:** " .. targetPlayer
				desc = desc .. " \n**Time:** " .. time .. " hour(s)"
				desc = desc .. " \n**Reason:** " ..reason:gsub("Temp Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
				local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Temp Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			end)
		end)
	elseif commandName == 'setadmin' then
		if #args ~= 2 then
			RconPrint("Usage: setadmin [user-id] [permission-level]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			if(true)then
				print(args[1] .. " " .. args[2])
				TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
				TriggerClientEvent('chatMessage', -1, "CONSOLE", {255, 255, 255}, "Permission level of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2 " .. args[2])
			end
		end)

		CancelEvent()
	elseif commandName == 'setgroup' then
		if #args ~= 2 then
			RconPrint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)
					RconPrint(response)

					if(true)then
						print(args[1] .. " " .. args[2])
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
						TriggerClientEvent('chatMessage', -1, "CONSOLE", {255, 255, 255}, "Group of ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 has been set to ^2^*" .. args[2])
					end
				end)
			else
				RconPrint("This group does not exist.\n")
			end
		end)

	elseif commandName == 'setmoney' then
		if #args ~= 2 then
			RconPrint("Usage: setmoney [user-id] [money]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
			if(user)then
				user.setActiveCharacterData("money", tonumber(args[2]))

				RconPrint("Money set")
				TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {255, 255, 255}, "Your money has been set to: ^2^*$" .. tonumber(args[2]))
			end
		end)

	end
	CancelEvent()
end)

-- Logging
AddEventHandler("es:adminCommandRan", function(source, command)

end)

--------------- BAN MANAGEMENT: -------------------

function fetchAllBans()
	print("fetching all bans...")
	PerformHttpRequest("http://127.0.0.1:5984/bans/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting bans...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			bans = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all bans from 'bans' db into lua table
			for i = 1, #(response.rows) do
				table.insert(bans, response.rows[i].doc)
			end
			print("finished loading bans...")
			print("# of bans: " .. #bans)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

-- Fetch all bans when resource starts
fetchAllBans()

-- check for player being banned
AddEventHandler('playerConnecting', function(name, setReason)
	--local identifier = GetPlayerIdentifiers(source)[1]
	local allPlayerIdentifiers = GetPlayerIdentifiers(tonumber(source))
	for i = 1, #bans do
		local bannedPlayer = bans[i]
		local allBannedPlayerIdentifiers = bannedPlayer.identifiers
		if allBannedPlayerIdentifiers then
			for j = 1, #allBannedPlayerIdentifiers do
				local bannedPlayerId = allBannedPlayerIdentifiers[j]
				for k = 1, #allPlayerIdentifiers do
					local connectingPlayerId = allPlayerIdentifiers[k]
					if bannedPlayerId == connectingPlayerId then
						if bannedPlayer.duration then
							if getHoursFromTime(bannedPlayer.time) < bannedPlayer.duration then
								print("getHoursFromTime(bannedPlayer.time): " .. getHoursFromTime(bannedPlayer.time))
								print(GetPlayerName(tonumber(source)) .. " has been temp banned from your server and should not be able to play!")
								setReason("Temp Banned: " .. bannedPlayer.reason .. ". This ban is in place for " .. bannedPlayer.duration .. " hour(s).")
								CancelEvent()
								return
							else
								local docid = bannedPlayer._id
								local docRev = bannedPlayer._rev
								--RconPrint("\nfound a matching identifer to unban for "..bannedPlayer.name.."!")
								-- found a match, unban
								PerformHttpRequest("http://127.0.0.1:5984/bans/"..docid.."?rev="..docRev, function(err, rText, headers)
									if err == 0 then
										print("\nrText = " .. rText)
										print("\nerr = " .. err)
									else
										fetchAllBans()
									end
								end, "DELETE", "", {["Content-Type"] = 'application/json'})
								print("\nPlayer "..bannedPlayer.name.." has been unbanned!")
								return
							end
						else
							print(GetPlayerName(tonumber(source)) .. " has been perma banned from your server and should not be able to play!")
							setReason("Banned: " .. bannedPlayer.reason .. ". You may file an appeal at https://usarrp.net")
							CancelEvent()
							return
						end
					end
				end
			end
		end
	end
end)

	-- ban command
	TriggerEvent('es:addGroupCommand', 'ban', "admin", function(source, args, user)
		local userSource = tonumber(source)
		-- add player to ban list
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = GetPlayerName(userSource)
			local bannerId = GetPlayerIdentifiers(userSource)[1]
			local targetPlayer = tonumber(args[2])
			local targetPlayerName = GetPlayerName(targetPlayer)
			table.remove(args,1) -- remove /test
			table.remove(args, 1) -- remove id
			local reason = table.concat(args, " ")
			local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
			print("#allPlayerIdentifiers = " .. #allPlayerIdentifiers)
			for i = 1, #allPlayerIdentifiers do
				print("allPlayerIdentifiers[i] = " .. allPlayerIdentifiers[i])
			end
			-- show message
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
			-- get char name:
			local player = exports["essentialmode"]:getPlayerFromId(targetPlayer)
			local char_name = player.getActiveCharacterData("fullName")
			local desc = "**Character Name:** " .. char_name
			-- send discord message
			desc = desc .. "\n**Display Name:** " .. targetPlayerName
			for i = 1, #allPlayerIdentifiers do
				desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
			end
			desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())

			local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			-- update db
			GetDoc.createDocument("bans",  {char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				print("player banned!")
				-- drop player from session
				--print("banning player with endpoint: " .. GetPlayerEP(targetPlayer))
				DropPlayer(targetPlayer, "Banned: " .. reason .. " -- You can file an appeal at https://usarrp.net")
				-- refresh lua table of bans for this resource
				fetchAllBans()
			end)
		end)
	end, {
		help = "Ban a player from the server.",
		params = {
			{ name = "id", help = "Player's ID" },
			{ name = "reason", help = "The reason of the ban. Please include as much detail as possible."  }
		}
	})

	-- temp ban command // Usage: /tempban id time (in hours) reason
	TriggerEvent('es:addGroupCommand', 'tempban', "admin", function(source, args, user)
		local userSource = tonumber(source)
		-- add player to ban list
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = GetPlayerName(userSource)
			local bannerId = GetPlayerIdentifiers(userSource)[1]
			local targetPlayer = tonumber(args[2])
			local targetPlayerName = GetPlayerName(targetPlayer)
			local time = tonumber(args[3])
			local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
			table.remove(args,1) -- remove /tempban
			table.remove(args, 1) -- remove id
			table.remove(args, 1) -- remove time
			local reason = table.concat(args, " ")
			local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
			print("#allPlayerIdentifiers = " .. #allPlayerIdentifiers)
			for i = 1, #allPlayerIdentifiers do
				print("allPlayerIdentifiers[i] = " .. allPlayerIdentifiers[i])
			end
			-- show message
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(GetPlayerName(targetPlayer) .. " has been ^1temp banned^0 for " .. time .. " (" .. reason .. ")")
			-- get char name:
			local player = exports["essentialmode"]:getPlayerFromId(targetPlayer)
			local char_name = player.getActiveCharacterData("fullName")
			local desc = "**Character Name:** " .. char_name
			-- send discord message
			desc = desc .. "\n**Display Name:** " .. targetPlayerName
			for i = 1, #allPlayerIdentifiers do
				desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
			end
			desc = desc .. " \n**Time:** " .. time .. " hour(s)"
			desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
			local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Temp Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			-- update db
			GetDoc.createDocument("bans",  {time = os.time(), duration = time, char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				print("player banned!")
				-- drop player from session
				--print("banning player with endpoint: " .. GetPlayerEP(targetPlayer))
				DropPlayer(targetPlayer, "Temp Banned: " .. reason .. " This ban is in place for " .. time .. " hour(s).")
				-- refresh lua table of bans for this resource
				fetchAllBans()
			end)
		end)
	end, {
		help = "Tempban a player from the server.",
		params = {
			{ name = "id", help = "Player's ID" },
			{ name = "duration", help = "Duration of ban (in hours)" },
			{ name = "reason", help = "The reason of the temp ban. Please include as much detail as possible." }
		}
	})

RegisterServerEvent('mini:checkPlayerBannedOnSpawn')
AddEventHandler('mini:checkPlayerBannedOnSpawn', function()
	print("checking if loaded player is banned...")
	local allPlayerIdentifiers = GetPlayerIdentifiers(tonumber(source))
	for i = 1, #bans do
		local bannedPlayer = bans[i]
		local allBannedPlayerIdentifiers = bannedPlayer.identifiers
		if allBannedPlayerIdentifiers then
			for j = 1, #allBannedPlayerIdentifiers do
				local bannedPlayerId = allBannedPlayerIdentifiers[j]
				for k = 1, #allPlayerIdentifiers do
					local connectingPlayerId = allPlayerIdentifiers[k]
					if bannedPlayerId == connectingPlayerId then
						if bannedPlayer.duration then
							if getHoursFromTime(bannedPlayer.time) < bannedPlayer.duration then
								print(GetPlayerName(tonumber(source)) .. " has been temp banned from your server and should not be able to play!")
								DropPlayer(tonumber(source), "Temp Banned: " .. bannedPlayer.reason .. " This ban is in place for " .. bannedPlayer.duration .. " hour(s).")
							else
								local docid = bannedPlayer._id
								local docRev = bannedPlayer._rev
										--RconPrint("\nfound a matching identifer to unban for "..bannedPlayer.name.."!")
										-- found a match, unban
										PerformHttpRequest("http://127.0.0.1:5984/bans/"..docid.."?rev="..docRev, function(err, rText, headers)
											if err == 0 then
												print("\nrText = " .. rText)
												print("\nerr = " .. err)
											else
												fetchAllBans()
											end
										end, "DELETE", "", {["Content-Type"] = 'application/json'})
										print("\nPlayer "..bannedPlayer.name.." has been unbanned!")
							end
						else
							print(GetPlayerName(tonumber(source)) .. " has been banned from your server and should not be able to play!")
							DropPlayer(tonumber(source), "Banned: " .. bannedPlayer.reason)
						end
					end
				end
			end
		end
	end
end)

-- unban stuff im gunna need:
--[[
idents = GetPlayerIdentifiers(source)
TriggerEvent('es:exposeDBFunctions', function(usersTable)
usersTable.getDocumentByRow("dbnamehere", "identifier" , idents[1], function(result)
docid = result._id (except probably change to the _rev instead)
--]]

TriggerEvent('es:addCommand', 'stats', function(source, args, user)
	if args[2] then
		--admins only
		if user.getGroup() == "mod" or user.getGroup() == "admin" or user.getGroup() == "superadmin" or user.getGroup() == "owner" then
			TriggerEvent("es:getPlayerFromId", tonumber(args[2]), function(user)
				if user then
					local vehiclenames = ""
					local userVehicles = user.getActiveCharacterData("vehicles")
					for i = 1, #userVehicles do
						local vehicle = userVehicles[i]
						vehiclenames = vehiclenames .. userVehicles[i].model
						if i ~= #userVehicles then
							vehiclenames = vehiclenames .. ", "
						end
					end
					local weaponnames = ""
					local userWeapons = user.getActiveCharacterData("weapons")
					for i = 1, #userWeapons do
						local weapon = userWeapons[i]
						weaponnames = weaponnames .. userWeapons[i].name
						if i ~= #userWeapons then
							weaponnames = weaponnames .. ", "
						end
					end
					local inventorynames = ""
					local userInventory = user.getActiveCharacterData("inventory")
					for i = 1, #userInventory do
						--local inventory = userInventory[i]
						--local quantity = inventory.quantity
						inventorynames = inventorynames .. userInventory[i].name .. "(" .. userInventory[i].quantity .. ")"
						if i ~= #userInventory then
							inventorynames = inventorynames .. ", "
						end
					end
					local firearms_permit = "Invalid"
					local driving_license = "Invalid"
					local userLicenses = user.getActiveCharacterData("licenses")
					for i = 1, #userLicenses do
						local license = userLicenses[i]
						if license.name == "Driver's License"  then
							driving_license = "Valid"
						elseif license.name == "Firearm Permit" then
							firearms_permit = "Valid"
						end
					end

					local insurance = user.getActiveCharacterData("insurance")
					local insurance_month = insurance.expireMonth
					local insurance_year = insurance.expireYear
					local displayInsurance = "Invalid"
					if insurance_month and insurance_year then
						displayInsurance = insurance_month .. "/" .. insurance_year
					end

					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Name: " .. user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName") .. " | Identifer: " .. user.getIdentifier() .. " | Group: " .. user.getGroup() .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Police Rank: " .. user.getActiveCharacterData("policeRank") .. " | EMS Rank: " .. user.getActiveCharacterData("emsRank") .. " | Delta PMC Rank: " .. user.getActiveCharacterData("securityRank") .. " |  Job: " .. user.getActiveCharacterData("job") .. " |" )
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Cash: " .. user.getActiveCharacterData("money") .. " | Bank: " .. user.getActiveCharacterData("bank") .. " |  Ingame Time: " .. FormatSeconds(user.getActiveCharacterData("ingameTime")) .. " |" )
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Vehicles: " .. vehiclenames .. " | Insurance: " .. displayInsurance .. " | Driver's License: " .. driving_license .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weapons: " .. weaponnames .. " | Firearms License: " .. firearms_permit .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Inventory: " .. inventorynames .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weight: " .. user.getActiveCharacterCurrentInventoryWeight())
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 255, 255}, "User not found!")
				end
			end)
		end
	else
		--show player stats
		local vehiclenames = ""
		local userVehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #userVehicles do
			local vehicle = userVehicles[i]
			vehiclenames = vehiclenames .. userVehicles[i].model
			if i ~= #userVehicles then
				vehiclenames = vehiclenames .. ", "
			end
		end
		local weaponnames = ""
		local userWeapons = user.getActiveCharacterData("weapons")
		for i = 1, #userWeapons do
			local weapon = userWeapons[i]
			weaponnames = weaponnames .. userWeapons[i].name
			if i ~= #userWeapons then
				weaponnames = weaponnames .. ", "
			end
		end
		local inventorynames = ""
		local userInventory = user.getActiveCharacterData("inventory")
		for i = 1, #userInventory do
			--local inventory = userInventory[i]
			--local quantity = inventory.quantity
			if userInventory[i] then
				inventorynames = inventorynames .. userInventory[i].name .. "(" .. userInventory[i].quantity .. ")"
				if i ~= #userInventory then
					inventorynames = inventorynames .. ", "
				end
			end
		end
		local firearms_permit = "Invalid"
		local driving_license = "Invalid"
		local userLicenses = user.getActiveCharacterData("licenses")
		for i = 1, #userLicenses do
			local license = userLicenses[i]
			if license.name == "Driver's License"  then
				driving_license = "Valid"
			elseif license.name == "Firearm Permit" then
				firearms_permit = "Valid"
			end
		end

		local insurance = user.getActiveCharacterData("insurance")
		local insurance_month = insurance.expireMonth
		local insurance_year = insurance.expireYear
		local displayInsurance = "Invalid"
		if insurance_month and insurance_year then
			displayInsurance = insurance_month .. "/" .. insurance_year
		end

		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Name: " .. user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName") .. " | Identifer: " .. user.getIdentifier() .. " | Group: " .. user.getGroup() .. " |")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Police Rank: " .. user.getActiveCharacterData("policeRank") .. " | EMS Rank: " .. user.getActiveCharacterData("emsRank") .. " | Delta PMC Rank: " .. user.getActiveCharacterData("securityRank") .. " |  Job: " .. user.getActiveCharacterData("job") .. " |" )
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Cash: " .. user.getActiveCharacterData("money") .. " | Bank: " .. user.getActiveCharacterData("bank") .. " |  Ingame Time: " .. FormatSeconds(user.getActiveCharacterData("ingameTime")) .. " |" )
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Vehicles: " .. vehiclenames .. " | Insurance: " .. displayInsurance .. " | Driver's License: " .. driving_license .. " |")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weapons: " .. weaponnames .. " | Firearms License: " .. firearms_permit .. " |")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Inventory: " .. inventorynames .. " |")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weight: " .. user.getActiveCharacterCurrentInventoryWeight())
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
	end
end, {
	help = "View character statistics."
})

function FormatSeconds(mins)
	local output = ""
	local days = math.floor(mins / 1440)
	local remainder = mins % 1440
	local hours = math.floor(remainder / 60)
	local mins = remainder % 60
	if days ~= 0 then
		output = days .. " Days"
	end
	if output ~= "" then
		output = output .. ", "
	end
	if hours ~= 0 then
		output = output .. hours .. " Hrs"
	end
	if output ~= "" then
		output = output .. ", "
	end
	output = output .. mins .. " Mins"
	return output
end

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

function getHoursFromTime(time)
	local reference = time
	local hoursfrom = os.difftime(os.time(), reference) / (60 * 60) -- seconds in a day
	local hours = math.floor(hoursfrom)
	print("hours = " .. hours) -- today it prints "1"
	return hours
end

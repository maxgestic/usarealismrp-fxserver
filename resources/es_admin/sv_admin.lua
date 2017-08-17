local permission = {
	kick = 1,
	ban = 4
}

-- Adding custom groups called owner, inhereting from superadmin. (It's higher then superadmin). And moderator, higher then user but lower then admin
TriggerEvent("es:addGroup", "owner", "superadmin", function(group) end)
TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Level: ^*^2 " .. tostring(user.get('permission_level')))
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Group: ^*^2 " .. user.getGroup())
end)

TriggerEvent('es:addCommand', 'hash', function(source, args, user)
	TriggerClientEvent('es_admin:getHash', source, args[2])
end)

-- Default commands
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
				if player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						TriggerClientEvent("chatMessage", id, "REPORT ["..reporterId.."]", {255, 51, 204}, reportedId .. " " .. message)
					end
				end
			end
		end
	end)
end)

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

TriggerEvent('es:addGroupCommand', 'hashes', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:doHashes', source, doHashes())
end, function(source, args, user)end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "mod", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

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

				-- send discord notification
				local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
						PerformHttpRequest(url, function(err, text, headers)
							if text then
								print(text)
							end
						end, "POST", json.encode({
							embeds = {
								{
									description = "**Display Name:** " ..GetPlayerName(player).. " \n**Identifier:** " ..target.getIdentifier().. " \n**Reason:** " ..reason:gsub("Kicked: ", "").. " \n**Kicked By:** "..GetPlayerName(userSource),
									color = 16777062,
									author = {
										name = "User Kicked From The Server"
									}
								}
							}
						}), { ["Content-Type"] = 'application/json' })

				TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, GetPlayerName(player) .. " has been ^3kicked^0 (" .. reason .. ")")
				DropPlayer(player, reason)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "admin", function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "ANNOUNCEMENT", {255, 0, 0}, "" .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

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
					-- notify all admins/mods
					for id, adminOrMod in pairs(players) do
						local adminOrModGroup = adminOrMod.getGroup()
						if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
							TriggerClientEvent('chatMessage', id, "", {0, 0, 0}, "Player ^2" .. GetPlayerName(source) .. "^0 froze " .. GetPlayerName(player))
						end
					end
				end)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

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
					-- notify all admins/mods
					for id, adminOrMod in pairs(players) do
						local adminOrModGroup = adminOrMod.getGroup()
						if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
							TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been brought by " .. GetPlayerName(id))
						end
					end
				end)
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

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
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then

					TriggerClientEvent('es_admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)

					TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "You have been teleported to by ^2" .. GetPlayerName(source))
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Teleported to player ^2" .. GetPlayerName(player) .. "")
					TriggerEvent('es:getPlayers', function(players)
						-- notify all admins/mods
						for id, adminOrMod in pairs(players) do
							local adminOrModGroup = adminOrMod.getGroup()
							if adminOrModGroup == "mod" or adminOrModGroup == "admin" or adminOrModGroup == "superadmin" or adminOrModGroup == "owner" then
								TriggerClientEvent('chatMessage', id, "", {0, 0, 0}, "Player ^2" .. GetPlayerName(source) .. "^0 teleported to " .. GetPlayerName(player))
							end
						end
					end)
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
	TriggerClientEvent('chatMessage', source, "", {0,0,0}, "^1^*You killed yourself.")
end)

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
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('es_admin:crash', player)

				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been crashed.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

TriggerEvent('es:addCommand', 'car', function(source, args, user)
	if user.getGroup() == "superadmin" or user.getGroup() == "owner" or user.getGroup() == "admin" then
		TriggerClientEvent('es_admin:spawnVehicle', source, args[2])
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient permissions!")
	end
end)


-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setadmin' then
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
				TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Permission level of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2 " .. args[2])
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
						TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Group of ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 has been set to ^2^*" .. args[2])
					end
				end)
			else
				RconPrint("This group does not exist.\n")
			end
		end)

		CancelEvent()
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
					user.setMoney(tonumber(args[2]))

					RconPrint("Money set")
					TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "Your money has been set to: ^2^*$" .. tonumber(args[2]))
				end
			end)

			CancelEvent()
		end
end)

-- Logging
AddEventHandler("es:adminCommandRan", function(source, command)

end)

--------------- BAN MANAGEMENT: -------------------
local bans = {}

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
		local identifier = GetPlayerIdentifiers(source)[1]
		for i = 1, #bans do
			local bannedPlayer = bans[i]
			if identifier == bannedPlayer.identifier then
				print("player with identifier: " .. identifier .. " has been banned from your server and should not be allowed to connect!")
				setReason("Banned: " .. bannedPlayer.reason .. ". You may file an appeal at usarpp.enjin.com.")
				CancelEvent()
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
			local targerPlayerName = GetPlayerName(targetPlayer)
			table.remove(args,1) -- remove /test
			table.remove(args, 1) -- remove id
			local reason = table.concat(args, " ")
			idents = GetPlayerIdentifiers(targetPlayer)
			local id = idents[1]
			-- show message
		    TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")

			-- send discord message
			local url = 'https://discordapp.com/api/webhooks/319634825264758784/V2ZWCUWsRG309AU-UeoEMFrAaDG74hhPtDaYL7i8H2U3C5TL_-xVjN43RNTBgG88h-J9'
				PerformHttpRequest(url, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = "**Display Name:** " ..GetPlayerName(targetPlayer).. " \n**Identifier:** " .. id .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** "..GetPlayerName(userSource),
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })

			-- drop player from session
			DropPlayer(targetPlayer, "Banned: " .. reason)
			-- update db
			GetDoc.createDocument("bans",  {name = targerPlayerName, identifier = id, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date("%c", os.time())}, function()
				print("player banned!")
				fetchAllBans() -- refresh lua table of bans for this resource
			end)
		end)
	end, function(source,args,user)
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
	end)

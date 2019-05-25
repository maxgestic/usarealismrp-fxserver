local POLICE_RANKS = {
	[1] = "Cadet",
	[2] = "Trooper",
	[3] = "Senior Trooper",
	[4] = "Probationary Sergeant",
	[5] = "Sergeant",
	[6] = "Lieutenant",
	[7] = "Captain",
	[8] = "Deputy Commissioner",
	[9] = "Commissioner"
}

local target_player_id = 0

TriggerEvent('es:addJobCommand', 'ticket', { 'sheriff', 'police' , 'judge', "corrections"}, function(source, args, user)
	local targetPlayer = tonumber(args[2])
	local amount = math.ceil(tonumber(args[3]))
	table.remove(args, 1)
	table.remove(args, 1)
	table.remove(args, 1)
	local reason = table.concat(args, " ")
	if not targetPlayer or not amount or reason == "" or reason == " " or amount > 5000 then
		TriggerClientEvent("usa:notify", source, "~y~Usage: ~w~/ticket [id] [amount] [infractions]")
		return
	end
	print("player is getting ticketed for $" .. amount .. "! by officer " .. GetPlayerName(source))
	local target = exports["essentialmode"]:getPlayerFromId(targetPlayer)
	local target_name = target.getActiveCharacterData('fullName')
	local target_bank = target.getActiveCharacterData('bank')
	TriggerClientEvent('usa:notify', source, 'Ticket issued to ~y~'..target_name..'~s~ for ~y~$'..amount..'~s~!')
	target.setActiveCharacterData("bank", target_bank - amount)
	local ticket = {
		reason = reason,
		fine = amount,
		timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
		issuedBy = user.getActiveCharacterData('fullName'),
		type = "ticket",
		number = 'T'..math.random(10000000, 99999999)
	}
	local user_history = target.getActiveCharacterData("criminalHistory")
	table.insert(user_history, ticket)
	target.setActiveCharacterData("criminalHistory", user_history)
	TriggerClientEvent('chatMessage', targetPlayer, '^3^*[TICKET] ^r^0You have been issued a ticket for ^3$'..amount..'^0. ('..reason..')')
end, {
	help = "Write a ticket to player",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "amount", help = "Fine Amount" },
		{ name = "infractions", help = "Traffic Infractions" }
	}
})

RegisterServerEvent("police:payTicket")
AddEventHandler("police:payTicket", function(fromPlayerId, amount, reason, wantsToPay)
	local userSource = tonumber(source)
	if wantsToPay then
		--TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user = exports["essentialmode"]:getPlayerFromId(userSource)
			if user then
				local user_char_name = user.getActiveCharacterData("fullName")
				local user_money = user.getActiveCharacterData("money")
				if user_money >= tonumber(amount) then
					user.setActiveCharacterData("money", user_money - tonumber(amount))
					TriggerClientEvent("police:notify", userSource, "You have ~g~signed~w~ your ticket of $" .. comma_value(amount) .. "!")
					TriggerClientEvent("police:notify", fromPlayerId, user_char_name .. " has ~g~signed~w~ their ticket of $" .. comma_value(amount) .. "!")
				else
					local user_bank = user.getActiveCharacterData("bank")
					if user_bank >= tonumber(amount) then
						print("player had enough money in their bank for ticket! setting new bank amount...")
						user.setActiveCharacterData("bank", user_bank - tonumber(amount))
						TriggerClientEvent("police:notify", userSource, "You have ~g~signed~w~ your ticket of $" .. comma_value(amount) .. "!")
						TriggerClientEvent("police:notify", fromPlayerId, user_char_name .. " has ~g~signed~w~ their ticket of $" .. comma_value(amount) .. "!")
					else
						TriggerClientEvent("police:notify", userSource, "You don't have enough money to pay the ticket of $" .. comma_value(amount) .. "!")
						TriggerClientEvent("police:notify", fromPlayerId, "Person does have enough money to pay the ticket!")
					end
				end
				local ticket = {
					reason = reason,
					fine = amount,
					timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
					type = "ticket",
					number = 'T'..math.random(10000000, 99999999)
				}
				local user_history = user.getActiveCharacterData("criminalHistory")
				table.insert(user_history, ticket)
				user.setActiveCharacterData("criminalHistory", user_history)
			end
		--end)
	else
		TriggerClientEvent("police:notify", userSource, "You have ~r~denied~w~ to sign your ticket of $" .. amount .. "!")
		TriggerClientEvent("police:notify", fromPlayerId, GetPlayerName(userSource) .. " has ~r~denied~w~ to sign their ticket of $" .. comma_value(amount) .. "!")
	end
end)

-- /dispatch
TriggerEvent('es:addJobCommand', 'dispatch', { "police", "sheriff", "ems", "fire", "taxi", "tow" }, function(source, args, user)
	local userSource = tonumber(source)
	local target = tonumber(args[2])
	if GetPlayerName(target) then
		table.remove(args,1)
		table.remove(args,1)
		local msg = table.concat(args, " ")
		TriggerClientEvent('dispatch:notify', target, user.getActiveCharacterData('lastName'), source, msg)
		exports["globals"]:notifyPlayersWithJob(user.getActiveCharacterData("job"), '^5^*[DISPATCH] ^r^0'..user.getActiveCharacterData("lastName")..' ['..source..'] to #'..target..': '..msg) -- send to all others players with same job as dispatcher
	else
		TriggerClientEvent("usa:notify", userSource, "Error: caller id # not entered")
	end
end, {
	help = "Send a message as dispatch.",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "message", help = "Message to player" }
	}
})

TriggerEvent('es:addJobCommand', 'repair', { "police", "sheriff", "dai" }, function(source, args, user)
	TriggerClientEvent("usa:repairVeh", source)
end, {
	help = "Repair the vehicle you're facing."
})

TriggerEvent('es:addJobCommand', 'runserial', { "police", "sheriff", 'judge', 'dai' }, function(source, args, user)
	local userSource = tonumber(source)
	if args[2] then
		local serialNumber = string.upper(args[2])
		TriggerEvent('es:exposeDBFunctions', function(couchdb)
	        couchdb.getDocumentById("legalweapons", serialNumber, function(weapon)
	            if weapon then
	                TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, '^1^*[ATF QUERY] ^7Registered Owner: ^r'..weapon.ownerName..' ^1^*| ^7Date of Birth: ^r'..weapon.ownerDOB..' ^1^*| ^7Registered Weapon: ^r'..weapon.name..' ^1^*| ^7Date of Issue: ^r'..weapon.issueDate..' ^1^*| ^7Serial Number: ^r'..weapon.serialNumber)
	            else
	                TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, '^1^*[ATF QUERY] ^7^rThis serial number is not registered.')
	            end
	        end)
	    end)
	else
		TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, '^1^*[ATF QUERY] ^7^rPlease enter a valid serial number!')
	end
end, {
	help = "Run the serial number of a weapon",
	params = {
		{ name = "serial", help = "weapon serial number" }
	}
})

-- /cone barrier
TriggerEvent('es:addJobCommand', 'barrier', { "police", "sheriff", "ems", "fire"}, function(source, args, user)
	local obj = nil
	if args[2] == "1" then
		obj = "prop_mp_cone_01"
	elseif args[2] == "2" then
		obj = "prop_barrier_work05"
	end
	TriggerClientEvent('createObject', source, obj)
end, {
	help = "Place a barrier",
	params = {
		{ name = "Barrier Number", help = "Either 1 or 2. 1 = cone, 2 = wood barrier" }
	}
})

-- /cone barrier
TriggerEvent('es:addJobCommand', 'cone', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, user)
	TriggerClientEvent('c_setCone', source)
end, {
	help = "Drop a cone down"
})

TriggerEvent('es:addJobCommand', 'pickup', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, user)
	TriggerClientEvent('c_removeCones', source)
end, {
	help = "Pick up cones or barriers"
})

TriggerEvent('es:addJobCommand', 'removecones', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, user)
	TriggerClientEvent('c_removeCones', source)
end, {
	help = "Pick up cones or barriers"
})

function comma_value(amount)
  local formatted = amount
  while true do
	formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	if (k==0) then
	  break
	end
  end
  return formatted
end

---------- SEARCH COMMAND ------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("search:searchPlayer")
AddEventHandler("search:searchPlayer", function(playerId, src)
	local usource = source
	if src then usource = src end
	local user = exports["essentialmode"]:getPlayerFromId(playerId)
	local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	local items = {}
	--[[local licenses = user.getActiveCharacterData("licenses")
	for index = 1, #licenses do
		--if licenses[index].name == "Driver's License" then
		table.insert(items, licenses[index])
		--end
	end]]
	local playerInventory = user.getActiveCharacterData("inventory")
	for i = 1, #playerInventory do
		table.insert(items, playerInventory[i])
	end
	local playerWeapons = user.getActiveCharacterData("weapons")
	for j = 1, #playerWeapons do
		table.insert(items, playerWeapons[j])
	end
	TriggerClientEvent("chatMessage", usource, "", {255,136,0}, "SEARCH OF " .. user_name .. ":")
	TriggerClientEvent("chatMessage", usource, "", {0,0,0}, "^3CASH:^0 $" .. comma_value(user.getActiveCharacterData("money")))
	for i = 1, #items do
		local name = items[i].name
		local quantity = items[i].quantity
		local legality = items[i].legality
		if legality == "illegal" then
			TriggerClientEvent("chatMessage", usource, "", {}, "^1(x" .. quantity .. ") " .. name) -- print item red
		else
			if items[i].serialNumber then
				TriggerClientEvent("chatMessage", usource, "", {}, "^0(x" .. quantity .. ") " .. name .. ' - '..items[i].serialNumber) -- print item
			elseif items[i].residue and items[i].name == 'Razor Blade' then
				TriggerClientEvent("chatMessage", usource, "", {}, "^0(x" .. quantity .. ") " .. name .. ' (Powdery Residue)') -- print item
			elseif items[i].residue and items[i].name == 'Large Scissors' then
				TriggerClientEvent("chatMessage", usource, "", {}, "^0(x" .. quantity .. ") " .. name .. ' (Odor of Marijuana)') -- print item
			else
				TriggerClientEvent("chatMessage", usource, "", {}, "^0(x" .. quantity .. ") " .. name)
			end
		end
		if items[i].components then
			for k = 1, #items[i].components do
				TriggerClientEvent("chatMessage", usource, "", {0, 50, 0}, "^0		+ " .. items[i].components[k])
			end
		end
	end
end)

RegisterServerEvent("search:playSuspectAnim")
AddEventHandler("search:playSuspectAnim", function(sourceToSearch, x, y, z, heading)
	TriggerClientEvent("search:playSuspectAnim", sourceToSearch, x, y, z, heading)
end)

RegisterServerEvent("search:foundPlayerToSearch")
AddEventHandler("search:foundPlayerToSearch", function(id)
	TriggerClientEvent("crim:areHandsTied", id, source, id, "search")
end)

TriggerEvent('es:addCommand', 'search', function(source, args, user)
	local job = user.getActiveCharacterData("job")
	if job == "civ" then
		TriggerClientEvent("search:attemptToSearchNearestPerson", source, true)
	elseif job == "sheriff" or job == "corrections" or job == "dai" then
		if not tonumber(args[2]) then
			TriggerClientEvent("search:searchNearest", source)
		else
			TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 4)
			TriggerEvent("search:searchPlayer", tonumber(args[2]), source)
		end
	end
end, {help = "Search the nearest person or vehicle."})

--------------------------------------------------------------------------------------------------------------------------------------------------

-- start bait car
TriggerEvent('es:addJobCommand', 'lockbc',  {"sheriff"}, function(source, args, user)
	local ServerID = args[2]
	if not tonumber(ServerID) then return end
	TriggerClientEvent("simp:baitCarDisable", tonumber(ServerID))
end, {
	help = "Lock the bait car's doors and shut off the engine.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

TriggerEvent('es:addJobCommand', 'unlockbc',  {"sheriff"}, function(source, args, user)
	local ServerID = args[2]
	if not tonumber(ServerID) then return end
	TriggerClientEvent("simp:baitCarunlock", tonumber(ServerID))
end, {
	help = "Unlock the bait car's doors.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})
-- end bait car

-- start seize contraband
TriggerEvent('es:addJobCommand', 'seize', { "police", "sheriff", "corrections", "dai" }, function(source, args, user)
	local arg = args[2]
	local targetId = tonumber(args[3])
	local name = user.getActiveCharacterData("firstName") .. user.getActiveCharacterData("lastName")
	if arg and targetId then
		if arg == "contraband" then
			print(name .. " is seizing contraband!")
			--TriggerEvent('es:getPlayerFromId', targetId, function(target)
			local target = exports["essentialmode"]:getPlayerFromId(targetId)
				local targetInventory = target.getActiveCharacterData("inventory")
				local targetWeapons = target.getActiveCharacterData("weapons")
				for i = #targetInventory, 1, -1 do
					--print("checking item: " .. targetInventory[i].name)
					if targetInventory[i].legality == "illegal" then
						TriggerClientEvent("usa:notify", source, "~y~Seized: ~w~(x".. targetInventory[i].quantity ..") " .. targetInventory[i].name)
						TriggerClientEvent("usa:notify", targetId, "~y~Seized: ~w~(x".. targetInventory[i].quantity ..") " .. targetInventory[i].name)
						table.remove(targetInventory, i)
					end
				end
				for j = #targetWeapons, 1, -1 do
					--print("checking item: " .. targetWeapons[j].name)
					if targetWeapons[j].legality == "illegal" then
						TriggerClientEvent("usa:notify", source, "~y~Seized: ~w~" .. targetWeapons[j].name)
						TriggerClientEvent("usa:notify", targetId, "~y~Seized: ~w~" .. targetWeapons[j].name)
						table.remove(targetWeapons, j)
					end
				end
				target.setActiveCharacterData("inventory", targetInventory)
				target.setActiveCharacterData("weapons", targetWeapons)
			--end)
		elseif arg == "cash" then
			print(name .. " is seizing a player's cash!")
			target_player_id = targetId
			TriggerClientEvent("police:getMoneyInput", source)
		end
	end
end, {
	help = "Seize contraband or cash",
	params = {
		{ name = "type", help = "contraband OR cash" },
		{ name = "id", help = "Player's' ID" }
	}
})

RegisterServerEvent("police:seizeCash")
AddEventHandler("police:seizeCash", function(amount)
	local userSource = tonumber(source)
	print("seizing cash from id #" .. target_player_id .. "! amount: $" .. amount)
	--TriggerEvent('es:getPlayerFromId', target_player_id, function(target)
	local target = exports["essentialmode"]:getPlayerFromId(target_player_id)
		local target_money = target.getActiveCharacterData("money")
		if target_money - amount >= 0 then
			target.setActiveCharacterData("money", target_money - amount)
			TriggerClientEvent("usa:notify", userSource, "~y~Seized: ~w~$" .. amount)
			TriggerClientEvent("usa:notify", target_player_id, "~y~Seized: ~w~$" .. amount)
		end
	--end)
end)
-- end seize contraband

-- retrieve AR/pump shotgun
TriggerEvent('es:addJobCommand', 'showbadge', { "police", "sheriff" }, function(source, args, user, location)

	local police_rank = tonumber(user.getActiveCharacterData("policeRank"))
	local char_name = user.getActiveCharacterData("fullName")
	if police_rank > 0 then
		exports["globals"]:sendLocalActionMessage(source, "shows official police badge")
		local msg = "^*[ID]^r ^2Name: ^0" .. char_name .. " - ^2SSN: ^0" .. source .. " - ^2Police Rank: ^0" .. GetRankName(police_rank)
		exports["globals"]:sendLocalActionMessageChat(msg, location)
	end

end, { help = "Present your official police or EMS identification." })

function GetRankName(rank)
	return POLICE_RANKS[rank]
end

-- store AR/pump shotgun
TriggerEvent('es:addJobCommand', 'store', { "police", "sheriff" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("police:storeWeapon", source, args[2])
	else
		TriggerClientEvent("usa:notify", source, "Invalid format!")
	end
end, {
	help = "store a weapon",
	params = {
		{ name = "weapon", help = "ar, shotgun, flaregun, extinguisher" }
	}
})

-- retrieve AR/pump shotgun
TriggerEvent('es:addJobCommand', 'grab', { "police", "sheriff" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("police:grabWeapon", source, args[2])
	else
		TriggerClientEvent("usa:notify", source, "Invalid format!")
	end
end, {
	help = "grab a weapon",
	params = {
		{ name = "weapon", help = "ar, shotgun, flaregun, extinguisher" }
	}
})

-- panic button --
TriggerEvent('es:addJobCommand', 'p', { "police", "sheriff", "ems", "corrections" }, function(source, args, user, location)
	--TriggerEvent('es:getPlayerFromId', source, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local source_user_job = user.getActiveCharacterData("job")
		TriggerEvent("es:getPlayers", function(pl)
			for k, v in pairs(pl) do
				local user_job = v.getActiveCharacterData("job")
				if user_job == "cop" or user_job == "sheriff" or user_job == "highwaypatrol" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
					if source_user_job ~= "corrections" then
						TriggerClientEvent("chatMessage", k, "", {255, 0, 0}, "^1^*[RADIO]^r Panic button activated by " .. user.getActiveCharacterData("fullName")) -- need to implement automatic street name locations here
						local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
						TriggerClientEvent("usa:playSound", k, params)
					else
						TriggerClientEvent("chatMessage", k, "", {255, 0, 0}, "^1^*[RADIO]^r Panic button activated by " .. user.getActiveCharacterData("fullName") .. " (Department of Corrections, Senora Fwy)") -- need to implement automatic street name locations here
						local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
						TriggerClientEvent("usa:playSound", k, params)
					end
				end
					--[[
				elseif user_job == "corrections" then
					for i = 1, 3 do
						if source_user_job == "corrections" then
							TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "(10-99) Panic button pressed by " .. user.getActiveCharacterData("fullName") .. " (Department of Corrections, Senora Fwy)")
							local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
							TriggerClientEvent("usa:playSound", k, params)
						end
					end
				end
				--]]
			end
		end)
	--end)
end, { help = "Press your panic button. CAUTION: ONLY FOR EXTREME EMERGENCIES."})

-- revoke gun license / firearm permit --
RegisterServerEvent("police:revokeFirearmPermit")
AddEventHandler("police:revokeFirearmPermit", function(source)
	--TriggerEvent('es:getPlayerFromId', id, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(source)
		local licenses = user.getActiveCharacterData("licenses")
		for i = 1, #licenses do
			local license = licenses[i]
			if license.name == "Firearm Permit" then
				table.remove(licenses, i)
				user.setActiveCharacterData("licenses", licenses)
				print("gun permit has been revoked.")
				return
			end
		end
		print("person had no firearm permit!")
	--end)
end)

-- check suspension dates --
RegisterServerEvent("police:checkSuspension")
AddEventHandler("police:checkSuspension", function(id)
	print("checking player license status!")
	local userSource = id
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local licenses = user.getActiveCharacterData("licenses")
		if licenses then
			for i = 1, #licenses do
				if licenses then
					local license =  licenses[i]
					if  license.name == "Driver's License" or license.name == "Firearm Permit"  then
						if license.status == "suspended" then
							--licenses[i].suspension_start = os.time()
							--licenses[i].suspension_days = days
							local reference = licenses[i].suspension_start
							print("reference: " .. reference)
							print("suspended days: " .. licenses[i].suspension_days)
							local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
							local wholedays = math.floor(daysfrom)
							print("wholedays: " .. wholedays) -- today it prints "1"
							if wholedays >= licenses[i].suspension_days then
								licenses[i].status = "valid"
								user.setActiveCharacterData("licenses", licenses)
								print("suspension period was over! setting to valid!")
							end
						end
					end
				end
			end
		end
		return
		print("person had no DL or FP!")
	--end)
end)

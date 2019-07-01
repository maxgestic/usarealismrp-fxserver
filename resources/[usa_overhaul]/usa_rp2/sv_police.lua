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

TriggerEvent('es:addJobCommand', 'ticket', { 'sheriff', 'police' , 'judge', "corrections"}, function(source, args, char)
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
	local target = exports["usa-characters"]:GetCharacter(targetPlayer)
	local target_name = target.getFullName()
	local target_bank = target.get('bank')
	TriggerClientEvent('usa:notify', source, 'Ticket issued to ~y~'..target_name..'~s~ for ~y~$'..amount..'~s~!')
	target.removeBank(amount)
	local ticket = {
		reason = reason,
		fine = amount,
		timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time()),
		issuedBy = char.getFullName(),
		type = "ticket",
		number = 'T'..math.random(10000000, 99999999)
	}
	local user_history = target.get("criminalHistory")
	table.insert(user_history, ticket)
	target.set("criminalHistory", user_history)
	TriggerClientEvent('chatMessage', targetPlayer, '^3^*[TICKET] ^r^0You have been issued a ticket for ^3$'..amount..'^0. ('..reason..')')
end, {
	help = "Write a ticket to player",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "amount", help = "Fine Amount" },
		{ name = "infractions", help = "Traffic Infractions" }
	}
})

-- /dispatch
TriggerEvent('es:addJobCommand', 'dispatch', { "police", "sheriff", "ems", "fire", "taxi", "tow" }, function(source, args, char)
	local target = tonumber(args[2])
	if GetPlayerName(target) then
		table.remove(args,1)
		table.remove(args,1)
		local msg = table.concat(args, " ")
		TriggerClientEvent('dispatch:notify', target, char.get("name").last, source, msg)
		exports["globals"]:notifyPlayersWithJob(char.get("job"), '^5^*[DISPATCH] ^r^0'..char.get("name").last..' ['..source..'] to #'..target..': '..msg) -- send to all others players with same job as dispatcher
	else
		TriggerClientEvent("usa:notify", source, "Error: caller id # not entered")
	end
end, {
	help = "Send a message as dispatch.",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "message", help = "Message to player" }
	}
})

TriggerEvent('es:addJobCommand', 'repair', { "police", "sheriff", "ems", "dai" }, function(source, args, char)
	TriggerClientEvent("usa:repairVeh", source)
end, {
	help = "Repair the vehicle you're facing."
})

TriggerEvent('es:addJobCommand', 'runserial', { "police", "sheriff", 'judge', 'dai' }, function(source, args, char)
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
TriggerEvent('es:addJobCommand', 'barrier', { "police", "sheriff", "ems", "fire"}, function(source, args, char)
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
TriggerEvent('es:addJobCommand', 'cone', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, char)
	TriggerClientEvent('c_setCone', source)
end, {
	help = "Drop a cone down"
})

TriggerEvent('es:addJobCommand', 'pickup', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, char)
	TriggerClientEvent('c_removeCones', source)
end, {
	help = "Pick up cones or barriers"
})

TriggerEvent('es:addJobCommand', 'removecones', { "police", "sheriff", "ems", "fire", "tow" }, function(source, args, char)
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
	local char = exports["usa-characters"]:GetCharacter(playerId)
	local items = {}
	local playerInventory = char.get("inventory")
	local inventory = char.get("inventory")
	for i = 0, (inventory.MAX_CAPACITY - 1) do
		if inventory.items[tostring(i)] then
			local item = inventory.items[tostring(i)]
			if item.type ~= "license" then
				table.insert(items, inventory.items[tostring(i)])
			end
		end
	end
	TriggerClientEvent("chatMessage", src, "", {0,0,0}, "^3^*[SEARCH] ^r^0Cash Found:^0 $" .. comma_value(char.get("money")))
	for i = 1, #items do
		local name = items[i].name
		local quantity = items[i].quantity
		local legality = items[i].legality
		if legality == "illegal" then
			TriggerClientEvent("chatMessage", src, "", {}, "^1(x" .. quantity .. ") " .. name) -- print item red
		else
			if items[i].serialNumber then
				TriggerClientEvent("chatMessage", src, "", {}, "^0(x" .. quantity .. ") " .. name .. ' - '..items[i].serialNumber) -- print item
			elseif items[i].residue and items[i].name == 'Razor Blade' then
				TriggerClientEvent("chatMessage", src, "", {}, "^0(x" .. quantity .. ") " .. name .. ' (Powdery Residue)') -- print item
			elseif items[i].residue and items[i].name == 'Large Scissors' then
				TriggerClientEvent("chatMessage", src, "", {}, "^0(x" .. quantity .. ") " .. name .. ' (Odor of Marijuana)') -- print item
			else
				TriggerClientEvent("chatMessage", src, "", {}, "^0(x" .. quantity .. ") " .. name)
			end
		end
		if items[i].components then
			for k = 1, #items[i].components do
				TriggerClientEvent("chatMessage", src, "", {0, 50, 0}, "^0		+ " .. items[i].components[k])
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

TriggerEvent('es:addCommand', 'search', function(source, args, char)
	local job = char.get("job")
	if job == "civ" then
		TriggerClientEvent("search:attemptToSearchNearestPerson", source, true)
	elseif job == "sheriff" or job == "corrections" or job == "dai" then
		if not tonumber(args[2]) then
			TriggerClientEvent("search:searchNearest", source, source)
		else
			TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 4)
			TriggerEvent("search:searchPlayer", tonumber(args[2]), source)
		end
	end
end, {help = "Search the nearest person or vehicle"})

TriggerEvent('es:addJobCommand', 'frisk', {"sheriff", "ems", "doc", "dai"}, function(source, args, char)
	if not tonumber(args[2]) then
		TriggerClientEvent("police:friskNearest", source, source)
	else
		TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 4)
		TriggerEvent("police:frisk", tonumber(args[2]), source)
	end
end, {help = "Search the nearest person or vehicle"})

--------------------------------------------------------------------------------------------------------------------------------------------------

-- start bait car
TriggerEvent('es:addJobCommand', 'lockbc',  {"sheriff"}, function(source, args, user)
	local ServerID = args[2]
	if not tonumber(ServerID) then return end
	TriggerClientEvent("simp:baitCarDisable", tonumber(ServerID))
end, {
	help = "Lock the bait car's doors and shut off the engine",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

TriggerEvent('es:addJobCommand', 'unlockbc',  {"sheriff"}, function(source, args, user)
	local ServerID = args[2]
	if not tonumber(ServerID) then return end
	TriggerClientEvent("simp:baitCarunlock", tonumber(ServerID))
end, {
	help = "Unlock the bait car's doors",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})
-- end bait car

-- start seize contraband
TriggerEvent('es:addJobCommand', 'seize', { "police", "sheriff", "corrections" }, function(source, args, char)
	local targetId = tonumber(args[2])
	local arg = args[3]
	if arg and targetId then
		if arg == "contraband" then
			local target = exports["usa-characters"]:GetCharacter(targetId)
			local seized = target.removeIllegalItems()
			for i = 1, #seized do
				TriggerClientEvent("usa:notify", source, "~y~Seized: ~w~(x".. (seized[i].quantity or 1) ..") " .. seized[i].name)
				TriggerClientEvent("usa:notify", targetId, "~y~Seized: ~w~(x".. (seized[i].quantity or 1) ..") " .. seized[i].name)
			end
		elseif arg == "cash" then
			target_player_id = targetId
			TriggerClientEvent("police:getMoneyInput", source)
		elseif arg == "vehcontraband" then
			TriggerClientEvent("police:removeAllIllegalItems", source)
		end
	end
end, {
	help = "Seize illegal items on a person, in a vehicle or cash from the person.",
	params = {
		{ name = "id", help = "Player's' ID (or '0' for vehicle seizures)" },
		{ name = "type", help = "'cash', 'contraband', or 'vehcontraband'" }
	}
})

RegisterServerEvent("police:seizeCash")
AddEventHandler("police:seizeCash", function(amount)
	local target_money = exports["usa-characters"]:GetCharacterField(target_player_id, "money")
	if target_money - amount >= 0 then
		exports["usa-characters"]:SetCharacterField(target_player_id, "money", target_money - amount)
		TriggerClientEvent("usa:notify", source, "~y~Seized: ~w~$" .. amount)
		TriggerClientEvent("usa:notify", target_player_id, "~y~Seized: ~w~$" .. amount)
	end
end)

-- retrieve AR/pump shotgun
TriggerEvent('es:addJobCommand', 'showbadge', { "police", "sheriff" }, function(source, args, char, location)
	local police_rank = tonumber(char.get("policeRank"))
	local char_name = char.getFullName()
	if police_rank > 0 then
		exports["globals"]:sendLocalActionMessage(source, char_name .. " shows official police badge.")
		local msg = "^*[ID]^r ^2Name: ^0" .. char_name .. " - ^2SSN: ^0" .. source .. " - ^2Police Rank: ^0" .. GetRankName(police_rank)
		exports["globals"]:sendLocalActionMessageChat(msg, location)
	end
end, { help = "Present your official police or EMS identification." })

function GetRankName(rank)
	return POLICE_RANKS[rank]
end

TriggerEvent('es:addJobCommand', 'p', { "police", "sheriff", "ems", "corrections" }, function(source, args, char, location)
	local source_user_job = char.get("job")
	local pl = exports["usa-characters"]:GetCharacters()
	for k, v in pairs(pl) do
		local user_job = v.get("job")
		if user_job == "cop" or user_job == "sheriff" or user_job == "highwaypatrol" or user_job == "ems" or user_job == "fire" or user_job == "corrections" then
			if source_user_job ~= "corrections" then
				TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "(10-99) Panic button pressed by " .. char.getFullName()) -- need to implement automatic street name locations here
				local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
				TriggerClientEvent("usa:playSound", k, params)
			else
				TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "(10-99) Panic button pressed by " .. char.getFullName() .. " (Department of Corrections, Senora Fwy)") -- need to implement automatic street name locations here
				local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
				TriggerClientEvent("usa:playSound", k, params)
			end
		end
	end
end, { help = "Press your panic button. CAUTION: ONLY FOR EXTREME EMERGENCIES."})

-- revoke gun license / firearm permit --
RegisterServerEvent("police:revokeFirearmPermit")
AddEventHandler("police:revokeFirearmPermit", function(source)
	--TriggerEvent('es:getPlayerFromId', id, function(user)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.hasItem('Firearm Permit') then char.removeItem('Firearm Permit') end
	--end)
end)

-- check suspension dates --
RegisterServerEvent("police:checkSuspension")
AddEventHandler("police:checkSuspension", function(character)
	local dl =  character.getItem("Driver's License")
	local bl = character.getItem("Boat License")
	local al = character.getItem("Aircraft License")
	local bar = character.getItem("Bar Certificate")

	-- DL --
	if dl then
		if dl.status == "suspended" then
			local reference = dl.suspension_start
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			if wholedays >= dl.suspension_days then
				character.modifyItem(dl, "status", "valid")
			end
		end
	end

	if bl then
		if bl.status == "suspended" then
			local reference = bl.suspension_start
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			if wholedays >= bl.suspension_days then
				character.modifyItem(bl, "status", "valid")
			end
		end
	end

	if al then
		if al.status == "suspended" then
			local reference = al.suspension_start
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			if wholedays >= al.suspension_days then
				character.modifyItem(al, "status", "valid")
			end
		end
	end

	if bar then
		if bar.status == "suspended" then
			local reference = bar.suspension_start
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			if wholedays >= bar.suspension_days then
				character.modifyItem(bar, "status", "valid")
			end
		end
	end
end)

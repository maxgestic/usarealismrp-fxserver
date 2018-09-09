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
	local amount = tonumber(args[3])
	table.remove(args, 1)
	table.remove(args, 1)
	table.remove(args, 1)
	local reason = table.concat(args, " ")
	if not targetPlayer or not amount or reason == "" or reason == " " then
		TriggerClientEvent("police:notify", tonumber(source), "~y~Usage: ~w~/ticket [id] [amount] [infractions]")
		return
	end
	print("player is getting ticketed for $" .. amount .. "! by officer " .. GetPlayerName(source))
	TriggerClientEvent("police:ticket", targetPlayer, amount, reason, source)
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
		TriggerEvent('es:getPlayerFromId', userSource, function(user)
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
					type = "ticket"
				}
				local user_history = user.getActiveCharacterData("criminalHistory")
				table.insert(user_history, ticket)
				user.setActiveCharacterData("criminalHistory", user_history)
			end
		end)
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
		TriggerClientEvent('chatMessage', target, "DISPATCHER", {255, 20, 10}, msg) -- send to caller
		exports["globals"]:notifyPlayersWithJob(user.getActiveCharacterData("job"), "^1DISPATCHER <" .. user.getActiveCharacterData("lastName") .. "> to #" .. target ..": ^0" .. msg) -- send to all others players with same job as dispatcher
		TriggerClientEvent("dispatch:setWaypoint", userSource, tonumber(target)) -- set waypoint for dispatcher
	else
		TriggerClientEvent("usa:notify", userSource, "Error: caller id # not entered")
	end
end, {
	help = "Send a message as dispatch",
	params = {
		{ name = "id", help = "Players ID" },
		{ name = "message", help = "Message to player" }
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
TriggerEvent('es:addJobCommand', 'seize', { "police", "sheriff" }, function(source, args, user)
	local arg = args[2]
	local targetId = tonumber(args[3])
	local name = user.getActiveCharacterData("firstName") .. user.getActiveCharacterData("lastName")
	if arg and targetId then
		if arg == "contraband" then
			print(name .. " is seizing contraband!")
			TriggerEvent('es:getPlayerFromId', targetId, function(target)
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
			end)
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
	TriggerEvent('es:getPlayerFromId', target_player_id, function(target)
		local target_money = target.getActiveCharacterData("money")
		if target_money - amount >= 0 then
			target.setActiveCharacterData("money", target_money - amount)
			TriggerClientEvent("usa:notify", userSource, "~y~Seized: ~w~$" .. amount)
			TriggerClientEvent("usa:notify", target_player_id, "~y~Seized: ~w~$" .. amount)
		end
	end)
end)
-- end seize contraband

-- retrieve AR/pump shotgun
TriggerEvent('es:addJobCommand', 'showbadge', { "police", "sheriff" }, function(source, args, user, location)

	local police_rank = tonumber(user.getActiveCharacterData("policeRank"))
	local char_name = user.getActiveCharacterData("fullName")
	if police_rank > 0 then
		exports["globals"]:sendLocalActionMessage(source, char_name .. " shows official police badge.")
		local msg = "^*[ID]^r ^2Name: ^0" .. char_name .. " - ^2SSN: ^0" .. source .. " - ^2Police Rank: ^0" .. GetRankName(police_rank)
		exports["globals"]:sendLocalActionMessageChat(msg, location)
	end

end, { help = "Present your official police or EMS identification." })

function GetRankName(rank)
	return POLICE_RANKS[rank]
end

TriggerEvent('es:addJobCommand', 'breathalyze', { "police", "sheriff", "ems" }, function(source, args, user)
	local targetId = tonumber(args[2])
	if type(targetId) == "number" then
		-- get BAC:
		TriggerClientEvent("breathalyze:breathalyzePerson", targetId, source)
		-- play animation:
		local anim = {
			name = "base",
			dict = "amb@world_human_security_shine_torch@male@base"
		}
		--TriggerClientEvent("usa:playAnimation", source, anim.name, anim.dict, 3)
		--TriggerClientEvent("usa:playAnimation", source, anim.dict, anim.name, 5, 1, 3000, 31, 0, 0, 0, 0)
		TriggerClientEvent("usa:playAnimation", source, anim.dict, anim.name, -8, 1, -1, 53, 0, 0, 0, 0, 3)
	end
end, {
	help = "Breathalyze",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

RegisterServerEvent("breathalyze:receivedResults")
AddEventHandler("breathalyze:receivedResults", function(BAC, officer_source)
	local color = ""
	if BAC >= 0.08 then
		color = "~r~"
	elseif BAC >= 0.04 then
		color = "~y~"
	else
		color = "~g~"
	end
	TriggerClientEvent("usa:notify", tonumber(officer_source), "BAC READING: " .. color .. BAC)
	-- play sound:
	local soundParams = {-1, "PIN_BUTTON", "ATM_SOUNDS", 1}
	TriggerClientEvent("usa:playSound", tonumber(officer_source), soundParams)
end)

-- store AR/pump shotgun
TriggerEvent('es:addJobCommand', 'store', { "police", "sheriff", "ems" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("police:storeWeapon", source, args[2])
	else
		TriggerClientEvent("usa:notify", source, "Invalid format!")
	end
end, {
	help = "store a weapon",
	params = {
		{ name = "weapon", help = "ar, shotgun" }
	}
})

-- retrieve AR/pump shotgun
TriggerEvent('es:addJobCommand', 'grab', { "police", "sheriff", "ems" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("police:grabWeapon", source, args[2])
	else
		TriggerClientEvent("usa:notify", source, "Invalid format!")
	end
end, {
	help = "grab a weapon",
	params = {
		{ name = "weapon", help = "ar, shotgun" }
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
				if user_job == "cop" or user_job == "sheriff" or user_job == "highwaypatrol" or user_job == "ems" or user_job == "fire" then
					for i = 1, 3 do
						if source_user_job ~= "corrections" then
							TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "(10-99) Panic button pressed by " .. user.getActiveCharacterData("fullName")) -- need to implement automatic street name locations here
							local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
							TriggerClientEvent("usa:playSound", k, params)
						end
					end
				elseif user_job == "corrections" then
					for i = 1, 3 do
						if source_user_job == "corrections" then
							TriggerClientEvent("chatMessage", k, "DISPATCH", {255, 0, 0}, "(10-99) Panic button pressed by " .. user.getActiveCharacterData("fullName") .. " (Department of Corrections, Senora Fwy)")
							local params = {-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1}
							TriggerClientEvent("usa:playSound", k, params)
						end
					end
				end
			end
		end)
	--end)
end, { help = "Press your panic button. Only for use in extreme emergencies."})

-- GSR test --
TriggerEvent('es:addJobCommand', 'gsr', { "police", "sheriff" }, function(source, args, user)
	TriggerClientEvent("police:performGSR", source, source)
end, { help = "Perform a gun shot residue test on the nearest person."})

RegisterServerEvent("police:getGSRResult")
AddEventHandler("police:getGSRResult", function(id, from_id)
	print("GSR Testing ID#: " .. id .. ", from id: " .. from_id)
	TriggerClientEvent("police:testForGSR", id, from_id)
end)

RegisterServerEvent("police:notifyGSR")
AddEventHandler("police:notifyGSR", function(id, was_detected)
	local message = ""
	if was_detected then
		message = "Gun shot residue ~r~detected~w~!"
		-- todo: play sound
	else
		message = "No gun shot residue detected."
		-- todo: play sound
	end
	TriggerClientEvent("usa:notify", id, message)
end)

-- suspend gun license / firearm permit --
RegisterServerEvent("police:setFirearmPermitStatus")
AddEventHandler("police:setFirearmPermitStatus", function(status, id, days)
	TriggerEvent('es:getPlayerFromId', id, function(user)
		local licenses = user.getActiveCharacterData("licenses")
		for i = 1, #licenses do
			local license =  licenses[i]
			if  license.name == "Firearm Permit" then
				licenses[i].status = status
				if status == "suspended" then
					licenses[i].suspension_start = os.time()
					licenses[i].suspension_days = days
					licenses[i].suspension_start_date = os.date('%m-%d-%Y %H:%M:%S', os.time())
				end
				print("gun permit set to: " .. status .. " for " .. days)
				user.setActiveCharacterData("licenses", licenses)
				return
			end
		end
		print("person had no firearm permit!")
	end)
end)

-- check suspension dates --
RegisterServerEvent("police:checkSuspension")
AddEventHandler("police:checkSuspension", function(id)
	print("checking player license status!")
	local userSource = id
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
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
	end)
end)

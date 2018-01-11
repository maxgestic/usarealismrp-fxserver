local target_player_id = 0

TriggerEvent('es:addCommand', 'ticket', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" or user_job == "police" then
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
	else
		TriggerClientEvent("police:notify", tonumber(source), "Only police can use /ticket!")
	end
end)

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
-- 911 DISPATCH
TriggerEvent('es:addCommand', 'dispatch', function(source, args, user)
	local userJob = user.getActiveCharacterData("job")
	if userJob == "sheriff" or userJob == "ems" or userJob == "fire" or userJob == "taxi" or userJob == "tow" then
		local userSource = tonumber(source)
		local target = args[2]
		table.remove(args,1)
		table.remove(args,1)
		TriggerClientEvent('chatMessage', target, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
		TriggerClientEvent('chatMessage', userSource, "DISPATCH", {255, 20, 10}, table.concat(args, " "))
		-- set waypoint...
	    print("setting waypoint with target = " .. target)
		TriggerClientEvent("dispatch:setWaypoint", userSource, tonumber(target))
	end
end)


-- /cone barrier
TriggerEvent("es:addCommand", 'cone', function(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_job = user.getActiveCharacterData("job")
       if user_job == "sheriff" or user_job == "ems" then -- set police job can also use [ user.permission_level >= 2 ] in place of job if need be
          TriggerClientEvent('c_setCone', source)
       end
    end)
end)

TriggerEvent("es:addCommand", 'pickup', function(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local user_job = user.getActiveCharacterData("job")
       if user_job == "sheriff" or user_job == "ems" then -- set police job can also use [ user.permission_level >= 2 ] in place of job if need be
          TriggerClientEvent('c_removeCones', source)
       end
    end)
end)

AddEventHandler( 'chatMessage', function( source, n, msg )
    msg = string.lower( msg )
    if ( msg == "/r" ) then
        CancelEvent()
        TriggerClientEvent( 'Radio', source )
    end
end )

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
TriggerEvent('es:addCommand', 'lockbc', function(source, args, user)
	local userjob = user.getActiveCharacterData("job")
	if userjob == "sheriff" then
		local ServerID = args[2]
		if not tonumber(ServerID) then return end
		TriggerClientEvent("simp:baitCarDisable", tonumber(ServerID))
	end
end)

TriggerEvent('es:addCommand', 'unlockbc', function(source, args, user)
	local userjob = user.getActiveCharacterData("job")
	if userjob == "sheriff" then
		local ServerID = args[2]
		if not tonumber(ServerID) then return end
		TriggerClientEvent("simp:baitCarunlock", tonumber(ServerID))
	end
end)
-- end bait car

-- start seize contraband
TriggerEvent('es:addCommand', 'seize', function(source, args, user)
	local arg = args[2]
	local targetId = tonumber(args[3])
	local user_job = user.getActiveCharacterData("job")
	local name = user.getActiveCharacterData("firstName") .. user.getActiveCharacterData("lastName")
	if user_job == "sheriff" or user_job == "police" then
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
	end
end)

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

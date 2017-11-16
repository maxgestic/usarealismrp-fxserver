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
AddEventHandler("police:payTicket", function(fromPlayerId, amount, wantsToPay)
	local userSource = tonumber(source)
	if wantsToPay then
		TriggerEvent('es:getPlayerFromId', userSource, function(user)
			if user then
				local user_money = user.getActiveCharacterData("money")
				if user_money >= tonumber(amount) then
					user.setActiveCharacterData("money", user_money - tonumber(amount))
					TriggerClientEvent("police:notify", userSource, "You have ~g~signed~w~ your ticket of $" .. comma_value(amount) .. "!")
					TriggerClientEvent("police:notify", fromPlayerId, GetPlayerName(userSource) .. " has ~g~signed~w~ their ticket of $" .. comma_value(amount) .. "!")
				else
					TriggerClientEvent("police:notify", userSource, "You don't have enough money to pay the ticket of $" .. comma_value(amount) .. "!")
				end
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

--[[
-- /spikestrip
TriggerEvent('es:addCommand', 'spikestrip', function(source) -- usage /spike in chat maybe change to a hot key at later date
  TriggerEvent('es:getPlayerFromId', source, function(user)
     if user.getJob() == "sheriff"  then -- set police job can also use [ user.permission_level >= 2 ] in place of job if need be
        TriggerClientEvent('c_setSpike', source)
     end
  end)
end)
--]]

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

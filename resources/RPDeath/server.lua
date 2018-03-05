local deathLog = {}

players = {}

AddEventHandler('es:playerLoaded', function(source, user)
	print("setting players[source = true!]")
	players[source] = true
end)
--[[
RegisterServerEvent('RPD:addPlayer')
AddEventHandler('RPD:addPlayer', function()
	players[source] = true
	print("player added inside of RPD:addPlayer!")
end)
--]]
AddEventHandler('playerDropped',function(reason)
	players[source] = nil
end)

RegisterServerEvent('RPD:userDead')
AddEventHandler('RPD:userDead', function(userName, street)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		downedUser = user
		TriggerEvent("es:getPlayers", function(pl)
			local meta = {}
			for k, v in pairs(pl) do
				TriggerEvent("es:getPlayerFromId", k, function(user)
					if k ~= source then
						local user_job = user.getActiveCharacterData("job")
						if user_job == "cop" or user_job == "sheriff" or user_job == "highwaypatrol" or user_job == "ems" or user_job == "fire" then
							TriggerClientEvent("chatMessage", k, "911", {255, 0, 0}, userName .. " has been incapacitated on " .. street .. ".")
						end
					end
				end)
			end
		end)
	end)
end)

RegisterServerEvent("RPD:removeWeapons")
AddEventHandler("RPD:removeWeapons", function()
	local DEATH_PENALTY = 2000
	local userSource = source
	print("inside of RPD:removeWeapons")
	TriggerEvent("es:getPlayerFromId", source, function(user)

		if user.getActiveCharacterData("job") == "civ" then
			-- empty out everything since person has died and NLR is in place
			--user.removeMoney(user.getMoney())
			local user_money = user.getActiveCharacterData("money")
			if user_money - DEATH_PENALTY >= 0 then
				user.setActiveCharacterData("money", user_money - DEATH_PENALTY)
			end
			user.setActiveCharacterData("weapons", {})
			user.setActiveCharacterData("criminalHistory", {})
			--user.setLicenses({})
			--user.setVehicles({})
			--user.setInsurance({})
			--TriggerEvent("sway:updateDB", userSource)
		end

		local user_inventory = user.getActiveCharacterData("inventory")
		print("#inventory before death: " .. #user_inventory)
		-- find non cell phone items to delete
		for i = #user_inventory, 1, -1 do
			local item = user_inventory[i]
			if item == nil or not string.find(item.name, "Cell Phone") then
        table.remove(user_inventory, i)
    	end
		end
		--[[
		for i = 1, #user_inventory do
			local item = user_inventory[i]
			if not string.find(item.name, "Cell Phone") then
				print("setting to item to nil: " .. item.name)
				user_inventory[i] = nil
			end
		end
		print("after setting nils, #inventory = " .. #user_inventory)
		-]]
		-- save
		user.setActiveCharacterData("inventory", user_inventory)
		print("#inventory after death: " .. #user_inventory)
		-- remove any rope/blindfolds person may have had on while being killed
		-- remove blindfolds/tied hands
		TriggerClientEvent("crim:untieHands", userSource, userSource)
		TriggerClientEvent("crim:blindfold", userSource, false, true)
		-- REMOVE ANY WARRANTS:
		TriggerEvent("warrants:removeAnyActiveWarrants", user.getActiveCharacterData("fullName"))
	end)
end)

TriggerEvent('es:addCommand', 'revive', function(source, args, user)
	local from = source
	TriggerEvent('es:getPlayerFromId', from, function(user)
		if user then
			local targetId = 0
			local userJob = user.getActiveCharacterData("job")
			if userJob == "cop" or
				userJob == "sheriff" or
				userJob == "highwaypatrol" or
				userJob == "ems" or
				userJob == "fire" or
				user.getGroup() == "mod" or
				user.getGroup() == "admin" or
				user.getGroup() == "superadmin" or
				user.getGroup() == "owner" then
				if args[2] == nil then
					targetId = 0
					TriggerClientEvent("chatMessage", from, "SYSTEM", {255, 0, 0}, "Invalid command format. Ex: /revive [id]")
					return
				else
					targetId = tonumber(args[2])
				end
				TriggerClientEvent("RPD:revivePerson", targetId)
			else
				TriggerClientEvent("chatMessage", from, "SYSTEM", {255, 0, 0}, "You don't have permissions to use this command.")
			end
		else
			print("ERROR GETTING USER BY ID")
		end
	end)
end, {
	help = "Revive a player (EMS/Staff)",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

TriggerEvent('es:addCommand', 'respawn', function(source, args, user)
	TriggerClientEvent('RPD:allowRespawn', source)
end, { help = "Respawn while dead." })

function splitString(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function serializeTable(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)

	if name then tmp = tmp .. name .. " = " end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	end

	return tmp
end

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "revive" then
		local targetId = args[1]
		if not targetId then RconPrint("Error: no target id"); CancelEvent() return end
		TriggerClientEvent("RPD:revivePerson", targetId)
		CancelEvent()
	elseif commandName == "log" then
		for i = 1, #deathLog do
			RconPrint("\nDEATH #" .. i)
			RconPrint("\nDied: " .. deathLog[i].deadPlayerName)
			RconPrint("\nKiller: " .. deathLog[i].killerName .. " (#" .. deathLog[i].killerId .. ")")
			RconPrint("\nCause: " .. deathLog[i].cause)
			RconPrint("\nTime: " .. deathLog[i].timestamp)
		end
		CancelEvent()
	end
end)

TriggerEvent('es:addGroupCommand', 'log', "mod", function(source, args, user)
	for i = 1, #deathLog do
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3DEATH #" .. i)
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0Died: " .. deathLog[i].deadPlayerName .. " (#" .. deathLog[i].deadPlayerId .. ")")
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0Killer: " .. deathLog[i].killerName .. " (#" .. deathLog[i].killerId .. ")")
		TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0Time: " .. deathLog[i].timestamp)
	end
end, {
	help = "View death log"
})

RegisterServerEvent("RPD:newDeathLog")
AddEventHandler("RPD:newDeathLog", function(log)
	log.timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
	if #deathLog >= 10 then
		--deathLog = {}
		table.remove(deathLog, 1)
	end
	table.insert(deathLog, log)
	print("Player " .. log.killerName .. " (#" .. log.killerId .. ") just killed player " .. log.deadPlayerName .. "(#" .. log.deadPlayerId .. ").")
end)

-- END DEATH LOG

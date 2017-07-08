players = {}

RegisterServerEvent('RPD:addPlayer')
AddEventHandler('RPD:addPlayer', function()
	players[source] = true
end)

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
						if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
							TriggerClientEvent("chatMessage", k, "911", {255, 0, 0}, userName .. " has been incapacitated on " .. street .. ".")
							TriggerClientEvent("gps:addEMSReq", k, downedUser)
						end
					end
				end)
			end
		end)
	end)
end)

RegisterServerEvent("RPD:removeWeapons")
AddEventHandler("RPD:removeWeapons", function()
	print("inside of RPD:removeWeapons")
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if user.getJob() == "civ" then
			-- empty out everything since person has died and NLR is in place
			--user.removeMoney(user.getMoney())
			user.setInventory({})
			user.setWeapons({})
			user.setLicenses({})
			user.setVehicles({})
			user.setInsurance({})
		end
	end)
end)

AddEventHandler('chatMessage', function(from,name,message)
	if(message:sub(1,1) == "/") then

		local args = splitString(message, " ")
		local cmd = args[1]


		if (cmd == "/respawn") then
			CancelEvent()
			TriggerClientEvent('RPD:allowRespawn', from)
		end

		if (cmd == "/revive") then
			CancelEvent()
			TriggerEvent('es:getPlayerFromId', from, function(user)
				if user then
					local userJob = user.getJob()
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
							size = 10
						else
							size = tonumber(args[2])

							if size > 25 then
								size = 25
							elseif size < 0 then
								size = 0
							end
						end
						TriggerClientEvent('RPD:allowRevive', -1, from, user.getGroup(), size)
					else
						TriggerClientEvent("chatMessage", from, "SYSTEM", {255, 0, 0}, "You don't have permissions to use this command.")
					end
				else
					print("ERROR GETTING USER BY ID")
				end
			end)
		end
	end
end)

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

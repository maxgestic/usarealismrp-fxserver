RegisterServerEvent("gps:pingPlayers")
AddEventHandler("gps:pingPlayers", function()
	-- local Gov = {}
	-- TriggerEvent("es:getPlayers", function(pl)
	-- 	local meta = {}
	-- 	for k, v in pairs(pl) do
	-- 		TriggerEvent("es:getPlayerFromId", k, function(user)
	-- 			if k ~= source then
	-- 				table.insert(Gov, user)
	-- 			end
	-- 		end)
	-- 	end
	-- end)
	-- TriggerEvent('es:getPlayerFromId', source, function(user)
	-- 	if user then
	-- 		if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
	-- 			TriggerClientEvent("gps:showGov", source, Gov)
	-- 		end
	-- 	else
	-- 		print("ERROR GETTING USER BY ID")
	-- 	end
	-- end)
end)

RegisterServerEvent("gps:removeEMSReqLookup")
AddEventHandler("gps:removeEMSReqLookup", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		downedUser = user
		TriggerEvent("es:getPlayers", function(pl)
			local meta = {}
			for k, v in pairs(pl) do
				if k then
					TriggerEvent("es:getPlayerFromId", k, function(user)
						if user then
							if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
								TriggerClientEvent("gps:removeEMSReq", k, downedUser)
							end
						end
					end)
				end
			end
		end)
	end)
end)

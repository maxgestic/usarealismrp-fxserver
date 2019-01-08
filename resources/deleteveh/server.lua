TriggerEvent('es:addJobCommand', 'impound', { "police", "sheriff", "ems", "corrections" }, function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "Impound a vehicle." })

TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "(Delete) Impound a vehicle." })

RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local playerJob = user.getActiveCharacterData("job")
	local userGroup = user.getGroup()
	if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or userGroup == "owner" or userGroup == "admin" or userGroup == "mod" or userGroup == "superadmin" then
 		-- update impounded status of vehicle in DB --
		TriggerEvent('es:exposeDBFunctions', function(couchdb)
			couchdb.updateDocument("vehicles", plate, { impounded = true }, function()
				-- done impounding vehicle --
			end)
		end)
	else
		TriggerClientEvent("impound:notify", userSource, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
	end
end)

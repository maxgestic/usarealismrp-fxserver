local spawnableVehicles = {
	['ems'] = {'maverick2', 'ambulance', 'firetruk'},
	['sheriff'] = {'chrg14a', 'chrg14b', 'chrg18', 'cvpi11a', 'cvpi11b', 'bison19', 'sheriff2', 'scorcher', 'pbus', 'policet', 'tahoe', 'riot', 'policeb', 'maverick2', 'predator', 'fbi', 'fbi2', 'fbi3', 'maverick2'},
	['dai'] = {'schafter19', 'buffalo19', 'baller19', 'oracle19', 'taurus16a', 'chrg14a', 'chrg18a', 'cvpi11a'}
}

local VEH_RANKS = {
	[1] = {'taurus16b', 'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2', 'scorcher'},
	[2] = {'taurus16b', 'chrg18b', 'chrg14b', 'cvpi11b', 'bison19', 'sheriff2','scorcher', 'policet', 'tahoe'},
	[3] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'maverick2'},
	[4] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[5] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[6] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[7] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[8] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[9] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
	[10] = {'taurus16b', 'chrg14a', 'chrg14b', 'chrg18a', 'chrg18b', 'cvpi11a', 'cvpi11b', 'bison19', 'scorcher', 'policet', 'riot', 'policeb', 'fbi', 'fbi2', 'schafter19', 'buffalo19', 'baller19', 'interceptor19', 'oracle19', 'maverick2'},
}

TriggerEvent('es:addJobCommand', 'spawn', { "police", "sheriff", "ems", "fire", "dai" }, function(source, args, user)
	if args[2] then
		local vehicleRequested = string.lower(args[2])
		local user_job = user.getActiveCharacterData('job')
		if user_job == "sheriff" then
			local user_police_rank = tonumber(user.getActiveCharacterData("policeRank"))
			if vehicleRequested ~= nil and vehicleRequested ~= '' and IsVehicleSpawnable(vehicleRequested) then
				if IsHighEnoughRank(vehicleRequested, user_police_rank) then
					TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, user_job)
					return
				else
					TriggerClientEvent("usa:notify", "You are not a high enough rank for that vehicle option.")
					return
				end
			else
				DisplaySpawnOptionsBasedOnRank(source, user_police_rank)
			end
		elseif user_job == "ems" then
			for _, vehicle in pairs(spawnableVehicles[user_job]) do
				if vehicle == vehicleRequested then
					TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, user_job)
					return
				end
			end
			TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3^*[SPAWN] ^r^0Options: maverick2, ambulance, firetruk")
		elseif user_job == "dai" then
			for _, vehicle in pairs(spawnableVehicles[user_job]) do
				if vehicle == vehicleRequested then
					TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, user_job)
					return
				end
			end
			TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3^*[SPAWN] ^r^0Options: schafter19, buffalo19, baller19", "oracle19", "taurus16a", "chrg14a", "chrg18a", "cvpi11a")
		end
	end
end, {
	help = "Spawn an exclusive emergency vehicle.",
	params = {
		{ name = "option", help = "Vehicle name" }
	}
})

TriggerEvent('es:addJobCommand', 'livery', { "police", "sheriff", "ems", "fire", "dai" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("vehicleCommands:setLivery", source, args[2])
	else
		TriggerClientEvent("usa:notify", source, "Invalid livery!")
	end
end, {
	help = "Set livery of your emergency vehicle.",
	params = {
		{ name = "livery", help = "Index number of livery" }
	}
})

TriggerEvent('es:addJobCommand', 'extra', { "police", "sheriff", "ems", "fire", "corrections", "dai" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("vehicleCommands:setExtra", source, args[2], args[3])
	else
		TriggerClientEvent("usa:notify", source, "Invalid extra!")
	end
end, {
	help = "Set extra of your emergency vehicle.",
	params = {
		{ name = "extra", help = "Index number of extra" }
	}
})

function IsHighEnoughRank(model, user_rank)
	for rank, vehicles in pairs(VEH_RANKS) do
		if user_rank >= rank then
			for k = 1, #vehicles do
				if model == vehicles[k] then
					return true
				end
			end
		end
	end
	return false
end

function IsVehicleSpawnable(modelName)
	for i = 1, #spawnableVehicles["sheriff"] do
		if spawnableVehicles["sheriff"][i] == modelName then
			return true
		end
	end
	return false
end

function DisplaySpawnOptionsBasedOnRank(source, user_rank)
	local string = ""
	for rank, vehicles in pairs(VEH_RANKS) do
		if rank == user_rank then
			for k = 1, #vehicles do
				if k == 1 then
					string = vehicles[k]
				end
				string = string .. ", " .. vehicles[k]
			end
			break
		end
	end
	TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3^*[SPAWN] ^r^0Options: " .. string)
end
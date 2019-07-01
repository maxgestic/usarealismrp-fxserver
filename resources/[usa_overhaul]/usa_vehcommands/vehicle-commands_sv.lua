local VEHICLE_RANKS = {
	["sheriff"] = {
		["pdcvpi"] = 1,
		["pdtau"] = 2,
		["pdchrg"] = 2,
		["pdexp"] = 2,
		["pdtahoe"] = 2,
		["pdchrgum"] = 4
	},
	["ems"] = {
		["ambulance"] = 1,
		["paraexp"] = 2,
		["pranger"] = 2,
		["firetruk"] = 1,
		["polmav"] = 1
	},
	["dai"] = {
		"pdchrgum"
	}
}

TriggerEvent('es:addJobCommand', 'spawn', { "police", "sheriff", "ems", "fire", "dai" }, function(source, args, char)
	local job = char.get('job')
	if not args[2] then
		local rank = 0
		if job == "sheriff" then
			rank = char.get("policeRank")
		elseif job == "ems" then
			rank = char.get("emsRank")
		elseif job == "dai" then
			rank = char.get("daiRank")
		end
		DisplaySpawnOptionsBasedOnRank(source, job, rank)
		return
	end
	local vehicleRequested = string.lower(args[2])
	if job == "sheriff" then
		local rank = char.get("policeRank")
		local neededRank = VEHICLE_RANKS[job][vehicleRequested]
		if  neededRank then
			if rank >= neededRank then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, job)
				return
			else
				TriggerClientEvent("usa:notify", "You are not a high enough rank for that vehicle option.")
				return
			end
		else
			DisplaySpawnOptionsBasedOnRank(source, job, rank)
		end
	elseif job == "ems" then
		local rank = char.get("emsRank")
		local neededRank = VEHICLE_RANKS[job][vehicleRequested]
		if neededRank then
			if rank >= neededRank then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, job)
				return
			end
		end
		DisplaySpawnOptionsBasedOnRank(source, job, rank)
	elseif job == "dai" then
		local rank = char.get("emsRank")
		local neededRank = VEHICLE_RANKS[job][vehicleRequested]
		if neededRank then
			if rank >= neededRank then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, vehicleRequested, job)
				return
			end
		end
		DisplaySpawnOptionsBasedOnRank(source, job, rank)
	end
end, {
	help = "Spawn an exclusive emergency vehicle.",
	params = {
		{ name = "option", help = "Vehicle name" }
	}
})

TriggerEvent('es:addJobCommand', 'livery', { "police", "sheriff", "ems", "fire", "dai" }, function(source, args, char)
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

TriggerEvent('es:addJobCommand', 'extra', { "police", "sheriff", "ems", "fire", "corrections", "dai" }, function(source, args, char)
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

function DisplaySpawnOptionsBasedOnRank(src, job, rank)
	local msg = ""
	for veh, neededRank in pairs(VEHICLE_RANKS[job]) do
		if rank >= neededRank then
			msg = msg .. veh .. ", "
		end
	end
	TriggerClientEvent("chatMessage", src, "", {0,0,0}, "^3SPAWN OPTIONS:^0 " .. msg )
end

local VEHICLE_RANKS = {
	["sheriff"] = {
		["pdcvpi"] = {
			rank = 1,
			allowedLiveries = { 3 },
			hash = 938090162
		},
		--["pdchrg"] = 1,
		["pdchgr"] = {
			rank = 1,
			allowedLiveries = { 2 },
			hash = -685283761
		},
		["pdtau"] = {
			rank = 1,
			allowedLiveries = { 2 },
			hash = GetHashKey("pdtau")
		},
		["pdexp"] = {
			rank = 1,
			allowedLiveries = { 2 },
			hash = GetHashKey("pdexp")
		},
		--["pdexp"] = 2,
		--["pdtahoe"] = 2,
		--["pdchrgum"] = 5,
		["riot"] = {
			rank = 5,
			allowedLiveries = { 1 },
			hash = -1205689942
		},
		["polmav"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = 353883353
		},
		["policeb"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = -34623805
		},
		["1200RT"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = 1230579450
		},
		["fbi"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = 1127131465
		},
		["predator"] = {
			rank = 1,
			allowedLiveries = { 1 },
			hash = -488123221
		},
		["sheriff2"] = {
			rank = 5,
			allowedLiveries = { 1, 2 },
			hash = GetHashKey("sheriff2")
		},
		["fbi2"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = -1647941228	
		},
		["police4"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = -1973172295	
		}
	},
	["corrections"] = {
		["pdcvpi"] = {
			rank = 1,
			allowedLiveries = { 1, 2 },
			hash = 938090162
		},
		["pdchgr"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = -685283761
		},
		["pdtau"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = GetHashKey("pdtau")
		},
		["pdexp"] = {
			rank = 3,
			allowedLiveries = { 1 },
			hash = GetHashKey("pdexp")
		},
		["polmav"] = {
			rank = 3,
			allowedLiveries = { 2 },
			hash = 353883353
		},
		["predator"] = {
			rank = 1,
			allowedLiveries = { 1 },
			hash = -488123221
		},
		["fbi"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = 1127131465
		},
		["policeb"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = -34623805
		},
		["sheriff2"] = {
			rank = 5,
			allowedLiveries = { 3 },
			hash = GetHashKey("sheriff2")
		},
		["1200RT"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = 1230579450
		},
		["fbi2"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = -1647941228	
		},
		["police4"] = {
			rank = 4,
			allowedLiveries = { 1 },
			hash = -1973172295	
		}
	},
	["ems"] = {
		["ambulance"] = {
			rank = 1,
			allowedLiveries = { 1, 2, 3, 4 },
			hash = 1171614426
		},
		["paraexp"] = {
			rank = 3,
			allowedLiveries = { 1, 2, 3 },
			hash = 296562921
		},
		--[[
		["sheriff2"] = {
			rank = 4,
			allowedLiveries = { 1, 2, 3, 4 },
			hash = 1922257928
		},
		--]]
		["firetruk"] = {
			rank = 1,
			allowedLiveries = { 1 },
			hash = 1938952078
		},
		["polmav"] = {
			rank = 1,
			allowedLiveries = { 3 },
			hash = 353883353
		},
		--["lguard2"] = 1,
		["blazer2"] = {
			rank = 1,
			allowedLiveries = { 1 },
			hash = -48031959
		},
		["predator"] = {
			rank = 1,
			allowedLiveries = { 1 },
			hash = -488123221
		}
	},
	["doctor"] = {
		--["paraexp"] = 1,
		--[[
		["sheriff2"] = {
			rank = 4,
			allowedLiveries = { 1, 2, 3, 4 },
			hash = 1922257928
		}
		--]]
	}
}

function getRankForJob(char, job, cb)
	if job == "sheriff" then
		cb(char.get("policeRank"))
	elseif job == "ems" or job == "doctor" then
		cb(char.get("emsRank"))
	elseif job == "corrections" then 
		TriggerEvent('es:exposeDBFunctions', function(db)
			local ident = GetPlayerIdentifiers(char.get("source"))[1]
			db.getDocumentByRow("correctionaldepartment", "identifier", ident, function(doc)
				if doc then
					cb(doc.rank)
				end
			end)
		end)
	end
end

TriggerEvent('es:addJobCommand', 'spawn', { "police", "sheriff", "ems", "fire", "doctor", "corrections" }, function(source, args, char)
	local usource = source
	local job = char.get('job')
	getRankForJob(char, job, function(rank)
		print("rank: " .. rank)
		local selected = args[2]
		if not selected then
			DisplaySpawnOptionsBasedOnRank(usource, job, rank)
			return
		end
		local vehicleRequested = selected
		if job == "sheriff" or job == "corrections" or job == "ems" then
			local neededRank = VEHICLE_RANKS[job][vehicleRequested]
			if neededRank then
				if type(neededRank) == "table" then
					neededRank = neededRank.rank
				end
				if rank >= neededRank then
					TriggerClientEvent("vehicleCommands:spawnVehicle", usource, vehicleRequested, job)
					return
				else
					TriggerClientEvent("usa:notify", "You are not a high enough rank for that vehicle option.")
					return
				end
			else
				DisplaySpawnOptionsBasedOnRank(usource, job, rank)
			end
		end
	end)
end, {
	help = "Spawn an exclusive emergency vehicle.",
	params = {
		{ name = "option", help = "Vehicle name" }
	}
})

RegisterServerEvent("vehCommands:gotVehModel")
AddEventHandler("vehCommands:gotVehModel", function(model, srcAction, selected)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if srcAction == "livery" then 
		for name, info in pairs(VEHICLE_RANKS[job]) do 
			if type(info) == "table" then
				if info.hash == model then 
					for i = 1, #info.allowedLiveries do 
						if selected == info.allowedLiveries[i] then 
							TriggerClientEvent("vehicleCommands:setLivery", source, selected)
							return
						end
					end
					TriggerClientEvent("usa:notify", source, "Invalid livery (wrong job)!")
					return
				end
			elseif type(info) == "number" then
				TriggerClientEvent("vehicleCommands:setLivery", source, selected)
				return
			end
		end
	end
end)

TriggerEvent('es:addJobCommand', 'livery', { "sheriff", "ems", "corrections" }, function(source, args, char)
	local selected = tonumber(args[2])
	if selected then
		TriggerClientEvent("vehCommands:getVehModel", source, selected)
	else
		TriggerClientEvent("usa:notify", source, "Invalid livery!")
	end
end, {
	help = "Set livery of your emergency vehicle.",
	params = {
		{ name = "livery", help = "Index number of livery" }
	}
})

TriggerEvent('es:addJobCommand', 'extra', { "sheriff", "ems", "corrections" }, function(source, args, char)
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
	print("rank: " .. rank)
	local msg = ""
	for veh, neededRank in pairs(VEHICLE_RANKS[job]) do
		if type(neededRank) == "table" then
			neededRank = neededRank.rank
		end
		if rank >= neededRank then
			msg = msg .. veh .. ", "
		end
	end
	TriggerClientEvent("chatMessage", src, "", {0,0,0}, "^3SPAWN OPTIONS:^0 " .. msg )
end

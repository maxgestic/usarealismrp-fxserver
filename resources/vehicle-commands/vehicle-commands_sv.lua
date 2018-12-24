local spawnableVehicles = {
	["sheriff"] = {
		'policeb',
		'sheriff',
		'sheriff2',
		'sheriff3',
		'pbus',
		'policet',
		'police',
		'police2',
		'police3',
		'police4',
		'police5',
		'police6',
		'police7',
		'police8',
		'fbi',
		'fbi2',
		'riot',
		'polmav',
		'scorcher',
		'predator',
		'chpcvpi',
		'unmarked1',
		'unmarked3',
		'unmarked4',
		'unmarked6',
		'unmarked7',
		'unmarked8',
		'unmarked9',
		'pranger'
	}
}

local VEH_RANKS = {
	[1] = {"police", "police2", "police3", "police5", "scorcher", "police7", "predator", "pbus", "policet", "sheriff"},
	[2] = {"police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked7", "predator", "pbus", "policet", "sheriff", "sheriff2"},
	[3] = {"police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked7", "predator", "polmav", "pbus", "policet", "sheriff", "sheriff2", "fbi2"},
	[4] = {"pranger", "police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "predator", "polmav", "pbus", "policet", "riot", "sheriff", "sheriff2"},
	[5] = {"pranger", "police", "police2", "police3", "police5", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked6", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "unmarked3", "unmarked9", "predator", "polmav", "pbus", "policet", "riot", "sheriff", "sheriff2"},
	[6] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3','unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[7] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[8] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[9] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"},
	[10] = {"pranger", 'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9', "sheriff", "sheriff2"}
	}

-- TODO: compact above two tables into one single table

function isSpawnable(modelName)
	for i =1, #spawnableVehicles["sheriff"] do
		if spawnableVehicles["sheriff"][i] == modelName then
			return true
		end
	end
	return false
end


-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'spawn', function(source, args, user)
	local model = args[2]
	local user_job = user.getActiveCharacterData("job")
	if user_job == "sheriff" then
		local user_police_rank = tonumber(user.getActiveCharacterData("policeRank"))
		if model ~= nil and model ~= '' then
			if isSpawnable(model) then
				print("police rank: " .. user_police_rank)
				if IsHighEnoughRank(model, user_police_rank) then
					TriggerClientEvent("vehicleCommands:spawnVehicle", source, model, user_job)
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3You are not a high enough rank for that vehicle option.")
				end
			else
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3Invalid spawn option!")
			end
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			DisplaySpawnOptionsBasedOnRank(source, user_police_rank)
			--TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 predator, scorcher, policeb, sheriff, sheriff2, sheriff3, police, police2, police3, police4, police5, police6, police7, police8, policet, pbus, chpcvpi, fbi, fbi2, riot, polmav")
		end
	elseif user_job == "ems" then
		if args[2] == "ambulance" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "ambulance")
		elseif args[2] == "suv" then
			--TriggerClientEvent("vehicleCommands:spawnVehicle", source, "pranger")
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "sheriff2", user_job)
		elseif args[2] == "heli" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "polmav")
		elseif args[2] == "blazer" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "blazer2")
		elseif args[2] == "lguard2" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "lguard2")
		elseif args[2] == "firetruck" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "firetruk")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 ambulance, suv, firetruck, heli, blazer, lguard2")
		end
	elseif user_job == "fire" then
		if args[2] == "firetruck" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "firetruk")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 firetruck")
		end
	else
		TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 180, 0}, "^3Only cops/sheriffs/ems/fire can use /spawn.")
	end
end, {
	help = "Spawn a job vehicle.",
	params = {
		{ name = "option", help = "Vehicle name" }
	}
})

TriggerEvent('es:addJobCommand', 'livery', { "police", "sheriff", "ems", "fire" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("vehicleCommands:setLivery", source, args[2])
	else
		TriggerClientEvent("chatMessage", source, "CAR", { 255, 180, 0 }, "Missing Livery.")
	end
end, {
	help = "Set livery of vehicle.",
	params = {
		{ name = "livery", help = "Index number of livery" }
	}
})

TriggerEvent('es:addJobCommand', 'extra', { "police", "sheriff", "ems", "fire", "corrections" }, function(source, args, user)
	if args[2] then
		TriggerClientEvent("vehicleCommands:setExtra", source, args[2], args[3])
	else
		TriggerClientEvent("chatMessage", source, "CAR", { 255, 180, 0 }, "Missing Extra.")
	end
end, {
	help = "Set extra of vehicle.",
	params = {
		{ name = "extra", help = "Index number of extra" }
	}
})

function IsHighEnoughRank(model, user_rank)
	-- see if user is high enough rank  to spawn vehicle --
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

function DisplaySpawnOptionsBasedOnRank(source, user_rank)
	local string = "police"
	for rank, vehicles in pairs(VEH_RANKS) do
		if rank == user_rank then
			for k = 1, #vehicles do
				string = string .. ", " .. vehicles[k]
			end
			break
		end
	end
	TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3Options: " .. string)
end

local function power(a, b)
	return a ^ b
	end

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(power(x1 - x2, 2) + power(y1 - y2, 2) + power(z1 - z2, 2))
end

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
		'unmarked9'
	}
}

local VEH_RANKS = {
	[1] = {"police", "police2", "police3", "scorcher", "police7", "predator", "pbus", "policet"},
	[2] = {"police", "police2", "police3", "scorcher", "police7", "policeb", "police6", "unmarked7", "predator", "pbus", "policet"},
	[3] = {"police", "police2", "police3", "scorcher", "police7", "policeb", "police6", "unmarked7", "predator", "polmav", "pbus", "policet"},
	[4] = {"police", "police2", "police3", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "predator", "polmav", "pbus", "policet", "riot"},
	[5] = {"police", "police2", "police3", "scorcher", "police7", "policeb", "police6", "unmarked1", "unmarked6", "unmarked7", "unmarked8", "fbi", "fbi2", "police4", "sheriff", "unmarked3", "unmarked9", "predator", "polmav", "pbus", "policet", "riot"},
	[6] = {'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3','unmarked6','unmarked7','unmarked8','unmarked9'},
	[7] = {'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9'},
	[8] = {'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9'},
	[9] = {'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9'},
	[10] = {'policeb','sheriff','sheriff2','sheriff3','pbus','policet','police','police2','police3','police4','police5','police6','police7','police8','fbi','fbi2',	'riot','polmav','scorcher','predator','chpcvpi','unmarked1','unmarked3', 'unmarked4', 'unmarked6','unmarked7','unmarked8','unmarked9'}
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
					TriggerClientEvent("vehicleCommands:spawnVehicle", source, model)
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
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "pranger")
		elseif args[2] == "heli" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "polmav")
		elseif args[2] == "firetruck" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "firetruk")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 ambulance, suv, firetruck, heli")
		end
	elseif user_job == "fire" then
		if args[2] == "firetruck" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "firetruk")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 firetruck")
		end
    elseif user_job == "security" then
		local mPos = user.getCoords()
		if get3DDistance(3502.5, 3762.45, 29.010, mPos.x, mPos.y, mPos.z) < 20.0 then
			if args[2] == "barracks" then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, "barracks")
			elseif args[2] == "crusader" then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, "crusader")
			elseif args[2] == "buzzard2" then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, "buzzard2")
			else
				TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
				TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 barracks, crusader, buzzard2")
			end
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Vehicles can only be spawned at HQ!")
		end
	else
		TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 180, 0}, "^3Only cops/sheriffs/ems/fire/security can use /spawn.")
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

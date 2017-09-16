local spawnableVehicles = {
	["sheriff"] = {
		'policeb',
		'sheriff',
		'sheriff2',
		'sheriff3',
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
		'scorcher'
	}
}

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
	if user.getJob() == "sheriff" then
		if model ~= nil and model ~= '' then
			if isSpawnable(model) then
				TriggerClientEvent("vehicleCommands:spawnVehicle", source, model)
			else
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3Invalid spawn option!")
			end
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 scorcher, policeb, sheriff, sheriff2, sheriff3, police, police2, police3, police4, police5, police6, police7, police8, fbi, fbi2, riot, polmav")
		end
	elseif user.getJob() == "ems" then
		if args[2] == "ambulance" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "ambulance")
		elseif args[2] == "suv" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "pranger")
		elseif args[2] == "heli" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "polmav")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 ambulance, suv, heli")
		end
	elseif user.getJob() == "fire" then
		if args[2] == "firetruck" then
			TriggerClientEvent("vehicleCommands:spawnVehicle", source, "firetruk")
		else
			TriggerClientEvent("vehicleCommands:error", source, "^1Invalid model name. Usage: /spawn <name>")
			TriggerClientEvent("vehicleCommands:error", source, "^3options:^0 firetruck")
		end
	else
		TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 180, 0}, "^3Only cops/sheriffs/ems/fire can use /spawn.")
	end
end)

TriggerEvent('es:addCommand', 'livery', function(source, args, user)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user then
			if user.getJob() == "cop" or user.getJob() == "sheriff" or user.getJob() == "highwaypatrol" or user.getJob() == "ems" or user.getJob() == "fire" then
				if args[2] then
					TriggerClientEvent("vehicleCommands:setLivery", source, args[2])
				else
					TriggerClientEvent("chatMessage", source, "CAR", { 255, 180, 0 }, "Missing Livery.")
				end
			else
				TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You don't have permissions to use this command.")
			end
		else
			print("ERROR GETTING USER BY ID")
		end
	end)
end)

TriggerEvent('es:addCommand', 'extra', function(source, args, user)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if user then
			if user.getJob() == "cop" or user.getJob() == "sheriff" or user.getJob() == "highwaypatrol" or user.getJob() == "ems" or user.getJob() == "fire" then
				if args[2] then
					TriggerClientEvent("vehicleCommands:setExtra", source, args[2], args[3])
				else
					TriggerClientEvent("chatMessage", source, "CAR", { 255, 180, 0 }, "Missing Extra.")
				end
			else
				TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You don't have permissions to use this command.")
			end
		else
			print("ERROR GETTING USER BY ID")
		end
	end)
end)

TriggerEvent('es:addCommand', 'engine', function(source, args, user)
	if user.getJob() == "sheriff" then
		local userSource = tonumber(source)
		local param = args[2]
		TriggerClientEvent("vehicleCommands:upgradeEngine", userSource, param)
		--local engine = 11
		--local totalOptions = GetNumVehicleMods()
		--SetVehicleMod(currentvehicle, engine, param)
	end
end)

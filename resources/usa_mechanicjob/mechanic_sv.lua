exports["globals"]:PerformDBCheck("usa_mechanicjob", "mechanicjob")

local TOW_REWARD = {200, 350}

local installQueue = {}

RegisterServerEvent("towJob:giveReward")
AddEventHandler("towJob:giveReward", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "mechanic" then
		local amountRewarded = math.random(TOW_REWARD[1], TOW_REWARD[2])
		char.giveMoney(amountRewarded)
		TriggerClientEvent('usa:notify', source, 'Vehicle impounded, you have received: ~y~$'..amountRewarded..'.00')
		print("TOW: " .. GetPlayerName(source) .. "["..GetPlayerIdentifier(source).."] has received amount["..amountRewarded..'] for impounding vehicle!')
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
    	TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit towJob:giveReward event, please intervene^0!')
    end
end)

TriggerEvent('es:addJobCommand', 'tow', { "mechanic" }, function(source, args, char)
	TriggerClientEvent('towJob:towVehicleInFront', source)
end, {
	help = "Load or unload the car in front of you onto a flatbed."
})

TriggerEvent('es:addJobCommand', 'install', { "mechanic" }, function(source, args, char)
	local upgrade = UPGRADES[args[2]]
	if upgrade then
		local char = exports["usa-characters"]:GetCharacter(source)
		MechanicHelper.getMechanicRank(char.get("_id"), function(rank)
			if rank >= 2 then
				TriggerClientEvent('mechanic:tryInstall', source, upgrade)
				installQueue[source] = args[2]
			else 
				TriggerClientEvent("usa:notify", source, "Must be lvl 2 to install upgrades!", "^3INFO: ^0Must be a level 2 mechanic to install upgrades! Respond to more player calls and repair vehicles to rank up!")		
			end
		end)
	else 
		local optionsStr = ""
		local count = 0
		for name, info in pairs(UPGRADES) do 
			if count == 0 then
				optionsStr = "($" .. exports.globals:comma_value(info.cost) .. ") " .. name
			else
				optionsStr = "($" .. exports.globals:comma_value(info.cost) .. ") " .. name .. ", " .. optionsStr
			end
			count = count + 1
		end
		TriggerClientEvent("usa:notify", source, "Invalid upgrade name!", "^3INFO: ^0Invalid upgrade name! Options: " .. optionsStr)
	end
end, {
	help = "Install custom vehicle upgrades",
	params = {
		{ name = "upgradeName", help = "Options: topspeed1, topspeed2, topspeed3, topspeed4" }
	}
})

RegisterServerEvent("towJob:setJob")
AddEventHandler("towJob:setJob", function(truckSpawnCoords)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "mechanic" then
		TriggerClientEvent("towJob:offDuty", source)
		char.set("job", "civ")
		TriggerClientEvent("radio:unsubscribe", source)
	else
		local drivers_license = char.getItem("Driver's License")
		if drivers_license then
			if drivers_license.status == "valid" then
				local usource = source
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/dispatch [id] [msg]^0 to respond to a tow request!")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/tow^0 when facing a vehicle to load/unload it from the flatbed.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/repair^0 when facing a vehicle to repair it.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Use ^3/ping [id]^0 to request a person\'s location.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "A tow truck has been equipped for you just there, use this to tow vehicles.")
				Citizen.Wait(3000)
				TriggerClientEvent("chatMessage", usource, "", {}, "Press ^3SHIFT + F2^0 to open the radio, left/right arrows keys to change channels, and CAPS LOCK to speak on it")
				char.set("job", "mechanic")
				TriggerClientEvent("towJob:onDuty", usource, truckSpawnCoords)
				return
			else
				TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
				return
			end
		end
		if not has_dl then
			TriggerClientEvent("usa:notify", source, "You do not have a driver's license!")
			return
		end
	end
end)

RegisterServerEvent("tow:forceRemoveJob")
AddEventHandler("tow:forceRemoveJob", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	char.set("job", "civ")
	TriggerClientEvent("towJob:offDuty", source)
	TriggerClientEvent("radio:unsubscribe", source)
end)

RegisterServerEvent("mechanic:repairJobCheck")
AddEventHandler("mechanic:repairJobCheck", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "mechanic" then
		local kit = char.getItem("Repair Kit")
		if kit then
			TriggerClientEvent("mechanic:repair", source)
		else 
			TriggerClientEvent("usa:notify", source, "You need a repair kit!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Must be on duty as mechanic!")
	end
end)

RegisterServerEvent("mechanic:vehicleRepaired")
AddEventHandler("mechanic:vehicleRepaired", function()
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local ident = char.get("_id")
	MechanicHelper.incrementStat(ident, "repairCount", function(updatedVal)
		TriggerClientEvent("usa:notify", usource, "You have repaired " .. updatedVal .. " vehicle(s)!", "^3INFO: ^0You have repaired " .. updatedVal .. " vehicle(s)!")
		if updatedVal == MechanicHelper.LEVEL_2_RANK_THRESH then -- notify of rank up
			TriggerClientEvent("usa:notify", usource, "You have reached mechanic level 2!", "^3INFO: ^0You have reached mechanic level 2! You can now use ^3/install <upgradeName>^0 to install custom vehicle upgrades!")
		end
	end)
end)

RegisterServerEvent("mechanic:installedUpgrade")
AddEventHandler("mechanic:installedUpgrade", function(plate)
	print("installing upgrade!")
	local usource = source
	local upgrade = UPGRADES[installQueue[usource]]
	local char = exports["usa-characters"]:GetCharacter(usource)
	if upgrade then
		if char.get("money") >= upgrade.cost then
			char.removeMoney(upgrade.cost)
			MechanicHelper.upgradeInstalled(plate, upgrade, function()
				installQueue[usource] = nil
				print("upgrade install complete!")
			end)
		else
			TriggerClientEvent("usa:notify", usource, "Not enough money! Need $" .. exports.globals:comma_value(upgrade.cost))
		end
	end
end)

AddEventHandler("playerDropped", function(reason)
	if installQueue[source] then 
		installQueue[source] = nil
	end
end)

function GetUpgradeObjectsFromIds(upgradeIds)
	local ret = {}
	if upgradeIds then
		for i = 1, #upgradeIds do 
			local id = upgradeIds[i]
			table.insert(ret, UPGRADES[id])
		end
	end
	return ret
end

--[[
	- attributes to make fully persistant -
	engine hp
	body hp
	dirt level
	tires popped
	door broken
]]
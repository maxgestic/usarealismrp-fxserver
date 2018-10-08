-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

_VERSION = '4.1.4'

---------------------------------------------------------------------------
-- Variable Declarations --
---------------------------------------------------------------------------

-- Server
Users = {}
commands = {}
settings = {}
-- some of these default settings are now unused (since it was moved into the characters attribute)
settings.defaultSettings = {
	['pvpEnabled'] = true,
	['permissionDenied'] = false,
	['debugInformation'] = false,
	['startingCash'] = 5000,
	['startingBank'] = 0,
	['startingJob'] = "civ",
	['startingModel'] = "a_m_y_skater_01",
	['startingInventory'] = {},
	['startingWeapons'] = {},
	['startingVehicles'] = {},
	['startingInsurance'] = {},
	['startingLicenses'] = {},
	['enableRankDecorators'] = false,
	['moneyIcon'] = "$",
	['nativeMoneySystem'] = false,
	['commandDelimeter'] = '/'
}
settings.sessionSettings = {}
commandSuggestions = {}
local justJoined = {}

---------------------------------------------------------------------------
-- Function Definitions --
---------------------------------------------------------------------------

function getCommands()
	return commandSuggestions
end

function CanGroupTarget(group, target)
	if (group == nil or target == nil) then return false end
	return groups[group]:canTarget(target)
end

function addCommand(command, callback, suggestion)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].job = "everyone"
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = "everyone"
		suggestion.group = "user"

		commandSuggestions[command] = suggestion
	end

	debugMsg("Command added: " .. command)
end

function addJobCommand(command, job, callback, suggestion)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].job = job
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = job
		suggestion.group = "user"

		commandSuggestions[command] = suggestion
	end

	debugMsg("Job command added: " .. command .. ", requires job level: " .. table.concat(job, ", "))
end

function addGroupCommand(command, group, callback, suggestion)
	commands[command] = {}
	commands[command].perm = math.maxinteger
	commands[command].group = group
	commands[command].job = { "everyone" }
	commands[command].cmd = callback

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end
		suggestion.job = "everyone"
		suggestion.group = group

		commandSuggestions[command] = suggestion
	end

	debugMsg("Group command added: " .. command .. ", requires group: " .. group)
end

---------------------------------------------------------------------------
-- Event Handlers --
---------------------------------------------------------------------------

AddEventHandler('playerDropped', function()
	local numberSource = tonumber(source)

	TriggerEvent("anticheese:playerDropped", numberSource)
	if(Users[numberSource])then
		print("player " .. GetPlayerName(numberSource) .. " dropped from the server!")
		TriggerEvent("chat:sendToLogFile", numberSource, "dropped from the server! Timestamp: " .. os.date('%m-%d-%Y %H:%M:%S', os.time()))
		local inventory = Users[numberSource].getActiveCharacterData("inventory")
		if inventory then
			for i = 1, #inventory do
				local item = inventory[i]
				if item then
					if item.name == "20g of concentrated cannabis" then
						table.remove(inventory, i)
						Users[numberSource].setActiveCharacterData("inventory", inventory)
						print("player dropped with cannabis, removing it...")
					end
				end
			end
		end
		TriggerEvent("es:playerDropped", Users[numberSource])
		db.updateUser(Users[numberSource].get('identifier'), {characters = Users[numberSource].getCharacters(), policeCharacter = Users[numberSource].getPoliceCharacter(), emsCharacter = Users[numberSource].getEmsCharacter()}, function()
			Users[numberSource] = nil
		end)
	else
		print("Users[numberSource] did not exist!")
	end
end)

RegisterServerEvent('es:firstJoinProper')
AddEventHandler('es:firstJoinProper', function()
	registerUser(GetPlayerIdentifiers(source)[1], tonumber(source))
	justJoined[source] = true

	if(settings.defaultSettings.pvpEnabled)then
		TriggerClientEvent("es:enablePvp", source)
	end
end)

AddEventHandler('es:setSessionSetting', function(k, v)
	settings.sessionSettings[k] = v
end)

AddEventHandler('es:getSessionSetting', function(k, cb)
	cb(settings.sessionSettings[k])
end)

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	if(justJoined[source])then
		TriggerEvent("es:firstSpawn", source, Users[source])
		justJoined[source] = nil
	end
end)

AddEventHandler("es:setDefaultSettings", function(tbl)
	for k,v in pairs(tbl) do
		if(settings.defaultSettings[k] ~= nil)then
			settings.defaultSettings[k] = v
		end
	end

	debugMsg("Default settings edited.")
end)

AddEventHandler('chatMessageLocation', function(source, n, message, location)
	if(startswith(message, settings.defaultSettings.commandDelimeter))then
		local command_args = stringsplit(message, " ")

		command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")

		local command = commands[command_args[1]]
		if command then
			CancelEvent()
			if command.perm > 0 then
				if(Users[source].getPermissions() >= command.perm or groups[Users[source].getGroup()]:canTarget(command.group)) then
					command.cmd(source, command_args, Users[source], location)
					TriggerEvent("es:adminCommandRan", source, command_args, Users[source])
				else
					TriggerClientEvent('chatMessage', source, "", {255, 50, 50}, "That command is for " .. command.group .. " and up only!");
					TriggerEvent("es:adminCommandFailed", source, command_args, Users[source])
					debugMsg("Non admin (" .. GetPlayerName(source) .. ") attempted to run admin command: " .. command_args[1])
				end
			elseif command.job ~= "everyone" then
				local allowed = 0;
				for k,v in pairs(command.job) do
					if Users[source].getActiveCharacterData("job") == v then
						allowed = 1
					end
				end

				if allowed == 1 then
					command.cmd(source, command_args, Users[source], location)
					TriggerEvent("es:commandRan", source, command_args, Users[source])
				else
					TriggerClientEvent('chatMessage', source, "", {255, 50, 50}, "That command is for " .. tostring(table.concat(command.job, ", ")) .. " only!");
				end
			else
				command.cmd(source, command_args, Users[source], location)
				TriggerEvent("es:userCommandRan", source, command_args)
			end

			TriggerEvent("es:commandRan", source, command_args, Users[source])
		else
			TriggerEvent('es:invalidCommandHandler', source, command_args, Users[source])

			if WasEventCanceled() then
				CancelEvent()
			end
		end
	else
		TriggerEvent('es:chatMessage', source, message, Users[source])
	end
end)

AddEventHandler('es:addCommand', function(command, callback, suggestion)
	addCommand(command, callback, suggestion)
end)

AddEventHandler('es:addJobCommand', function(command, job, callback, suggestion)
	addJobCommand(command, job, callback, suggestion)
end)

AddEventHandler('es:addGroupCommand', function(command, perm, callback, suggestion)
	addGroupCommand(command, perm, callback, suggestion)
end)

RegisterServerEvent('es:updatePositions')
AddEventHandler('es:updatePositions', function(x, y, z)
	if(Users[source])then
		Users[source].setCoords(x, y, z)
	end
end)

---------------------------------------------------------------------------
-- Threads --
---------------------------------------------------------------------------

Citizen.CreateThread(function()

	function saveData()
		print("calling saveData()...")
		TriggerEvent("es:getPlayers", function(players)
			print("inside of es:getPlayers")
			if not players then
				return
			end

			print("players existed")
			for id, player in pairs(players) do
				if not player then
					return
				end
				print("player existed")

				db.updateUser(
					player.get('identifier'),
					{
						characters = player.getCharacters(),
						policeCharacter = (player.getPoliceCharacter() or {}),
						emsCharacter = (player.getEmsCharacter() or {})
					},
					function()
						print("saved player #" .. id .. "'s data!'")
					end
				)
			end
		end)
	end

	local minutes = 30

	while true do
		Citizen.Wait(minutes * 60000)
		saveData()
	end
end)

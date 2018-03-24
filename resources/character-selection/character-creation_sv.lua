local WHOLE_DAYS_TO_DELETE = 3

TriggerEvent('es:addCommand', 'swap', function(source, args, user)
	TriggerClientEvent("character:swap--check-distance", source)
end, { help = "Swap to another character (Must be at the clothing store)." })

RegisterServerEvent("character:getCharactersAndOpenMenu")
AddEventHandler("character:getCharactersAndOpenMenu", function(menu)
	print("loading characters to open menu...")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
	if user then
		local characters = user.getCharacters()
		TriggerClientEvent("character:open", userSource, menu, characters)
	end
	end)
end)

local default_money = 5000
local default_bank = 0

-- Creating a new character
RegisterServerEvent("character:new")
AddEventHandler("character:new", function(data)
	local userSource = tonumber(source)
	print("***INSIDE OF CHARACTER:NEW***")
	local slot = data.slot
	local newCharacterTemplate = {
		firstName = data.firstName,
		middleName = data.middleName,
		lastName = data.lastName,
		dateOfBirth = data.dateOfBirth,
		active = true,
		appearance = {},
		jailtime = 0,
		money = default_money,
		bank = default_bank,
		inventory = {},
		weapons = {},
		vehicles = {},
		watercraft = {},
		aircraft = {},
		insurance = {},
		job = "civ",
		licenses = {},
		criminalHistory = {},
		policeRank = 0,
		emsRank = 0,
		securityRank = 0,
		ingameTime = 0,
		created = {
			date = os.date('%m-%d-%Y %H:%M:%S', os.time()),
			time = os.time()
		}
	}
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local characters = user.getCharacters()
			print("trying to save character data into slot #" .. slot .. "...")
			characters[slot] = newCharacterTemplate
			user.setCharacters(characters)
			print("done saving character data into slot #" .. slot)

			TriggerClientEvent("character:open", userSource, "home", characters)
		end
	end)
end)

RegisterServerEvent("character:setActive")
AddEventHandler("character:setActive", function(slot)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local money_to_display = 0
			local characters = user.getCharacters()
			for i = 1, #characters do
				if i == tonumber(slot) then
					characters[i].active = true
					money_to_display = characters[i].money
				else
					characters[i].active = false
				end
			end
			user.setCharacters(characters)
			user.setActiveCharacterData("money", money_to_display) -- set money GUI in top right (?)
			-- check jailed status
			print("calling checkJailedStatusOnPlayerJoin server function!")
			TriggerEvent("usa_rp:checkJailedStatusOnPlayerJoin", userSource)
		end
	end)
end)

RegisterServerEvent("character:save")
AddEventHandler("character:save", function(characterData, slot)
print("***INSIDE OF CHARACTER:SAVE***")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local characters = user.getCharacters()
			print("trying to save character data into slot #" .. slot .. "...")
			characters[slot] = characterData
			user.setCharacters(characters)
			print("done saving character data into slot #" .. slot)
		end
	end)
end)

RegisterServerEvent("character:delete")
AddEventHandler("character:delete", function(slot)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local characters = user.getCharacters()
			-- See if character is at least one week old
			local characterAge = getWholeDaysFromTime(characters[slot].created.time)
			if characterAge >= WHOLE_DAYS_TO_DELETE then
				print("debug: Deleting character at slot #" .. slot .. "...")
				characters[slot] = {active = false}
				user.setCharacters(characters)
				print("debug: Done deleting character at slot #" .. slot .. ".")
				TriggerClientEvent("character:open", userSource, "home", characters)
			else
				print("Error: Can't delete a character whose age is less than " .. WHOLE_DAYS_TO_DELETE .. "!")
				TriggerClientEvent("character:send-nui-message", userSource, {type = "delete", status = "fail", slot = slot}) -- update nui menu
			end
		end
	end)
end)

RegisterServerEvent("character:loadCharacter")
AddEventHandler("character:loadCharacter", function(activeSlot)
	print("trying to load character in active slot #" .. activeSlot)
	local userSource = tonumber(source)
	TriggerClientEvent('chat:removeSuggestionAll', userSource)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			local characters = user.getCharacters()
			local character = characters[activeSlot]
			local myGroup = user.getGroup()
			TriggerClientEvent("character:setCharacter", userSource, character)
			print("loaded character at slot #" .. activeSlot .. " with #weapons = " .. #(character.weapons))
			-- set commands
			for k,v in pairs(exports['essentialmode']:getCommands()) do
				if v.job == "everyone" and exports['essentialmode']:CanGroupTarget(myGroup, v.group) then
					TriggerClientEvent('chat:addSuggestion', userSource, '/' .. k, v.help, v.params)
				end
			end
			-- check dmv / firearm permit license status
			TriggerEvent("police:checkSuspension", userSource)
			
		end
	end)
end)

function getWholeDaysFromTime(time)
	local reference = time
	local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
	local wholedays = math.floor(daysfrom)
	print("wholedays = " .. wholedays) -- today it prints "1"
	return wholedays
end

RegisterServerEvent('character:disconnect')
AddEventHandler('character:disconnect', function()
	DropPlayer(source, "Disconnected at character selection.")
end)
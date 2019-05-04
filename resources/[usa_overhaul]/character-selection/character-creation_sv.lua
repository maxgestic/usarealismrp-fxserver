local WHOLE_DAYS_TO_DELETE = 0
local blacklistedNames = {
	'nig',
	'fuck',
	'shit',
	'bitch',
	'ass',
	'prick',
	'ngger',
	'ngga',
	'nga',
	'nger',
	'fck',
	'fak',
	'sht',
	'sh1t',
	'fuk',
	'ing',
	'fag',
	'gay',
	'cunt',
	'cock',
	'dick',
	'penis',
	'vag',
	'crack',
	'jerk',
	'piss',
	'slut',
	'tit',
	'twat',
	'wank',
	'whore',
	'jihad',
	'fivem',
	'usarrp',
	'allahu',
	'akbar',
	'admin',
	'owner',
	'slave',
	'thot',
	'weed',
	'meth'
}

TriggerEvent('es:addCommand', 'swap', function(source, args, user)
	TriggerClientEvent("character:swap--check-distance", source)
end, { help = "Swap to another character (Must be at the clothing store)." })

RegisterServerEvent("character:getCharactersAndOpenMenu")
AddEventHandler("character:getCharactersAndOpenMenu", function(menu)
	print("loading characters to open menu...")
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local characters = user.getCharacters()
		TriggerClientEvent("character:open", userSource, menu, characters)
	end
end)

local default_money = 5000
local default_bank = 0

-- Creating a new character
RegisterServerEvent("character:new")
AddEventHandler("character:new", function(data)
	local userSource = tonumber(source)
	print("***INSIDE OF CHARACTER:NEW***")
	for i = 1, #blacklistedNames do
		local name = blacklistedNames[i]
		local firstName = string.lower(data.firstName)
		local middleName = string.lower(data.middleName)
		local lastName = string.lower(data.lastName)
		if string.find(firstName, name) or string.find(middleName, name) or string.find(lastName, name) then
			TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (1)')
			print('Character name contained forbidden words: '..data.firstName..' '..data.middleName..' '..data.lastName)
			return
		end
	end
	if not ContainsVowel(data.firstName) or (not ContainsVowel(data.middleName) and data.middleName ~= '') or not ContainsVowel(data.lastName) then
		TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (2)')
		print('Character name did not contain a vowel: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return
	end
	if string.len(data.firstName) < 3 or (string.len(data.middleName) < 3 and data.middleName ~= '') or string.len(data.lastName) < 3 then
		TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (3)')
		print('Character name was insufficient length: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return
	end
	if string.len(data.firstName) > 16 or (string.len(data.middleName) > 16 and data.middleName ~= '') or string.len(data.lastName) > 16 then
		TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (4)')
		print('Character name was insufficient length: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return
	end
	local dob_year = tonumber(string.sub(data.dateOfBirth, 1, 4))
	if dob_year > 2001 or dob_year < 1940 then
		TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (5)')
		print('Character date of birth was unrealistic: '..data.dateOfBirth)
		return
	end
	if ContainsSpecialCharacters(data.firstName) or (ContainsSpecialCharacters(data.middleName) and data.middleName ~= '') or ContainsSpecialCharacters(data.lastName) then
		TriggerClientEvent('usa:showHelp', userSource, true, 'The character data provided is invalid or inappropriate! (6)')
		print('Character name contained special characters: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return
	end

	data.firstName = firstToUpper(data.firstName)
	data.middleName = firstToUpper(data.middleName)
	data.lastName = firstToUpper(data.lastName)

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
		spawn = nil,
		property = {
			['location'] = 'Perrera Beach Motel',
			['storage'] = {},
			['paid_time'] = os.time(),
			['money'] = 0
		},
		created = {
			date = os.date('%m-%d-%Y %H:%M:%S', os.time()),
			time = os.time()
		}
	}
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			local characters = user.getCharacters()
			print("trying to save character data into slot #" .. slot .. "... "..data.firstName..' '..data.middleName..' '..data.lastName)
			characters[slot] = newCharacterTemplate
			user.setCharacters(characters)
			print("done saving character data into slot #" .. slot)

			TriggerClientEvent("character:open", userSource, "home", characters)
		end
end)

RegisterServerEvent("character:setActive")
AddEventHandler("character:setActive", function(slot)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
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
			user.setActiveCharacterData("job", "civ")
			TriggerEvent("eblips:remove", userSource)
			--[[ check jailed status [ MOVED ]
			print("calling checkJailedStatusOnPlayerJoin server function!")
			TriggerEvent("usa_rp:checkJailedStatusOnPlayerJoin", userSource)
			--]]
		end
end)

RegisterServerEvent("character:save")
AddEventHandler("character:save", function(characterData, slot)
print("***INSIDE OF CHARACTER:SAVE***")
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			local characters = user.getCharacters()
			print("trying to save character data into slot #" .. slot .. "...")
			characters[slot] = characterData
			user.setCharacters(characters)
			print("done saving character data into slot #" .. slot)
		end
end)

RegisterServerEvent("character:delete")
AddEventHandler("character:delete", function(slot)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if user then
			local characters = user.getCharacters()
			-- See if character is at least one week old
			local characterAge
			if not characters[slot].created then
				characterAge = 999999999999 -- just to make it old enough to delete (for people without the .created property for some reason)
			else
				characterAge = getWholeDaysFromTime(characters[slot].created.time)
			end
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

RegisterServerEvent("character:loadCharacter")
AddEventHandler("character:loadCharacter", function(activeSlot)
	print("trying to load character in active slot #" .. activeSlot)
	local userSource = tonumber(source)
	TriggerClientEvent('chat:removeSuggestionAll', userSource)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	if user then
		local characters = user.getCharacters()
		local character = characters[activeSlot]
		local myGroup = user.getGroup()
		TriggerClientEvent("character:setCharacter", userSource, character)
		TriggerClientEvent('playerlist:playersToShow', userSource, false)
		print("loaded character at slot #" .. activeSlot .. " with #weapons = " .. #(character.weapons))
		-- set commands --
		for k,v in pairs(exports['essentialmode']:getCommands()) do
			if v.job == "everyone" and exports['essentialmode']:CanGroupTarget(myGroup, v.group) then
				TriggerClientEvent('chat:addSuggestion', userSource, '/' .. k, v.help, v.params)
			end
		end
		-- check dmv / firearm permit license status --
		TriggerEvent("police:checkSuspension", userSource)
		TriggerEvent('morgue:checkToeTag', userSource)
		-- Temporary event to automatically migrate existing player vehicles into new DB --
		TriggerEvent("vehicles:migrateCheck", user, activeSlot)
	end
end)

RegisterServerEvent("character:setSpawnPoint")
AddEventHandler("character:setSpawnPoint", function(spawn)
	print("inside character:setSpawnPoint!")
	local user_source = source
	local player = exports["essentialmode"]:getPlayerFromId(user_source)
	local player_spawn = player.getActiveCharacterData("spawn")
	if not player_spawn then
		player.setActiveCharacterData("spawn", spawn)
		TriggerClientEvent("usa:notify", user_source, "Spawn set!")
	else
		player.setActiveCharacterData("spawn", nil)
		TriggerClientEvent("usa:notify", user_source, "Spawn cleared!")
	end
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

function ContainsVowel(word)
	local vowels = {'a', 'e', 'i', 'o', 'u', 'y'}
	for i = 1, #vowels do
		if string.find(string.lower(word), vowels[i]) then
			return true
		end
	end
	return false
end

function ContainsSpecialCharacters(word)
	local characters = {"!", "@", "#", "&", "*", "`", ":", ";", '"', "'", "|", ">", "<", "?", "/", "=", "+", "_", '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
	for i = 1, #characters do
		if string.find(string.lower(word), characters[i]) then
			return true
		end
	end
	return false
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
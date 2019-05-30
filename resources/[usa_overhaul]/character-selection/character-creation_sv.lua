local WHOLE_DAYS_TO_DELETE = 3
local DEFAULT_MONEY = 0
local DEFAULT_BANK = 5000

TriggerEvent('es:addCommand', 'swap', function(source, args, user)
	TriggerClientEvent("character:swap--check-distance", source)
end, { help = "Swap to another character (Must be at the clothing store)." })

RegisterServerEvent("character:getCharactersAndOpenMenu")
AddEventHandler("character:getCharactersAndOpenMenu", function(menu, src)
	local usource = source
	if src then
		usource = src -- for when triggered from a server event (has no source)
	end
	exports["usa-characters"]:SaveCurrentCharacter(usource, function()
		local steamID = GetPlayerIdentifiers(usource)[1]
		exports["usa-characters"]:LoadCharactersForSelection(steamID, function(characters)
			TriggerClientEvent("character:open", usource, menu, characters)
		end)
	end)
end)

-- Creating a new character
RegisterServerEvent("character:new")
AddEventHandler("character:new", function(data)
	local usource = tonumber(source)
	if IsValidInput(usource, data) then
		data = ValidateNameCapitlization(data)
		exports["usa-characters"]:CreateNewCharacter(usource, data, function()
			TriggerEvent("character:getCharactersAndOpenMenu", "home", usource)
		end)
	end
end)

RegisterServerEvent("character:delete")
AddEventHandler("character:delete", function(data)
	local usource = source
	local id = data.id
	local rev = data.rev
	local createdTime = data.createdTime
	local characterAge = getWholeDaysFromTime(createdTime)
	if characterAge >= 3 then
		DeleteCharacterById(id, rev, function()
			print("Done deleting character with id: " .. id .. ".")
			TriggerEvent("character:getCharactersAndOpenMenu", "home", usource)
		end)
	else
		print("Error: Can't delete a character whose age is less than " .. WHOLE_DAYS_TO_DELETE .. "!")
	end
end)

RegisterServerEvent("character:loadCharacter")
AddEventHandler("character:loadCharacter", function(id, doSpawnAtProperty)
	TriggerClientEvent('chat:removeSuggestionAll', source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user then
		-- set commands --
		local myGroup = user.getGroup()
		for k,v in pairs(exports['essentialmode']:getCommands()) do
			if v.job == "everyone" and exports['essentialmode']:CanGroupTarget(myGroup, v.group) then
				TriggerClientEvent('chat:addSuggestion', source, '/' .. k, v.help, v.params)
			end
		end
		-- initialize character --
		exports["usa-characters"]:InitializeCharacter(source, id, doSpawnAtProperty)
	end
end)

RegisterServerEvent("character:setSpawnPoint")
AddEventHandler("character:setSpawnPoint", function(spawn)
	local player_spawn = exports["usa-characters"]:GetCharacterField(source, "spawn")
	if not player_spawn then
		exports["usa-characters"]:SetCharacterField(source, "spawn", spawn)
		TriggerClientEvent("usa:notify", source, "Spawn set!")
	else
		exports["usa-characters"]:SetCharacterField(source, "spawn", nil)
		TriggerClientEvent("usa:notify", source, "Spawn cleared!")
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

function DeleteCharacterById(id, rev, cb)
	PerformHttpRequest("http://127.0.0.1:5984/characters/".. id .."?rev=".. rev, function(err, rText, headers)
		if err == 0 then
			RconPrint("\nrText = " .. rText)
			RconPrint("\nerr = " .. err)
		else
			cb()
		end
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

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
	local SPECIAL_CHARS = {"!", "@", "#", "&", "*", "`", ":", ";", '"', "|", ">", "<", "?", "/", "=", "+", "_", '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
	for i = 1, #characters do
		if string.find(word, SPECIAL_CHARS[i]) then
			return true
		end
	end
	return false
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function IsValidInput(src, data)
	for i = 1, #BLACKLISTED_WORDS do
		local BLACKLISTED_WORD = BLACKLISTED_WORDS[i]
		local firstName = string.lower(data.firstName)
		local middleName = string.lower(data.middleName)
		local lastName = string.lower(data.lastName)
		if string.find(firstName, BLACKLISTED_WORD) or string.find(middleName, BLACKLISTED_WORD) or string.find(lastName, BLACKLISTED_WORD) then
			TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (1) '..BLACKLISTED_WORD)
			print('Character name contained forbidden words: '..data.firstName..' '..data.middleName..' '..data.lastName)
			return false
		end
	end
	if not ContainsVowel(data.firstName) or (not ContainsVowel(data.middleName) and data.middleName ~= '') or not ContainsVowel(data.lastName) then
		TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (2)')
		print('Character name did not contain a vowel: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return false
	end
	if string.len(data.firstName) < 3 or (string.len(data.middleName) < 3 and data.middleName ~= '') or string.len(data.lastName) < 3 then
		TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (3)')
		print('Character name was insufficient length: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return false
	end
	if string.len(data.firstName) > 16 or (string.len(data.middleName) > 16 and data.middleName ~= '') or string.len(data.lastName) > 16 then
		TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (4)')
		print('Character name was insufficient length: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return false
	end
	local dob_year = tonumber(string.sub(data.dateOfBirth, 1, 4))
	if dob_year > 2001 or dob_year < 1940 then
		TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (5)')
		print('Character date of birth was invalid: '..data.dateOfBirth)
		return false
	end
	if ContainsSpecialCharacters(data.firstName) or (ContainsSpecialCharacters(data.middleName) and data.middleName ~= '') or ContainsSpecialCharacters(data.lastName) then
		TriggerClientEvent('chatMessage', src, '^1^*[ERROR]^r^0 The character data provided is invalid or inappropriate! (6)')
		print('Character name contained special characters: '..data.firstName..' '..data.middleName..' '..data.lastName)
		return false
	end
	return true
end

function ValidateNameCapitlization(data)
	data.firstName = firstToUpper(data.firstName)
	data.middleName = firstToUpper(data.middleName)
	data.lastName = firstToUpper(data.lastName)
	return data
end

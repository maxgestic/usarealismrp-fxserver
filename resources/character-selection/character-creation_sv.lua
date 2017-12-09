TriggerEvent('es:addCommand', 'swap', function(source, args, user)
  TriggerClientEvent("character:swap--check-distance", source)
end)

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
    active = data.active,
    appearance = {},
    jailtime = 0,
    money = 5000,
    bank = 0,
    inventory = {},
    weapons = {},
    vehicles = {},
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
  print("trying to delete character at slot #" .. slot .. "...")
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            -- See if character is at least one week old
            local characterAge = getWholeDaysFromTime(characters[slot].created.time)
            if characterAge >= 7 then
              characters[slot] = {active = false}
              user.setCharacters(characters)
              print("Done deleting character at slot #" .. slot .. ".")
              TriggerClientEvent("character:send-nui-message", userSource, {type = "delete", status = "success"}) -- update nui menu
            else
              print("Error: Can't delete a character whose age is less than one week.")
              TriggerClientEvent("character:send-nui-message", userSource, {type = "delete", status = "fail"}) -- update nui menu
            end
        end
    end)
end)

RegisterServerEvent("character:loadCharacter")
AddEventHandler("character:loadCharacter", function(activeSlot)
    print("trying to load character in active slot #" .. activeSlot)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            local characters = user.getCharacters()
            local character = characters[activeSlot]
            TriggerClientEvent("character:setCharacter", userSource, character)
            print("loaded character at slot #" .. activeSlot .. " with #weapons = " .. #(character.weapons))
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

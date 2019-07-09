-- need to check for existance of DB
exports["globals"]:PerformDBCheck("usa-characters", "characters", nil)

local UPDATE_TIME_INTERVAL_MINUTES = 1

local CHARACTERS = {} -- table of all playing characters for fast look up

local SETTINGS = {
  DEFAULT_BANK = 0,
  DEFAULT_MONEY = 5000
}

local lastUpdated = {} -- keep track of in game times to save every 30 min of play time

AddEventHandler("playerDropped", function(reason)
  local usource = source
  if CHARACTERS[usource] then
      local job = CHARACTERS[usource].get("job")
      if job == "sheriff"  then
        exports["usa_police"]:RemovePoliceWeapons(CHARACTERS[usource])
    elseif job == "ems" or job ==  "corrections" then
        exports["usa_ems"]:RemoveServiceWeapons(CHARACTERS[usource])
      end
    -- save player data --
    TriggerEvent('es:exposeDBFunctions', function(db)
      print("updating char with ID: " .. CHARACTERS[usource].get("_id"))
      CHARACTERS[usource].set("_rev", nil)
      db.updateDocument("characters", CHARACTERS[usource].get("_id"), CHARACTERS[usource].getSelf(), function(doc, err, rText)
  			print("* Character updated in DB! err " .. err .. " *")
        -- notify DOC of player disconnect while in jail --
    		local jailtime = CHARACTERS[usource].get("jailTime")
    		if jailtime then
    			if jailtime > 0 then
                    local n = CHARACTERS[usource].getName()
    				exports["globals"]:notifyPlayersWithJobs({"corrections"}, "^3INFO: ^0" .. n .. " has fallen asleep.")
    			end
    		end
        -- destroy player object --
        CHARACTERS[usource] = nil
  		end)
    end)
  end
  if lastUpdated[tostring(usource)] then
      lastUpdated[tostring(usource)] = nil
  end
end)

function LoadCharactersForSelection(steamID, fCallback)
  local endpoint = "/characters/_design/characterFilters/_view/getCharactersForSelectionBySteamID"
  local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
  PerformHttpRequest(url, function(err, responseText, headers)
    if responseText then
      local charDataForMenu = {}
      --print(responseText)
      local data = json.decode(responseText)
      if data.rows then
        for i = 1, #data.rows do
          local charData = {
            id = data.rows[i].value[1],
            rev = data.rows[i].value[2],
            name = data.rows[i].value[3],
            dateOfBirth = data.rows[i].value[4],
            money = data.rows[i].value[5],
            bank = data.rows[i].value[6],
            spawn = data.rows[i].value[7],
            created = {
              time = data.rows[i].value[8]
            }
          }
          table.insert(charDataForMenu, charData)
        end
      end
      print("# of chars for menu: " .. #charDataForMenu)
      fCallback(charDataForMenu)
    end
  end, "POST", json.encode({
    keys = { steamID }
    --keys = { "steam:123123" }
  }), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

function CreateNewCharacter(src, data, cb)
  -- build new character doc --
  local newCharacter = {
    name = {
      first = data.name.first,
      middle = data.name.middle,
      last = data.name.last
    },
    dateOfBirth = data.dateOfBirth,
    appearance = {},
    jailTime = 0,
    money = SETTINGS.DEFAULT_MONEY,
    bank = SETTINGS.DEFAULT_BANK,
    inventory = {
      MAX_CAPACITY = 25,
      MAX_WEIGHT = 100.0,
      currentWeight = 0.0,
      items = {}
    },
    vehicles = {},
    watercraft = {},
    aircraft = {},
    insurance = {},
    job = "civ",
    criminalHistory = {},
    policeRank = 0,
    emsRank = 0,
    securityRank = 0,
    ingameTime = 0,
    spawn = nil,
    pets = {},
    property = {
			['location'] = 'Perrera Beach Motel',
			['storage'] = {},
			['paid_time'] = os.time(),
			['money'] = 0
		},
    created = {
      date = os.date('%m-%d-%Y %H:%M:%S', os.time()),
      time = os.time(),
      ownerIdentifier = GetPlayerIdentifiers(src)[1] -- steam ID foreign key
    }
  }
  -- create character in DB --
  TriggerEvent('es:exposeDBFunctions', function(db)
    db.createDocument("characters", newCharacter, function(success)
      cb()
    end)
  end)
end

function InitializeCharacter(src, characterID, doSpawnAtProperty)
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocument("characters", characterID, function(charData)
            charData.source = src
            local character = CreateCharacter(charData) -- Create character object in memory
            character.set("job", "civ")
            lastUpdated[tostring(src)] = os.time()
            CHARACTERS[src] = character
            TriggerClientEvent("character:setCharacter", src, character.get("appearance"), character.getWeapons()) -- load character
            TriggerEvent("police:checkSuspension", character) -- check dmv / firearm permit license status
            TriggerEvent("properties:loadCharacter", src, doSpawnAtProperty) -- ?
            TriggerEvent("eblips:remove", src) -- remove any eblip
            TriggerClientEvent("banking:updateBalance", src, character.get("bank")) -- intialize bank resource
            TriggerClientEvent("es:activateMoney", src, character.get("money")) -- make /cash work
        end)
    end)
end

function SaveCurrentCharacter(src, cb)
  if CHARACTERS[src] then
    TriggerEvent('es:exposeDBFunctions', function(db)
      db.updateDocument("characters", CHARACTERS[src].get("_id"), CHARACTERS[src].getSelf(), function(err)
  			print("* Character updated in DB! *")
        cb()
  		end)
    end)
  else
    cb()
  end
end

function GetCharacter(src)
  if CHARACTERS[src] then
    return CHARACTERS[src]
  else
    return nil
  end
end

function GetCharacters(cb)
    cb(CHARACTERS)
end

function GetNumCharactersWithJob(job)
  local count = 0
  for src, char in pairs(CHARACTERS) do
    if char.get("job") == job then
      count = count + 1
    end
  end
  return count
end

function DoesCharacterHaveItem(src, itemName)
  return CHARACTERS[src].hasItem(itemName)
end

function GetCharacterField(src, field)
  return CHARACTERS[src].get(field)
end

function SetCharacterField(src, field, val)
  if not CHARACTERS[src].get(field) then
    return
  end
  CHARACTERS[src].set(field, val)
end

Citizen.CreateThread(function()
    while true do
        for id, time in pairs(lastUpdated) do
            if GetMinutesFromTime(time) >= UPDATE_TIME_INTERVAL_MINUTES then
                TriggerEvent("es:exposeDBFunctions", function(db)
                    local char = GetCharacter(tonumber(id))
                    char.set("_rev", nil)
                    db.updateDocument("characters", char.get("_id"), char.getSelf(), function(doc, err, rText)
                        print("updated char with id: " .. char.get("_id") .. ", err " .. err)
                        lastUpdated[id] = os.time()
                    end)
                end)
            end
        end
        Wait(UPDATE_TIME_INTERVAL_MINUTES * 60 * 1000)
    end
end)

function GetMinutesFromTime(time)
	local timestamp = os.date("*t", os.time())
	local minutesfrom = os.difftime(os.time(), time) / 60
	local wholemins = math.floor(minutesfrom)
	--print("CHARACTERS:  wholemins: " .. wholemins)
	return wholemins
end

AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'showcharacterstable' then
        for id, char in pairs(CHARACTERS) do
            print("id: " .. id .. ", name: " .. char.getFullName())
        end
    elseif commandName:lower() == 'countcharacterstable' then
        print("# characters loaded: "  .. #CHARACTERS)
    elseif commandName:lower() == 'typeofcharacterstable' then
        print("type: " .. type(CHARACTERS))
    elseif commandName:lower() == 'showcharacter' then
        local id = tonumber(args[1])
        for k, v in pairs(CHARACTERS[id]) do
            print("key: " .. k)
        end
    end
end)

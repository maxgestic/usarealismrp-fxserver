local totalPlayerCount = 0
local publicPlayerCount = 0
local reservedPlayerCount = 0
local publicList = {}
local reservedList = {}
local reservedPlayers = {}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerLicense

    for i = 1, #playerIdentifiers do
        if string.find(playerIdentifiers[i], "license:") then
            playerLicense = playerIdentifiers[i]
            --print("license set for activated player: " .. playerLicense)
        end
    end

    for i = 1, #reservedPlayers do
        if string.find(playerLicense, reservedPlayers[i].identifier) then
            --print("reserved license for player was found!")
            if not reservedList[source] then
                totalPlayerCount = totalPlayerCount + 1
                reservedPlayerCount = reservedPlayerCount + 1
                reservedList[source] = true
                print("player loaded and was reserved...")
                print("totalPlayerCount = " .. totalPlayerCount)
                print("publicPlayerCount = " .. publicPlayerCount)
                print("reservedPlayerCount = " .. reservedPlayerCount)
                return
            end
        end
    end
    -- at this point, player is not reserved
    if not publicList[source] then
        totalPlayerCount = totalPlayerCount + 1
        publicPlayerCount = publicPlayerCount + 1
        publicList[source] = true
    end

    print("player loaded and was not reserved...")
    print("totalPlayerCount = " .. totalPlayerCount)
    print("publicPlayerCount = " .. publicPlayerCount)
    print("reservedPlayerCount = " .. reservedPlayerCount)
end)

AddEventHandler('playerDropped', function()
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerLicense

    for i = 1, #playerIdentifiers do
        if string.find(playerIdentifiers[i], "license:") then
            playerLicense = playerIdentifiers[i]
        end
    end

    for i = 1, #reservedPlayers do
        if string.find(playerLicense, reservedPlayers[i].identifier) then
            if reservedList[source] then
                totalPlayerCount = totalPlayerCount - 1
                reservedPlayerCount = reservedPlayerCount - 1
                reservedList[source] = nil
                return
            end
        end
    end
    -- at this point, player is not reserved
    if publicList[source] then
        totalPlayerCount = totalPlayerCount - 1
        publicPlayerCount = publicPlayerCount - 1
        publicList[source] = nil
    end
end)

AddEventHandler('playerConnecting', function(name, setReason)
    local MAX_PUBLIC_PLAYER_COUNT = 29
    local MAX_PLAYER_COUNT = 32
    print('Connecting: ' .. name)
    print("Player EP: " .. GetPlayerEP(source))
    print("totalPlayerCount = " .. totalPlayerCount)
    print("publicPlayerCount = " .. publicPlayerCount)
    print("reservedPlayerCount = " .. reservedPlayerCount)

    if totalPlayerCount >= MAX_PLAYER_COUNT then
        print("Sorry, " .. GetPlayerName(source) .. "! The server is full (at 32) :(")
        setReason("Sorry, " .. GetPlayerName(source) .. "! The server is full (at 32) :(")
        CancelEvent()
    end

    if publicPlayerCount >= MAX_PUBLIC_PLAYER_COUNT then
        if not playerHasReservedSlot(source) then
            print("Sorry, " .. GetPlayerName(source) .. "! All public slots taken :(")
            setReason("Sorry, " .. GetPlayerName(source) .. "! All public slots taken :(")
            CancelEvent()
        end
    end

end)

function playerHasReservedSlot(source)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local playerLicense

    for i = 1, #playerIdentifiers do
        if string.find(playerIdentifiers[i], "license:") then
            playerLicense = playerIdentifiers[i]
        end
    end

    for i = 1, #reservedPlayers do
        if string.find(playerLicense, reservedPlayers[i].identifier) then
            -- match found
            return true
        else
            --print("no match found.. compared:")
            --print(playerLicense.identifier)
            --print("and")
            --print(reservedPlayers[i])
        end
    end
    -- no match found
    return false
end

function fetchAllReserved()
	print("fetching all reserved players...")
	PerformHttpRequest("http://127.0.0.1:5984/reserved/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting reserved players...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			reservedPlayers = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all bans from 'bans' db into lua table
			for i = 1, #(response.rows) do
				table.insert(reservedPlayers, response.rows[i].doc)
			end
			print("finished loading reserved players...")
			print("# of reserved players: " .. #reservedPlayers)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

fetchAllReserved()

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "reserve" then
		local targetPlayerId = tonumber(args[1])
        if not targetPlayerId then
            RconPrint("Error! Usage: reserve [id]")
            CancelEvent()
            return
        end
        local targetPlayerName = GetPlayerName(targetPlayerId)
        local playerLicenses = GetPlayerIdentifiers(targetPlayerId)
        local playerGameLicense
        for i = 1, #playerLicenses do
            if string.find(playerLicenses[i], "license:") then
                playerGameLicense = playerLicenses[i]
            end
        end
        RconPrint("player " .. GetPlayerName(targetPlayerId) .. "added to reserved slot list!")
        TriggerEvent('es:exposeDBFunctions', function(GetDoc)
            -- update db
			GetDoc.createDocument("reserved",  {name = targetPlayerName, identifier = playerGameLicense, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				-- refresh table
				fetchAllReserved()
			end)
        end)
    end
end)

local pingLimit = 1500
local afkTokens = {}

RegisterServerEvent("afkping:kickMe")
AddEventHandler("afkping:kickMe", function()
	DropPlayer(source, "You have lost connection to the server. (Idling too long)")
end)

AddEventHandler('playerDropped', function()
	local _source = source
	for player, token in pairs(afkTokens) do
		if player == _source then
			afkTokens[_source] = nil
			print('AFK: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] has been removed from token table!')
		end
	end
end)


RegisterServerEvent("afkping:checkMyPing")
AddEventHandler("afkping:checkMyPing", function()
	local _source = source
	local playerPing = GetPlayerPing(_source)
	if playerPing >= pingLimit then
		print('PING: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] has been kicked for ping['..playerPing..']!')
		DropPlayer(_source, "You have lost connection to the server. (Please ensure you have a stable internet connection and rejoin)")
	end
end)

RegisterServerEvent('afkping:verifyIdle')
AddEventHandler('afkping:verifyIdle', function()
	local _source = source
	for player, token in pairs(afkTokens) do
		if _source == player then
			return
		end
	end
	local token = tostring(math.random(1000000, 9999999))
	afkTokens[_source] = token
	TriggerClientEvent('afkping:displayTokenMessage', _source, token)
	print('AFK: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] has been added to token table!')
end)

TriggerEvent('es:addCommand','token', function(source, args, user)
	local tokenGiven = args[2]
	local _source = source
	for player, token in pairs(afkTokens) do
		if tokenGiven == token and _source == player then
			TriggerClientEvent('afkping:resetTimer', _source)
			afkTokens[_source] = nil
			print('AFK: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] has passed token table verification!')
			return
		end
	end
end, {
	help = "Verify that you are not idle when prompted"
})

function randomString(length)

	local charset = {}  do -- [0-9a-zA-Z]
	    for c = 48, 57  do table.insert(charset, string.char(c)) end
	    for c = 65, 90  do table.insert(charset, string.char(c)) end
	end
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end
local recentDC = {}

RegisterServerEvent('playerlist:getPlayers')
AddEventHandler('playerlist:getPlayers', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_group = user.getGroup()
	exports["usa-characters"]:GetCharacters(function(characters)
		local playersToReturn = {}
		for id, char in pairs(characters) do
			local steamName = GetPlayerIdentifiers(id)[1]
			local ping = GetPlayerPing(id)
			data = {
				steam = steamName,
				ping = ping,
				id = id,
				fullname = char.getFullName(char),
				job = char.get('job')
			}
			if ping ~= 0 then
				table.insert(playersToReturn, data)
			end
		end
		TriggerClientEvent("playerlist:displayPlayerlist", source, playersToReturn, user_group)
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_group = user.getGroup()
	TriggerClientEvent("playerlist:setUserGroup", source, user_group)
end)

RegisterServerEvent("playerlist:addDC")
AddEventHandler("playerlist:addDC", function(char)
	print('PLAYERLIST: Adding player to recently disconnected list!')
	local usource = char.get("source")
	if char then
		recentDC[usource] = {char.getFullName(), GetPlayerIdentifier(usource)}
		Citizen.Wait(600000)
		recentDC[usource] = nil
	end
end)

TriggerEvent('es:addCommand', 'dcs', function(source, args, char)
	TriggerClientEvent('playerlist:dcList', source, recentDC)
end, {
	help = "View a list of recently disconnected players."
})

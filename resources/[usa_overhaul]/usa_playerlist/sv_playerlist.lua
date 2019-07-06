local recentDC = {}

RegisterServerEvent('playerlist:getPlayers')
AddEventHandler('playerlist:getPlayers', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_group = user.getGroup()
	exports["usa-characters"]:GetCharacters(function(characters)
		local playersToReturn = {}
		for id, char in pairs(characters) do
			local steamName = GetPlayerIdentifier(id)
			local ping = GetPlayerPing(id)
			data = {
				steam = GetPlayerIdentifier(id),
				ping = GetPlayerPing(id),
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

AddEventHandler('playerDropped', function()
	print('PLAYERLIST: Adding player to recently disconnected list!')
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
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

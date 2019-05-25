local recentDC = {}

RegisterServerEvent('playerlist:getPlayers')
AddEventHandler('playerlist:getPlayers', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_group = user.getGroup()
  	TriggerEvent("es:getPlayers", function(players)
	if players then
		local playersToReturn = {}
		for id, player in pairs(players) do
			if id and player then
				local steamName = GetPlayerIdentifier(id)
				local ping = GetPlayerPing(id)
				data = {
					steam = GetPlayerIdentifier(id),
					ping = GetPlayerPing(id), 
					id = id,
					fullname = GetFullName(player),
					job = player.getActiveCharacterData('job')
				}
				if ping ~= 0 then
					table.insert(playersToReturn, data)
				end
			end
		end
		TriggerClientEvent("playerlist:displayPlayerlist", userSource, playersToReturn, user_group)
	end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local user_group = user.getGroup()
	TriggerClientEvent("playerlist:setUserGroup", source, user_group)
end)

AddEventHandler('playerDropped', function()
	local _source = source
	print('PLAYERLIST: Adding player to recently disconnected list!')
	local user = exports["essentialmode"]:getPlayerFromId(_source)
	if user then
		recentDC[_source] = {GetFullName(user), GetPlayerIdentifier(_source)}
		Citizen.Wait(600000)
		recentDC[_source] = nil
	end
end)

TriggerEvent('es:addCommand', 'dcs', function(source, args, user)
	TriggerClientEvent('playerlist:dcList', source, recentDC)
end, {
	help = "View a list of recently disconnected players."
})


function GetFullName(player)
	local first_name = player.getActiveCharacterData("firstName")
	local middle_name = player.getActiveCharacterData("middleName")
	local last_name = player.getActiveCharacterData("lastName")
	local final_name = first_name
	if middle_name then
		if middle_name ~= " " and middle_name ~= "" then
			final_name = final_name .. " " .. middle_name
		end
	end
	if last_name then
		final_name = final_name .. " " .. last_name
	end
	return final_name
end
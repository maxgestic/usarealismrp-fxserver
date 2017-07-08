local characters = {}

RegisterServerEvent('loggedIn')
AddEventHandler('loggedIn', function()
	characters[GetHostId(source)] = "John Doe"
end)

RegisterServerEvent("getScoreboard")
AddEventHandler("getScoreboard", function(ptable)
	local players = {}
	for _, i in ipairs(ptable) do
		if characters[i] then
			table.insert(players, '<tr><td>' .. i .. '</td><td>' .. GetPlayerName(i) .. '</td><td>' .. GetPlayerPing(i) .. '<small>ms</small></td></tr>')
		else
			if type(GetPlayerName(i)) ~= nil and type(GetPlayerPing(i)) ~= nil then
				table.insert(players, '<tr><td>' .. i .. '</td><td>' .. GetPlayerName(i) .. '</td><td>' .. GetPlayerPing(i) .. '<small>ms</small></td></tr>')
			end
		end
	end
	TriggerClientEvent("scoreboard", source, table.concat(players))
end)

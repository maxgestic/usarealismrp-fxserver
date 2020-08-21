
RegisterCommand('coords1', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = "x = " .. coords.x .. ", y = " .. coords.y ..", z = " .. coords.z
	})
end)

RegisterCommand('coords2', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = "['x'] = " .. coords.x .. ", ['y'] = " .. coords.y ..", ['z'] = " .. coords.z
	})
end)

RegisterCommand('coords3', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = coords.x .. ", " .. coords.y ..", " .. coords.z
	})
end)

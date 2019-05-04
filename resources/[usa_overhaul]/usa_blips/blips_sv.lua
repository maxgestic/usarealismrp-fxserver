local blipstotoggle = {'Clothes', 'Barber', 'Store', 'CarWash', 'Tattoo', 'GunShop', 'BoatShop', 'PlaneShop', 'Fuel', 'BoatFuel', 'PlaneFuel', 'Movies', 'AutoRepair', 'Bank'}


TriggerEvent('es:addCommand','toggleblips', function(source, args, user)
	print("inside /toggleblips command!")
	local foundblip = false
	local playerSource = source
	for _, i in pairs(blipstotoggle) do
		if args[2] and string.lower(i) == string.lower(args[2]) then
			foundblip = true
			TriggerEvent('usaSettings:returnUserSettings', playerSource, function(settings)
				for k, v in pairs(settings.blips) do
					if k == string.lower(args[2]) then
						settings.blips[k] = not settings.blips[k]
						TriggerClientEvent('usa:notify', playerSource, i .. " blips have been toggled to ~y~" .. tostring(settings.blips[k]) .. '~s~.')
						TriggerClientEvent('blips:returnBlips', playerSource, settings.blips)
						TriggerEvent('usaSettings:updateUserSettings', playerSource, settings)
						return
					end
				end
			end)
		end
	end
	if not foundblip then
		TriggerClientEvent('chatMessage', playerSource, '^1^*[SERVER] ^r^7Usage: /toggleblips <type>')
		local blipsString = ''
		for _, k in pairs(blipstotoggle) do
			blipsString = k .. ' | ' .. blipsString
		end
		TriggerClientEvent('chatMessage', playerSource, '^1^*Types: ^r^7'..blipsString)
	end
end, {
	help = "Toggle blips on the map.",
	params = {
		{ name = "bliptype", help = "do /toggleblips for list" }
	}
})

RegisterServerEvent('blips:getBlips')
AddEventHandler('blips:getBlips', function()
	local playerSource = source
	TriggerEvent('usaSettings:returnUserSettings', playerSource, function(settings)
		TriggerClientEvent('blips:returnBlips', playerSource, settings.blips)
	end)
end)


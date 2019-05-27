RegisterServerEvent('visuals:checkVisuals')
AddEventHandler('visuals:checkVisuals', function()
	local _source = source
	TriggerEvent('usaSettings:returnUserSettings', _source, function(settings)
		if settings.serverVisuals then
			TriggerClientEvent('visuals:enableVisuals', _source)
		end
	end)
end)

TriggerEvent('es:addCommand', 'visuals', function(source, args, char)
	local _source = source
	local toggle = string.lower(args[2])
	TriggerEvent('usaSettings:returnUserSettings', _source, function(settings)
		if toggle == "on" then
			if settings.serverVisuals then
				TriggerClientEvent("usa:notify", _source, 'Server-sided visuals are already enabled!')
			else
				settings.serverVisuals = true
				TriggerEvent("usaSettings:updateUserSettings", _source, settings)
				TriggerClientEvent("usa:notify", _source, 'Enabling visuals in ~g~five seconds~s~, expect lag spike!')
				Citizen.Wait(5000)
				TriggerClientEvent('visuals:enableVisuals', _source)
			end
		elseif toggle == "off" then
			if settings.serverVisuals then
				settings.serverVisuals = false
				TriggerEvent("usaSettings:updateUserSettings", _source, settings)
				TriggerClientEvent("usa:notify", _source, 'Server-sided visuals are now ~r~disabled~s~, reconnect for changes!')
			else
				TriggerClientEvent("usa:notify", _source, 'Server-sided visuals are already disabled!')
			end
		else
			TriggerClientEvent("usa:notify", _source, "Usage: /visuals <on/off>")
		end
	end)
end, {
	help = "Enable or disable the server-sided visuals.",
	params = {
		{ name = "toggle", help = "on or off" }
	}
})

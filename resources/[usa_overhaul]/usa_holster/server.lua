-- hand on radio:
TriggerEvent('es:addJobCommand', 'r', { "police", "sheriff", "ems", "corrections" }, function(source, args, user)
	local playerSource = source
	if type(tonumber(args[2])) ~= "number" then TriggerClientEvent("usa:notify", "Invalid format!") end
	TriggerEvent('usaSettings:returnUserSettings', playerSource, function(settings)
		settings.radioHotkey = tonumber(args[2])
		TriggerEvent('usaSettings:updateUserSettings', playerSource, settings)
	end)
	TriggerClientEvent("ptt:returnHotkey", source, tonumber(args[2]))
end, {
	help = "Set your dispatch radio microphone control key." ,
	params = {
		{ name = "control", help = "See control reference key list" }
	}
})

RegisterServerEvent('ptt:getHotkey')
AddEventHandler('ptt:getHotkey', function()
	local playerSource = source
	TriggerEvent('usaSettings:returnUserSettings', playerSource, function(settings)
		TriggerClientEvent('ptt:returnHotkey', playerSource, settings.radioHotkey)
	end)
end)
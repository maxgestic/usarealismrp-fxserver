-- hand on radio:
TriggerEvent('es:addJobCommand', 'r', { "police", "sheriff", "ems" }, function(source, args, user)
	if type(tonumber(args[2])) ~= "number" then TriggerClientEvent("usa:notify", "Invalid format!") end
	TriggerClientEvent("ptt:radio", source, tonumber(args[2]))
end, {
	help = "Set your dispatch radio microphone control key." ,
	params = {
		{ name = "control", help = "See control reference key list" }
	}
})
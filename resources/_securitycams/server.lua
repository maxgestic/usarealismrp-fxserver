TriggerEvent('es:addJobCommand', 'camera', { 'sheriff', 'police' , 'judge', "corrections", "doctor"}, function(source, args, user)
	local cameraID = args[2]
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == "doctor" then
		if cameraID == "pillbox" or cameraID == "viceroy" or cameraID == "sandyhospital" then
			TriggerClientEvent('cameras:activateCamera', source, cameraID)
		else
			TriggerClientEvent("usa:notify", source, "You do not have access to that camera system!")
		end
	else
		TriggerClientEvent('cameras:activateCamera', source, cameraID)
	end
end, {
	help = "Activate a security camera",
	params = {
		{ name = "id", help = "Camera ID" }
	}
})

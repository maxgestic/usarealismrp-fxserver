TriggerEvent('es:addJobCommand', 'camera', { 'sheriff', 'police' , 'judge', "corrections"}, function(source, args, user)
	local cameraID = args[2]
	TriggerClientEvent('cameras:activateCamera', source, cameraID)
end, {
	help = "Activate a security camera",
	params = {
		{ name = "id", help = "Camera ID" }
	}
})

TriggerEvent('es:addJobCommand', 'camera', { 'sasp', 'police' , 'judge', "corrections", "bcso"}, function(source, args, user)
	local cameraID = args[2]
	TriggerClientEvent('cameras:activateCamera', source, cameraID)
end, {
	help = "Activate a security camera",
	params = {
		{ name = "id", help = "Camera ID" }
	}
})

RegisterNetEvent("license:failureNotJurisdiction")
AddEventHandler("license:failureNotJurisdiction", function()
	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Civilians are not allowed to use /mdt.")
end)

RegisterNetEvent("license:help")
AddEventHandler("license:help", function()
	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "example: /mdt <id>")
end)

RegisterNetEvent("license:notifyNoExist")
AddEventHandler("license:notifyNoExist", function(playerId)
	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "Player with id ^3" .. playerId .. "^0 does not exist.")
end)

RegisterNetEvent("mdt:vehicleInfo")
AddEventHandler("mdt:vehicleInfo", function(vehicle)
	if vehicle ~= nil then
		TriggerEvent("chatMessage", "", { 0, 141, 155 }, "^3Registered Vehicles:")
		TriggerEvent("chatMessage", "MODEL", { 0, 0, 0 }, vehicle.model)
		TriggerEvent("chatMessage", "PLATE", { 0, 0, 0 }, vehicle.plate)
	else
		TriggerEvent("chatMessage", "", { 0, 141, 155 }, "^0No registered vehicle on record.")
	end
end)

RegisterNetEvent("licenseCheck:notify")
AddEventHandler("licenseCheck:notify", function(message)
	DrawCoolLookingNotification(message)
end)

function DrawCoolLookingNotification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

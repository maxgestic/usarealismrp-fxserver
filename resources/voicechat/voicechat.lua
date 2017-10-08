local voip = {}
voip['off'] = {name = 'off', setting = 0.0}
voip['default'] = {name = 'default', setting = 10.0}
voip['local'] = {name = 'local', setting = 10.0}
voip['whisper'] = {name = 'whisper', setting = 2.0}
voip['yell'] = {name = 'yell', setting = 25.0}
setDistance = voip['default'].setting

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('voip')
AddEventHandler('voip', function(voipDistance)
	if voip[voipDistance] then
		distanceName = voip[voipDistance].name
		distanceSetting = voip[voipDistance].setting
	else
		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
	end

	NotificationMessage("Your VOIP is now ~b~" .. distanceName .."~w~.")
	NetworkSetTalkerProximity(distanceSetting)
	setDistance = distanceSetting
	
	TriggerEvent("test:setCSharpVoipLevel", distanceSetting)
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

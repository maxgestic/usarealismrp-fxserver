local voip = {}
voip['off'] = {name = 'off', setting = 0.0}
voip['default'] = {name = 'default', setting = 8.5}
voip['local'] = {name = 'local', setting = 8.5}
voip['whisper'] = {name = 'whisper', setting = 2.0}
voip['yell'] = {name = 'yell', setting = 23.0}
setDistance = voip['default'].setting
local distanceName = "default"
local distanceSetting = 0

local voip_toggle_key = 289 -- 38 = "E", 289 = "F2"

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

	print("setting interaction menu voip display: " .. distanceSetting)
	TriggerEvent("interaction:setF1VoipLevel", distanceSetting)
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if GetLastInputMethod(2) then -- check for keyboard use only
			if IsControlJustPressed(1,voip_toggle_key) then
				print("distanceName is: " .. distanceName)
				if distanceName == "whisper" then
					TriggerEvent("voip", "default")
				elseif distanceName == "default" then
					TriggerEvent("voip", "yell")
				elseif distanceName == "yell" then
					TriggerEvent("voip", "whisper")
				end
			end
		end
	end
end)

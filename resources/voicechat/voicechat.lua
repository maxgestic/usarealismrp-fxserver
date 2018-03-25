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

local r,g,b
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		-- toggle voip range with hotkey --
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
		-- voip range HUD display color --
		for id = 0, 64 do 
			if NetworkIsPlayerActive(id) and GetPlayerPed(-1) == GetPlayerPed(id) then
				if NetworkIsPlayerTalking(id) then
					r = 57
					g = 176
					b = 132
				else 
					r = 224
					g = 227
					b = 218
				end
				-- draw voip range HUD display --
				if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
					drawTxt(0.66, 1.665, 1.0, 1.5, 0.4, "R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
				else
					drawTxt(0.66, 1.69, 1.0, 1.5, 0.4, "R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
				end
			end
		end
		-- draw voip range HUD display --
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			drawTxt(0.66, 1.665, 1.0, 1.5, 0.4, "R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
		else
			drawTxt(0.66, 1.69, 1.0, 1.5, 0.4, "R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
		end
	end
end)

function GetDisplayName(name)
	local names = {
		["default"] = "Normal",
		["yell"] = "Yell",
		["whisper"] = "Whisper"
	}
	return names[name]
end

-------------------
-- HUD FUNCTIONS --
-------------------
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(6)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end
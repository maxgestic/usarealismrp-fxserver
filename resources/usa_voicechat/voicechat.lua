local SETTINGS = {
	TALKING_CIRCLE_ENABLED = true
}

local voip = {}
voip['off'] = {name = 'off', setting = 0.0}
voip['default'] = {name = 'default', setting = 8.5}
voip['local'] = {name = 'local', setting = 8.5}
voip['whisper'] = {name = 'whisper', setting = 2.0}
voip['yell'] = {name = 'yell', setting = 23.0}
setDistance = voip['default'].setting
local distanceName = "default"
local distanceSetting = 0
local displayText = true

local voip_toggle_key = 289 -- 38 = "E", 289 = "F2"

AddEventHandler('onClientMapStart', function()
	NetworkSetVoiceActive(true)
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('voip:toggleTalkingCircle')
AddEventHandler('voip:toggleTalkingCircle', function()
	SETTINGS.TALKING_CIRCLE_ENABLED = not SETTINGS.TALKING_CIRCLE_ENABLED
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

	NetworkSetTalkerProximity(distanceSetting)
	setDistance = distanceSetting

	print("setting interaction menu voip display: " .. distanceSetting)
	TriggerEvent("interaction:setF1VoipLevel", distanceSetting)
end)

AddEventHandler('usa:toggleImmersion', function(toggleOn)
	displayText = toggleOn
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

function DrawTalkingCircle(ped)
	if GetPlayerPed(-1) ~= ped then
		local x, y, z = table.unpack(GetEntityCoords(ped, true))
		DrawMarker(27, x, y, z - 0.96, 0, 0, 0, 0, 0, 0, 0.71, 0.71, 0.71, 57 --[[r]], 176 --[[g]], 132 --[[b]], 90 --[[alpha]], 0, 0, 2, 0, 0, 0, 0)
	end
end

local color
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		-- toggle voip range with hotkey --
		if GetLastInputMethod(0) then -- check for keyboard use only
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
		for id = 0, 255 do
			if NetworkIsPlayerActive(id) then
				----------------------------
				-- talking cirlce at feet --
				----------------------------
				if SETTINGS.TALKING_CIRCLE_ENABLED then
					if NetworkIsPlayerTalking(id) then
						DrawTalkingCircle(GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(id))))
					end
				end
				-----------------------------
				-- talking notifier on HUD --
				-----------------------------
				if GetPlayerPed(-1) == GetPlayerPed(id) and displayText then
					if NetworkIsPlayerTalking(id) then
						color = '~g~'
					else
						color = '~w~'
					end
					-- draw voip range HUD display --
					local playerPed = PlayerPedId()
					local playerVeh = GetVehiclePedIsIn(playerPed, true)
					if IsPedInAnyVehicle(playerPed, false) and (GetPedInVehicleSeat(playerVeh, -1) == playerPed or GetPedInVehicleSeat(playerVeh, 0) == playerPed) and GetVehicleClass(playerVeh) ~= 13 and GetVehicleClass(playerVeh) ~= 21 then
						drawTxt(0.703, 1.395, 1.0, 1.0, 0.40, color.."R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
					else
						drawTxt(0.703, 1.455, 1.0, 1.0, 0.40, color.."R: " .. GetDisplayName(distanceName), r, g, b, 255) -- voip range
					end
				end
			end
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

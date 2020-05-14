local minutesUntilKick = 35
local minutesUntilWarning = 3
local warningGiven = false
local timer

Citizen.CreateThread(function()
	timer = minutesUntilKick
	while true do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, true)
		if Vdist(playerCoords, prevPos) < 5 or warningGiven then
			if timer > 0 then
				timer = timer - 1
				if timer <= minutesUntilWarning and not warningGiven then
					TriggerServerEvent('afkping:verifyIdle')
				end
				--print(timer)
			else
				TriggerServerEvent("afkping:kickMe")
			end
		else
			timer = minutesUntilKick
		end

		prevPos = playerCoords
		Wait(60000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		TriggerServerEvent("afkping:checkMyPing")
	end
end)

RegisterNetEvent('afkping:displayTokenMessage')
AddEventHandler('afkping:displayTokenMessage', function(token)
	warningGiven = true
	local beginTime = GetGameTimer()
	PlaySoundFrontend(-1, 'FocusIn', 'HintCamSounds', 1)
	while timer <= minutesUntilWarning do
		Citizen.Wait(0)
		DrawRect(0.5, 0.0, 1.0, 0.2, 0, 0, 0, 255)
		DrawTxt(0.85, 0.50, 1.0, 1.0, 0.60, 'You will be disconnected in '..timer..' minutes for idling too long!', 255, 255, 255, 255)
		DrawTxt(0.95, 0.54, 1.0, 1.0, 0.60, 'Type /token ' .. token .. " to cancel.", 255, 255, 255, 255)
	end
end)

RegisterNetEvent('afkping:resetTimer')
AddEventHandler('afkping:resetTimer', function()
	PlaySoundFrontend(-1, 'FocusIn', 'HintCamSounds', 1)
	warningGiven = false
	timer = minutesUntilKick
end)

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

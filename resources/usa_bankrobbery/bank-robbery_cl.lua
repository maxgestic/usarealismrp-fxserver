local bankCoords = {
	{x = 252.95, y = 228.60, z = 102.00}, -- pacific standard
	{x = -105.36250305176,y = 6471.91796875, z = 31.626722335815}, -- paleto
	{x = 1176.3208007813,y = 2712.5603027344, z = 38.088005065918}, -- harmony fleeca
	{x = 146.84455871582,y = -1045.71875, z = 29.368036270142} -- legion fleeca
}
local clerkCoords = {x = 253.57, y = 221.05, z = 106.28}

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		-- draw 3d text --
		for i = 1, #bankCoords do
			if Vdist(playerCoords, bankCoords[i].x, bankCoords[i].y, bankCoords[i].z) < 5.0 then
				DrawText3D(bankCoords[i].x, bankCoords[i].y, bankCoords[i].z, '[HOLD K] - Rob Bank')
			end
		end
		if Vdist(playerCoords, clerkCoords.x, clerkCoords.y, clerkCoords.z) < 5.0 then
			DrawText3D(clerkCoords.x, clerkCoords.y, clerkCoords.z, '[E] - Bank Clerk')
		end
		-- rob / clerk tip --
		for i = 1, #bankCoords do
			if IsControlJustPressed(0, 311) and Vdist(playerCoords, bankCoords[i].x, bankCoords[i].y, bankCoords[i].z) < 2.0 then
				Wait(500)
				if IsControlPressed(0, 311) then
					TriggerServerEvent('bank:beginRobbery')
				end
			end
		end
		if IsControlJustPressed(0, 38) and Vdist(playerCoords, clerkCoords.x, clerkCoords.y, clerkCoords.z) < 2.0 then
			TriggerServerEvent('bank:clerkTip')
		end
		Wait(0)
	end
end)

---------------
-- mini game --
---------------
RegisterNetEvent("bank:startHacking")
AddEventHandler("bank:startHacking", function()
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(playerPed))
	local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
	local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
	TriggerServerEvent("911:BankRobbery", x, y, z, lastStreetNAME, IsPedMale(playerPed))
	TriggerEvent("usa:playScenario", "WORLD_HUMAN_STAND_MOBILE")
	local beginTime = GetGameTimer()
	while GetGameTimer() - beginTime < 60000 do
		Citizen.Wait(0)
		x, y, z = table.unpack(GetEntityCoords(playerPed))
		DrawTimer(beginTime, 60000, 1.42, 1.475, 'TAPPING')
		if Vdist(x, y, z, bankCoords.x, bankCoords.y, bankCoords.z) > 5.0 then
			TriggerEvent('usa:notify', 'You went too far away, signal lost!')
			return
		end
	end
	TriggerEvent("mhacking:seqstart", {4, 3, 2, 1}, 70, mycb)
end)

local failed  = false
function mycb(success, timeremaining, finish)
	ClearPedTasks(playerPed)
	if success then
		print('Success with '..timeremaining..'s remaining.')
		if finish then
			if not failed then
				local playerPed = PlayerPedId()
				if Vdist(GetEntityCoords(playerPed), bankCoords.x, bankCoords.y, bankCoords.z) < 3.0 then
					TriggerServerEvent('bank:hackComplete')
					TriggerEvent("usa:notify", "You successfully hacked the firewall!")
				else
					TriggerEvent('usa:notify', 'You went out of range!')
				end
			else
				TriggerEvent("usa:notify", "You failed to hacked the firewall!")
			end
		end
	else
		failed = true
		print('Failure to win hacking game!')
		TriggerEvent("usa:notify", "You failed to hacked the firewall!")
	end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end
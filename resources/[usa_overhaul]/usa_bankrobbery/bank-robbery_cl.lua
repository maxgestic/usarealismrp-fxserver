local bankCoords = {x = 254.05, y = 225.14, z = 101.87}
local clerkCoords = {x = 253.57, y = 221.05, z = 106.28}
local peds = {
	{x = 254.52, y = 222.29, z = 105.28, heading = 137.52, hash = GetHashKey('csb_reporter'), task = 'WORLD_HUMAN_CLIPBOARD'},
	{x = 248.37, y = 224.55, z = 105.28, heading = 186.0, hash = GetHashKey('g_m_y_korlieut_01'), task = 'WORLD_HUMAN_BUM_STANDING'},
	{x = 244.21, y = 226.05, z = 105.28, heading = 134.90, hash = GetHashKey('ig_bankman'), task = 'WORLD_HUMAN_GUARD_STAND'},
	{x = 239.53, y = 213.99, z = 105.28, heading = 159.0, hash = GetHashKey('ig_joeminuteman'), task = 'WORLD_HUMAN_LEANING'},
	{x = 238.31, y = 227.03, z = 105.28, heading = 135.0, hash = GetHashKey('ig_paper'), task = 'WORLD_HUMAN_DRINKING'},
	{x = 243.13, y = 224.60, z = 105.28, heading = 341.0, hash = GetHashKey('ig_ramp_hipster'), task = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT'},
	{x = 246.54, y = 214.21, z = 105.28, heading = 22.81, hash = GetHashKey('ig_screen_writer'), task = 'WORLD_HUMAN_STAND_MOBILE'},
	{x = 248.40, y = 222.67, z = 105.28, heading = 338.0, hash = GetHashKey('s_m_m_cntrybar_01'), task = 'WORLD_HUMAN_STAND_IMPATIENT'},
	{x = 247.99, y = 221.42, z = 105.28, heading = 339.0, hash = GetHashKey('s_m_m_hairdress_01'), task = 'WORLD_HUMAN_GUARD_STAND﻿'},
	{x = 233.35, y = 220.29, z = 109.28, heading = 18.16, hash = GetHashKey('ig_barry'), task = 'WORLD_HUMAN_CLIPBOARD'},
	{x = 243.74, y = 210.34, z = 109.28, heading = 153.16, hash = GetHashKey('u_m_m_bankman'), task = 'WORLD_HUMAN_DRINKING'},
	{x = 236.92, y = 218.87, z = 105.28, heading = 294.0, hash = GetHashKey('u_f_y_mistress'), task = 'PROP_HUMAN_ATM'}

}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		if Vdist(playerCoords, bankCoords.x, bankCoords.y, bankCoords.z) < 5.0 then
			DrawText3D(bankCoords.x, bankCoords.y, bankCoords.z, '[HOLD K] - Rob Bank')
		elseif Vdist(playerCoords, clerkCoords.x, clerkCoords.y, clerkCoords.z) < 5.0 then
			DrawText3D(clerkCoords.x, clerkCoords.y, clerkCoords.z, '[E] - Bank Clerk')
		end
		if IsControlJustPressed(0, 311) and Vdist(playerCoords, bankCoords.x, bankCoords.y, bankCoords.z) < 2.0 then
			Citizen.Wait(500)
			if IsControlPressed(0, 311) then
				TriggerServerEvent('bank:beginRobbery')
			end
		end
		if IsControlJustPressed(0, 38) and Vdist(playerCoords, clerkCoords.x, clerkCoords.y, clerkCoords.z) < 2.0 then
			TriggerServerEvent('bank:clerkTip')
		end
	end
end)

Citizen.CreateThread(function()
	for i = 1, #peds do
		RequestModel(peds[i].hash)
		while not HasModelLoaded(peds[i].hash) do
			Citizen.Wait(100)
		end
		local ped = CreatePed(4, peds[i].hash, peds[i].x, peds[i].y, peds[i].z, peds[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		SetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, peds[i].task, 0, true);
	end
end)

---------------
-- mini game --
---------------
RegisterNetEvent("bank:startHacking")
AddEventHandler("bank:startHacking", function()
	print("inside startHacking event handler!")
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
		DrawTimer(beginTime, 30000, 1.42, 1.475, 'TAPPING')
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
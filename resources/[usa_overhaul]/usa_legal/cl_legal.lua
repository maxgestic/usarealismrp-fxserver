local legal_blips = {
	{x = 233.29, y = -410.34, z = 48.11, sprite = 475, scale = 0.7, color = 9, label = 'Legal Offices'},
	{x = -70.75, y = -801.20, z = 44.22, sprite = 475, scale = 0.7, color = 60, label = 'DA Office'}
}

local legal_peds = {
	{x = -72.03, y = -814.49, z = 242.38, heading = 160.0, hash = GetHashKey('ig_bankman'), task = 'WORLD_HUMAN_CLIPBOARD'},
	{x = -61.91, y = -818.21, z = 242.38, heading = 135.0, hash = GetHashKey('csb_reporter'), task = 'WORLD_HUMAN_DRINKING'},
	{x = -72.43, y = -820.04, z = 242.38, heading = 64.0, hash = GetHashKey('s_m_m_security_01'), task = 'WORLD_HUMAN_LEANING'},
}

Citizen.CreateThread(function()
	EnumerateBlips()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		DrawText3D(233.29, -410.34, 48.11, 5, '[E] - Legal Offices')
		DrawText3D(146.75, -738.35, 242.30, 5, '[E] - Exit')
		DrawText3D(154.40, -742.87, 242.15, 5, '[E] - On/Off Duty (~g~Lawyer~s~)')
		DrawText3D(-79.87, -801.90, 243.41, 3, '[E] - MDT')
		if IsControlJustPressed(0, 38, true) then -- E
			local playerCoords = GetEntityCoords(playerPed)
			if Vdist(playerCoords, 233.29, -410.34, 48.11) < 2 then -- courthouse to legal offices
				DoorTransition(playerPed, 147.25, -738.05, 242.15, 250.0)
			elseif Vdist(playerCoords, 147.25, -738.05, 242.15) < 2 then -- legal offices to courthouse
				DoorTransition(playerPed, 233.39, -410.34, 48.11, 335.0)
			elseif Vdist(playerCoords, 154.40, -742.87, 242.15) < 2 then
				TriggerServerEvent('legal:checkBarCertificate')
			elseif Vdist(playerCoords, -79.87, -801.90, 244.21) < 1.6 then
				TriggerServerEvent('legal:openMDT')
			end
		end
	end
end)

RegisterNetEvent('lawyer:checkDistanceForPayment')
AddEventHandler('laywer:checkDistanceForPayment', function(targetSource, targetAmount)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSource))
	if Vdist(GetEntityCoords(playerPed), GetEntityCoords(targetPed)) < 5.0 then
		TriggerServerEvent('lawyer:payLawyer', targetSource, targetAmount)
	else
		TriggerEvent('usa:notify', 'You are too far away!')
	end
end)

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	    SetTextScale(0.35, 0.35)
	    SetTextFont(4)
	    SetTextProportional(1)
	    SetTextColour(255, 255, 255, 215)
	    SetTextEntry("STRING")
	    SetTextCentre(1)
	    AddTextComponentString(text)
	    DrawText(_x,_y)
	    local factor = (string.len(text)) / 370
	    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
	end
end

function PlayDoorAnimation()
    while ( not HasAnimDictLoaded( 'anim@mp_player_intmenu@key_fob@' ) ) do
        RequestAnimDict( 'anim@mp_player_intmenu@key_fob@' )
        Citizen.Wait( 0 )
	end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, -1, 48)
end

function DoorTransition(playerPed, x, y, z, heading)
	PlayDoorAnimation()
	DoScreenFadeOut(500)
	Wait(500)
	RequestCollisionAtCoord(x, y, z)
	SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true)
	SetEntityHeading(playerPed, heading)
	while not HasCollisionLoadedAroundEntity(playerPed) do
	    Citizen.Wait(100)
	    SetEntityCoords(playerPed, x, y, z, 1, 0, 0, 1)
	end
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.5)
	Wait(2000)
	DoScreenFadeIn(500)
end

function EnumerateBlips()
	for i = 1, #legal_blips do
		local blip = legal_blips[i]
		local handle = AddBlipForCoord(blip.x, blip.y, blip.z)
		SetBlipSprite(handle, blip.sprite)
		SetBlipDisplay(handle, 4)
		SetBlipScale(handle, blip.scale)
		SetBlipColour(handle, blip.color)
		SetBlipAsShortRange(handle, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blip.label)
		EndTextCommandSetBlipName(handle)
	end
end

Citizen.CreateThread(function()
	for i = 1, #legal_peds do
		local ped = legal_peds[i]
		RequestModel(ped.hash)
		while not HasModelLoaded(ped.hash) do
			Citizen.Wait(100)
		end
		local handle = CreatePed(4, ped.hash, ped.x, ped.y, ped.z, ped.heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(handle, false)
		SetPedCanRagdollFromPlayerImpact(handle, false)
		SetBlockingOfNonTemporaryEvents(handle, true)
		SetPedFleeAttributes(handle, 0, 0)
		SetPedCombatAttributes(handle, 17, 1)
		SetPedRandomComponentVariation(handle, true)
		TaskStartScenarioInPlace(handle, ped.task, 0, true);
	end
end)

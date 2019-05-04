local inMorgued = false

local morgueTeleportLocations = {
		{x = 262.46, y = -1340.29, z = 24.00, heading = 141.40},
		{x = 260.16, y = -1347.09, z = 24.00, heading = 46.03},
		{x = 256.54, y = -1343.84, z = 24.00, heading = 235.04},
		{x = 256.07, y = -1352.21, z = 24.00, heading = 44.85},
		{x = 251.73, y = -1348.86, z = 24.00, heading = 230.00},
		{x = 249.28, y = -1355.49, z = 24.00, heading = 316.11}
	}

RegisterNetEvent('morgue:toeTag')
AddEventHandler('morgue:toeTag', function()
	local index = math.random(1, #morgueTeleportLocations)
	DoScreenFadeOut(500)
    Citizen.Wait(500)
    -- admit
    playerPed = PlayerPedId()
    RequestCollisionAtCoord(morgueTeleportLocations[index].x, morgueTeleportLocations[index].y, morgueTeleportLocations[index].z)
    Wait(1000)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'zip-close', 0.3)
    SetEntityCoords(playerPed, morgueTeleportLocations[index].x, morgueTeleportLocations[index].y, morgueTeleportLocations[index].z, morgueTeleportLocations[index].heading, 0, 0, 1) -- tp to morgue
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Citizen.Wait(100)
        SetEntityCoords(playerPed, morgueTeleportLocations[index].x, morgueTeleportLocations[index].y, morgueTeleportLocations[index].z, morgueTeleportLocations[index].heading, 0, 0, 1) -- tp to hospital
    end
    Citizen.Wait(3000)
    DoScreenFadeIn(500)
    -- remove any blindfolds/tied hands
    TriggerEvent("crim:untieHands", GetPlayerServerId(PlayerId()))
    TriggerEvent("crim:blindfold", false, true)
    isMorgued = true
end)

RegisterNetEvent('morgue:release')
AddEventHandler('morgue:release', function()
	isMorgued = false
	DoScreenFadeOut(500)
	Citizen.Wait(500)
    -- admit
    playerPed = GetPlayerPed(-1)
    FreezeEntityPosition(playerPed, false)
    RequestCollisionAtCoord(240.74, -1379.803, 33.74)
    Wait(1000)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'door-shut', 0.3)
    SetEntityCoords(playerPed, 240.74, -1379.803, 33.74, 138.0, 0, 0, 1) -- tp to exit morgue
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Citizen.Wait(100)
        SetEntityCoords(playerPed, 240.74, -1379.803, 33.74, 138.0, 0, 0, 1) -- tp to exit morgue
    end
    Citizen.Wait(3000)
    DoScreenFadeIn(500)
    TriggerEvent('usa:notify', 'You have been ~y~released~s~ from the morgue.')
end)

FreezeEntityPosition(PlayerPedId(), false)
DoScreenFadeIn()

Citizen.CreateThread(function()

	while true do
		Wait(0)

		local playerPed = PlayerPedId()
		if (isMorgued) then
			ShowHelp('You have been sent to the morgue, and can no longer play on this character.', true)
			FreezeEntityPosition(playerPed, true) -- freeze player in place while in morgue
			DisableControlAction(0, 288, true) -- phone
			DisableControlAction(0, 244, true) -- interaction menu
			DisableControlAction(0, 301, true) -- interaction menu
			DisableControlAction(0, 249, true) -- talking
			DisableControlAction(0, 306, true) -- talking
		end
	end
end)

function ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end
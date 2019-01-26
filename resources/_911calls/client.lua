local colorNames = {
    ['0'] = "Metallic Black",
    ['1'] = "Metallic Graphite Black",
    ['2'] = "Metallic Black Steel",
    ['3'] = "Metallic Dark Silver",
    ['4'] = "Metallic Silver",
    ['5'] = "Metallic Blue Silver",
    ['6'] = "Metallic Steel Gray",
    ['7'] = "Metallic Shadow Silver",
    ['8'] = "Metallic Stone Silver",
    ['9'] = "Metallic Midnight Silver",
    ['10'] = "Metallic Gun Metal",
    ['11'] = "Metallic Anthracite Grey",
    ['12'] = "Matte Black",
    ['13'] = "Matte Gray",
    ['14'] = "Matte Light Grey",
    ['15'] = "Util Black",
    ['16'] = "Util Black Poly",
    ['17'] = "Util Dark silver",
    ['18'] = "Util Silver",
    ['19'] = "Util Gun Metal",
    ['20'] = "Util Shadow Silver",
    ['21'] = "Worn Black",
    ['22'] = "Worn Graphite",
    ['23'] = "Worn Silver Grey",
    ['24'] = "Worn Silver",
    ['25'] = "Worn Blue Silver",
    ['26'] = "Worn Shadow Silver",
    ['27'] = "Metallic Red",
    ['28'] = "Metallic Torino Red",
    ['29'] = "Metallic Formula Red",
    ['30'] = "Metallic Blaze Red",
    ['31'] = "Metallic Graceful Red",
    ['32'] = "Metallic Garnet Red",
    ['33'] = "Metallic Desert Red",
    ['34'] = "Metallic Cabernet Red",
    ['35'] = "Metallic Candy Red",
    ['36'] = "Metallic Sunrise Orange",
    ['37'] = "Metallic Classic Gold",
    ['38'] = "Metallic Orange",
    ['39'] = "Matte Red",
    ['40'] = "Matte Dark Red",
    ['41'] = "Matte Orange",
    ['42'] = "Matte Yellow",
    ['43'] = "Util Red",
    ['44'] = "Util Bright Red",
    ['45'] = "Util Garnet Red",
    ['46'] = "Worn Red",
    ['47'] = "Worn Golden Red",
    ['48'] = "Worn Dark Red",
    ['49'] = "Metallic Dark Green",
    ['50'] = "Metallic Racing Green",
    ['51'] = "Metallic Sea Green",
    ['52'] = "Metallic Olive Green",
    ['53'] = "Metallic Green",
    ['54'] = "Metallic Gasoline Blue Green",
    ['55'] = "Matte Lime Green",
    ['56'] = "Util Dark Green",
    ['57'] = "Util Green",
    ['58'] = "Worn Dark Green",
    ['59'] = "Worn Green",
    ['60'] = "Worn Sea Wash",
    ['61'] = "Metallic Midnight Blue",
    ['62'] = "Metallic Dark Blue",
    ['63'] = "Metallic Saxony Blue",
    ['64'] = "Metallic Blue",
    ['65'] = "Metallic Mariner Blue",
    ['66'] = "Metallic Harbor Blue",
    ['67'] = "Metallic Diamond Blue",
    ['68'] = "Metallic Surf Blue",
    ['69'] = "Metallic Nautical Blue",
    ['70'] = "Metallic Bright Blue",
    ['71'] = "Metallic Purple Blue",
    ['72'] = "Metallic Spinnaker Blue",
    ['73'] = "Metallic Ultra Blue",
    ['74'] = "Metallic Bright Blue",
    ['75'] = "Util Dark Blue",
    ['76'] = "Util Midnight Blue",
    ['77'] = "Util Blue",
    ['78'] = "Util Sea Foam Blue",
    ['79'] = "Uil Lightning blue",
    ['80'] = "Util Maui Blue Poly",
    ['81'] = "Util Bright Blue",
    ['82'] = "Matte Dark Blue",
    ['83'] = "Matte Blue",
    ['84'] = "Matte Midnight Blue",
    ['85'] = "Worn Dark blue",
    ['86'] = "Worn Blue",
    ['87'] = "Worn Light blue",
    ['88'] = "Metallic Taxi Yellow",
    ['89'] = "Metallic Race Yellow",
    ['90'] = "Metallic Bronze",
    ['91'] = "Metallic Yellow Bird",
    ['92'] = "Metallic Lime",
    ['93'] = "Metallic Champagne",
    ['94'] = "Metallic Pueblo Beige",
    ['95'] = "Metallic Dark Ivory",
    ['96'] = "Metallic Choco Brown",
    ['97'] = "Metallic Golden Brown",
    ['98'] = "Metallic Light Brown",
    ['99'] = "Metallic Straw Beige",
    ['100'] = "Metallic Moss Brown",
    ['101'] = "Metallic Biston Brown",
    ['102'] = "Metallic Beechwood",
    ['103'] = "Metallic Dark Beechwood",
    ['104'] = "Metallic Choco Orange",
    ['105'] = "Metallic Beach Sand",
    ['106'] = "Metallic Sun Bleeched Sand",
    ['107'] = "Metallic Cream",
    ['108'] = "Util Brown",
    ['109'] = "Util Medium Brown",
    ['110'] = "Util Light Brown",
    ['111'] = "Metallic White",
    ['112'] = "Metallic Frost White",
    ['113'] = "Worn Honey Beige",
    ['114'] = "Worn Brown",
    ['115'] = "Worn Dark Brown",
    ['116'] = "Worn straw beige",
    ['117'] = "Brushed Steel",
    ['118'] = "Brushed Black Steel",
    ['119'] = "Brushed Aluminium",
    ['120'] = "Chrome",
    ['121'] = "Worn Off White",
    ['122'] = "Util Off White",
    ['123'] = "Worn Orange",
    ['124'] = "Worn Light Orange",
    ['125'] = "Metallic Securicor Green",
    ['126'] = "Worn Taxi Yellow",
    ['127'] = "Police Car Blue",
    ['128'] = "Matte Green",
    ['129'] = "Matte Brown",
    ['130'] = "Worn Orange",
    ['131'] = "Matte White",
    ['132'] = "Worn White",
    ['133'] = "Worn Olive Army Green",
    ['134'] = "Pure White",
    ['135'] = "Hot Pink",
    ['136'] = "Salmon pink",
    ['137'] = "Metallic Vermillion Pink",
    ['138'] = "Orange",
    ['139'] = "Green",
    ['140'] = "Blue",
    ['141'] = "Mettalic Black Blue",
    ['142'] = "Metallic Black Purple",
    ['143'] = "Metallic Black Red",
    ['144'] = "hunter green",
    ['145'] = "Metallic Purple",
    ['146'] = "Metallic Dark Blue",
    ['147'] = "Black",
    ['148'] = "Matte Purple",
    ['149'] = "Matte Dark Purple",
    ['150'] = "Metallic Lava Red",
    ['151'] = "Matte Forest Green",
    ['152'] = "Matte Olive Drab",
    ['153'] = "Matte Desert Brown",
    ['154'] = "Matte Desert Tan",
    ['155'] = "Matte Foilage Green",
    ['156'] = "Default Alloy Color",
    ['157'] = "Epsilon Blue",
}

local mute911 = false
local ReportAssault = false
local ReportShotsFired = true
local ReportCarjacking = true
local ReportAttemptedVehicleTheft = true
local ReportPersonWithAGun = false
local ReportPersonWithAKnife = false
local ReportRecklessDriving = true
local ReportVehicleTheft = true
local ReportExplosion = true
local ReportMVA = false
local oldBodyDamage = 0
local oldSpeed = 0
local onDuty = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local currentDamage = GetVehicleBodyHealth(vehicle)
		if not onDuty then
			if ReportShotsFired and IsPedShooting(ped) and GetSelectedPedWeapon(me) ~= 101631238 and GetSelectedPedWeapon(me) ~= 911657153 and GetSelectedPedWeapon(me) ~= 883325847 and GetSelectedPedWeapon(me) ~= GetHashKey("WEAPON_SNOWBALL") then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				area = GetNameOfZone(x, y, z)
				TriggerServerEvent('911:ShotsFired', x, y, z, lastStreetNAME, area, IsPedMale(ped))
				Citizen.Wait(500)
			elseif ReportAttemptedVehicleTheft and IsPedTryingToEnterALockedVehicle(ped) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				local primary, secondary = GetVehicleColours(GetVehiclePedIsTryingToEnter(ped))
				primary = colorNames[tostring(primary)]
				secondary = colorNames[tostring(secondary)]
				TriggerServerEvent('911:AttemptedVehicleTheft', x, y, z, lastStreetNAME, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsTryingToEnter(ped)))), GetVehicleNumberPlateText(GetVehiclePedIsTryingToEnter(ped)), IsPedMale(ped), primary, secondary)
				Citizen.Wait(500)
			elseif ReportCarjacking and IsPedJacking(ped) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				local primary, secondary = GetVehicleColours(GetVehiclePedIsUsing(ped))
				primary = colorNames[tostring(primary)]
				secondary = colorNames[tostring(secondary)]
				TriggerServerEvent('911:Carjacking', x, y, z, lastStreetNAME, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(ped)))), GetVehicleNumberPlateText(GetVehiclePedIsUsing(ped)), IsPedMale(ped), primary, secondary)
				Citizen.Wait(500)
			elseif ReportPersonWithAGun and IsPedArmed(ped, 6) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				area = GetNameOfZone(x, y, z)
				TriggerServerEvent('911:PersonWithAGun', x, y, z, lastStreetNAME, area, IsPedMale(ped))
				Citizen.Wait(500)
			elseif ReportPersonWithAKnife and IsPedArmed(ped, 1) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				if (GetSelectedPedWeapon(ped) == -1716189206 or GetSelectedPedWeapon(ped) == -1834847097 or GetSelectedPedWeapon(ped) == -581044007 or GetSelectedPedWeapon(ped) == -538741184) then
					TriggerServerEvent('911:PersonWithAKnife', x, y, z, lastStreetNAME, IsPedMale(ped))
					Citizen.Wait(500)
				end
			elseif ReportAssault and IsPedInMeleeCombat(ped) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				TriggerServerEvent('911:AssaultInProgress', x, y, z, lastStreetNAME, IsPedMale(ped))
				Citizen.Wait(500)
			elseif ReportRecklessDriving and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped and GetEntitySpeed(GetVehiclePedIsIn(ped))*2.236936 > 120 and IsAreaPopulated() and GetVehicleClass(vehicle) ~= 14 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 19 then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				local primary, secondary = GetVehicleColours(GetVehiclePedIsUsing(ped))
				primary = colorNames[tostring(primary)]
				secondary = colorNames[tostring(secondary)]
				area = GetNameOfZone(x, y, z)
				TriggerServerEvent('911:RecklessDriving', x, y, z, lastStreetNAME, area, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(ped)))), GetVehicleNumberPlateText(GetVehiclePedIsIn(ped)), primary, secondary)
				Citizen.Wait(500)
			elseif ReportVehicleTheft and IsPedInAnyVehicle(ped, false) and IsVehicleNeedsToBeHotwired(GetVehiclePedIsIn(ped)) and IsAreaPopulated() then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
				local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
				local primary, secondary = GetVehicleColours(vehicle)
				primary = colorNames[tostring(primary)]
				secondary = colorNames[tostring(secondary)]
				TriggerServerEvent('911:VehicleTheft', x, y, z, lastStreetNAME, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), GetVehicleNumberPlateText(vehicle), IsPedMale(ped), primary, secondary)
				Citizen.Wait(500)
			elseif ReportMVA and DoesEntityExist(vehicle) and IsAreaPopulated() and GetVehicleClass(vehicle) ~= 14 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 19 then
				local currentDamage = GetVehicleBodyHealth(vehicle)
				if currentDamage ~= oldBodyDamage then
					if (currentDamage < oldBodyDamage) and (oldBodyDamage - currentDamage) >= 5 then
						local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
						local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
						local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
						local primary, secondary = GetVehicleColours(vehicle)
						primary = colorNames[tostring(primary)]
						secondary = colorNames[tostring(secondary)]
						area = GetNameOfZone(x, y, z)
		               	TriggerServerEvent('911:MVA', x, y, z, lastStreetNAME, area, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), GetVehicleNumberPlateText(vehicle), IsPedMale(ped), primary, secondary)
		               	Citizen.Wait(500)
					end
					oldBodyDamage = currentDamage
				end
			end
		end
	end
end)

RegisterNetEvent('911:mute911') -- pauses receiving local 911 calls
AddEventHandler('911:mute911', function()
	mute911 = not mute911
	if mute911 then
		ShowNotification('Emergency calls have been ~r~muted~s~.')
		Citizen.Wait(10000)
		while mute911 do
			Citizen.Wait(1000)
			ShowNotification('Emergency calls are ~r~muted~s~!')
		end
	else
		ShowNotification('Emergency calls have been ~g~unmuted~s~.')
	end
end)

RegisterNetEvent('911:clear911') -- clears all blips for player
AddEventHandler('911:clear911', function()
	for i = 1, #blips do
		RemoveBlip(blips[i])
	end
	ShowNotification('Call blips have been cleared.')
end)

RegisterNetEvent('911:mark911') -- marks latest 911 call's blip
AddEventHandler('911:mark911', function()
	blipCoords = GetBlipCoords(blips[#blips])
	SetNewWaypoint(blipCoords)
	ShowNotification('Latest call has been marked as waypoint.')
end)

Citizen.CreateThread(function() -- automatically remove all call blips you are closest too
	while true do
		Citizen.Wait(1000)
		pedCoords = GetEntityCoords(PlayerPedId())
		for i = 1, #blips do
			blipCoords = GetBlipCoords(blips[i])
			if GetDistanceBetweenCoords(pedCoords, blipCoords, false) < 20.0 then
				--print('removing closest call blip')
				Citizen.Wait(3000)
				RemoveBlip(blips[i])
			end
		end
	end
end)


blips = {}

RegisterNetEvent('911:Notification')
AddEventHandler('911:Notification', function(string, x, y, z, blipText)
	if not mute911 then
		TriggerEvent("chatMessage", "", { 0, 0, 0 }, "^1^*[911] ^r^7"..string)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'demo', 0.1)
		blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 304)
		SetBlipDisplay(blip, 2)
		SetBlipScale(blip, 1.2)
		SetBlipColour(blip, 29)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blipText)
		EndTextCommandSetBlipName(blip)
		Citizen.CreateThread(function()
			table.insert(blips, blip)
			for i = 1, #blips do
				Citizen.Wait(45000)
				RemoveBlip(blips[i])
			end
		end)
	end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function IsAreaPopulated()
	local AREAS = {
		{x = 1491.839, y = 3112.53, z = 40.656, range = 330}, -- sandy shores airport area // 75 - 150 probably range
		{x = 151.62, y = 1038.808, z = 32.735, range = 1200}, -- los santos // 600 - 900 ish?
		{x = -3161.96, y = 790.088, z = 6.824, range = 650}, -- west coast, NW of los santos // 300 - 400 ish?
		{x = 2356.744, y = 4776.75, z = 34.613, range = 600}, -- grape seed // 350 - 450 ish?
		{x = 145.209, y = 6304.922, z = 40.277, range = 650}, -- paleto bay // 500 - 600
		{x = -1070.5, y = 5323.5, z = 46.339, range = 700}, -- S of Paleto Bay // 350 - 500 ish
		{x = -2550.21, y = 2321.747, z = 33.059, range = 350}, -- west of map, gas station // 100 - 200
		{x = 1927.374, y = 3765.77, z = 32.309, range = 350}, -- sandy shores
		{x = 895.649, y = 2697.049, z = 41.985, range = 200}, -- harmony
		{x = -1093.773, y = -2970.00, z = 13.944, range = 300}, -- LS airport
		{x = 1070.506, y = -3111.021, z = 5.9, range = 450} -- LS ship cargo area
	}
	local my_coords = GetEntityCoords(me, true)
	for k = 1, #AREAS do
		if Vdist(my_coords.x, my_coords.y, my_coords.z, AREAS[k].x, AREAS[k].y, AREAS[k].z) <= AREAS[k].range then
			--print("within range of populated area!")
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    local handsup = false
    while true do
        Citizen.Wait(0)
        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
        if aiming then
    
            local pP = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pP, true)
            local tCoords = GetEntityCoords(targetPed, true)
            local veh = GetVehiclePedIsIn(targetPed, false)
        
            -- Citizen.Trace('Aiming')
            if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
            -- Citizen.Trace('Exists')
                if IsPedInAnyVehicle(targetPed, false) and not IsPedAPlayer(targetPed) and IsPedArmed(pP, 4) then
                    if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) < 6 then
                        ShowHelp('~INPUT_PICKUP~ to intimidate the driver', 1)
                        if IsControlJustPressed(0, 38) then
                        	local primary, secondary = GetVehicleColours(veh)
							primary = colorNames[tostring(primary)]
							secondary = colorNames[tostring(secondary)]
                            lastStreetHASH = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)
                            lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
                            TriggerServerEvent('911:ArmedCarjacking', pCoords.x, pCoords.y, pCoords.z, lastStreetNAME, GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))), GetVehicleNumberPlateText(veh), IsPedMale(pP), primary, secondary)
                            TaskLeaveVehicle(targetPed, veh, 256)
                            Citizen.Wait(500)
                            TriggerServerEvent('carjack:playHandsUpOnAll', targetPed)
                            TaskPlayAnim(targetPed, dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                            TaskTurnPedToFaceEntity(targetPed, GetPlayerPed(-1), 1)
                            Citizen.Wait(100)
                            TaskStandStill(targetPed, 15000)
                            Citizen.Wait(15000)
                            ClearPedTasks(targetPed)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('carjack:playAnimOnPed')
AddEventHandler('carjack:playAnimOnPed', function(ped)
	local dict = "missminuteman_1ig_2"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    print('playing anim')
	TaskPlayAnim(ped, dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
end)

RegisterNetEvent('interaction:setPlayersJob')
AddEventHandler('interaction:setPlayersJob', function(job)
	if job == 'sheriff' or job == 'ems' or job == 'fire' or job == 'police' then
		onDuty = true
		RespectPedRelations(true)
	else
		onDuty = false
		RespectPedRelations(false)
	end
end)

function ShowHelp(text, bleep)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, bleep, -1)
end

function RespectPedRelations(boolean)
	if boolean then -- AI will respect the emergency worker when on-duty
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
	else -- AI will be neutral once emergency worker is off-duty
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("COP"), GetHashKey('PLAYER'))
	end
end

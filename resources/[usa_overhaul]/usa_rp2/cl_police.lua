local me = nil

local spawnedCones = {}

RegisterNetEvent("dispatch:setWaypoint")
AddEventHandler("dispatch:setWaypoint", function(targetServerId)
    local targetPed = GetPlayerFromServerId(targetServerId)
    --Citizen.Trace("targetPed = " .. targetPed)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(targetPed), false))
    --Citizen.Trace("x = " .. x .. ", y = " .. y .. ", z = " .. z)
    ClearGpsPlayerWaypoint()
    SetNewWaypoint(x,y)
    --Citizen.Trace("waypoint set!")
end)

-- barrier --
RegisterNetEvent('createObject')
AddEventHandler('createObject', function(obj)
    SetObjectOnGround(obj)
end)

-- cone --
RegisterNetEvent('c_setCone')
AddEventHandler('c_setCone', function()
    SetConeOnGround()
end)

RegisterNetEvent('c_removeCones')
AddEventHandler('c_removeCones', function()
    removeCones()
end)

RegisterNetEvent('dispatch:notify')
AddEventHandler('dispatch:notify', function(lastName, source, msg)
  TriggerEvent('chatMessage', "", {255, 20, 10}, '^5^*[DISPATCH] ^r^0'..lastName..' ['..source..']: ^5'..msg) -- send to caller
  PlaySoundFrontend(-1,"Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
end)

-- SEARCH COMMAND --------------------------------------------------------------------------------------------------------

RegisterNetEvent("search:attemptToSearchNearestPerson")
AddEventHandler("search:attemptToSearchNearestPerson", function()
  TriggerEvent("usa:getClosestPlayer", 1.6, function(player)
    if player.id ~= 0 and IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(player.id))) then
      TriggerServerEvent("search:foundPlayerToSearch", player.id)
    elseif IsPedInAnyVehicle(PlayerPedId(), false) then
      TriggerEvent("veh:searchVeh")
    else
      TriggerEvent("usa:notify", "No person found to search!")
    end
  end)
end)

RegisterNetEvent("search:searchNearest")
AddEventHandler("search:searchNearest", function()
  TriggerEvent("usa:getClosestPlayer", 1.6, function(player)
    if player.id ~= 0 and IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(player.id))) then
      local playerPed = PlayerPedId()
      local playerHeading = GetEntityHeading(playerPed)
      local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.70, -1.0))
      TriggerEvent('search:playAnim')
      TriggerServerEvent('search:playSuspectAnim', player.id, x, y, z, playerHeading)
      Citizen.Wait(12000)
      TriggerServerEvent("search:searchPlayer", player.id)
    elseif IsPedInAnyVehicle(PlayerPedId(), false) then
      TriggerEvent("veh:searchVeh")
    end
  end)
end)

RegisterNetEvent("search:playAnim")
AddEventHandler("search:playAnim", function()
  local playerPed = PlayerPedId()
  local playerHeading = GetEntityHeading(playerPed)
  RequestAnimDict('anim@heists@load_box')
  while not HasAnimDictLoaded('anim@heists@load_box') do Citizen.Wait(0) end
  RequestAnimDict('anim@heists@box_carry@')
  while not HasAnimDictLoaded('anim@heists@box_carry@') do Citizen.Wait(0) end
  RequestAnimDict('missbigscore2aig_7@driver')
  while not HasAnimDictLoaded('missbigscore2aig_7@driver') do Citizen.Wait(0) end
  RequestAnimDict('mini@yoga')
  while not HasAnimDictLoaded('mini@yoga') do Citizen.Wait(0) end
  RequestAnimDict('missfam5_yoga')
  while not HasAnimDictLoaded('missfam5_yoga') do Citizen.Wait(0) end
  TaskPlayAnim(playerPed, 'anim@heists@load_box', 'idle', 8.0, 8.0, -1, 1, -1)
  Citizen.Wait(800)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 1, -1)
  Citizen.Wait(800)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'missfam5_yoga', 'start_pose', 8.0, 8.0, -1, 1, -1)
  Citizen.Wait(800)
  ClearPedTasks(playerPed)
  SetEntityHeading(playerPed, playerHeading - 10.0)
  TaskPlayAnim(playerPed, 'missbigscore2aig_7@driver', 'idle_to_boot_l', 8.0, 8.0, -1, 2, -1)
  Citizen.Wait(1500)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'missbigscore2aig_7@driver', 'boot_l_loop', 8.0, 8.0, -1, 2, -1)
  Citizen.Wait(500)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'mini@yoga', 'outro_2', 8.0, 8.0, -1, 1, -1)
  Citizen.Wait(2000)
  ClearPedTasks(playerPed)
  SetEntityHeading(playerPed, playerHeading + 10.0)
  TaskPlayAnim(playerPed, 'missbigscore2aig_7@driver', 'idle_to_boot_r', 8.0, 8.0, -1, 2, -1)
  Citizen.Wait(500)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'missbigscore2aig_7@driver', 'boot_r_loop', 8.0, 8.0, -1, 2, -1)
  Citizen.Wait(1500)
  ClearPedTasks(playerPed)
  TaskPlayAnim(playerPed, 'mini@yoga', 'outro_2', 8.0, 8.0, -1, 1 , -1)
  Citizen.Wait(2000)
  ClearPedTasks(playerPed)
end)

RegisterNetEvent("search:playSuspectAnim")
AddEventHandler("search:playSuspectAnim", function(x, y, z, heading)
  local playerPed = PlayerPedId()
  FreezeEntityPosition(playerPed, true)
  SetEntityCoords(playerPed, x, y, z)
  SetEntityHeading(playerPed, heading)
  Citizen.Wait(13000)
  FreezeEntityPosition(playerPed, false)
end)


----------------------------------------------------------------------------------------------------------------------------

function SetObjectOnGround(obj)
    barrier = GetHashKey(obj)
    RequestModel(barrier)
    while not HasModelLoaded(barrier) do
      Wait(1)
    end
    local playerped = GetPlayerPed(-1)
    local coords = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 2.0, 0.0)
    local object = CreateObject(barrier, coords.x, coords.y, coords.z-1.9, true, true, false)
    PlaceObjectOnGroundProperly(object)
    local player_heading =  GetEntityHeading(playerped)
    SetEntityHeading(object, player_heading)
    table.insert(spawnedCones, object)
end

function SetConeOnGround()
    barrier = GetHashKey("prop_mp_cone_01")
    RequestModel(barrier)
    while not HasModelLoaded(barrier) do
      Citizen.Wait(1)
    end
    local playerped = GetPlayerPed(-1)
    local coords = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 2.0, 0.0)
    local object = CreateObject(barrier, coords.x, coords.y, coords.z-1.9, true, true, false)
    PlaceObjectOnGroundProperly(object)
    local player_heading =  GetEntityHeading(playerped)
    SetEntityHeading(object, player_heading)
    table.insert(spawnedCones, object)
end

function removeCones()
    for i = 1, #spawnedCones do
        local cone = spawnedCones[i]
        SetEntityAsMissionEntity(cone, true, true)
        DeleteObject(cone)
    end
    spawnedCones = {}
end

function requestDict(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
end

RegisterNetEvent("police:notify")
AddEventHandler("police:notify", function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end)

RegisterNetEvent("police:getMoneyInput")
AddEventHandler("police:getMoneyInput", function()
    Citizen.CreateThread( function()
            DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
            while true do
                if ( UpdateOnscreenKeyboard() == 1 ) then
                    local input_amount = GetOnscreenKeyboardResult()
                    if ( string.len( input_amount ) > 0 ) then
                        local amount = tonumber( input_amount )
                        if ( amount > 0 ) then
                            -- todo: prevent decimals
                            -- trigger server event to remove money
                            amount = round(amount, 0)
                            TriggerServerEvent("police:seizeCash", amount)
                        end
                        break
                    else
                        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 9 )
                    end
                elseif ( UpdateOnscreenKeyboard() == 2 ) then
                    break
                end
            Citizen.Wait( 0 )
        end
    end )
end)

local stored_weapons = {}
-- storing / retrieving police weapons from their vehicles
RegisterNetEvent("police:grabWeapon")
AddEventHandler("police:grabWeapon", function(wep_name)
  local weapon = {hash = 0, ammo = 0}
  local playerPed = PlayerPedId()
  local target_veh = getVehicleInFrontOfUser()
  if target_veh == 0 or not target_veh then
    target_veh = GetVehiclePedIsIn(PlayerPedId())
  end
  if (GetVehicleClass(target_veh) == 18) then
    if stored_weapons[target_veh] then
      local requestedHash = 0
      if string.lower(wep_name) == "ar" then
        requestedHash = 4208062921
      elseif string.lower(wep_name) == "shotgun" then
        requestedHash = 1432025498
      elseif string.lower(wep_name) == "flaregun" then
        requestedHash = GetHashKey("WEAPON_FLAREGUN")
      elseif string.lower(wep_name) == "extinguisher" then
        requestedHash = 101631238
      end
      if requestedHash ~= 0 then
        for i = 1, #stored_weapons[target_veh] do
          local weapon = stored_weapons[target_veh][i]
          if weapon.hash == requestedHash then
            if weapon.hash == 1432025498 then
              GiveWeaponToPed(playerPed, 1432025498, 0, false, false)
              SetPedAmmo(playerPed, 1432025498, 0)
              GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_AT_SIGHTS'))
              GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_AT_AR_FLSH'))
              GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT'))
              Citizen.Wait(100)
              local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weapon.hash)
              SetPedAmmoByType(playerPed, ammoType, weapon.ammo)
              TriggerEvent('usa:notify', 'You have equipped a Pump Shotgun.')
              table.remove(stored_weapons[target_veh], i)
              return
            elseif weapon.hash == 4208062921 then
              GiveWeaponToPed(playerPed, 4208062921, 0, false, false)
              SetPedAmmo(playerPed, 4208062921, 0)
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_SIGHTS'))
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_AR_FLSH'))
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_AR_AFGRIP_02'))
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ'))
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_CR_BARREL_02'))
              GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_MUZZLE_06'))
              Citizen.Wait(100)
              local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weapon.hash)
              SetPedAmmoByType(playerPed, ammoType, weapon.ammo)
              TriggerEvent('usa:notify', 'You have equipped a Carbine Rifle.')
              table.remove(stored_weapons[target_veh], i)
              return
            else
              print('equip')
              TriggerEvent('usa:equipWeapon', weapon)
              return
            end
          end
        end
        TriggerEvent("usa:notify", "Weapon to grab was not stored.")
      end
    end
  else
    --print("not a police vehicle!")
    TriggerEvent("usa:notify", "Not a police vehicle!")
  end
end)

RegisterNetEvent("police:storeWeapon")
AddEventHandler("police:storeWeapon", function(wep_name)
  local playerPed = PlayerPedId()
  local weapon = {hash = 0, ammo = 0}
  local target_veh = getVehicleInFrontOfUser()
  if target_veh == 0 or not target_veh then
    target_veh = GetVehiclePedIsIn(PlayerPedId())
  end
  if (GetVehicleClass(target_veh) == 18) then
    if string.lower(wep_name) == "ar" then
      weapon.hash = 4208062921
      weapon.ammo = GetAmmoInPedWeapon(playerPed, 4208062921)
    elseif string.lower(wep_name) == "shotgun" then
      weapon.hash = 1432025498
      weapon.ammo = GetAmmoInPedWeapon(playerPed, 1432025498)
    elseif string.lower(wep_name) == "flaregun" then
      weapon.hash = GetHashKey("WEAPON_FLAREGUN")
      weapon.ammo = GetAmmoInPedWeapon(playerPed, GetHashKey("WEAPON_FLAREGUN"))
    elseif string.lower(wep_name) == "extinguisher" then
      weapon.hash = 101631238
      weapon.ammo = 100
    end
    if GetSelectedPedWeapon(playerPed) == weapon.hash or HasPedGotWeapon(playerPed, weapon.hash, false) then
      if not stored_weapons[target_veh] then
        stored_weapons[target_veh] = {}
        table.insert(stored_weapons[target_veh], weapon)
        RemoveWeaponFromPed(playerPed, weapon.hash)
        print('weapon inserted!')
      else
        table.insert(stored_weapons[target_veh], weapon)
        RemoveWeaponFromPed(playerPed, weapon.hash)
        print('weapon inserted! (2)')
      end
    end
  else
    --print("not a police vehicle!")
  end
end)

function getVehicleInFrontOfUser()
	local playerped = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 2.0, 0.0)
	local targetVehicle = getVehicleInDirection(coordA, coordB)
	return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

---------------------------------------------------------------------
-- BAITCAR SCRIPT --
---------------------------------------------------------------------
local isInBaitCar = false
RegisterNetEvent("simp:baitCarDisable")
AddEventHandler("simp:baitCarDisable", function()
	local playerPed = PlayerPedId()
	local playerVeh = GetVehiclePedIsIn(playerPed)
	if IsPedInAnyVehicle(playerPed, false) then
		print("locking the doors!")
			SetVehicleDoorShut(playerVeh, 0, true)
			SetVehicleDoorShut(playerVeh, 1, true)
			SetVehicleDoorShut(playerVeh, 2, true)
			SetVehicleDoorShut(playerVeh, 3, true)
			SetVehicleDoorShut(playerVeh, 4, true)
			SetVehicleDoorShut(playerVeh, 5, true)
			TaskVehicleTempAction(playerPed, playerVeh, 27, 5000)
			PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
			isInBaitCar = true
			SetVehicleEngineHealth(playerVeh, -4000)
			SetVehicleDoorsLocked(playerVeh, 4)
			SetNotificationTextEntry("STRING")
			AddTextComponentString("~r~WARNING:~s~~n~This is the SA State Police. You are under arrest.")
			DrawNotification(true, true)
	end
end)

RegisterNetEvent("simp:baitCarunlock")
AddEventHandler("simp:baitCarunlock", function()
	local playerPed = PlayerPedId()
	local playerVeh = GetVehiclePedIsIn(playerPed)
	if IsPedInAnyVehicle(playerPed, false) then
		isInBaitCar = false;
		SetVehicleDoorsLocked(playerVeh, 2)
		SetVehicleDoorsLocked(playerVeh, 1)
		SetNotificationTextEntry("STRING")
		AddTextComponentString('~y~Info:~s~~n~Step out of the vehicle and follow the instructions you are given.')
		DrawNotification(true, true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------
-- BAITCAR SCRIPT CREATED BY TONI MORTON FOR THE FIVEM COMMUNITY, PLEASE GIVE CREDITS TO ME IF YOU USE THIS SCRIPT IN YOUR SERVER.  --
-----------------------------------------------------------------------------------------------------------------------

-- KEEP DOOR OPEN ON EXIT (HOLD F) --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	  if IsPedInAnyPoliceVehicle(playerPed) and IsControlPressed( 2, 75 ) and GetLastInputMethod(0) then
			Citizen.Wait(150)
			if IsPedInAnyPoliceVehicle(playerPed) and IsControlPressed( 2, 75 ) then
				local handle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				TaskLeaveVehicle(playerPed, handle, 256)
			end
	  end
		if isInBaitCar then
			veh = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleEngineOn(veh, false, true)
			DisableControlAction(0, 75, true)
		end
	end
end)

------------------end baitcar--------------------------

-- todo: somehow convet RGB value of vehicle color to human readable name for 911 report above
-- 15, 15, 15 or anything less = black
-- 240, 240, 240 or greater = white
-- 63, 66, 40 = dark green
-- 28, 30, 33 = gray
-- 74, 10, 10 = red

function send911Message(msg, type)
	-- send 911 message --
	-- get location of sender and send to server function:
	local data = {}
	local playerPos = GetEntityCoords( GetPlayerPed( -1 ), true )
	local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street = {}
	if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
		-- Ignores the switcharoo while doing circles on intersections
		lastStreetA = streetA
		lastStreetB = streetB
	end
	if lastStreetA ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
	end
	if lastStreetB ~= 0 then
		table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
	end
	data.location = table.concat( street, " & " )
	data.pos = {
		x = playerPos.x,
		y = playerPos.y,
		z = playerPos.z
	}
	data.message = msg
	TriggerServerEvent("phone:send911Message", data, true, true, type)
end

function GetClosestPlayerInfo(range)
	local closestDistance = 0
	local closestPlayerServerId = 0
	local closestName = ""
	for x = 0, 64 do
		if NetworkIsPlayerActive(x) then
			targetPed = GetPlayerPed(x)
			targetPedCoords = GetEntityCoords(targetPed, false)
			playerPedCoords = GetEntityCoords(GetPlayerPed(-1), false)
			distanceToTargetPed = Vdist(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z)
			if targetPed ~= GetPlayerPed(-1) and IsEntityVisible(targetPed) then
				if distanceToTargetPed < range then
					if closestDistance == 0 then
						closestDistance = distanceToTargetPed
						closestPlayerServerId = GetPlayerServerId(x)
						closestName = GetPlayerName(x)
						hitHandlePed = GetPlayerPed(x)
						--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
						--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
					else
						if distanceToTargetPed <= closestDistance then
							closestDistance = distanceToTargetPed
							closestPlayerServerId = GetPlayerServerId(x)
							closestName = GetPlayerName(x)
							hitHandlePed = GetPlayerPed(x)
							--rayHandle = CastRayPointToPoint(playerPedCoords.x, playerPedCoords.y, playerPedCoords.z, targetPedCoords.x, targetPedCoords.y, targetPedCoords.z, 12, GetPlayerPed(-1), 0)
							--a, b, c, d, hitHandlePed = GetRaycastResult(rayHandle)
						end
					end
				end
			end
		end
	end
	return closestPlayerServerId, closestName, closestDistance
end

function ConvertRealCarToGtaCar(name)
  if string.lower(name) == "sabregt" then
    return "Ford Mustang Boss 302"
  elseif string.lower(name) == "sadler" then
    return "Ford F350 Super Duty"
  elseif string.lower(name) == "fugitive" then
    return "Masseratti Quattroporte"
  elseif string.lower(name) == "buffalo" then
    return "Chrystler 300C"
  elseif string.lower(name) == "ruiner" then
	return "Imponte Ruiner"
  elseif string.lower(name) == "bobcatxl" then
	return "Vapid Bobcat XL"
  elseif string.lower(name) == "dubsta" then
	return "Benefactor Dubsta"
  elseif string.lower(name) == "tornado3" then
	return "Declasse Tornado"
  elseif string.lower(name) == "oracle2" then
	return "Ubermacht Oracle XS"
  elseif string.lower(name) == "rebel02" then
	return "Karin Rebel"
  elseif string.lower(name) == "sanchez02" then
	return "Miabatsu Sanchez"
  elseif string.lower(name) == "sandking" then
	return "Vapid Sandking XL"
  elseif string.lower(name) == "emperor" then
	return "Albany Emperor"
  elseif string.lower(name) == "seminole" then
	return "Canis Seminole"
  elseif string.lower(name) == "blista2" then
	return "Dinka Blista Compact"
  elseif string.lower(name) == "flatbed" then
	return "MTL Flatbed (tow)"
  elseif string.lower(name) == "scrap" then
	return "Utility Scrap Truck"
  elseif string.lower(name) == "peyote" then
	return "Vapid Peyote"
  elseif string.lower(name) == "bfinject" then
	return "BF Injection"
  elseif string.lower(name) == "penumbra" then
	return "Nissan 370z"
  else
    return name
  end
end

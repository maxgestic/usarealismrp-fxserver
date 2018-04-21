local spawnedCones = {}

RegisterNetEvent("dispatch:setWaypoint")
AddEventHandler("dispatch:setWaypoint", function(targetServerId)
    local targetPed = GetPlayerFromServerId(targetServerId)
    Citizen.Trace("targetPed = " .. targetPed)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(targetPed), false))
    Citizen.Trace("x = " .. x .. ", y = " .. y .. ", z = " .. z)
    ClearGpsPlayerWaypoint()
    SetNewWaypoint(x,y)
    Citizen.Trace("waypoint set!")
end)


-- barrier
RegisterNetEvent('c_setCone')
AddEventHandler('c_setCone', function()
    SetConeOnGround()
end)

RegisterNetEvent('c_removeCones')
AddEventHandler('c_removeCones', function()
    removeCones()
end)

function SetConeOnGround()
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    barrier = GetHashKey("prop_mp_cone_01")
    RequestModel(barrier)
    while not HasModelLoaded(barrier) do
      Citizen.Wait(1)
    end
    local object = CreateObject(barrier, x, y+1, z-1.9, true, true, false) -- x+1
    PlaceObjectOnGroundProperly(object)
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

-- /ticket [id] [amount] [infractions]
RegisterNetEvent("police:ticket")
AddEventHandler("police:ticket", function(amount, reason, fromPlayerId)
    local responded = false
    Citizen.Trace("amount = " .. amount)
    Citizen.Trace("reason = " .. reason)
    DrawTicketNotification(tostring(amount), reason)
    Citizen.CreateThread(function()
        while not responded do
            Citizen.Wait(0)
            DrawSpecialText("Pay ticket of $" .. amount .. "? ~g~Y~w~/~r~N" )
        	if IsControlJustPressed(1, 246) then -- Y key
                Citizen.Trace("player wants to pay ticket!")
                responded = true
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, reason, true) -- remove money & notify officer of signature
            elseif IsControlJustPressed(1, 177) then -- Backspace key
                Citizen.Trace("player does not want to pay ticket!")
                responded = true
                TriggerServerEvent("police:payTicket", fromPlayerId, amount, reason, false) -- notify officer of denial to sign
            end
        end
    end)
end)

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

local grabbed_weapons = {}
-- storing / retrieving police weapons from their vehicles
RegisterNetEvent("police:grabWeapon")
AddEventHandler("police:grabWeapon", function(wep_name)
  local weapon = {hash = 0}
  local target_veh = getVehicleInFrontOfUser()
  if isPoliceVehicle(target_veh) and not grabbed_weapons[wep_name] then
    if string.lower(wep_name) == "ar" then
      weapon.hash = -2084633992
    elseif string.lower(wep_name) == "shotgun" then
      weapon.hash = 487013001
    end
    if weapon.hash ~= 0 then
      grabbed_weapons[wep_name] = target_veh
      TriggerEvent("usa:equipWeapon", weapon)
      -- give flashlight:
      GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0x7BC4CDDC)
      GiveWeaponComponentToPed(GetPlayerPed(-1), 2210333304, 0xC164F53)
    end
  else
    --print("not a police vehicle!")
    TriggerEvent("usa:notify", "Not a police vehicle or did not store grabbed weapon!")
  end
end)

RegisterNetEvent("police:storeWeapon")
AddEventHandler("police:storeWeapon", function(wep_name)
  local me = GetPlayerPed(-1)
  local weapon = {hash = 0}
  if isPoliceVehicle(getVehicleInFrontOfUser()) then
    if string.lower(wep_name) == "ar" then
      weapon.hash = -2084633992
    elseif string.lower(wep_name) == "shotgun" then
      weapon.hash = 487013001
    end
    if GetSelectedPedWeapon(me) == weapon.hash or HasPedGotWeapon(me, weapon.hash, false) then
      RemoveWeaponFromPed(me, weapon.hash)
      grabbed_weapons[wep_name] = nil
    end
  else
    print("not a police vehicle!")
  end
end)

function isPoliceVehicle(veh_handle)
  local policeVehicles = {
      1171614426, -- ambulance
      1127131465, -- fbi
      -1647941228, -- fbi2
      1938952078, -- firetruck
      2046537925, -- police
      -1627000575, -- police2
      1912215274, -- police3
      -1973172295, -- police4
      0x9C32EB57, -- Police5
      0xB2FF98F0, -- police 6
      0xC4B53C5B, -- police 7
      0xD0AF544F, -- police 8
      -34623805, -- policeb
      741586030, -- pranger
      -1205689942 -- riot
  }
  for i = 1, #policeVehicles do
    if IsVehicleModel(veh_handle, policeVehicles[i]) then
      return true
    end
  end
  return false
end

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

function DrawTicketNotification(amount, reason)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("~y~TICKET: ~w~$" .. amount .. "\n~y~REASON: ~w~" .. reason .. "\nPay? ~g~Y~w~/~r~Backspace")
	DrawNotification(0,1)
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
	local ped_l = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	if IsPedInAnyVehicle(ped_l, false) then
		print("locking the doors!")
			SetVehicleDoorShut(veh, 0, true)
			SetVehicleDoorShut(veh, 1, true)
			SetVehicleDoorShut(veh, 2, true)
			SetVehicleDoorShut(veh, 3, true)
			SetVehicleDoorShut(veh, 4, true)
			SetVehicleDoorShut(veh, 5, true)
			TaskVehicleTempAction(ped_l, veh, 27, 5000)
			PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
			isInBaitCar = true
			SetVehicleEngineHealth(veh, 0)
			SetVehicleEngineOn(veh, false)
			SetVehicleDoorsLocked(veh, 4)
			SetNotificationTextEntry("STRING")
			AddTextComponentString("~r~WARNING:~s~~n~This is the Blaine County Sheriff's Office. You are under arrest.")
			DrawNotification(true, true)
	end
end)

RegisterNetEvent("simp:baitCarunlock")
AddEventHandler("simp:baitCarunlock", function()
	local ped_l = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
	if IsPedInAnyVehicle(ped_l, false) then
			isInBaitCar = false;
			SetVehicleEngineHealth(veh, 150.0)
			SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
			SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1)), 2)
			SetVehicleDoorsLocked(GetVehiclePedIsIn(GetPlayerPed(-1)), 1)
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
		if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) and IsControlPressed( 2, 75 ) and GetLastInputMethod(2) then
			Citizen.Wait(150)
			if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) and IsControlPressed( 2, 75 ) then
				local handle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				TaskLeaveVehicle(GetPlayerPed(-1), handle, 256)
			end
		end
	end
end)

------------------end baitcar--------------------------

---------------------------------------------------------------------------------------
-- Gun Shot Resdiue(GSR) & Shots fired notifications (based on area + random chance) --
---------------------------------------------------------------------------------------
local me = nil
local last_shot_time = 0
local duration = 25 * 60 * 1000 -- 25 minutes to ms
local sending_msg = false
local already_sent_msg = false
local jacked = false
local timer = {
  last_press = 0,
  delay = 6000 -- 6 seconds
}

-- Gun Shot Resdiue(GSR) --
Citizen.CreateThread(function()
	while true do
		Wait(0)
		me = GetPlayerPed(-1)
		---------------------------------
		-- shooting notification / gsr --
		---------------------------------
		--print("GetSelectedPedWeapon(me): " .. GetSelectedPedWeapon(me))
		if IsPedShooting(me) and GetSelectedPedWeapon(me) ~= 101631238 then
			last_shot_time = GetGameTimer()
			--print("IsInPopulatedArea(): " .. tostring(IsInPopulatedArea()))
			if IsInPopulatedArea() then
				if math.random(100) < 32 then
					if not sending_msg then
						sending_msg = true
  					if GetGameTimer() > timer.last_press + timer.delay then
						  send911Message("(10-32) Report of shots fired.")
              timer.last_press = GetGameTimer()
            end
						sending_msg = false
					end
				end
			end
		end
		------------------------------
		-- car jacking notification --
		------------------------------
		if IsPedJacking(me) then
			if not already_sent_msg then
				if IsInPopulatedArea() then
					if math.random(100) < 90 then
						already_sent_msg = true
						jacked = true
					end
				end
			end
		else
			if jacked then
				local handle = GetVehiclePedIsIn(me, true)
				if handle ~= 0 then
					local display_name = GetDisplayNameFromVehicleModel(GetEntityModel(handle))
					display_name = ConvertRealCarToGtaCar(display_name)
					local r,g,b = GetVehicleColor(handle)
					print("r: " .. r)
					print("g: " .. g)
					print("b: " .. b)
					send911Message("(10-28F) Reported car jacking of a " .. display_name .. " with plate " .. GetVehicleNumberPlateText(handle))
				end
				jacked = false
			end
			already_sent_msg = false
		end
	end
end)

-- todo: somehow convet RGB value of vehicle color to human readable name for 911 report above
-- 15, 15, 15 or anything less = black
-- 240, 240, 240 or greater = white
-- 63, 66, 40 = dark green
-- 28, 30, 33 = gray
-- 74, 10, 10 = red

function IsInPopulatedArea()
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
	local me = GetPlayerPed(-1)
	local my_coords = GetEntityCoords(me, true)
	for k = 1, #AREAS do
		if Vdist(my_coords.x, my_coords.y, my_coords.z, AREAS[k].x, AREAS[k].y, AREAS[k].z) <= AREAS[k].range then
			print("within range of populated area!")
			return true
		end
	end
	return false
end

function send911Message(msg)
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
						TriggerServerEvent("phone:send911Message", data, true, true)
end

RegisterNetEvent("police:performGSR")
AddEventHandler("police:performGSR", function(source)
	--print("performing GSR test")
	local id, name, dist = GetClosestPlayerInfo()
	--print("closest: " .. name .. ", id: " .. id)
	TriggerServerEvent("police:getGSRResult", id, source)
end)

RegisterNetEvent("police:testForGSR")
AddEventHandler("police:testForGSR", function(to_notify_id)
	if GetGameTimer() - last_shot_time > duration then
		--print("passed duration! notify id: " .. to_notify_id)
		TriggerServerEvent("police:notifyGSR", to_notify_id, false)
	else
		--print("player shot weapon recently! gsr detected! notify id: " .. to_notify_id)
		TriggerServerEvent("police:notifyGSR", to_notify_id, true)
	end
end)

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
			if targetPed ~= GetPlayerPed(-1) then
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

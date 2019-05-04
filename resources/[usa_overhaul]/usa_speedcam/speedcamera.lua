local locked = false
local lastScan = { plate = "N/A", speed = 0.00, vehicle = nil }
local showText = true
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if IsControlJustPressed(0, 182, true) and GetVehicleClass(car) == 18 and GetLastInputMethod(0)  then
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			locked = not locked
		end
		if GetVehicleClass(car) == 18 and (GetPedInVehicleSeat(car, -1) == ped or GetPedInVehicleSeat(car, 0) == ped) and showText then
			if locked then
				DrawTxt(0.515, 1.270, 1.0, 1.0, 0.40, '~r~[LOCKED] ~w~Plate: '..lastScan.plate..' | MPH: '..math.ceil(lastScan.speed), 255, 255, 255, 255)
			else
				DrawTxt(0.515, 1.270, 1.0, 1.0, 0.40, 'Plate: '..lastScan.plate..' | MPH: '..math.ceil(lastScan.speed), 255, 255, 255, 255)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if DoesEntityExist(car) and not locked then
			lastScan.vehicle = GetCurrentTargetCar()
			if lastScan.vehicle and GetVehicleNumberPlateText(lastScan.vehicle) then
				lastScan.plate = GetVehicleNumberPlateText(lastScan.vehicle)
				lastScan.speed = GetEntitySpeed(lastScan.vehicle) * 2.236936
			end
		end
	end
end)

AddEventHandler('usa:toggleImmersion', function(toggleOn)
	showText = toggleOn
end)

function GetCurrentTargetCar()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, 0.0)
    local rayHandle = CastRayPointToPoint(coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

	-- DrawMarker(4, entityWorld.x, entityWorld.y, entityWorld.z+0.5, 0, 0, 0, 0, 0.0, 0, 1.5, 1.0, 1.25, 255, 255, 255, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)

    return vehicleHandle
end

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
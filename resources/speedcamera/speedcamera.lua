function drawTxt(x, y, width, height, scale, text, r,g,b,a)
    SetTextFont(0)
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

local lastScan = { plate = "--", speed = 0.00 }
Citizen.CreateThread(function()
  Wait(30000)
	while true do
		Wait(0)
		local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if DoesEntityExist(car) then
			local carM = GetCurrentTargetCar()
			if carM ~= nil then
				local plate = GetVehicleNumberPlateText(carM)
				local speed = GetEntitySpeed(carM) * 2.236936
				if plate ~= nil then
					lastScan.plate = plate;
					lastScan.speed = speed;
				end
				if plate == nil and lastScan.plate ~= nil then
					plate = lastScan.plate
					speed = lastScan.speed
				end

				info = string.format("~y~Plate:~w~ %s ~n~~y~MPH: ~g~%s", plate, math.ceil(speed))

				local vehModel = GetEntityModel(car)
				if vehModel == GetHashKey("fbi") or
					vehModel == GetHashKey("fbi2") or
					vehModel == GetHashKey("police") or
					vehModel == GetHashKey("police2") or
					vehModel == GetHashKey("police3") or
					vehModel == GetHashKey("police4") or
					vehModel == GetHashKey("police5") or
					vehModel == GetHashKey("police6") or
					vehModel == GetHashKey("police7") or
					vehModel == GetHashKey("policeold1") or
					vehModel == GetHashKey("policeold2") or
					vehModel == GetHashKey("policet") or
					vehModel == GetHashKey("policeb") or
					vehModel == GetHashKey("sheriff") or
					vehModel == -672516475 or -- unmarked9
					vehModel == -1960928017 or -- unmarked8
					vehModel == -59441254 or -- unmarked7
					vehModel == -1663942570 or -- unmarked6
					vehModel == 1109330673 or -- unmarked4
					vehModel == -1285460620 or -- unmarked3
					vehModel == 1383443358 or -- unmarked1
					vehModel == GetHashKey("sheriff2") or
                    vehModel == GetHashKey("pranger") then
					drawTxt(0.105,0.808,0.185,0.206, 0.40, info, 255,255,255,255)
				end
			end
		end
	end
end)

--[[
	-672516475, -- unmarked9
	-1960928017, -- unmarked8
	-59441254, -- unmarked7 (slicktop)
	-1663942570, -- unmarked6
	1109330673, -- unmarked4
	-1285460620, -- unmarked3
	1383443358 -- unmarked1
	]]

function GetCurrentTargetCar()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)

    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 50.0, 0.0)
    local rayHandle = CastRayPointToPoint(coords.x, coords.y, coords.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

	-- DrawMarker(4, entityWorld.x, entityWorld.y, entityWorld.z+0.5, 0, 0, 0, 0, 0.0, 0, 1.5, 1.0, 1.25, 255, 255, 255, 200, 0, GetEntityHeading(GetPlayerPed(-1)), 0, 0)

    return vehicleHandle
end

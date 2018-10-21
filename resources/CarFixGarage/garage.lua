local plyPed = GetPlayerPed(-1)
local plyVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
local timer = 15000 -- miliseconds?
local alreadyInside = false

local KEY = 38

-----------------------------------------------------------------------
----------------------------GARAGE-LOCATION----------------------------
-----------------------------------------------------------------------

vehicleRepairStation = {
	{536.1182,  -178.5338,  53.08846},
	{2006.354,  3798.739,  30.83191},
	--{128.6394,  6620.741,  30.43497}, -- OG paleto spot v1
	{103.479,  6622.048,  30.8}, -- OG paleto spot v2
	--{1150.1766,  -774.4962,  57.1689},
	--{103.513,  6622.77,  30.1868}, -- paleto
	{-456.078,5984.27,30.0}, -- Paleto Bay SO
	{-355.011,6109.35,30.0},-- Paleto Bay FD
	--{-222.407,-1329.69,30.89},
	{480.805,-1317.43,29.2},
	{447.534, -997.033, 24.3635}, -- los santos police department on atlee & sinner st
	{201.339, -1656.36, 27.2832}, -- los santos fire department in davis
	{1146.7, -775.8, 56.79}
}

blips = {
	{536.1182,  -178.5338,  53.08846},
	{2006.354,  3798.739,  30.83191},
	--{128.6394,  6620.741,  30.43497}, -- OG paleto spot v1
	{103.479,  6622.048,  30.8}, -- OG paleto spot v2
	--{1150.1766,  -774.4962,  57.1689},
	--{103.513,  6622.77,  30.1868}, -- paleto
	--{-222.407,-1329.69,30.89},
	{480.805,-1317.43,29.2},
	{1146.7, -775.8, 56.79}
}

Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #blips do
		garageCoords = blips[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 446) --446 = Tools
		SetBlipAsShortRange(stationBlip, true)
		SetBlipScale(stationBlip, 0.7)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Auto Repair")
		EndTextCommandSetBlipName(stationBlip)
	end
	return
end)

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end

RegisterNetEvent("carFix:repairVehicle")
AddEventHandler("carFix:repairVehicle", function()
	print("inside carFix:repairVehicle")
	DrawCoolLookingNotification("Your vehicle is  ~y~being repaired~w~!")
	SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), true, false, false)
	SetVehicleFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)),  0.0000000001) -- clean vehicle
	SetVehicleDeformationFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
	DrawCoolLookingNotification("Your vehicle has been ~g~repaired~w~!")
end)

local checking = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			for i = 1, #vehicleRepairStation do
				garageCoords2 = vehicleRepairStation[i]
				DrawMarker(27, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 3 then
					local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
						DrawSpecialText("Press ~g~E~w~ to repair your vehicle!")
						-- check if e is pressed:
						if IsControlJustPressed(1, KEY) and not checking then
							checking = true
							print("checking money for vehicle repair!")
							local engineHealth = GetVehicleEngineHealth(veh)
							local bodyHealth = GetVehicleBodyHealth(veh)
							if not engineHealth then engineHealth = 0.0 end
							if not bodyHealth then bodyHealth = 0.0 end
							if bodyHealth < 1000.0 or engineHealth < 1000.0 then
								SetVehicleEngineOn(veh, false, false, false)
								SetVehicleUndriveable(veh, true)
								local started = GetGameTimer()
								while GetGameTimer() - started < 10000 do
									Wait(5)
									SetVehicleEngineOn(veh, false, false, false)
									SetVehicleUndriveable(veh, true)
								end
								--SetVehicleEngineOn(veh, true, true, true)
								TriggerServerEvent("carFix:checkPlayerMoney", engineHealth, bodyHealth)
							else
								TriggerEvent("usa:notify", "Your vehicle does not need any repairs!")
							end
							checking = false
						end
					end
				end
			end
		end
	end
end)

function DrawSpecialText(m_text)
  ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

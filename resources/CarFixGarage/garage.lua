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
	{201.339, -1656.36, 27.2832} -- los santos fire department in davis
}

blips = {
	--{1150.1766,  -774.4962,  57.1689},
	{536.1182,  -178.5338,  53.08846},
	--{-222.407,-1329.69,30.89},
	{480.805,-1317.43,29.2}
}

--[[
Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #blips do
		garageCoords = blips[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 446) --446 = Tools
		SetBlipAsShortRange(stationBlip, true)
	end
	return
end)
--]]

function DrawCoolLookingNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(0,1)
end

RegisterNetEvent("carFix:repairVehicle")
AddEventHandler("carFix:repairVehicle", function()
	print("inside carFix:repairVehicle")
	DrawCoolLookingNotification("Your vehicle is  ~y~being repaired~w~!")
	SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), false, false, false) -- turn engine off
	while timer > 0 do
		Citizen.Wait(1)
		timer = timer - 15
		if timer < 16 then
			print("timer was < 16!")
			SetVehicleFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)),  0.0000000001) -- clean vehicle
			SetVehicleDeformationFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
			SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), true, false, false)
			DrawCoolLookingNotification("Your vehicle has been ~g~repaired~w~!")
		end
	end
	timer = 15000 -- reset timer
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then -- todo: check for driver seat only
			for i = 1, #vehicleRepairStation do
				garageCoords2 = vehicleRepairStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 3 then
					local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
						DrawSpecialText("Press ~g~E~w~ to repair your vehicle!")
						-- check if e is pressed:
						if IsControlJustPressed(1, KEY) then
							print("checking money for vehicle repair!")
							local engineHealth = GetVehicleEngineHealth(veh)
							local bodyHealth = GetVehicleBodyHealth(veh)
							TriggerServerEvent("carFix:checkPlayerMoney", engineHealth, bodyHealth)
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

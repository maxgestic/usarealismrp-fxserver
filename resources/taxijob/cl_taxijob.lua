local taxiDutyX, taxiDutyY, taxiDutyZ = 895.563, -179.536, 73.8003
local spawn = {x=907.193,y= -186.33,z=74.0205}

RegisterNetEvent("taxi:onDuty")
AddEventHandler("taxi:onDuty", function()
	DrawCoolLookingNotificationWithTaxiPic("Here's your cab! Have a good shift!")
	spawnVehicle()
end)

RegisterNetEvent("taxi:offDuty")
AddEventHandler("taxi:offDuty", function()
	DrawCoolLookingNotificationWithTaxiPic("You have clocked out! Have a good one!")
end)

local playerNotified = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DrawMarker(1, taxiDutyX, taxiDutyY, taxiDutyZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
	    if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,taxiDutyX,taxiDutyY,taxiDutyZ,false) < 3 and not playerNotified then
            --DrawCoolLookingNotification("Press ~y~E~w~ to go work for Downtown Taxi Co.!")
    		if IsControlJustPressed(1,38) then
				TriggerServerEvent("taxi:setJob")
                --DrawCoolLookingNotification("Here's your cab! Have a good shift!")
                --spawnVehicle()
                --Citizen.Wait(120000) -- ghetto spawn delay
    		end
        elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,taxiDutyX,taxiDutyY,taxiDutyZ,false) > 3 then
            -- out of range
        end
	end
end)

function spawnVehicle()
    local numberHash = -956048545
    Citizen.CreateThread(function()
        RequestModel(numberHash)
        while not HasModelLoaded(numberHash) do
            RequestModel(numberHash)
            Citizen.Wait(0)
        end
        local playerPed = GetPlayerPed(-1)
        local vehicle = CreateVehicle(numberHash, spawn.x, spawn.y, spawn.z, 0.0, true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehRadioStation(vehicle, "OFF")
        SetEntityAsMissionEntity(vehicle, true, true)
    end)
end

function DrawCoolLookingNotificationWithTaxiPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_TAXI", "CHAR_TAXI", true, 1, name, "", msg)
	DrawNotification(0,1)
end

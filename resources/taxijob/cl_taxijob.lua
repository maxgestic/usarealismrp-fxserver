local taxiDutyX, taxiDutyY, taxiDutyZ = -41.306, 6436.432, 30.490
local spawn = {x=-29.793,y= 6435.638,z=31.426}
local ped_heading = 40.0

RegisterNetEvent("taxi:onDuty")
AddEventHandler("taxi:onDuty", function(name)
	DrawCoolLookingNotificationWithTaxiPic("Here's your cab! Have a good shift!")
	spawnVehicle(name)
end)

RegisterNetEvent("taxi:offDuty")
AddEventHandler("taxi:offDuty", function()
	DrawCoolLookingNotificationWithTaxiPic("You have clocked out! Have a good one!")
end)

-- S P A W N  J O B  P E D S
Citizen.CreateThread(function()
	--for name, data in pairs(locations) do
		local hash = 1397974313
		--local hash = GetHashKey(data.ped.model)
		print("requesting hash...")
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		print("spawning ped, heading: " .. ped_heading)
		print("hash: " .. hash)
		local ped = CreatePed(4, hash, taxiDutyX, taxiDutyY, taxiDutyZ, ped_heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetEntityInvincible(ped)
		SetPedRandomComponentVariation(ped, true)
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER_HARD", 0, true);
	--end
end)

local playerNotified = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DrawMarker(27, taxiDutyX, taxiDutyY, taxiDutyZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
	    if GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,taxiDutyX,taxiDutyY,taxiDutyZ,false) < 3 and not playerNotified then
        drawTxt("Press ~y~E~w~ to go on/off duty for Downtown Taxi Co.!",0,1,0.5,0.8,0.6,255,255,255,255)
    		if IsControlJustPressed(1,38) then
				local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
				TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
					TriggerServerEvent("taxi:setJob", property)
				end)
    		end
        elseif GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,taxiDutyX,taxiDutyY,taxiDutyZ,false) > 3 then
            -- out of range
        end
	end
end)

function spawnVehicle(name)
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
		SetVehicleNumberPlateText(vehicle, name)
    end)
end

function DrawCoolLookingNotificationWithTaxiPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_TAXI", "CHAR_TAXI", true, 1, name, "", msg)
	DrawNotification(0,1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

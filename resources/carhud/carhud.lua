local UI = { 
	x =  0.000,
	y = -0.001,
}

Citizen.CreateThread(function()
	local reset = true
	local on = false
	while true do Citizen.Wait(0)
		local MyPed = GetPlayerPed(-1)

		if (IsPedInAnyVehicle(MyPed, false)) then
			DisplayRadar(true)

			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)

			-- SPEED
			Speed = GetEntitySpeed(vehicle) * 2.236936
			drawRct(UI.x + 0.11, UI.y + 0.898, 0.046,0.03,0,0,0,150)
			drawTxt(UI.x + 0.61, UI.y + 1.386, 1.0, 1.0, 0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
			drawTxt(UI.x + 0.633, UI.y + 1.393, 1.0, 1.0, 0.4, "~w~ MPH", 255, 255, 255, 255)

			-- SPEED LIMITER
			if maxSpeed then
				drawRct(UI.x + 0.09, UI.y + 0.932, 0.066, 0.03, 0, 0, 0, 150)
				drawTxt(UI.x + 0.59, UI.y + 1.42, 1.0, 1.0, 0.64 , "~w~" .. math.ceil(maxSpeed), 255, 255, 255, 255)
				drawTxt(UI.x + 0.612, UI.y + 1.427, 1.0, 1.0, 0.4, "~w~ Max Speed", 255, 255, 255, 255)
			end

			if GetPedInVehicleSeat(vehicle, -1) == MyPed then
				if reset then
					maxSpeed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
					SetEntityMaxSpeed(vehicle, maxSpeed)
					reset = false
					on = false
				end

				if IsControlJustReleased(0, 29) then
					if not on then
						on = true
						maxSpeed = GetEntitySpeed(vehicle) * 2.236936;
						SetEntityMaxSpeed(vehicle, GetEntitySpeed(vehicle))
					else
						reset = true
					end
				end
			end
			SetRadarBigmapEnabled(false)
			DrawRect(0.08555, 0.976, 0.14, 0.0149999999999998, 0, 0, 0, 255)
		else
			DisplayRadar(false)
			DrawRect(0.08555, 0.976, 0.14, 0.0149999999999998, 0, 0, 0, 140)
			reset = true
		end
		-- HEALTH
		local Health = GetEntityHealth(MyPed)

		Health = ((Health-100) / 100) * 0.070

		if Health <= 0.0007 then
			r, b, g = table.unpack({ 165, 34, 34 })
			Health = 0.0;
		elseif Health >= 0.0175 then
			r, b, g = table.unpack({ 80, 146, 78 })
		else
			r, b, g = table.unpack({ 165, 34, 34 })
		end

		DrawRect(0.0155 + (Health / 2), 0.9755, Health, 0.00833, r, b, g, 230)
		DrawRect(0.0504, 0.9755, 0.07, 0.00833, r, b, g, 130)
		
		-- ARMOR
		local Armour = GetPedArmour(MyPed)
		
		Armour = (Armour / 100) * 0.069

		DrawRect(0.0866+(Armour/2), 0.9755, Armour, 0.00833, 80, 150, 191, 230)
		DrawRect(0.1214, 0.9755, 0.07, 0.00833, 80, 150, 191, 130)
	end
end)

function drawHelp(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

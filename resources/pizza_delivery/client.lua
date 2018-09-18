-----------------------------------------------------------------------------------------------
--SCRIPT CREADO PARA EL SERVIDOR DE FIVEM DE PLATA O PLOMO COMUNIDAD GAMER.
--SCRIPT CREADO TOTALMENTE POR THEMAYKELLLL1 [ MIGUEL ANGEL LOPEZ REYES ].
--PLATA O PLOMO COMUNIDAD GAMER ACEPTA NO VENDER / REGALAR / PASAR ESTOS SCRIPTS A OTRAS PERSONAS O COMUNIDADES.
-----------------------------------------------------------------------------------------------


-------------------------------------------
------------------VARIABLES----------------
-------------------------------------------

local pizzeria = { x = 1907.44, y = 3733.34, z = 31.15}
local spawnemperor2 = { x = 1908.88, y = 3730.87, z = 32.4387 }

local propina = 0
local posibilidad = 0

local casas = {
	[1] = {name = "Marina Drive",x = 1388.7, y = 3665.32 , z = 33.4100},
	[2] = {name = "Procopio Drive",x = -402.733, y =  6316.95 , z = 27.947},
	[3] = {name = "Sheriff Station",x = -447.148, y = 6010.76 , z = 30.7164 },
	[4] = {name = "Grapeseed",x = 1663.08 , y = 4776.13 , z = 41.0076 },
	[5] = {name = "Stab City",x = 9.35711  , y = 3699.12 , z = 38.6468 },
	[6] = {name = "Route 68"        ,x = 470.97 , y = 2608.36  , z = 43.4772 },
	[7] = {name = "Penitentiary"  ,x = 1846.41  , y = 2585.95, z = 44.672 },
	[8] = {name = "Union Road" ,x = 2931.3    , y = 4624.69 , z = 47.7236 },
	[9] = {name = "Great Ocean Highway"  ,x = 1510.37  , y = 6326.34 , z = 23.6071},
	[10] ={name = "N.Calafia Way" ,x = 1335.38  , y = 4306.5, z = 37.0969},
	[11] ={name = "Procopio Promenade"  ,x = -696.39  , y =  5802.61, z = 16.331},
	[12] ={name ="Paleto Blvd",x = 32.5307, y = 6595.35  , z = 31.4704},
	[13] ={name ="La Fuente Blanca"  ,x = 1380.93, y = 1147.32 ,z = 113.100}
}

local isInJobPizz = false
local sigcasa = 0
local plateab = "POPJOBS"
local isToHouse = false
local isToPizzaria = false
local multiplicador_De_dinero = 0.87
local paga = 0

local px = 0
local py = 0
local pz = 0

local blips = {
	{title="Pizzeria", colour=66, id=267, x = 1907.44, y = 3733.34, z = 31.15},
}

-------------------------------------------
--------------------BLIPS------------------
-------------------------------------------

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function Iracasa(casas,sigcasa)
	blip_casa = AddBlipForCoord(casas[sigcasa].x,casas[sigcasa].y, casas[sigcasa].z)
	SetBlipSprite(blip_casa, 1)
	SetNewWaypoint(casas[sigcasa].x,casas[sigcasa].y)
end

-------------------------------------------
------------------CITIZENS-----------------
-------------------------------------------

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInJobPizz == false then
			DrawMarker(1,pizzeria.x,pizzeria.y,pizzeria.z, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(pizzeria.x, pizzeria.y, pizzeria.z, GetEntityCoords(GetPlayerPed(-1),true)) < 1.5 then
				drawTxt("PRESS <E> TO START THE DELIVERY",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
				if IsControlJustPressed(1,38) then
					isInJobPizz = true
					isToHouse = true
					sigcasa = math.random(1, 13)
					-- [INFO] TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, sigcasa)
					px = casas[sigcasa].x
					py = casas[sigcasa].y
					pz = casas[sigcasa].z
					distancia = round(GetDistanceBetweenCoords(pizzeria.x, pizzeria.y, pizzeria.z, px,py,pz))
					paga = round(distancia * multiplicador_De_dinero, 0)
					-- [INFO] TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, distancia)
					spawn_emperor2()
					Iracasa(casas,sigcasa)
				end
			end
		end
		if isToHouse == true then
			destinol = casas[sigcasa].name
			drawTxt("TAKE THE CAR AND HEAD TO "..destinol .." AND DELIVER THE PIZZA",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
			DrawMarker(1,casas[sigcasa].x,casas[sigcasa].y,casas[sigcasa].z, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)
			if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(GetPlayerPed(-1),true)) < 3 then
				drawTxt("PRESS <E> TO DELIVER THE PIZZA",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
				if IsControlJustPressed(1,38) then
					posibilidad = math.random(1, 100)
					if (posibilidad > 70) and (posibilidad < 90) then
						propina = math.random(100, 300)
						TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"Here's a tip, thanks! ~ $"..propina)
						TriggerServerEvent("pizzaJob:payForDelivery", propina, property)
					end
					isToHouse = false
					isToPizzaria = true
					RemoveBlip(blip_casa)
					SetNewWaypoint(pizzeria.x,pizzeria.y)
				end
			end
		end
		if isToPizzaria == true then
			drawTxt("HEAD BACK TO THE PIZZERIA TO COLLECT YOUR MONEY",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
			DrawMarker(1,pizzeria.x,pizzeria.y,pizzeria.z, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(pizzeria.x,pizzeria.y,pizzeria.z, GetEntityCoords(GetPlayerPed(-1),true)) < 3 then
					drawTxt("PRESS <E> TO COLLECT REWARD",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
					--if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey("emperor2"))  then
						if IsControlJustPressed(1,38) then
							if IsInVehicle() then
								TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"Thanks for doing the delivery, take your pay: $"..paga)
								local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
								TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
									TriggerServerEvent("pop_pizzero:propina", paga, property)
								end)
								isToHouse = false
								isToPizzaria = false
								isInJobPizz = false
								paga = 0
								px = 0
								py = 0
								pz = 0
								local vehicleu = GetVehiclePedIsIn(GetPlayerPed(-1), false)
								SetEntityAsMissionEntity( vehicleu, true, true )
			               		deleteCar( vehicleu )
								-- remove active job
							else
								TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"I will not pay you if you do not give me my car. I'm sorry.")
							end
						end
					--else
						--TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"I will not pay you if you do not give me my car, I'm sorry.")
					--end
				end
		end
		if IsEntityDead(GetPlayerPed(-1)) then
			 isInJobPizz = false
			 sigcasa = 0
			 isToHouse = false
			 isToPizzaria = false
			 paga = 0
			 px = 0
			 py = 0
			 pz = 0
		end
	end
end)

-------------------------------------------
----------------FUNCIONES------------------
-------------------------------------------

function spawn_emperor2()
	Citizen.Wait(0)

	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('emperor2')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(100)
	end

	local plate = math.random(100, 900)
	local spawned_car = CreateVehicle(vehicle, spawnemperor2.x,spawnemperor2.y,spawnemperor2.z, 431.436, - 996.786, 25.1887, true, false)

	local plate = "CTZN"..math.random(100, 300)
    SetVehicleNumberPlateText(spawned_car, plate)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleLivery(spawned_car, 2)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetEntityAsMissionEntity(spawned_car, true, true)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-------------------------------------------
----------FUNCIONES ADICIONALES------------
-------------------------------------------

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

local blips = {
	{ title="Go Postal", colour=60, id=85, x=-311.6630, y=-1029.1395, z=30.3850 },
	{ title="Go Postal", colour=60, id=85, x=-441.5871, y=6144.7211, z=31.4783 },
	{ title="Go Postal", colour=60, id=85, x=-3157.6508, y=1128.9541, z=20.8447 },
	{ title="Go Postal", colour=60, id=85, x=2983.7958, y=3488.7570, z=71.3818 },
	--{ title="Cannabis Transport", colour = 25, id = 469, x = -1004.18, y = 4848.26, z = 274.01},
	{ title="FridgeIt Trucking", colour = 51, id = 477, x = -574.042, y = 5251.671, z = 70.469  }
}

local peds = {
	{x = -1004.18, y = 4848.26, z = 275.01}, -- weed distributer | PALETO
	--{x = 31.1395, y = -1928.05, z = 20.4}, -- weed distributer | GROVE ST
	{x = 1435.595, y = 6355.136, z = 23.150}, -- weed buyer | GOH
	{x = 2339.37, y = 2570.07, z = 49.7231}, -- weed buyer
	{ x = -875.733, y = -1083.43, z = 2.16288 }, -- weed buyer LS INVENTION ST
	{ x = - 806.306, y = 162.535, z = 71.5399 }, -- weed buyer VINE WOOD
	{ x = 1293.34, y = -1695.4, z = 55.0786 }, -- weed buyer EAST LOS SANTOS
	{ x = 2545.41, y = 343.727, z = 108.466 }, -- weed buyer ROUTE 15 GAS STATION
	{x = -1923.0, y = 553.634, z = 114.711}, -- weed buyer NORTH ROCKFORD DR
	{x=1538.26,y=6324.73,z=24.07}, -- paleto 1
	{x=-2186.82,y=4250.06,z=48.94}, -- paleto 2
	{x=2352.62,y=3132.28,z=48.21} -- paleto 3
}

local weedBuyers = {
	{x = 1435.595, y = 6355.136, z = 23.150},
	{x = 2339.37, y = 2570.07, z = 46.1231},
	{ x = -875.733, y = -1083.43, z = 2.16288 },
	{ x = 1293.34, y = -1695.0, z = 55.0786 },
	{ x = 2545.41, y = 343.727, z = 106.466 },
	{x = -1923.0, y = 553.634, z = 114.711},
	{x=1538.26,y=6324.73,z=24.07}, -- paleto 1
	{x=-2186.82,y=4250.06,z=48.94}, -- paleto 2
	{x=2352.62,y=3132.28,z=48.21} -- paleto 3
}

local gopostal = {
	{ x=-8.1763, y=-1111.0294, z=28.6175 },
	{ x=-317.0818, y=6090.0209, z=31.4622 },
	{ x=-1297.8881, y=-384.5165, z=36.7344 },
	{ x=822.2550, y=-2144.3666, z=28.7616 },
	{ x=-652.4305, y=-940.2009, z=22.0881 },
	{ x=237.428, y=-43.655, z=69.698 },
	{ x=2583.2360, y=286.6179, z=108.4577 },
	{ x=1703.9606, y=3750.3444, z=34.0815 },
	{ x=-1131.3316, y=2699.0109, z=18.8003 }
}

local fridgeItTruckingDropOff = {
	{x = -3250.8, y = 989.944, z = 12.4899},
	{x = -2532.84, y = 2339.42, z = 33.0599},
	{x = -1818.01, y = 805.399, z = 138.617},
	{x = 2566.03, y = 399.011, z = 108.463},
	{x = 579.853, y = 2737.14, z = 42.0038},
	{x = 2687.68, y = 3455.55, z = 55.0758},
	{x = 1708.17, y = 4803.8, z = 41.0013},
	{x = 1994.89, y = 3058.77, z = 47.0521}
}

local retrievedVehicles = {}

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

-- spawn cannabis distributer npc
local hash = GetHashKey("A_M_M_Polynesian_01")
-- thread code stuff below was taken from an example on the wiki
-- Create a thread so that we don't 'wait' the entire game
Citizen.CreateThread(function()
	-- Request the model so that it can be spawned
	RequestModel(hash)
	-- Check if it's loaded, if not then wait and re-request it.
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Citizen.Wait(0)
	end
	-- Model loaded, continue
	-- Spawn the peds
	for i = 1, #peds do
		Citizen.Trace("spawned in ped # " .. i)
		local ped = CreatePed(4, hash, peds[i].x, peds[i].y, peds[i].z, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
	end
end)

local has_valid_dl = false

RegisterNetEvent("go-postal:hadDL")
AddEventHandler("go-postal:hadDL", function()
	print("had DL!!")
	has_valid_dl = true
end)

local pressed = false
local distance = nil
local job = nil
local lastTruck = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	    for _, info in pairs(blips) do
			-- go postal transport job
			if info.title == "Go Postal" and GetDistanceBetweenCoords(info.x, info.y, info.z,GetEntityCoords(GetPlayerPed(-1))) < 50 and not job then
				DrawMarker(1, info.x, info.y, info.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info.x, info.y, info.z, true) < 2 and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false or GetVehiclePedIsIn(GetPlayerPed(-1), false) == lastTruck) then
					DrawSpecialText("Press [ ~g~Enter~w~ ] to start working for Go Postal")
			        if IsControlJustPressed(0, 176) then
						if not has_valid_dl then
							--print("calling check license!")
							TriggerServerEvent("go-postal:checkLicense")
						elseif has_valid_dl then
							has_valid_dl = false
							--print("has valid dl was true!")
							--if not pressed then
								local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
								TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
									job = gopostal[math.random(#gopostal)]
									job.name = "Go Postal"
									job.closest_property = property
									job.distance = GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1)))
									job.truck = -1
									if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= lastTruck or IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
										-- vehicle = GetHashKey("adder")
										vehicle = GetHashKey("boxville2")
										RequestModel(vehicle)
										while not HasModelLoaded(vehicle) do
											RequestModel(vehicle)
											Citizen.Wait(0)
										end
										job.truck = CreateVehicle(vehicle, info.x, info.y, info.z+1.0, 2.0, true, false)
										SetEntityAsMissionEntity(job.truck, true, true)
										table.insert(retrievedVehicles,job.truck)
										--print("inserted into retrievedVehicles: " .. job.truck)
									else
										job.truck = lastTruck
										table.insert(retrievedVehicles,job.truck)
										--print("inserted into retrievedVehicles: " .. job.truck)
									end
									if job.truck ~= -1 then
										SetVehicleOnGroundProperly(job.truck)
										SetVehRadioStation(job.truck, "OFF")
										SetPedIntoVehicle(GetPlayerPed(-1), job.truck, -1)
										SetVehicleEngineOn(job.truck, true, false, false)
										SetEntityAsMissionEntity(job.truck, true, true)
										--SetNewWaypoint(job.x, job.y)
										TriggerEvent("swayam:SetWayPointWithAutoDisable", job.x, job.y, job.z, 1, 60, "Go Postal Destination")
										lastTruck = job.truck
										TriggerServerEvent("transport:addJob", job)
									else
										SetNotificationTextEntry("STRING")
										AddTextComponentString("Failed to get truck! Try again.")
										DrawNotification(0,1)
										job = nil
									end
									pressed = true
									while pressed do
										Wait(0)
										if(IsControlJustPressed(0, 176) == false) then
											pressed = false
											break
										end
									end
								end)
							--end
						end
	                end
				end
			end
			-- cannabis transport job
			if info.title == "Cannabis Transport" and GetDistanceBetweenCoords(info.x, info.y, info.z,GetEntityCoords(GetPlayerPed(-1))) < 50 and not job then
				DrawMarker(1, info.x, info.y, info.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info.x, info.y, info.z, true) < 2 then
					DrawSpecialText("Press [ ~g~Enter~w~ ] to get a package of ~y~20g of concentrated cannabis")
					if IsControlJustPressed(0, 176) then -- ENTER = 176
			            if not pressed then
							job = weedBuyers[math.random(#weedBuyers)]
							job.name = "Cannabis Transport"
							job.distance = GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1)))
							SetNewWaypoint(job.x, job.y)
							TriggerServerEvent("transport:addJob", job)
							pressed = true
							SetNotificationTextEntry("STRING")
							AddTextComponentString("Here are the directions to your destination. Don't get caught!")
							DrawNotification(0,1)
			                while pressed do
			                    Wait(0)
			                    if(IsControlJustPressed(0, 176) == false) then
			                        pressed = false
			                        break
			                    end
			                end
		                end
	                end
				end
			end
			-- fridge it trucking job
			if info.title == "FridgeIt Trucking" and GetDistanceBetweenCoords(info.x, info.y, info.z,GetEntityCoords(GetPlayerPed(-1))) < 50 and not job then
				DrawMarker(1, info.x, info.y, info.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), info.x, info.y, info.z, true) < 2 and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false or GetVehiclePedIsIn(GetPlayerPed(-1), false) == lastTruck) then
					DrawSpecialText("Press [ ~g~Enter~w~ ] to start working for FridgeIt Trucking")
			        if IsControlJustPressed(0, 176) then -- ENTER = 176
						if not has_valid_dl then TriggerServerEvent("go-postal:checkLicense") end
						if has_valid_dl then
							if not pressed then
								local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
								TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
									job = fridgeItTruckingDropOff[math.random(#fridgeItTruckingDropOff)]
									job.closest_property = property
									job.name = "FridgeIt Trucking"
									job.distance = GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1)))
									job.truck = -1
									if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= lastTruck or IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
										-- vehicle = GetHashKey("adder")
										--vehicle = GetHashKey("boxville2")
										vehicle = tonumber(2112052861) -- semi truck (pounder)
										RequestModel(vehicle)
										while not HasModelLoaded(vehicle) do
											RequestModel(vehicle)
											Citizen.Wait(0)
										end
										job.truck = CreateVehicle(vehicle, info.x, info.y, info.z+1.0, 2.0, true, false)
										SetEntityAsMissionEntity(job.truck, true, true)
										table.insert(retrievedVehicles,job.truck)
										print("inserted into retrievedVehicles: " .. job.truck)
									else
										job.truck = lastTruck
										table.insert(retrievedVehicles,job.truck)
										print("inserted into retrievedVehicles: " .. job.truck)
									end
									if job.truck ~= -1 then
										SetVehicleOnGroundProperly(job.truck)
										SetVehRadioStation(job.truck, "OFF")
										SetPedIntoVehicle(GetPlayerPed(-1), job.truck, -1)
										SetVehicleEngineOn(job.truck, true, false, false)
										SetEntityAsMissionEntity(job.truck, true, true)
										--SetNewWaypoint(job.x, job.y)
										TriggerEvent("swayam:SetWayPointWithAutoDisable", job.x, job.y, job.z, 1, 60, "FridgeIt Destination")
										lastTruck = job.truck
										TriggerServerEvent("transport:addJob", job)
									else
										SetNotificationTextEntry("STRING")
										AddTextComponentString("Failed to get truck! Try again.")
										DrawNotification(0,1)
										job = nil
									end
									pressed = true
									SetNotificationTextEntry("STRING")
									AddTextComponentString("Here are directions to your delivery location. Have a nice ride!")
									DrawNotification(0,1)
									while pressed do
										Wait(0)
										if(IsControlJustPressed(0, 176) == false) then
											pressed = false
											break
										end
									end
								end)
							end
						end
	                end
				end
			end
		end
		if job and GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1))) < 50 then
			DrawMarker(1, job.x, job.y, job.z + 0.01, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 32, 0, 90, 0, 0, 2, 0, 0, 0, 0)
			if job.name == "Go Postal" then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), job.x, job.y, job.z, true) < 4 and GetVehiclePedIsIn(GetPlayerPed(-1), false) == job.truck then
					DrawSpecialText("Press [ ~g~E~w~ ] to deliver your Go Postal packages")
			        if IsControlJustPressed(0, 86) then
			            if not pressed then
							if job.distance * 2 > 3600 then
								pay = 3600
							else
								pay = math.ceil(job.distance * 2)
							end
							-- notify user
							SetNotificationTextEntry("STRING")
							AddTextComponentString("~h~Job Completed!~h~ ~n~" .. "+ ~g~$" .. pay .. "\n~w~Next location set.")
							TriggerServerEvent("transport:giveMoney", pay, job)
							DrawNotification(0,1)
							-- give next location:
							local temp_truck = job.truck
							job = gopostal[math.random(#gopostal)]
							job.name = "Go Postal"
							job.distance = GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1)))
							job.truck = temp_truck
							--SetNewWaypoint(job.x, job.y)
							TriggerEvent("swayam:SetWayPointWithAutoDisable", job.x, job.y, job.z, 1, 60, "GoPostal Destination")
							TriggerServerEvent("transport:addJob", job)
							-- not sure what below code is for:
							pressed = true
			                while pressed do
			                    Wait(0)
			                    if(IsControlJustPressed(0, 86) == false) then
			                        pressed = false
			                        break
			                    end
			                end
		                end
					end
				end
			elseif job.name == "Cannabis Transport" then
				--DrawMarker(1, job.x, job.y, job.z-1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.25, 0, 155, 255, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), job.x, job.y, job.z, true) < 7 then
					DrawSpecialText("Press [ ~g~E~w~ ] to deliver the cannabis!")
					if IsControlJustPressed(0, 86) then -- E = 86
						if not pressed then
							if job.distance * 2 > 6000 then
								pay = 6000
							else
								pay = math.ceil(job.distance * 2)
							end
							-- notify user
							SetNotificationTextEntry("STRING")
							AddTextComponentString("~h~Job Completed!~h~ ~n~" .. "+ ~g~$" .. pay)
							DrawNotification(0,1)
							TriggerServerEvent("transport:giveMoney", pay, job)
							-- set variables
							job = nil
							pressed = true
							while pressed do
								Wait(0)
								if(IsControlJustPressed(0, 86) == false) then
									pressed = false
									break
								end
							end
						end
					end
				end
			elseif job.name == "FridgeIt Trucking" then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), job.x, job.y, job.z, true) < 4 and GetVehiclePedIsIn(GetPlayerPed(-1), false) == job.truck then
					DrawSpecialText("Press [ ~g~E~w~ ] to deliver your goods.")
			        if IsControlJustPressed(0, 86) then
			            if not pressed then
							if job.distance * 2 > 3000 then
								pay = 3000
							else
								pay = math.ceil(job.distance * 2)
							end
							-- notify user
							SetNotificationTextEntry("STRING")
							AddTextComponentString("~h~Job Completed!~h~ ~n~" .. "+ ~g~$" .. pay .. "\n~w~Next location set.")
							TriggerServerEvent("transport:giveMoney", pay, job)
							DrawNotification(0,1)
							-- set next location:
							local temp_truck = job.truck
							job = fridgeItTruckingDropOff[math.random(#fridgeItTruckingDropOff)]
							job.name = "FridgeIt Trucking"
							job.distance = GetDistanceBetweenCoords(job.x, job.y, job.z, GetEntityCoords(GetPlayerPed(-1)))
							job.truck = temp_truck
							print("setting new trucking WP: x = " .. job.x .. ", y = " .. job.y)
							--SetNewWaypoint(job.x, job.y)
							TriggerEvent("swayam:SetWayPointWithAutoDisable", job.x, job.y, job.z, 1, 60, "FridgeIt Destination")
							TriggerServerEvent("transport:addJob", job)
							-- not sure what below code is for:
							pressed = true
			                while pressed do
			                    Wait(0)
			                    if(IsControlJustPressed(0, 86) == false) then
			                        pressed = false
			                        break
			                    end
			                end
		                end
					end
				end
			end
		end
	end
end)

RegisterNetEvent("transport:quitJob")
AddEventHandler("transport:quitJob", function()
	--ClearGpsPlayerWaypoint()
	TriggerEvent("swayam:RemoveWayPoint")
	pressed = false
	distance = nil
	job = nil
	lastTruck = 0
	Citizen.Trace("#retrievedVehicles = " .. #retrievedVehicles)
	for i =1, #retrievedVehicles do
		SetEntityAsMissionEntity( retrievedVehicles[i], true, true )
		deleteCar( retrievedVehicles[i] )
	end
	for i=1, #retrievedVehicles do
		table.remove(retrievedVehicles)
	end
end)

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

RegisterNetEvent("placeMarker")
AddEventHandler("placeMarker", function(x, y, z) -- todo: add Z parameter to all calls
	--ClearGpsPlayerWaypoint()
	--SetNewWaypoint(x, y)
	TriggerEvent("swayam:SetWayPointWithAutoDisable", x, y, z, 280, 60, "Go Postal Destination")
end)

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

function serializeTable(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)

	if name then tmp = tmp .. name .. " = " end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	end

	return tmp
end

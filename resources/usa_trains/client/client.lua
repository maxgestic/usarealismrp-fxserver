local train = nil
local trainNID = nil
local trainSpeed = 0.0
local isDriver = false
local isPassanger = false
local passangerTrain = nil
local doors = false
SetTrainsForceDoorsOpen(false)
local lastDoorToggle = GetGameTimer()
local trainstations = {
	[1] = {coords = vector3(-1042.2565, -2745.7266, 15.9190)},
	[2] = {coords = vector3(-946.0543, -2340.5015, 6.5338)},
	[3] = {coords = vector3(-540.6730, -1282.5905, 33.4663)},
	[4] = {coords = vector3(271.1004, -1204.2211, 38.9169)},
	[5] = {coords = vector3(-246.2736, -330.3786, 31.9112)},
	[6] = {coords = vector3(-824.7607, -112.1072, 31.0874)},
	[7] = {coords = vector3(-1363.5077, -524.0391, 29.8416)},
	[8] = {coords = vector3(-490.6987, -695.5313, 35.5731)},
	[9] = {coords = vector3(-220.9811, -1036.7648, 34.3784)},
	[10] = {coords = vector3(112.1726, -1723.6456, 33.1850)},
}

Citizen.CreateThread(function()
	for i,v in ipairs(trainstations) do
		local blip = AddBlipForCoord(v.coords)
		SetBlipHiddenOnLegend(blip, true)
		SetBlipSprite(blip, 9)
		SetBlipDisplay(blip, 8)
		SetBlipScale(blip, 0.08)
		SetBlipColour(blip, 0)
		SetBlipAlpha(blip, 200)
		SetBlipAsShortRange(blip, true)
		EndTextCommandSetBlipName(blip)
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite(blip, 124)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.35)
		SetBlipColour(blip, 61)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Metro Station')
		EndTextCommandSetBlipName(blip)
	end
end)

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

function takeOwn(object)
	NetworkRequestControlOfEntity(object)
    while not NetworkHasControlOfEntity(object) do
        Wait(100)
    end
    SetEntityAsMissionEntity(object, true, true)
    while not IsEntityAMissionEntity(object) do
        Wait(100)
    end
end

function alert(msg)
	SetTextComponentFormat("STRING")
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyTrain(GetPlayerPed(-1)) and isDriver then
			if GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey("metrotrain") then
				if (GetEntitySpeed(train) == 0) then
					alert("~b~Horn ~INPUT_VEH_HORN~\n~b~Open/Close Doors ~INPUT_DETONATE~\n~b~Leave Train ~INPUT_ENTER~")
				else
					alert("~b~Horn ~INPUT_VEH_HORN~")
				end
			else
				if (GetEntitySpeed(train) == 0) then
					alert("~b~Horn ~INPUT_VEH_HORN~\n~b~Leave Train ~INPUT_ENTER~")
				else
					alert("~b~Horn ~INPUT_VEH_HORN~")
				end
			end
			DisableControlAction(0, 75, true)
			if IsControlPressed(0, 71) and trainSpeed < 27.495 and not doors then
				trainSpeed = trainSpeed + 0.1
			elseif IsControlPressed(0, 72) and trainSpeed > -7 and not doors and GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) ~= GetHashKey("metrotrain") then 
				trainSpeed = trainSpeed - 0.1
			elseif IsControlPressed(0, 72) and trainSpeed > 0 and not doors and GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey("metrotrain") then 
				trainSpeed = trainSpeed - 0.1
			elseif IsControlPressed(0, 22) and not doors then
				if trainSpeed > 5.0 then
					trainSpeed = trainSpeed - 1.0
				elseif trainSpeed < 5.0 and trainSpeed > -5.0 then
					trainSpeed = 0
				elseif trainSpeed < -5.0 then
				 	trainSpeed = trainSpeed + 1.0
				 end
			elseif IsControlJustReleased(0, 47) and GetEntitySpeed(train) == 0 then
				toggleDoors()
			end
			local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			SetTrainCruiseSpeed(playerVeh, trainSpeed)
			DrawTxt(0.663, 1.418, 1.0, 1.0, 0.55, math.floor(GetEntitySpeed(playerVeh)*2.2, 0) .. '', 255, 255, 255, 255)
			DrawTxt(0.684, 1.425, 1.0, 1.0, 0.35, 'mph', 255, 255, 255, 255)
			if IsDisabledControlJustReleased(0, 75) and GetEntitySpeed(playerVeh) == 0 then
				DoScreenFadeOut(500)
				Citizen.Wait(1000)
				isDriver = false
				TaskLeaveVehicle(GetPlayerPed(-1), playerVeh, 16)
				Citizen.Wait(1500)
				DoScreenFadeIn(500)
			end
		end
		if isPassanger then
			if (GetEntitySpeed(passangerTrain) == 0) then
				alert("~b~Switch Seats ~INPUT_MOVE_DOWN_ONLY~\n~b~Leave Train ~INPUT_ENTER~")
			else
				alert("~b~Switch Seats ~INPUT_MOVE_DOWN_ONLY~")
			end

			if IsDisabledControlJustReleased(0, 75) and GetEntitySpeed(passangerTrain) == 0 then
				local trainNetID = NetworkGetNetworkIdFromEntity(passangerTrain)
				DoScreenFadeOut(500)
				Citizen.Wait(600)
				TriggerServerEvent("usa_trains:seat", trainNetID, GetPlayerPed(-1))
			elseif IsControlJustReleased(0, 33) then
				local trainNetID = NetworkGetNetworkIdFromEntity(passangerTrain)
				TriggerServerEvent("usa_trains:moveseat", trainNetID, GetPlayerPed(-1))
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for vehicle in EnumerateVehicles() do
			if GetEntityModel(vehicle) == GetHashKey("streakcoaster") and (Vdist2(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(vehicle)) < 25) and IsVehicleSeatFree(vehicle, -1) and IsVehicleSeatFree(vehicle, 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then 
				alert("~b~Enter Train as Driver ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					DoScreenFadeOut(500)
					Citizen.Wait(750)
					SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
					isDriver = true
					Citizen.Wait(500)
					DoScreenFadeIn(500)
	            end
	        elseif GetEntityModel(vehicle) == GetHashKey("streakcoasterc") and (Vdist2(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(vehicle)) < 25) and not isPassanger then 
	        	alert("~b~Enter Train as Passanger ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					local trainNetID = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("usa_trains:seat", trainNetID, GetPlayerPed(-1))
	            end
	        elseif GetEntityModel(vehicle == GetHashKey("metrotrain")) and (Vdist2(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(vehicle)) < 25) and IsVehicleSeatFree(vehicle, -1) and IsVehicleSeatFree(vehicle, 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and IsVehicleSeatFree(GetTrainCarriage(vehicle, 1), -1) and IsVehicleSeatFree(GetTrainCarriage(vehicle, 1), 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then
	        	alert("~b~Enter Metro as Driver ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					DoScreenFadeOut(500)
					Citizen.Wait(750)
					SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
					isDriver = true
					Citizen.Wait(500)
					DoScreenFadeIn(500)
	            end
			end
		end
	end
end)

RegisterNetEvent("usa_trains:seat_player")
AddEventHandler("usa_trains:seat_player", function(seat, trainID)
	local trainent = NetworkGetEntityFromNetworkId(trainID)
	local dict = "amb@prop_human_seat_chair_mp@male@generic@base"
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
	passangerTrain = trainent
	DoScreenFadeOut(500)
	Citizen.Wait(600)
	TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 8.0, -1, 69, 1, false, false, false)
	AttachEntityToEntity(GetPlayerPed(-1), trainent, 0, seat.x, seat.y, seat.z, 0, 0, seat.rotation, true, false, false, false, 2, true)
	isPassanger = true
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNetEvent("usa_trains:moveseat_player")
AddEventHandler("usa_trains:moveseat_player", function(seat, trainID)
	DoScreenFadeOut(500)
	Citizen.Wait(600)
	local trainent = NetworkGetEntityFromNetworkId(trainID)
	AttachEntityToEntity(GetPlayerPed(-1), trainent, 0, seat.x, seat.y, seat.z, 0, 0, seat.rotation, true, false, false, false, 2, true)
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNetEvent("usa_trains:unseat_player")
AddEventHandler("usa_trains:unseat_player", function()
	isPassanger = false
	DetachEntity(PlayerPedId(), true, false)
	local coords = GetOffsetFromEntityInWorldCoords(passangerTrain, -2.0, 0.0, -0.5)
	SetEntityCoords(PlayerPedId(), coords.x,coords.y,coords.z)
	passangerTrain = nil
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNetEvent("usa_trains:no_seats")
AddEventHandler("usa_trains:no_seats", function()
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterCommand("delTrain", function()
	local dtrain = NetworkGetEntityFromNetworkId(trainNID)
	takeOwn(dtrain)
	if (NetworkGetEntityOwner(dtrain) == 128) then
		DeleteMissionTrain(dtrain)
		train = nil
		trainNID= nil
		trainSpeed = 0.0
	end
end, false)

RegisterCommand("spawnTrain", function(source, args, rawCommand)
	if not train then
		local train_models = {"freight", "freightcar", "freightcar2", "freightcont1", "freightcont2", "freightgrain", "metrotrain", "tankercar", "streakcoaster", "streakcoastercab", "streakcoasterc"}

		for i,v in ipairs(train_models) do
			local hash = GetHashKey(v)
			RequestModel(v)
			while not HasModelLoaded(v) do
				RequestModel(v)
				Citizen.Wait(0)
			end
		end

		local coords = vector3(GetEntityCoords(GetPlayerPed(-1)))
		train = CreateMissionTrain(tonumber(args[1]), coords.x, coords.y, coords.z, true)
		trainNID = NetworkGetNetworkIdFromEntity(train)
		local trainNetID = NetworkGetNetworkIdFromEntity(GetTrainCarriage(train, 1))
		doors = false
		SetEntityAsMissionEntity(train, true, false)
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(train), false)
		NetworkDisableProximityMigration(NetworkGetNetworkIdFromEntity(train))
		TriggerServerEvent("usa_trains:createTrain", trainNetID, source)
		SetTrainSpeed(train,0)
		SetTrainCruiseSpeed(train,0)
		SetEntityAsMissionEntity(train, true, false)
	end
end, false)

RegisterCommand("tpTrain", function()
	StartPlayerTeleport(PlayerId(), 670.2056, -685.7708, 25.15311, 0.0, false, true, true)
end, false)


RegisterCommand("doors", function()
	toggleDoors()
end, false)

function toggleDoors()
	if GetGameTimer() - lastDoorToggle > 500 then
		lastDoorToggle = GetGameTimer()
		TriggerServerEvent("usa_trains:toggleDoors", trainNID, doors)
		doors = not doors
	end
end

RegisterNetEvent("usa_trains:toggleDoorsC")
AddEventHandler("usa_trains:toggleDoorsC", function(trainID, open)
	local lTrain = NetworkGetEntityFromNetworkId(trainID)
	local doorCount = GetTrainDoorCount(lTrain)
	local carrige = GetTrainCarriage(lTrain, 1)
	for doorIndex = 0, doorCount - 1 do
		if open then
			Citizen.CreateThread(function ()
				for i=9,0,-1 do
					local doorRatio = i/10
					SetTrainDoorOpenRatio(lTrain, doorIndex, doorRatio)
					SetTrainDoorOpenRatio(carrige, doorIndex, doorRatio)
					Wait(10)
				end
			end)
		else
			Citizen.CreateThread(function ()
				for i=1,10 do
					local doorRatio = i/10
					SetTrainDoorOpenRatio(lTrain, doorIndex, doorRatio)
					SetTrainDoorOpenRatio(carrige, doorIndex, doorRatio)
					Wait(10)
				end
			end)
		end
	end
end)
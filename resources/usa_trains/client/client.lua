local train = nil
local trainNID = nil
local trainSpeed = 0.0
local isDriver = false
local isPassanger = false
local passangerTrain = nil

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
			DisableControlAction(0, 75, true)
			if IsControlPressed(0, 71) and trainSpeed < 27.495 then
				trainSpeed = trainSpeed + 0.1
			elseif IsControlPressed(0, 72) and trainSpeed > -7 then 
				trainSpeed = trainSpeed - 0.1
			elseif IsControlPressed(0, 22) then
				if trainSpeed > 5.0 then
					trainSpeed = trainSpeed - 1.0
				elseif trainSpeed < 5.0 and trainSpeed > -5.0 then
					trainSpeed = 0
				elseif trainSpeed < -5.0 then
				 	trainSpeed = trainSpeed + 1.0
				 end
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
			if (GetEntityModel(vehicle) == GetHashKey("streakcoaster") or GetEntityModel(vehicle) == GetHashKey("metrotrain")) and (Vdist2(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(vehicle)) < 25) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then 
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
		SetEntityAsMissionEntity(train, true, false)
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(train), false)
		NetworkDisableProximityMigration(NetworkGetNetworkIdFromEntity(train))
		TriggerServerEvent("usa_trains:createTrain", trainNetID)
		SetTrainSpeed(train,0)
		SetTrainCruiseSpeed(train,0)
		SetEntityAsMissionEntity(train, true, false)
	end
end, false)

RegisterCommand("tpTrain", function()
	StartPlayerTeleport(PlayerId(), 670.2056, -685.7708, 25.15311, 0.0, false, true, true)
end, false)

local doors = false
RegisterCommand("doors", function()
	doors = not doors
	SetTrainsForceDoorsOpen(doors)
end, false)
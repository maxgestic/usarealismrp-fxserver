local train = nil
local trainNID = nil
local trainSpeed = 0.0
local isDriver = false
local isPassanger = false
local passangerTrain = nil
local isMetroJob = false
local isTrainJob = false
local doors = false
SetTrainsForceDoorsOpen(false)
local lastDoorToggle = GetGameTimer()
local metrostations = {
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
local trainstations = {
	[1] = {coords = vector3(655.3147, -1215.3457, 27.1136)},
	[2] = {coords = vector3(2325.4028, 2676.2734, 48.2334)},
	[3] = {coords = vector3(1768.6127, 3491.1086, 42.0864)},
	[4] = {coords = vector3(-235.7802, 6037.5923, 37.3782)},
	[5] = {coords = vector3(2886.9177, 4850.3159, 66.7778)},
	[6] = {coords = vector3(2616.0828, 1679.5931, 29.3498)},
	[7] = {coords = vector3(674.3034, -966.7263, 26.5136)},
}
local cargostations = {
	[1] = {coords = vector3(2201.1565, 1362.0720, 85.5326)},
	[2] = {coords = vector3(3026.0645, 4255.8647, 64.0981)},
}

local trainBlipTable = {}
local showingBlips = true

local trainFlipPointSouth = vector3(396.0495, -2617.6992, 13.3674)
local trainFlipPointNorth = vector3(1382.2756, 6416.7627, 33.3126)

local metroFlipPointSouth = vector3(-1232.5068, -2885.6240, -8.9238)
local metroFlipPointNorth = vector3(553.0604, -1984.6080, 17.1745)

local currentTrack = nil

local hasMetroTicket = false

local serverTrainNIDs = {}

local metroTicketMachines = {
	[1] = {coords = vector3(-906.2183, -2319.8718, -3.5077)},
	[2] = {coords = vector3(-905.8086, -2318.5776, -3.5077)},
	[3] = {coords = vector3(-905.3441, -2317.2703, -3.5077)},
	[4] = {coords = vector3(-904.8586, -2315.9211, -3.5077)},
	[5] = {coords = vector3(-908.4088, -2350.0613, -3.4678)},
	[6] = {coords = vector3(-908.6968, -2351.4019, -3.5075)},
	[7] = {coords = vector3(-909.1623, -2352.7751, -3.5075)},
	[8] = {coords = vector3(-909.7504, -2354.1548, -3.5075)},
	-- [] = {coords = vector3()},
}


Citizen.CreateThread(function()
	for i,v in ipairs(metrostations) do
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite(blip, 607)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Metro Station')
		EndTextCommandSetBlipName(blip)
	end
	for i,v in ipairs(trainstations) do
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite(blip, 473)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.35)
		SetBlipColour(blip, 61)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Train Station')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if isDriver then
			if currentTrack == "north" then
				if (#(GetEntityCoords(train) - trainFlipPointNorth) < 30 or #(GetEntityCoords(train) - metroFlipPointNorth) < 30) then
					-- print("switching to southbound")
					currentTrack = "south"
					TriggerServerEvent("usa_trains:setTrainTrack", trainNID, currentTrack, "metro")
				end
			elseif currentTrack == "south" then

				if (#(GetEntityCoords(train) - trainFlipPointSouth) < 30 or #(GetEntityCoords(train) - metroFlipPointSouth) < 30) then
					-- print("switching to northbound")
					currentTrack = "north"
					TriggerServerEvent("usa_trains:setTrainTrack", trainNID, currentTrack, "metro")
				end
			end
		end
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

Citizen.CreateThread(function() -- train controlls
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
				TriggerEvent("usa_hud:setTrain", false)
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

Citizen.CreateThread(function() -- train enter prompts
	while true do
		Citizen.Wait(0)
		for i,v in ipairs(serverTrainNIDs) do
			local vehicle = NetworkGetEntityFromNetworkId(v)
			if isTrainJob and GetEntityModel(vehicle) == GetHashKey("streakcoaster") and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5 and IsVehicleSeatFree(vehicle, -1) and IsVehicleSeatFree(vehicle, 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then 
				alert("~b~Enter Train as Driver ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("usa_trains:checkTrainDriver", id)
	            end
	        elseif GetEntityModel(vehicle) == GetHashKey("streakcoasterc") and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5 and not isPassanger then 
	        	alert("~b~Enter Train as Passanger ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					local trainNetID = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("usa_trains:seat", trainNetID, GetPlayerPed(-1))
	            end
	        elseif isMetroJob and GetEntityModel(vehicle == GetHashKey("metrotrain")) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5 and IsVehicleSeatFree(vehicle, -1) and IsVehicleSeatFree(vehicle, 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and IsVehicleSeatFree(GetTrainCarriage(vehicle, 1), -1) and IsVehicleSeatFree(GetTrainCarriage(vehicle, 1), 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then
	        	alert("~b~Enter Metro as Driver ~INPUT_CONTEXT~")
				if IsControlJustPressed(1, 51) then
					local id = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("usa_trains:checkTrainDriver", id)
	            end
			end
		end
	end 
end)

Citizen.CreateThread(function() -- ticket machines
	while true do
		Citizen.Wait(0)
		for i,v in ipairs(metroTicketMachines) do
			if #(v.coords - GetEntityCoords(PlayerPedId())) < 1.0 then
				alert("~b~Buy Day Metro Pass ~INPUT_ENTER~")
				if IsControlPressed(0, 75) then
					if not hasMetroTicket then
						TriggerServerEvent("usa_trains:buyTicket", "metro")
						Wait(100)
					else
						TriggerEvent("usa:notify", "You already have a Day Metro pass for today")
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function() -- ticket checking
	while true do
		Citizen.Wait(0)
		if IsPedInAnyTrain(GetPlayerPed(-1)) and GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 0 and not isMetroJob and not isTrainJob then
			if not hasMetroTicket then
				local grace_time = 30
				local enter_time = GetGameTimer()
				local left = false
				TriggerServerEvent("usa_trains:passengerNoTicket", vector3(GetEntityCoords(PlayerPedId())))
				while GetGameTimer() - enter_time < grace_time * 1000 do
					Wait(0)
					alert("You do not have a train ticket, leave the train! You have " .. math.floor((30 - ((GetGameTimer() - enter_time)/1000))) .. " seconds before the police is called")
					if not IsPedInAnyTrain(GetPlayerPed(-1)) then
						left = true
						break
					end
				end
				if not left then
					while IsPedInAnyTrain(PlayerPedId()) and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) do
						Wait(0)
						alert("911 Called")
						-- TODO: Implement 911 Call
					end
				else
					alert("Thank you for leaving please buy a ticket!")
				end
			end
		end
	end
end)

RegisterNetEvent("usa_trains:issueTicket")
AddEventHandler("usa_trains:issueTicket", function(type, bool)
	if type == "metro" then
		hasMetroTicket = bool
	end
end)

RegisterNetEvent("usa_trains:checkTrainDriverCB")
AddEventHandler("usa_trains:checkTrainDriverCB", function (netID, bool)
	if bool then
		local vehicle = NetworkGetEntityFromNetworkId(netID)
		DoScreenFadeOut(500)
		Citizen.Wait(750)
		SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		isDriver = true
		Citizen.Wait(500)
		DoScreenFadeIn(500)
		TriggerEvent("usa_hud:setTrain", true)
	else
		TriggerEvent("usa:notify", "This train is not issued to you!")
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
		TriggerServerEvent("usa_trains:deleteTrainServer", trainNID)
		DeleteMissionTrain(dtrain)
		train = nil
		trainNID= nil
		trainSpeed = 0.0
	end
end, false)

function spawnTrain(type)
	if not train then
		local train_models = {}
		local train_type = "Train"
		if type == 25 then
			train_models = {"metrotrain"}
			train_type = "Metro"
		elseif type == 0 then
			train_models = {"streakcoaster", "streakcoasterc"}
		else
			train_models = {"freight", "freightcar", "freightcar2", "freightcont1", "freightcont2", "freightgrain", "metrotrain", "tankercar", "streakcoaster", "streakcoastercab", "streakcoasterc"}
		end
		for i,v in ipairs(train_models) do
			local hash = GetHashKey(v)
			RequestModel(v)
			while not HasModelLoaded(v) do
				RequestModel(v)
				Citizen.Wait(0)
			end
		end
		train = CreateMissionTrain(tonumber(type), -900.0752, -2343.4150, -12.6036, true)
		trainNID = NetworkGetNetworkIdFromEntity(train)
		local carrigeNID = NetworkGetNetworkIdFromEntity(GetTrainCarriage(train, 1))
		doors = false
		SetEntityAsMissionEntity(train, true, false)
		SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(train), false)
		NetworkDisableProximityMigration(NetworkGetNetworkIdFromEntity(train))
		TriggerServerEvent("usa_trains:createTrain", trainNID, carrigeNID, train_type)
		SetTrainSpeed(train,0)
		SetTrainCruiseSpeed(train,0)
		SetEntityAsMissionEntity(train, true, false)
		currentTrack = "south"
		TriggerServerEvent("usa_trains:setTrainTrack", trainNID, currentTrack, "metro")
	end
end

RegisterCommand("spawnMetro", function()
	isMetroJob = true
	spawnTrain(25)
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
	for doorIndex = 0, 2, 2 do
		if open then
			Citizen.CreateThread(function ()
				for i=9,0,-1 do
					local doorRatio = i/10
					SetTrainDoorOpenRatio(lTrain, doorIndex, doorRatio)
					SetTrainDoorOpenRatio(carrige, doorIndex + 1, doorRatio)
					Wait(10)
				end
			end)
		else
			Citizen.CreateThread(function ()
				for i=1,10 do
					local doorRatio = i/10
					SetTrainDoorOpenRatio(lTrain, doorIndex, doorRatio)
					SetTrainDoorOpenRatio(carrige, doorIndex + 1, doorRatio)
					Wait(10)
				end
			end)
		end
	end
end)

local breaking = false
RegisterNetEvent("usa_trains:checkDistances")
AddEventHandler("usa_trains:checkDistances", function(trainNetworkID, trainType, trainTable)
	for i,v in ipairs(trainTable) do
		if trainNetworkID ~= v.id and trainType == v.type then
			if #(GetEntityCoords(NetworkGetEntityFromNetworkId(trainNetworkID)) - GetEntityCoords(NetworkGetEntityFromNetworkId(v.id))) < 280 and not breaking then
				breaking = true
				while trainSpeed ~= 0.0 do
					-- print(trainSpeed)
					if trainSpeed > 0.2 then
						trainSpeed = trainSpeed - 0.1
					elseif trainSpeed < -0.2 then
						trainSpeed = trainSpeed + 0.1
					else
						trainSpeed = 0
					end
				end
				breaking = false
			end
		end
	end
end)

RegisterNetEvent("usa_trains:syncCreateTrain")
AddEventHandler("usa_trains:syncCreateTrain", function(id1, id2)
	table.insert(serverTrainNIDs, id1)
	table.insert(serverTrainNIDs, id2)
end)

RegisterNetEvent("usa_trains:syncDeleteTrain")
AddEventHandler("usa_trains:syncDeleteTrain", function(id1, id2)
	for i,v in ipairs(serverTrainNIDs) do
		if v == id1 then
			table.remove(serverTrainNIDs, i)
		end
	end
	for i,v in ipairs(serverTrainNIDs) do
		if v == id2 then
			table.remove(serverTrainNIDs, i)
		end
	end
end)

function RemoveTrainBlips()
	for i = #trainBlipTable, 1, -1 do
		local b = trainBlipTable[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(trainBlipTable, i)
		end
	end
end

function RefreshTrainBlips(Ttable)
	for k,v in pairs(Ttable) do
		if v and v.name and v.coords then
			local blip = AddBlipForCoord(v.coords)
			SetBlipSprite(blip, 795)
			SetBlipColour(blip, 41)
			SetBlipAsShortRange(blip, true)
			SetBlipDisplay(blip, 4)
			SetBlipShowCone(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
			table.insert(trainBlipTable, blip)
		end
	end
end

RegisterNetEvent("usa_trains:toggleTrainBlips")
AddEventHandler("usa_trains:toggleTrainBlips", function(bool)
	showingBlips = bool
	if not showingBlips then
		RemoveTrainBlips()
	end
end)

RegisterNetEvent("usa_trains:updateAll")
AddEventHandler("usa_trains:updateAll", function(Ttable)
	if showingBlips then
		RemoveTrainBlips()
		RefreshTrainBlips(Ttable)
	end
end)
local train = nil
local trainNID = nil
local trainSpeed = 0.0
local isDriver = false
local isPassanger = false
local passangerTrain = nil
local isMetroJob = false
local isTrainJob = false
local isEMS = false
local doors = false
local lastDoorToggle = GetGameTimer()
local showingMetroBlips = false
local showingTrainBlips = false
local hasMetroTicket = false
local hasTrainTicket = false
local serverTrainNIDs = {}
local openCoords = nil
local metroClockIn = vector3(-918.1724, -2345.6904, -3.5075)
local trainClockIn = vector3(235.8775, -2506.5186, 6.4852)
local isHelpShowing = false
local disableControlHint = false
local breaking = false
local called = false
local leftNoTicket = false
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
local ticketMachines = {
	vector3(656.5287, -1216.6416, 24.7288),
	vector3(656.5995, -1215.4160, 24.7288),
	vector3(656.6309, -1214.1396, 24.7288),
	vector3(656.5386, -1212.8849, 24.7288),
	vector3(654.2658, -1212.8998, 24.7287),
	vector3(654.2506, -1214.1533, 24.7287),
	vector3(654.2059, -1215.4633, 24.7287),
	vector3(654.1624, -1216.6091, 24.7287),
	vector3(675.1742, -968.1018, 23.4772),
	vector3(675.1564, -966.8605, 23.4772),
	vector3(675.2309, -965.5681, 23.4772),
	vector3(675.1404, -964.4034, 23.4772),
	vector3(672.9257, -964.4099, 23.4773),
	vector3(672.8621, -965.6062, 23.4773),
	vector3(672.8605, -966.7598, 23.4773),
	vector3(672.8602, -968.1181, 23.4773),
	vector3(2328.3696, 2676.4756, 45.5602),
	vector3(2327.2871, 2676.0879, 45.5602),
	vector3(2326.1616, 2675.5554, 45.5602),
	vector3(2325.0371, 2675.0825, 45.5602),
	vector3(2328.4436, 2676.4978, 45.5601),
	vector3(2327.3330, 2676.0420, 45.5601),
	vector3(2326.0913, 2675.5286, 45.5602),
	vector3(2324.9307, 2675.0571, 45.5602),
	vector3(1769.5721, 3490.7168, 39.4500),
	vector3(1768.5219, 3490.0818, 39.4500),
	vector3(1767.4751, 3489.5032, 39.4500),
	vector3(1766.2870, 3488.8232, 39.4500),
	vector3(1765.2615, 3490.9688, 39.4500),
	vector3(1766.2001, 3491.3999, 39.4500),
	vector3(1767.2905, 3492.0210, 39.4500),
	vector3(1768.3812, 3492.6616, 39.4500),
	vector3(-238.9935, 6037.0249, 34.7139),
	vector3(-238.3404, 6037.6743, 34.7139),
	vector3(-237.4695, 6038.5732, 34.7139),
	vector3(-236.5120, 6039.5522, 34.7139),
	vector3(-234.7809, 6038.0498, 34.7139),
	vector3(-235.6033, 6037.0967, 34.7139),
	vector3(-236.5086, 6036.1626, 34.7139),
	vector3(-237.4038, 6035.2373, 34.7139),
	vector3(2887.8413, 4851.2563, 63.8540),
	vector3(2888.5701, 4850.1069, 63.8540),
	vector3(2889.1328, 4849.1807, 63.8540),
	vector3(2889.7324, 4848.0474, 63.8540),
	vector3(2887.7844, 4846.8423, 63.8541),
	vector3(2887.2178, 4847.7417, 63.8540),
	vector3(2886.5317, 4848.8760, 63.8540),
	vector3(2885.9768, 4849.9365, 63.8540),
	vector3(2619.0161, 1690.5801, 27.5985),
	vector3(298.9805, -1205.5347, 38.8926),
	vector3(299.0714, -1203.0671, 38.8926),
	vector3(281.8425, -1203.0641, 38.9000),
	vector3(278.9162, -1203.0573, 38.8945),
	vector3(276.9263, -1203.0562, 38.8943),
	vector3(276.9967, -1205.5442, 38.8942),
	vector3(278.7496, -1205.5029, 38.8941),
	vector3(281.9468, -1205.4637, 38.9001),
	vector3(251.5182, -1208.0530, 29.2894),
	vector3(253.4942, -1208.0487, 29.2893),
	vector3(253.6056, -1200.2748, 29.2905),
	vector3(251.4944, -1200.2795, 29.2907),
	vector3(-538.9167, -1281.6249, 26.8978),
	vector3(-539.3651, -1282.7717, 26.9016),
	vector3(-539.8860, -1283.9149, 26.9016),
	vector3(-540.4699, -1284.9905, 26.9016),
	vector3(-542.5540, -1284.0881, 26.9016),
	vector3(-542.1733, -1282.9955, 26.9016),
	vector3(-541.5959, -1281.7271, 26.9016),
	vector3(-541.1106, -1280.7523, 26.9016),
}
local metroBlipTable = {}
local trainBlipTable = {}
SetTrainsForceDoorsOpen(false)

-- Functions

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

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
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

function isNearTicketMachine()
	local ticketMachineModels = {
		'prop_train_ticket_02',
		'prop_train_ticket_02_tu'
	}

	for i,v in ipairs(ticketMachines) do
		if #(GetEntityCoords(PlayerPedId())-v) < 1.0 then
			return true
		end
	end

	local plyCoords = GetEntityCoords(PlayerPedId())
	for i = 1, #ticketMachineModels do
		local obj = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 0.7, GetHashKey(ticketMachineModels[i]), false, false, false)
		if DoesEntityExist(obj) then
			return true
		end
	end
end

function toggleDoors()
	if GetGameTimer() - lastDoorToggle > 500 then
		lastDoorToggle = GetGameTimer()
		TriggerServerEvent("usa_trains:toggleDoors", trainNID, doors)
		doors = not doors
	end
end

function RemoveTrainBlips()
	for i = #trainBlipTable, 1, -1 do
		local b = trainBlipTable[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(trainBlipTable, i)
		end
	end
end

function RemoveMetroBlips()
	for i = #metroBlipTable, 1, -1 do
		local b = metroBlipTable[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(metroBlipTable, i)
		end
	end
end

function RefreshBlips(Ttable)
	for k,v in pairs(Ttable) do
		if v and v.name and v.coords then
			local blip = AddBlipForCoord(v.coords)
			SetBlipSprite(blip, 795)
			if v.name == "Train" then
				SetBlipColour(blip, 31)
			else
				SetBlipColour(blip, 41)
			end
			SetBlipAsShortRange(blip, true)
			SetBlipDisplay(blip, 4)
			SetBlipShowCone(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
			if v.name == "Train" then
				table.insert(trainBlipTable, blip)
			else
				table.insert(metroBlipTable, blip)
			end
		end
	end
end

-- Exports

exports('checkIsPassanger', function()
	return isPassanger
end)

-- Threads

Citizen.CreateThread(function() -- Setup Ticket Machine Menu
	_menuPool = NativeUI.CreatePool()
	ticketMenu = NativeUI.CreateMenu("LS Transit", "~b~Ticket Machine", 0 --[[X COORD]], 320 --[[Y COORD]])
	buyMetroTicket = NativeUI.CreateItem("Metro Day Pass", "Purchase a daypass for the metro system for $50")
	buyMetroTicket.Activated = function(parentmenu, selected)
		if not hasMetroTicket then
	    	TriggerServerEvent("usa_trains:buyTicket", "metro")
	    else
	    	TriggerEvent("usa:notify", "You already have a daypass for today!")
	    end
	end
	buyTrainTicket = NativeUI.CreateItem("Train Day Ticket", "Purchase a Train Day Ticket for $100")
	buyTrainTicket.Activated = function(parentmenu, selected)
		if not hasTrainTicket then
	    	TriggerServerEvent("usa_trains:buyTicket", "train")
	    else
	    	TriggerEvent("usa:notify", "You already have a train day ticket for today!")
	    end
	end
	_menuPool:Add(ticketMenu)
	ticketMenu:AddItem(buyMetroTicket)
	ticketMenu:AddItem(buyTrainTicket)
end)

Citizen.CreateThread(function() -- Add Blips for stations
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
		SetBlipSprite(blip, 677)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.45)
		SetBlipColour(blip, 31)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Train Station')
		EndTextCommandSetBlipName(blip)
	end
	local blip = AddBlipForCoord(metroClockIn)
	SetBlipSprite(blip, 78)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 61)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Metro Clock In')
	EndTextCommandSetBlipName(blip)
	local blip = AddBlipForCoord(trainClockIn)
	SetBlipSprite(blip, 79)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, 31)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Train Clock In')
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function() -- train controlls
	while true do
		Citizen.Wait(0)
		if IsPedInAnyTrain(PlayerPedId()) and isDriver then
			if IsPedDeadOrDying(PlayerPedId(), 1) then
				if trainSpeed > 5.0 then
					trainSpeed = trainSpeed - 1.0
				elseif trainSpeed < 5.0 and trainSpeed > -5.0 then
					trainSpeed = 0
				elseif trainSpeed < -5.0 then
				 	trainSpeed = trainSpeed + 1.0
				end
				if GetEntitySpeed(train) == 0.0 then
					if GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey("metrotrain") then
						toggleDoors()
					end
					TriggerEvent("usa_hud:setTrain", false)
					DoScreenFadeOut(500)
					Citizen.Wait(1000)
					local coords = GetOffsetFromEntityInWorldCoords(train, -2.0, 0.0, -0.5)
					TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(GetPlayerPed(-1), false), 16)
					SetEntityCoords(PlayerPedId(), coords.x,coords.y,coords.z)
					isDriver = false
					Citizen.Wait(1500)
					DoScreenFadeIn(500)
				end
			end
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
			elseif IsControlJustReleased(0, 47) and GetEntitySpeed(train) == 0 and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey("metrotrain") then
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
		elseif isPassanger then
			if not disableControlHint then
				if (GetEntitySpeed(passangerTrain) == 0) then
					alert("~b~Switch Seats ~INPUT_MOVE_DOWN_ONLY~\n~b~Leave Train ~INPUT_ENTER~")
				else
					alert("~b~Switch Seats ~INPUT_MOVE_DOWN_ONLY~")
				end
			end

			if IsDisabledControlJustReleased(0, 75) and GetEntitySpeed(passangerTrain) == 0 then
				local trainNetID = NetworkGetNetworkIdFromEntity(passangerTrain)
				DoScreenFadeOut(500)
				Citizen.Wait(600)
				TriggerServerEvent("usa_trains:seat", trainNetID, GetPlayerPed(-1))
			elseif IsControlJustReleased(0, 33) then
				local trainNetID = NetworkGetNetworkIdFromEntity(passangerTrain)
				TriggerServerEvent("usa_trains:moveseat", trainNetID)
			end
		end
	end 
end)

Citizen.CreateThread(function() -- train enter prompts
	while true do
		Citizen.Wait(0)
		if GetEntityHealth(PlayerPedId()) > 0.0 and not IsPedDeadOrDying(PlayerPedId(), 1) then
			for i,v in ipairs(serverTrainNIDs) do
				local vehicle = NetworkGetEntityFromNetworkId(v)
				if GetVehicleBodyHealth(vehicle) > 0.0 then
					if isTrainJob and GetEntityModel(vehicle) == GetHashKey("streakcoaster") and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5 and IsVehicleSeatFree(vehicle, -1) and IsVehicleSeatFree(vehicle, 0) and not IsPedInVehicle(GetPlayerPed(-1), vehicle, true) and not isPassanger and not isDriver then 
						alert("~b~Enter Train as Driver ~INPUT_CONTEXT~")
						if IsControlJustPressed(1, 51) then
							local id = NetworkGetNetworkIdFromEntity(vehicle)
							TriggerServerEvent("usa_trains:checkTrainDriver", id)
			            end
			        elseif GetEntityModel(vehicle) == GetHashKey("streakcoasterc") and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) < 5 and GetEntitySpeed(vehicle) == 0 and not isPassanger and not isDriver then 
			        	alert("~b~Enter Train as Passanger ~INPUT_CONTEXT~")
						if IsControlJustPressed(1, 51) then
							local trainNetID = NetworkGetNetworkIdFromEntity(vehicle)
							TriggerServerEvent("usa_trains:seat", trainNetID)
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
		end
	end 
end)

Citizen.CreateThread(function() -- ticket machines
	while true do
		Citizen.Wait(1)
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		if #(GetEntityCoords(PlayerPedId()) - vector3(2619.0161, 1690.5801, 27.5985)) < 5 then
			DrawText3D(2619.0161, 1690.5801, 27.9985, "[E] - Buy Tickets")
		end
        if IsControlJustPressed(1, 51) and isNearTicketMachine() then
        	--open ticket menu
        	ticketMenu:Visible(true)
        	openCoords = GetEntityCoords(PlayerPedId())
		end
		if _menuPool:IsAnyMenuOpen() then -- close when far away
            if #(GetEntityCoords(PlayerPedId()) - openCoords) > 0.7 then
                openCoords = nil
                _menuPool:CloseAllMenus()
            end
        end
	end
end)

Citizen.CreateThread(function() -- ticket checking
	while true do
		Citizen.Wait(0)
		if IsPedInAnyTrain(GetPlayerPed(-1)) and GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 0 and not isMetroJob and not isEMS then
			if not hasMetroTicket then
				local grace_time = 30
				local enter_time = GetGameTimer()
				leftNoTicket = false
				TriggerServerEvent("usa_trains:passengerNoTicket", vector3(GetEntityCoords(PlayerPedId())))
				disableControlHint = true
				while GetGameTimer() - enter_time < grace_time * 1000 do
					Wait(0)
					alert("You do not have a metro pass, leave the train! You have " .. math.floor((30 - ((GetGameTimer() - enter_time)/1000))) .. " seconds before the police is called")
					if not IsPedInAnyTrain(GetPlayerPed(-1)) then
						leftNoTicket = true
						break
					end
				end
				if not leftNoTicket then
					while IsPedInAnyTrain(PlayerPedId()) and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) do
						Wait(0)
						alert("911 Called")
						if not called then
							called = true
							TriggerServerEvent("911:NoTicket", GetEntityCoords(PlayerPedId()))
						end
					end
					leftNoTicket = true
				else
					alert("Thank you for leaving please buy a metro pass!")
				end
				disableControlHint = false
			end
		elseif isPassanger and not isTrainJob and not isEMS then
			if not hasTrainTicket then
				local grace_time = 30
				local enter_time = GetGameTimer()
				leftNoTicket = false
				TriggerServerEvent("usa_trains:passengerNoTicket", vector3(GetEntityCoords(PlayerPedId())))
				disableControlHint = true
				while GetGameTimer() - enter_time < grace_time * 1000 do
					Wait(0)
					alert("You have no ticket.\n" .. math.floor((30 - ((GetGameTimer() - enter_time)/1000))) .. " seconds before 911\n~b~Leave Train ~INPUT_ENTER~")
					if not isPassanger then
						leftNoTicket = true
						disableControlHint = false
						break
					end
				end
				if not leftNoTicket then
					while isPassanger do
						Wait(0)
						alert("911 Called\n~b~Leave Train ~INPUT_ENTER~")
						if not called then
							called = true
							TriggerServerEvent("911:NoTicket", GetEntityCoords(PlayerPedId()))
						end
					end
					leftNoTicket = true
				else
					alert("Thank you for leaving please buy a ticket!")
				end
				disableControlHint = false
			end
		end
	end
end)

Citizen.CreateThread(function() -- no ticket update
	while true do
		Citizen.Wait(0)
		while called do
			Wait(5000)
			if not leftNoTicket then
				TriggerServerEvent("911:NoTicketUpdate", GetEntityCoords(PlayerPedId()))
			else
				called = false
				TriggerServerEvent("911:NoTicketEnd", GetEntityCoords(PlayerPedId()))
			end
		end
	end
end)

Citizen.CreateThread(function() -- turnstyle ticket checking
	while true do
		local gateObject = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 6.0, 1531047580, false, false, false)
		Wait(100)
		if hasMetroTicket or isMetroJob or isEMS then
			FreezeEntityPosition(gateObject, false)
		else
			FreezeEntityPosition(gateObject, true)
		end
	end
end)

Citizen.CreateThread(function() -- Clock In
	while true do
		Citizen.Wait(0)
		if #(GetEntityCoords(PlayerPedId()) - metroClockIn) < 4 then
			if isMetroJob then
				DrawText3D(metroClockIn.x, metroClockIn.y, metroClockIn.z + 0.5, "[E] - Clock Off Duty (~r~Metro~s~)")
				DrawText3D(metroClockIn.x, metroClockIn.y, metroClockIn.z, "[F] - Summon Train (~r~Metro~s~)")
				if IsControlJustReleased(1, 51) then
					if #(GetEntityCoords(PlayerPedId()) - metroClockIn) < 1 then
						TriggerServerEvent("usa_trains:metroJobToggle", false)
					else
						TriggerEvent("usa:notify", "You are too far away please come closer!")
					end
				elseif IsControlJustPressed(0, 75) then
					if not train then
						TriggerServerEvent("usa_trains:metroSpawnRequest")
					else
						TriggerEvent("usa:notify", "You already have a train!")
					end
				end
			else
				DrawText3D(metroClockIn.x, metroClockIn.y, metroClockIn.z + 0.5, "[E] - Clock On Duty (~r~Metro~s~)")
				if IsControlJustReleased(1, 51) then
					if #(GetEntityCoords(PlayerPedId()) - metroClockIn) < 1 then
						TriggerServerEvent("usa_trains:metroJobToggle", true)
					else
						TriggerEvent("usa:notify", "You are too far away please come closer!")
					end
				end
			end
		elseif #(GetEntityCoords(PlayerPedId()) - trainClockIn) < 4 then
			if isTrainJob then
				DrawText3D(trainClockIn.x, trainClockIn.y, trainClockIn.z + 0.5, "[E] - Clock Off Duty (~r~Train~s~)")
				DrawText3D(trainClockIn.x, trainClockIn.y, trainClockIn.z, "[F] - Summon Train (~r~ Train~s~)")
				if IsControlJustReleased(1, 51) then
					if #(GetEntityCoords(PlayerPedId()) - trainClockIn) < 1 then
						TriggerServerEvent("usa_trains:trainJobToggle", false)
					else
						TriggerEvent("usa:notify", "You are too far away please come closer!")
					end
				elseif IsControlJustPressed(0, 75) then
					if not train then
						TriggerServerEvent("usa_trains:trainSpawnRequest")
					else
						TriggerEvent("usa:notify", "You already have a train!")
					end
				end
			else
				DrawText3D(trainClockIn.x, trainClockIn.y, trainClockIn.z + 0.5, "[E] - Clock On Duty (~r~Train~s~)")
				if IsControlJustReleased(1, 51) then
					if #(GetEntityCoords(PlayerPedId()) - trainClockIn) < 1 then
						TriggerServerEvent("usa_trains:trainJobToggle", true)
					else
						TriggerEvent("usa:notify", "You are too far away please come closer!")
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function() -- Train Blips
	while true do
		Citizen.Wait(1000)
		local found = false

		if not isTrainJob then
			for i,v in ipairs(trainstations) do
				if #(GetEntityCoords(PlayerPedId()) - v.coords) < 30 and GetEntityCoords(PlayerPedId()).z - v.coords.z < 13 then
					found = true
				end
			end
		else
			found = true
		end

		if found == true and not showingTrainBlips then
			TriggerEvent("usa_trains:toggleTrainBlips", true)
		elseif found == false and showingTrainBlips then
			TriggerEvent("usa_trains:toggleTrainBlips", false)
		end

	end
end)

Citizen.CreateThread(function() -- Metro Blips
	local metroPlatforms = {
		[1] = vector3(-1084.5409, -2719.6482, -7.4101),
		[2] = vector3(-883.6993, -2315.2178, -11.7328),
		[3] = vector3(-540.7547, -1282.7534, 29.4656),
		[4] = vector3(263.8945, -1204.2205, 42.4809),
		[5] = vector3(-292.9330, -332.3137, 10.0631),
		[6] = vector3(-815.2302, -135.4008, 19.9070),
		[7] = vector3(-1353.9834, -464.0378, 15.0453),
		[8] = vector3(-502.5693, -674.7533, 11.8090),
		[9] = vector3(-214.0222, -1035.3766, 32.0866),
		[10] = vector3(115.4997, -1725.8308, 32.2810),
	}
	while true do
		Citizen.Wait(1000)
		local found = false

		if not isMetroJob then
			for i,v in ipairs(metroPlatforms) do
				if (i >= 9 or i == 3 or i == 4) then
					if #(GetEntityCoords(PlayerPedId()) - v) < 30 and GetEntityCoords(PlayerPedId()).z - v.z < 13 then
						found = true
					end
				else
					if #(GetEntityCoords(PlayerPedId()) - v) < 50 and GetEntityCoords(PlayerPedId()).z - v.z < 13 then
						found = true
					end
				end
			end
		else
			found = true
		end

		if found == true and not showingMetroBlips then
			TriggerEvent("usa_trains:toggleTrainBlips", true)
		elseif found == false and showingMetroBlips then
			TriggerEvent("usa_trains:toggleTrainBlips", false)
		end

	end
end)

Citizen.CreateThread(function() -- Repair Windows
	while true do
		Citizen.Wait(1000)
		if train then
			if not AreAllVehicleWindowsIntact(train) then
				SetVehicleFixed(train)
			end
		end
	end
end)

-- Client Events

RegisterNetEvent("usa_trains:setJob")
AddEventHandler("usa_trains:setJob", function(job)
	if job == "metroDriver" then
		isTrainJob = false
		isMetroJob = true
		isEMS = false
		if train then
			TriggerEvent("usa_trains:delTrain")
		end
		if not isHelpShowing then
			isHelpShowing = true
			TriggerEvent("chatMessage", "", {}, "Welcome to the LS Transit Family!")
			Citizen.Wait(3000)
			TriggerEvent("chatMessage", "", {}, "You have started working as one of our Metro Operators!")
			Citizen.Wait(3000)
			TriggerEvent("chatMessage", "", {}, "Your job is to drive the metro around the city and make sure its citizens are able to get where they need to go!")
			Citizen.Wait(3000)
			TriggerEvent("chatMessage", "", {}, "The controls for the train will be shown to you when you get inside of it!")
			Citizen.Wait(3000)
			TriggerEvent("chatMessage", "", {}, "Make sure to drive safly and stop at every station for at least 30 seconds!")
			Citizen.Wait(3000)
			isHelpShowing = false
		end
	elseif job == "trainDriver" then
		isMetroJob = false
		isTrainJob = true
		isEMS = false
		if train then
			TriggerEvent("usa_trains:delTrain")
		end
	elseif job == "police" or job == "sheriff" or job == "ems" then
		isMetroJob = false
		isTrainJob = false
		isEMS = true
	else
		isMetroJob = false
		isTrainJob = false
		isEMS = false
		if train then
			TriggerEvent("usa_trains:delTrain")
		end
	end
end)

RegisterNetEvent("usa_trains:issueTicket")
AddEventHandler("usa_trains:issueTicket", function(type, bool)
	if type == "metro" then
		hasMetroTicket = bool
	elseif type == "train" then
		hasTrainTicket = bool
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
	AttachEntityToEntity(GetPlayerPed(-1), trainent, 0, seat.x, seat.y, seat.z, 0, 0, seat.rotation, false, true, false, false, 2, true)
	SetEntityCollision(PlayerPedId(), false, true)
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
	SetEntityCollision(PlayerPedId(), true, true)
	DetachEntity(PlayerPedId(), true, false)
	local coords = GetOffsetFromEntityInWorldCoords(passangerTrain, -2.0, 0.0, -0.5)
	SetEntityCoords(PlayerPedId(), coords.x,coords.y,coords.z)
	ClearPedTasks(PlayerPedId())
	passangerTrain = nil
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNetEvent("usa_trains:no_seats")
AddEventHandler("usa_trains:no_seats", function()
	Citizen.Wait(500)
	DoScreenFadeIn(500)
end)

RegisterNetEvent("usa_trains:delTrain")
AddEventHandler("usa_trains:delTrain", function()
	TriggerServerEvent("usa_trains:deleteTrainServer", trainNID)
end)

RegisterNetEvent("usa_trains:delTrainServerReq")
AddEventHandler("usa_trains:delTrainServerReq", function()
	local dtrain = NetworkGetEntityFromNetworkId(trainNID)
	takeOwn(dtrain)
	if (NetworkGetEntityOwner(dtrain) == 128) then
		TriggerServerEvent("usa_trains:deleteTrainServer", trainNID)
		DeleteMissionTrain(dtrain)
		train = nil
		trainNID= nil
		trainSpeed = 0.0
	end
end)

RegisterNetEvent("usa_trains:cleanTrain")
AddEventHandler("usa_trains:cleanTrain", function(traiNID)
	local dtrain = NetworkGetEntityFromNetworkId(traiNID)
	takeOwn(dtrain)
	if (NetworkGetEntityOwner(dtrain) == 128) then
		TriggerServerEvent("usa_trains:deleteTrainServer", trainNID)
		DeleteMissionTrain(dtrain)
	end
end)

RegisterNetEvent("usa_trains:spawnTrain")
AddEventHandler("usa_trains:spawnTrain",function(type, spawnCoords)
	if not train then
		local train_models = {}
		local train_type = "Train"
		if type == 25 then
			train_models = {"metrotrain"}
			train_type = "Metro"
			TriggerEvent("usa:notify", "Your Train has been set ready for you at the Southbound Platform!")
		elseif type == 0 then
			train_models = {"streakcoaster", "streakcoasterc"}
			train_type = "Train"
			TriggerEvent("usa:notify", "Your Train has been set ready for you!")
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
		train = CreateMissionTrain(tonumber(type), spawnCoords, true)
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
		SetVehicleDoorCanBreak(train, 0, false)
		SetVehicleDoorCanBreak(train, 1, false)
		SetVehicleDoorCanBreak(train, 2, false)
		SetVehicleDoorCanBreak(train, 3, false)
	else
		TriggerEvent("usa:notify", "You already have a train!")
	end
end)

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

RegisterNetEvent("usa_trains:checkDistances")
AddEventHandler("usa_trains:checkDistances", function(trainNetworkID, trainType, trainTable)
	local stopDistance = -60
	if trainType == 25 then
		stopDistance = -40
	end
	for i,v in ipairs(trainTable) do
		if trainNetworkID ~= v.trainNetID and trainType == v.name then
			if NetworkGetEntityFromNetworkId(v.trainNetID) ~= 0 then
				local train1Node = GetTrainCurrentTrackNode(NetworkGetEntityFromNetworkId(trainNetworkID))
				local train2Node = GetTrainCurrentTrackNode(NetworkGetEntityFromNetworkId(v.trainNetID))
				local distance = 0
				if trainSpeed >= 0 then
					distance = train1Node - train2Node
				else
					distance = train2Node - train1Node
				end
				if distance >= stopDistance and distance < stopDistance/2 then
					TriggerEvent("usa:notify", "You are getting to close to another train, SLOW DOWN!")
				elseif distance >= stopDistance/2 and distance <= 0 then
					breaking = true
					while trainSpeed ~= 0.0 do
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

RegisterNetEvent("usa_trains:toggleMetroBlips")
AddEventHandler("usa_trains:toggleMetroBlips", function(bool)
	showingMetroBlips = bool
	if not showingMetroBlips then
		RemoveMetroBlips()
	end
end)

RegisterNetEvent("usa_trains:updateAll")
AddEventHandler("usa_trains:updateAll", function(Ttable)
	if showingMetroBlips or showingTrainBlips then
		RemoveMetroBlips()
		RemoveTrainBlips()
		RefreshBlips(Ttable)
	end
end)

RegisterNetEvent("usa_trains:toggleTrainBlips")
AddEventHandler("usa_trains:toggleTrainBlips", function(bool)
	showingTrainBlips = bool
	if not showingTrainBlips then
		RemoveTrainBlips()
	end
end)

-- Debug Commands

RegisterCommand("spawnMetro", function()
	TriggerEvent("usa_trains:spawnTrain", 25, GetEntityCoords(PlayerPedId()))
	-- TriggerServerEvent("usa_trains:metroSpawnRequest")
end, false)

RegisterCommand("spawnTrain", function()
	TriggerEvent("usa_trains:spawnTrain", 0, GetEntityCoords(PlayerPedId()))
	-- TriggerServerEvent("usa_trains:trainSpawnRequest")
end, false)

RegisterCommand("delTrain", function()
	TriggerEvent("usa_trains:delTrain")
end, false)
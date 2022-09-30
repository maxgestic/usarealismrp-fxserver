local train = nil
local trainSpeed = 0.0
local isDriver = false
local isPassanger = false

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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyTrain(GetPlayerPed(-1)) and isDriver then 
			if IsControlPressed(0, 71) and trainSpeed < 27.495 then
				trainSpeed = trainSpeed + 0.1
			elseif IsControlPressed(0, 72) and trainSpeed > -7 then 
				trainSpeed = trainSpeed - 0.1
			elseif IsControlPressed(0, 22) then
				if trainSpeed > 5.0 then
					trainSpeed = trainSpeed - 2.0
				elseif trainSpeed < 5.0 and trainSpeed > -5.0 then
					trainSpeed = 0
				elseif trainSpeed < -5.0 then
				 	trainSpeed = trainSpeed + 2.0
				 end
			end
			SetTrainCruiseSpeed(train, trainSpeed)
			local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			DrawTxt(0.663, 1.418, 1.0, 1.0, 0.55, math.floor(GetEntitySpeed(playerVeh)*2.2, 0) .. '', 255, 255, 255, 255)
			DrawTxt(0.684, 1.425, 1.0, 1.0, 0.35, 'mph', 255, 255, 255, 255)
		end
	end
end)

RegisterCommand("delTrain", function()
	DeleteMissionTrain(train)
	train = nil
	trainSpeed = 0.0
end, false)

RegisterCommand("spawnTrain", function(source, args, rawCommand)
	print(args[1])
	if not train then
		local train_models = {"freight", "freightcar", "freightcar2", "freightcont1", "freightcont2", "freightgrain", "metrotrain", "tankercar"}

		for i,v in ipairs(train_models) do
			local hash = GetHashKey(v)
			RequestModel(v)
			print("loading ".. v)
			while not HasModelLoaded(v) do
				RequestModel(v)
				Citizen.Wait(0)
			end
		end


		train = CreateMissionTrain(tonumber(args[1]), 670.2056, -685.7708, 25.15311, true)
		SetTrainSpeed(train,0)
		SetTrainCruiseSpeed(train,0)
		SetEntityAsMissionEntity(train, true, false)
	end
end, false)
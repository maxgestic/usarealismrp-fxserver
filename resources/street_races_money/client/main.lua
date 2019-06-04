local streetRaces = {}

streetRaces.Races = {}


-- Events

RegisterNetEvent("createRace")
AddEventHandler("createRace", function(serverId, data)
	streetRaces.Races[data.id] = streetRaces.CreateNewRace(data)

	if GetPlayerServerId(PlayerId()) == serverId then
		TriggerServerEvent("joinRace", data.id)
	end
end)

RegisterNetEvent("removeRace")
AddEventHandler("removeRace", function(id)
	local race = streetRaces.getRace(id)
	local inRace = streetRaces.getInRace()

	if inRace and race.getData("id") == inRace.getData("id") then
		streetRaces.InRace = nil
	end

	race.remove()
end)

RegisterNetEvent("joinRace")
AddEventHandler("joinRace", function(id)
	streetRaces.InRace = id

	local inRace = streetRaces.getInRace()
	local endCoords = inRace.getData("endCoords")

	SetNewWaypoint(endCoords.x, endCoords.y)

	inRace.createBlip()
end)

RegisterNetEvent("setRaceData")
AddEventHandler("setRaceData", function(id, name, value)
	local race = streetRaces.getRace(id)

	if race then
		race.setData(name, value)
	end
end)


RegisterNetEvent("tryCreateRace")
AddEventHandler("tryCreateRace", function(bet)
	if not streetRaces.getInRace() and bet then
		local waypoint = GetFirstBlipInfoId(8)

    	if DoesBlipExist(waypoint) then
        	local waypointCoords = GetBlipInfoIdCoord(waypoint)

			TriggerServerEvent("createRace", GetEntityCoords(GetPlayerPed(-1)), waypointCoords, tonumber(bet))
		end
	end
end)

RegisterNetEvent("tryLeaveRace")
AddEventHandler("tryLeaveRace", function()
	local inRace = streetRaces.getInRace()

	if inRace then
		inRace.endRace("leave")
	end
end)

-- Trheads

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local playerPed = GetPlayerPed(-1)
		local playerCoords = GetEntityCoords(playerPed)
		local inRace = streetRaces.getInRace()

		if NetworkIsSessionStarted() and not streetRaces.Spawned then
			streetRaces.Spawned = true

			TriggerServerEvent("getRaces")
		end

		if not inRace then
			for raceId, race in pairs(streetRaces.Races) do 
				local waiting = race.getData("waiting")
				local coords = race.getData("startCoords")
				local bets = race.getData("bets")
				local bet = race.getData("bet")
				local distance = GetDistanceBetweenCoords(playerCoords, coords, true)

				if distance < 15.0 and waiting then
					sleep = 0

					streetRaces.Draw3D(coords, "Press ~g~E~w~ to join race. Bet: " .. bet ..  ", Pot: " .. bets)

					if IsControlJustPressed(0, 38) then
						TriggerServerEvent("joinRace", raceId)
					end
				end
			end
		end

		if inRace then
			sleep = 0
			local players = inRace.getData("players")
			local starting = inRace.getData("starting")
			local waiting = inRace.getData("waiting")
			local started = inRace.getData("started")
			local coords = inRace.getData("startCoords")
			local endCoords = inRace.getData("endCoords")
			local bets = inRace.getData("bets")
			local bet = inRace.getData("bet")

			if streetRaces.getInRace() and waiting then
				local distance = GetDistanceBetweenCoords(playerCoords, coords, true)

				streetRaces.Draw3D(coords, "Waiting for race to start, keep within 30 meters or you will leave the race, Total Bets: " .. bets)

				if distance >= 20.0 then
					inRace.endRace("leave")
				end
			end

			if streetRaces.getInRace() and starting then
				if players == 1 then
					inRace.endRace("win")
				else
					if starting > 0 then

						streetRaces.Draw3D(playerCoords, "Race starting in " .. starting)

						if (GetEntitySpeed(GetVehiclePedIsUsing(playerPed)) * 3.6) > 2.0 then
							inRace.endRace("failed")
						end
					else
						streetRaces.Draw3D(playerCoords, "Race!!")
					end
				end
			end

			if streetRaces.getInRace() and started then
				local distance = GetDistanceBetweenCoords(playerCoords, endCoords, false)
				
				if distance < 12.0 or players == 1 then
					inRace.endRace("win")

					sleep = 200
				end	
			end
		end

		Citizen.Wait(sleep)
	end
end)

-- Utils


streetRaces.getInRace = function()
	return streetRaces.Races[streetRaces.InRace]
end

streetRaces.getRace = function(id)
	return streetRaces.Races[id]
end


streetRaces.Draw3D = function(coords, text)
    local onScreen, _x, _y= World3dToScreen2d(coords.x, coords.y, coords.z + 0.5)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370

        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end


streetRaces.CreateNewRace = function(data)
	local self = {}

	self.data = data

	self.getData = function(name)
		return self.data[name]
	end

	self.setData = function(name, value)
		self.data[name] = value
	end

	self.remove = function()
		streetRaces.Races[self.data.id] = nil
	end

	self.createBlip = function()
		local blip = AddBlipForCoord(self.data.endCoords)
		local time = 0
		local coords = self.data.endCoords
		local raceId = self.data.id

		self.data.blip = blip
		
		SetBlipColour(blip, 34)
		SetBlipHighDetail(blip, true)
		SetBlipScale(blip, 0.8)
		SetBlipSprite(blip, 38)

		while true do
			Citizen.Wait(500)

			local playerPed = GetPlayerPed(-1)
			local playerCoords = GetEntityCoords(playerPed)
			local race = streetRaces.getInRace()

			if not race or race.getData("id") ~= raceId then
				local distance = GetDistanceBetweenCoords(playerCoords, coords, false)

				time = time + 0.5

				if time > (60 * 3) or distance < 15.0 or race and streetRaces.InRace ~= raceId then
					if DoesBlipExist(blip) then
						RemoveBlip(blip)
					end

					return
				end
			end
		end
	end

	self.endRace = function(endType)
		streetRaces.InRace = nil

		if DoesBlipExist(self.data.blip) then
			RemoveBlip(self.data.blip)
		end

		if endType == "win" then
			TriggerServerEvent("winRace", self.data.id)

			TriggerEvent("notification?", "You won the race!") -- This notifcation is not valid just for you guys to change later
		end

		if endType == "failed" then
			TriggerServerEvent("leaveRace", self.data.id)

			TriggerEvent("notification?", "You started to early and you got disqualifed!") -- This notifcation is not valid just for you guys to change later
		end

		if endType == "leave" then
			TriggerServerEvent("leaveRace", self.data.id)

			TriggerEvent("notification?", "You left the current race!") -- This notifcation is not valid just for you guys to change later
		end
	end

  	return self

end

local streetRaces = {}

streetRaces.Races = {}

streetRaces.RaceId = 0


-- Events
RegisterServerEvent("getRaces")
AddEventHandler("getRaces", function(startCoords, endCoords, bet)
	local src = source

	for raceId, race in pairs(streetRaces.Races) do
		TriggerClientEvent("createRace", -1, src, race.data)
	end
end)


RegisterServerEvent("createRace")
AddEventHandler("createRace", function(startCoords, endCoords, bet)
	local src = source

	local user = exports["essentialmode"]:getPlayerFromId(src)
	local money = user.getActiveCharacterData('money')

	if money > bet then
		local race = streetRaces.CreateNewRace(streetRaces.getRaceId(), startCoords, endCoords, bet)
		
		streetRaces.Races[race.data.id] = race

		TriggerClientEvent("createRace", -1, src, race.data)

	end
end)

RegisterServerEvent("joinRace")
AddEventHandler("joinRace", function(id)
	local src = source
	local race = streetRaces.getRace(id)

	local players = race.getData("players")
	local bets = race.getData("bets")
	local bet = race.getData("bet")

	local user = exports["essentialmode"]:getPlayerFromId(src)
	local money = user.getActiveCharacterData('money')

	if money > bet then
		race.setData("players", players + 1)
		race.setData("bets", bets + bet)

		user.setActiveCharacterData('race', id)
		user.setActiveCharacterData('money', money - bet)

		TriggerClientEvent("joinRace", src, id)
	end
end)

RegisterServerEvent("leaveRace")
AddEventHandler("leaveRace", function(id)
	local src = source
	local race = streetRaces.getRace(id)

	local players = race.getData("players")
	local bets = race.getData("bets")
	local bet = race.getData("bet")
	local waiting = race.getData("waiting")

	local user = exports["essentialmode"]:getPlayerFromId(src)
	local money = user.getActiveCharacterData('money')

	if user.getActiveCharacterData('race') ~= id then
		print("[" .. src .. "] just tried to leave a race they are not in")

		return
	end

	user.setActiveCharacterData('race', false)

	race.setData("players", players - 1)

	if waiting then
		race.setData("bets", bets - bet)

		user.setActiveCharacterData('money', money + bet)
	end

	if race.getData("players") == 0 then
		race.remove()
	end
end)

RegisterServerEvent("winRace")
AddEventHandler("winRace", function(id)
	local src  = source
	local race = streetRaces.getRace(id)
	local bets = race.getData("bets")

	local user  = exports["essentialmode"]:getPlayerFromId(src)
	local money = user.getActiveCharacterData('money')	

	if user.getActiveCharacterData('race') ~= id then
		print("[" .. src .. "] just tried to win a race they are not in")
		
		return
	end

	user.setActiveCharacterData('money', money + bets)
	user.setActiveCharacterData('race', false)

	race.remove()
end)

-- Commands
TriggerEvent('es:addCommand', 'race', function(source, args, user)
print("starting race")
	TriggerClientEvent("tryCreateRace", source, args[1])
end, {help = "Start a street race"})

TriggerEvent('es:addCommand', 'leaverace', function(source, args, user)
	TriggerClientEvent("tryLeaveRace", source)
end, {help = "Leave a street race"})

-- Threads

Citizen.CreateThread(function()
	while true do
		for raceId, race in pairs(streetRaces.Races) do
			local players = race.getData("players")
			local waiting = race.getData("waiting")
			local timer   = race.getData("timer")

			if players > 1 and waiting and timer then
				race.setData("timer", timer - 1)

				if timer <= 0 then
					race.setData("waiting",  false)

					race.setData("starting", 5)
				end
			else
				race.setData("timer", 30)
			end

			local starting  = race.getData("starting")

			if starting then
				race.setData("starting", starting - 1) 

				if starting < 0 then
					race.setData("starting", false) 

					race.setData("started", true) 
				end
			end
		end

		Citizen.Wait(1000)
	end
end)

-- Functions

streetRaces.getRaceId = function()
	streetRaces.RaceId = streetRaces.RaceId + 1

	if streetRaces.RaceId > 3000 then
		streetRaces.RaceId = 1
	end

	return streetRaces.RaceId
end

streetRaces.getRace = function(id)
	return streetRaces.Races[id]
end

streetRaces.CreateNewRace = function(id, startCoords, endCoords, bet)
	local self = {}

	self.data        = {}

	self.data.id    	  = id
	self.data.startCoords = startCoords
	self.data.endCoords   = endCoords
	self.data.bet         = bet
	self.data.players     = 0
	self.data.waiting     = true
	self.data.players     = 0
	self.data.bets  	  = 0


	self.getData = function(name)
		return self.data[name]
	end

	self.setData = function(name, value)
		self.data[name] = value

		TriggerClientEvent("setRaceData", -1, self.data.id, name, value)
	end

	self.remove = function()
		TriggerClientEvent("removeRace", -1,  self.data.id)
		
		streetRaces.Races[self.data.id] = nil

	end

  	return self

end


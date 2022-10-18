local trains = {}
local northboundTrains = {}
local southboundTrains = {}
local trainTable = {}
local updateInterval = 1
local metroPasses = {}
local trainTickets = {}

RegisterServerEvent("usa_trains:seat")
AddEventHandler("usa_trains:seat", function(train, ped)
	local deseat = false
	for i,v in ipairs(trains) do
		if (v.carrigeNetID == train) then
			for k,w in pairs(v.seats) do
				if (w.taken == ped) then
					TriggerClientEvent("usa_trains:unseat_player", source)
					w.taken = nil
					deseat = true
					break
				end
			end

			if not deseat then
				for k,x in pairs(v.seats) do
					if (x.taken == nil) then
						x.taken = ped
						TriggerClientEvent("usa_trains:seat_player", source, {x = x.x, y = x.y, z = x.z, rotation = x.rotate}, train)
						break
					end
					TriggerClientEvent("usa_trains:no_seats", source)
				end
			end
		end
	end
end)

RegisterServerEvent("usa_trains:moveseat")
AddEventHandler("usa_trains:moveseat", function(train, ped)
	for i,v in ipairs(trains) do
		if (v.carrigeNetID == train) then
			local currentseat = 0
			for k,w in pairs(v.seats) do
				if w.taken == ped then
					currentseat = w.number
					break
				end
			end
			local counter = currentseat + 1
			for k,w in pairs(v.seats) do
				if counter == 33 then
					counter = 1
				end
				if v.seats["seat"..counter].taken == nil then
					v.seats["seat"..counter].taken = ped
					v.seats["seat"..currentseat].taken = nil
					TriggerClientEvent("usa_trains:moveseat_player", source, {x = v.seats["seat"..counter].x, y = v.seats["seat"..counter].y, z = v.seats["seat"..counter].z, rotation = v.seats["seat"..counter].rotate}, train)
					break
				else
					counter = counter + 1
				end
			end
			TriggerClientEvent("usa_trains:no_seats", source)
		end
	end
end)

RegisterServerEvent("usa_trains:createTrain")
AddEventHandler("usa_trains:createTrain", function(train, carrige, type)
	local object = {
		name = type,
		driver = source,
		trainNetID = train,
		carrigeNetID = carrige,
		coords = vector3(GetEntityCoords(NetworkGetEntityFromNetworkId(train))),
		seats = {
			seat1 = {taken = nil, x = 1.0, y = 1.5, z = -0.65, rotate = 0.0, number = 1},
			seat2 = {taken = nil, x = -1.0, y = 1.5, z = -0.65, rotate = 0.0, number = 2},
			seat3 = {taken = nil, x = 1.0, y = 3.0, z = -0.65, rotate = 180.0, number = 3},
			seat4 = {taken = nil, x = -1.0, y = 3.0, z = -0.65, rotate = 180.0, number = 4},
			seat5 = {taken = nil, x = 1.0, y = 6.75, z = 0.35, rotate = 180.0, number = 5},
			seat6 = {taken = nil, x = 1.0, y = 7.5, z = 0.35, rotate = 0.0, number = 6},
			seat7 = {taken = nil, x = 1.0, y = 8.95, z = 0.35, rotate = 180.0, number = 7},
			seat8 = {taken = nil, x = -1.0, y = 6.75, z = 0.35, rotate = 180.0, number = 8},
			seat9 = {taken = nil, x = -1.0, y = 7.5, z = 0.35, rotate = 0.0, number = 9},
			seat10 = {taken = nil, x = -1.0, y = 8.95, z = 0.35, rotate = 180.0, number = 10},
			seat11 = {taken = nil, x = 1.0, y = -1.5, z = -0.65, rotate = 180.0, number = 11},
			seat12 = {taken = nil, x = -1.0, y = -1.5, z = -0.65, rotate = 180.0, number = 12},
			seat13 = {taken = nil, x = 1.0, y = -3.0, z = -0.65, rotate = 0.0, number = 13},
			seat14 = {taken = nil, x = -1.0, y = -3.0, z = -0.65, rotate = 0.0, number = 14},
			seat15 = {taken = nil, x = 1.0, y = -6.75, z = 0.35, rotate = 0.0, number = 15},
			seat16 = {taken = nil, x = 1.0, y = -7.5, z = 0.35, rotate = 180.0, number = 16},
			seat17 = {taken = nil, x = 1.0, y = -8.95, z = 0.35, rotate = 0.0, number = 17},
			seat18 = {taken = nil, x = -1.0, y = -6.75, z = 0.35, rotate = 0.0, number = 18},
			seat19 = {taken = nil, x = -1.0, y = -7.5, z = 0.35, rotate = 180.0, number = 19},
			seat20 = {taken = nil, x = -1.0, y = -8.95, z = 0.35, rotate = 0.0, number = 20},
			seat21 = {taken = nil, x = 1.0, y = 3.325, z = 1.35, rotate = 0.0, number = 21},
			seat22 = {taken = nil, x = 1.0, y = 1.85, z = 1.35, rotate = 0.0, number = 22},
			seat23 = {taken = nil, x = 1.0, y = 0.375, z = 1.35, rotate = 0.0, number = 23},
			seat24 = {taken = nil, x = 1.0, y = -1.05, z = 1.35, rotate = 0.0, number = 24},
			seat25 = {taken = nil, x = 1.0, y = -2.565, z = 1.35, rotate = 0.0, number = 25},
			seat26 = {taken = nil, x = 1.0, y = -4.05, z = 1.35, rotate = 0.0, number = 26},
			seat27 = {taken = nil, x = -1.0, y = 3.325, z = 1.35, rotate = 0.0, number = 27},
			seat28 = {taken = nil, x = -1.0, y = 1.85, z = 1.35, rotate = 0.0, number = 28},
			seat29 = {taken = nil, x = -1.0, y = 0.375, z = 1.35, rotate = 0.0, number = 29},
			seat30 = {taken = nil, x = -1.0, y = -1.05, z = 1.35, rotate = 0.0, number = 30},
			seat31 = {taken = nil, x = -1.0, y = -2.565, z = 1.35, rotate = 0.0, number = 31},
			seat32 = {taken = nil, x = -1.0, y = -4.05, z = 1.35, rotate = 0.0, number = 32},
		},
	}

	table.insert(trains, object)

	TriggerClientEvent("usa_trains:syncCreateTrain", -1, train, carrige)
end)

RegisterServerEvent("usa_trains:deleteTrainServer")
AddEventHandler("usa_trains:deleteTrainServer", function(id)
	local carrigeID = nil
	for i,v in ipairs(southboundTrains) do
		if v.id == id then
			table.remove(southboundTrains, i)
		end
	end
	for i,v in ipairs(northboundTrains) do
		if v.id == id then
			table.remove(northboundTrains, i)
		end
	end
	for i,v in ipairs(trains) do
		if v.trainNetID == id then
			carrigeID = v.carrigeNetID
			table.remove(trains, i)
		end
	end

	TriggerClientEvent("usa_trains:syncDeleteTrain", -1, id, carrigeID)
end)

RegisterServerEvent("usa_trains:toggleDoors")
AddEventHandler("usa_trains:toggleDoors", function(train, open)
	TriggerClientEvent("usa_trains:toggleDoorsC", -1, train, open)
end)

RegisterServerEvent("usa_trains:setTrainTrack")
AddEventHandler("usa_trains:setTrainTrack", function(trainNetID, direction, type)
	local owner = source
	if direction == "north" then
		for i,v in ipairs(southboundTrains) do
			if v.id == trainNetID then
				table.remove(southboundTrains, i)
				break
			end
		end
		table.insert(northboundTrains, {id = trainNetID, type = type, owner = owner})
	elseif direction == "south" then
		for i,v in ipairs(northboundTrains) do
			if v.id == trainNetID then
				table.remove(northboundTrains, i)
				break
			end
		end
		table.insert(southboundTrains, {id = trainNetID, type = type, owner = owner})
	end
end)

RegisterServerEvent("usa_trains:checkTrainDriver")
AddEventHandler("usa_trains:checkTrainDriver", function(id)
	local source = source
	for i,v in ipairs(trains) do
		if v.trainNetID == id then
			local isDriver = (v.driver == source)
			TriggerClientEvent("usa_trains:checkTrainDriverCB", source, id, isDriver)
		end
	end
end)

-- check distances
Citizen.CreateThread(function()
	while true do
		for i,v in ipairs(southboundTrains) do
			TriggerClientEvent("usa_trains:checkDistances", v.owner, v.id, v.type, southboundTrains)
		end
		Citizen.Wait(2000)
	end
end)
Citizen.CreateThread(function()
	while true do
		for i,v in ipairs(northboundTrains) do
			TriggerClientEvent("usa_trains:checkDistances", v.owner, v.id, v.type, northboundTrains)
		end
		Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
	local lastUpdateTime = os.time()
	while true do
		if os.difftime(os.time(), lastUpdateTime) >= updateInterval then
			for i, data in pairs(trains) do
				trains[i].coords = vector3(GetEntityCoords(NetworkGetEntityFromNetworkId(data.trainNetID)))
			end
			TriggerClientEvent("usa_trains:updateAll", -1, trains)
			lastUpdateTime = os.time()
		end
		Wait(500)
	end
end)

RegisterServerEvent("usa_trains:buyTicket")
AddEventHandler("usa_trains:buyTicket", function(ticket_type)
	local source = source
	if ticket_type == "metro" then
		local char = exports["usa-characters"]:GetCharacter(source)
		if char.get("money") >= 50 then
			char.removeMoney(50)
			TriggerClientEvent("usa_trains:issueTicket", source, ticket_type, true)
			TriggerClientEvent("usa:notify", source, "You have bought a metro daypass for $50")
			local charid = char.get("_id")
			table.insert(metroPasses, charid)
		else
			TriggerClientEvent("usa:notify", source, "You do not have enough money for a Day Pass ($50)")
		end
	elseif ticket_type == "train" then
		local char = exports["usa-characters"]:GetCharacter(source)
		if char.get("money") >= 100 then
			char.removeMoney(100)
			TriggerClientEvent("usa_trains:issueTicket", source, ticket_type, true)
			TriggerClientEvent("usa:notify", source, "You have bought a train day ticket for $100")
			local charid = char.get("_id")
			table.insert(trainTickets, charid)
		else
			TriggerClientEvent("usa:notify", source, "You do not have enough money for a Day Ticket ($100)")
		end
	end
end)

RegisterServerEvent("usa_trains:passengerNoTicket")
AddEventHandler("usa_trains:passengerNoTicket", function(player_coords)
	local distances = {}
	for i,v in ipairs(trains) do
		local train_coords = v.coords
		local d = #(player_coords - train_coords)
		table.insert(distances, {driver = v.driver, distance = d})
	end
	local min = math.huge
	local result = nil
	for i = 1, #distances  do
		if distances[i].distance < min and min then
			min = distances[i].distance
			result = distances[i].driver
		end
	end
	TriggerClientEvent("usa:notify", result, "Head's Up: There is a passenger on your train without a Ticket!")
end)

AddEventHandler("character:loaded", function(char)
	local hasMetroPass = false
	local hasTrainTicket = false
	for i,v in ipairs(metroPasses) do
		if v == char.get("_id") then
			hasMetroPass = true
		end
	end
	for i,v in ipairs(trainTickets) do
		if v == char.get("_id") then
			hasTrainTicket = true
		end
	end
	TriggerClientEvent("usa_trains:issueTicket", char.get("source"), "metro", hasMetroPass)
	TriggerClientEvent("usa_trains:issueTicket", char.get("source"), "train", hasTrainTicket)
end)

RegisterServerEvent("usa_trains:metroJobToggle")
AddEventHandler("usa_trains:metroJobToggle", function(isJob)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	if isJob then
		if char.hasItem("Driver's License") then
			char.set("job", "metroDriver")
		else
			TriggerClientEvent("usa:notify", usource, "You do not have a Driver's License.")
		end
	else
		char.set("job", "civ")
	end
end)

RegisterServerEvent("usa_trains:metroSpawnRequest")
AddEventHandler("usa_trains:metroSpawnRequest", function()
	local usource = source
	local trackOccupied = false
	local metroSpawnCoords = vector3(-898.7032, -2339.0503, -11.6807)
	for i,v in ipairs(southboundTrains) do
		print(#(metroSpawnCoords - GetEntityCoords(NetworkGetEntityFromNetworkId(v.id))))
		if #(metroSpawnCoords - GetEntityCoords(NetworkGetEntityFromNetworkId(v.id))) < 280 then
			trackOccupied = true
			break
		end
	end
	print(trackOccupied)
	if trackOccupied then
		TriggerClientEvent("usa:notify", usource, "The tack is currently occupied please wait until the current train has left the station!")
	else
		TriggerClientEvent("usa_trains:spawnTrain", usource, 25)
	end
end)

RegisterServerEvent("usa_trains:trainJobToggle")
AddEventHandler("usa_trains:trainJobToggle", function(isJob)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	if isJob then
		if char.hasItem("Driver's License") then
			char.set("job", "trainDriver")
		else
			TriggerClientEvent("usa:notify", usource, "You do not have a Driver's License.")
		end
	else
		char.set("job", "civ")
	end
end)

RegisterServerEvent("usa_trains:trainSpawnRequest")
AddEventHandler("usa_trains:trainSpawnRequest", function()
	local usource = source
	local trackOccupied = false
	local trainSpawnCoords = vector3(217.3837, -2509.7693, 6.4603)
	for i,v in ipairs(northboundTrains) do
		print(#(trainSpawnCoords - GetEntityCoords(NetworkGetEntityFromNetworkId(v.id))))
		if #(trainSpawnCoords - GetEntityCoords(NetworkGetEntityFromNetworkId(v.id))) < 280 then
			trackOccupied = true
			break
		end
	end
	print(trackOccupied)
	if trackOccupied then
		TriggerClientEvent("usa:notify", usource, "The tack is currently occupied please wait until the current train has left the trainyard!")
	else
		TriggerClientEvent("usa_trains:spawnTrain", usource, 0, trainSpawnCoords)
	end
end)
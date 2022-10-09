local trains = {}

RegisterServerEvent("usa_trains:seat")
AddEventHandler("usa_trains:seat", function(train, ped)
	local deseat = false
	for i,v in ipairs(trains) do
		if (v.netID == train) then
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
		if (v.netID == train) then
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
AddEventHandler("usa_trains:createTrain", function(train, driver)
	local object = {
		driver = driver,
		netID = train,
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
end)

RegisterServerEvent("usa_trains:toggleDoors")
AddEventHandler("usa_trains:toggleDoors", function(train, open)
	TriggerClientEvent("usa_trains:toggleDoorsC", -1, train, open)
end)
local trains = {}

RegisterServerEvent("usa_trains:seat")
AddEventHandler("usa_trains:seat", function(train, ped)
	local deseat = false
	for i,v in ipairs(trains) do
		print(v.netID)
		if (v.netID == train) then
			for k,v in pairs(v.seats) do
				print(k,v.taken)
				if (v.taken == ped) then
					TriggerClientEvent("usa_trains:unseat_player", source)
					v.taken = nil
					print(v.taken)
					deseat = true
					break
				end
			end

			if not deseat then
				for k,v in pairs(v.seats) do
					if (v.taken == nil) then
						v.taken = ped
						print(v.taken)
						TriggerClientEvent("usa_trains:seat_player", source, {x = v.x, y = v.y, z = v.z}, train)
						break
					end
					print("no seats")
				end
			end
		end
	end
end)

RegisterServerEvent("usa_trains:createTrain")
AddEventHandler("usa_trains:createTrain", function(train)
	print("creating object" .. train)
	local object = {
		netID = train,
		seats = {
			seat1 = {taken = 123, x = 1.0, y = 1.5, z = -0.65},
			seat2 = {taken = nil, x = -1.0, y = 1.5, z = -0.65},
			-- seat3 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat4 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat5 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat6 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat7 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat8 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat9 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat10 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat11 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat12 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat13 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat14 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat15 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat16 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat17 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat18 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat19 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat20 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat21 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat22 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat23 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat24 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat25 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat26 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat27 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat28 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat29 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat30 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat31 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
			-- seat32 = {taken = nil, x = 1.0, y = 1.0, z = 1.0},
		},
	}

	table.insert(trains, object)
end)
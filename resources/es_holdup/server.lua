local COPS_NEEDED_TO_ROB = 2
local stores = {
	["Los Santos Customs - Paleto"] = {
		position = { ['x'] = 99.053, ['y'] = 6620.112, ['z'] = 32.44 },
		nameofstore = "Los Santos Customs - Paleto",
		lastrobbed = 0
	},
	["Car Dealership - Paleto"] = {
		position = { ['x'] = 123.356, ['y'] = 6629.426, ['z'] = 31.9117 },
		nameofstore = "Car Dealership - Paleto",
		lastrobbed = 0
	},
	["24/7 Paleto"] = {
		position = { ['x'] = 1728.77, ['y'] = 6417.61, ['z'] = 35.0372161865234 },
		nameofstore = "24/7 (Paleto Bay)",
		lastrobbed = 0
	},
	["Gun Store - Sandy Shores"] = {
		position = { ['x'] = 1689.613, ['y'] = 3758.355, ['z'] = 34.705 },
		nameofstore = "Gun Store - Sandy Shores",
		lastrobbed = 0
	},
	["Pizza Delivery - Sandy Shores"] = {
		position = { ['x'] = 1902.687, ['y'] = 3734.021, ['z'] = 32.588 },
		nameofstore = "Pizza Delivery - Sandy Shores",
		lastrobbed = 0
	},
	["24/7 Sandy Shores"] = {
		position = { ['x'] = 1960.033, ['y'] = 3748.403, ['z'] = 32.343 },
		nameofstore = "24/7 (Sandy Shores)",
		lastrobbed = 0
	},
	["Los Santos Customs - Route 68, Harmony"] = {
		position = { ['x'] = 1187.163, ['y'] = 2636.262, ['z'] = 38.401 },
		nameofstore = "Los Santos Customs - Route 68, Harmony",
		lastrobbed = 0
	},
	["Revsta's Boat Shop - Sandy Shores"] = {
		position = { ['x'] = 2392.283, ['y'] = 4292.408, ['z'] = 31.998 },
		nameofstore = "Revsta's Boat Shop - Sandy Shores",
		lastrobbed = 0
	},
	["Revsta's Boat Shop - Paleto"] = {
		position = { ['x'] = 254.205, ['y'] = 6635.504, ['z'] = 1.784 },
		nameofstore = "Revsta's Boat Shop - Paleto",
		lastrobbed = 0
	},
	["Seaview Aircraft - Grapeseed"] = {
		position = { ['x'] = 2119.411, ['y'] = 4783.381, ['z'] = 40.97 },
		nameofstore = "Seaview Aircraft - Grapeseed",
		lastrobbed = 0
	},
	["Seaview Aircraft - Sandy Shores"] = {
		position = { ['x'] = 1723.332, ['y'] = 3290.0451, ['z'] = 41.196 },
		nameofstore = "Seaview Aircraft - Sandy Shores",
		lastrobbed = 0
	},
	["Garage - Paleto"] = {
		position = { ['x'] = -306.659, ['y'] = 6127.877, ['z'] = 31.499 },
		nameofstore = "Garage - Paleto",
		lastrobbed = 0
	},
	["Garage - Grapeseed"] = {
		position = { ['x'] = 1702.25, ['y'] = 4938.936, ['z'] = 42.078 },
		nameofstore = "Garage - Grapeseed",
		lastrobbed = 0
	},
	["Clothing Store - Paleto"] = {
		position = { ['x'] = 3.715, ['y'] = 6505.654, ['z'] = 31.877 },
		nameofstore = "Clothing Store - Paleto",
		lastrobbed = 0
	},
	["Blaine County Savings Bank"] = {
		position = { ['x'] = 103.53, ['y'] = 6477.866, ['z'] = 31.626 },
		nameofstore = "Blaine County Savings Bank",
		lastrobbed = 0
	},
	["Gas Station - Sandy Shores"] = {
		position = { ['x'] = 2001.7367, ['y'] = 3779.16, ['z'] = 32.18 },
		nameofstore = "Gas Station - Sandy Shores",
		lastrobbed = 0
	},
	["Gas Station - Paleto Blvd & Cascabel"] = {
		position = { ['x'] = 95.917, ['y'] = 6412.034, ['z'] = 31.468 },
		nameofstore = "Gas Station - Paleto Blvd & Cascabel",
		lastrobbed = 0
	},
	["Gas Station - Great Ocean Hwy & Procopio Dr."] = {
		position = { ['x'] = 180.0967, ['y'] = 6602.671, ['z'] = 31.868 },
		nameofstore = "Gas Station - Great Ocean Hwy & Procopio Dr.",
		lastrobbed = 0
	},
	["Car Wash - Paleto Blvd & Cascabel"] = {
		position = { ['x'] = 68.998, ['y'] = 6430.853, ['z'] = 31.438 },
		nameofstore = "Car Wash - Paleto Blvd & Cascabel",
		lastrobbed = 0
	},
	["Fish Restaurant - Paleto"] = {
		position = { ['x'] = -664.933, ['y'] = 5808.579, ['z'] = 17.518 },
		nameofstore = "Fish Restaurant - Paleto",
		lastrobbed = 0
	},
	["Ammunation - Route 68"] = {
		position = { ['x'] = 1122.222, ['y'] = 2697.431, ['z'] = 18.554},
		nameofstore = "Ammunation - Route 68",
		lastrobbed = 0
	},
	["Gun Store - Paleto"] = {
		position = { ['x'] = -334.4107, ['y'] = 6082.485, ['z'] = 31.455},
		nameofstore = "Gun Store - Paleto",
		lastrobbed = 0
	},
	-- below need testing:
	["Tow Truck - Paleto"] = {
		position = { ['x'] = -191.731, ['y'] = 6269.85, ['z'] = 31.489},
		nameofstore = "Tow Truck - Paleto",
		lastrobbed = 0
	},
	["Taxi Cab Co. - Paleto"] = {
		position = { ['x'] = -45.186, ['y'] = 6439.616, ['z'] = 31.490},
		nameofstore = "Taxi Cab Co. - Paleto",
		lastrobbed = 0
	},
	["Go-Postal - Paleto"] = {
		position = { ['x'] = -422.1905, ['y'] = 6135.021, ['z'] = 31.877},
		nameofstore = "Go-Postal - Paleto",
		lastrobbed = 0
	},
	["FridgeIt Trucking - Paleto"] = {
		position = { ['x'] = -568.065, ['y'] = 5253.392, ['z'] = 70.487},
		nameofstore = "FridgeIt Trucking - Paleto",
		lastrobbed = 0
	},
	["Herr Kutz Barber - Paleto"] = {
		position = { ['x'] = -277.958, ['y'] = 6229.62, ['z'] = 31.69},
		nameofstore = "Herr Kuts Barber - Paleto",
		lastrobbed = 0
	},
	["Tattoo Shop - Paleto"] = {
		position = { ['x'] = 292.94, ['y'] = 6197.46, ['z'] = 31.48},
		nameofstore = "Tattoo Shop - Paleto",
		lastrobbed = 0
	},
	["Herr Kutz Barber - Sandy Shores"] = {
		position = { ['x'] = 1930.88, ['y'] = 3728.8, ['z'] = 32.844},
		nameofstore = "Herr Kuts Barber - Sandy Shores",
		lastrobbed = 0
	},
	["Tattoo Shop - Sandy Shores"] = {
		position = { ['x'] = 1863.22, ['y'] = 3751.12, ['z'] = 33.03},
		nameofstore = "Tattoo Shop - Sandy Shores",
		lastrobbed = 0
	},
	["24/7 Market - Innocence Blvd"] = {
		position = { ['x'] = 24.9, ['y'] = -1343.6, ['z'] = 29.5 },
		nameofstore = "24/7 Market - Innocence Blvd",
		lastrobbed = 0
	},
	["Car Dealership - Los Santos"] = {
		position = { ['x'] = -31.5, ['y'] = -1106.9, ['z'] = 26.4 },
		nameofstore = "Car Dealership - Los Santos",
		lastrobbed = 0
	},
	["Clothing Store - Sinner St."] = {
		position = { ['x'] = 429.4, ['y'] = -808.3, ['z'] = 29.5 },
		nameofstore = "Car Dealership - Los Santos",
		lastrobbed = 0
	},
	["Ammunation - Adam's Apple Blvd."] = {
		position = { ['x'] = 14.3, ['y'] = -1106.2, ['z'] = 29.8 },
		nameofstore = "Ammunation - Adam's Apple Blvd.",
		lastrobbed = 0
	},
	["Benny's Garage - Strawberry Ave."] = {
		position = { ['x'] = -207.7, ['y'] = -1339.3, ['z'] = 34.9 },
		nameofstore = "Benny's Garage - Strawberry Ave.",
		lastrobbed = 0
	},
	["Blazing Tattoo - Vinewood Blvd."] = {
		position = { ['x'] = 320.6, ['y'] = 182.8, ['z'] = 103.6 },
		nameofstore = "Blazing Tattoo - Vinewood Blvd.",
		lastrobbed = 0
	},
	["24/7 Market - San Andreas Ave"] = {
		position = { ['x'] = -1220.3, ['y'] = -907.9, ['z'] = 12.3 },
		nameofstore = "24/7 Market - San Andreas Ave",
		lastrobbed = 0
	},
	["Tattoo Shop - Vespucci Beach"] = {
		position = { ['x'] = -1150.7, ['y'] = -1425, ['z'] = 4.9 },
		nameofstore = "Tattoo Shop - Vespucci Beach",
		lastrobbed = 0
	}
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', source, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
	local savedSource = source
	TriggerEvent("es:getPlayers", function(players)
		local count = 0
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
						count = count + 1
					end
				end
			end
			print("cop count: " .. count)
			print("cops needed: " .. COPS_NEEDED_TO_ROB)
			if count >= COPS_NEEDED_TO_ROB then
				print("returning true! enough cops on")
				if stores[robb] then
					local store = stores[robb]
					local robberyCooldown = 2100
					if (os.time() - store.lastrobbed) < robberyCooldown and store.lastrobbed ~= 0 then
						TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently. Please wait another: ^2" .. (1200 - (os.time() - store.lastrobbed)) .. "^0 seconds.")
						return
					end
					--TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. store.nameofstore)
					TriggerClientEvent('chatMessage', savedSource, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. store.nameofstore .. "^0, do not get too far away from this point!")
					TriggerClientEvent('chatMessage', savedSource, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
					TriggerClientEvent('chatMessage', savedSource, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^12 ^0minutes and the money is yours!")
					TriggerClientEvent('es_holdup:currentlyrobbing', savedSource, robb)
					--sendMessageToEmsAndPolice("^1DISPATCH: ^0Robbery in progress at ^2" .. store.nameofstore)
					stores[robb].lastrobbed = os.time()
					robbers[source] = robb
					SetTimeout(120000, function()
						if(robbers[savedSource])then
							--TriggerEvent('es:getPlayerFromId', savedSource, function(target)
							local target = exports["essentialmode"]:getPlayerFromId(savedSource)
								if(target)then
									print("target existed...")
									--target:addDirty_Money(store.reward)
									print("adding stolen money!")
									local user_money = target.getActiveCharacterData("money")
									TriggerEvent("properties:getPropertyMoney", robb, function(reward)
										reward = math.ceil(reward * 0.35)
										print("property was robbed of: $" .. reward)
										target.setActiveCharacterData("money", user_money + reward)
										--TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. store.nameofstore)
										sendMessageToEmsAndPolice("^1DISPATCH: ^0Robbery is over at: ^2" .. store.nameofstore)
										TriggerEvent("properties:withdraw", robb, reward, savedSource, false)
										TriggerClientEvent('es_holdup:robberycomplete', savedSource, reward)
									end)
								end
						--	end)
						end
					end)
					sendMessageToEmsAndPolice("^1DISPATCH: ^0Security Alarm Triggered at ^2" .. store.nameofstore)
				end
			else
				print("returning false! not enough cops on")
				TriggerClientEvent("usa:notify", savedSource, "Couldn't find any money!") -- not enough police on
			end
		end
	end)
end)

function sendMessageToEmsAndPolice(msg)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerJob = player.getActiveCharacterData("job")
					if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" or playerJob == "ems" then
						TriggerClientEvent("chatMessage", id, "", {}, msg)
					end
				end
			end
		end
	end)
end

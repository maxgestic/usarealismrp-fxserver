local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 6

-- prevent memory edit cheaters
local MIN_VEHICLE_PRICE = 500
local MAX_VEHICLE_SELL_PRICE = .50 * 4000000

-- VEHICLES
local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 10995, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 12000, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 15000, hash = -1775728740, storage_capacity = 175.0},
			{make = "Dundreary", model = "Landstalker", price = 15595, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 18000, hash = 1177543287, storage_capacity = 175.0},
			{make = "Phatom", model = "DQ2", price = 20000, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 20990, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 19500, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller", price = 28700, hash = 634118882, storage_capacity = 200.0}
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 24700, hash = -624529134, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Zion", price = 27450, hash = -1122289213, storage_capacity = 135.0},
			{make = "Dewbauchee", model = "Exemplar", price = 28070, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 30020, hash = 1349725314, storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Carbio", price = 33200, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 34550, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 105550, hash = -1930048799, storage_capacity = 135.0}
		},
		["Bicycles"] = {
			{make = "", model = "BMX", price = 500, hash = 1131912276, storage_capacity = 0.0},
			{make = "", model = "Cruiser", price = 500, hash = 448402357, storage_capacity = 0.0},
			{make = "", model = "Fixster", price = 850, hash = -836512833, storage_capacity = 0.0},
			{make = "", model = "Scorcher", price = 1200, hash = -186537451, storage_capacity = 0.0},
			{make = "", model = "TriBike", price = 1350, hash = 1127861609, storage_capacity = 0.0}
		},
		["Muscles"] = {
			{make = "Willand", model = "Faction", price = 10500, hash = -2119578145, storage_capacity = 160.0},
			{make = "Imponte", model = "Dukes", price = 10500, hash = 723973206, storage_capacity = 160.0},
			{make = "Declasse", model = "Vigero", price = 12500, hash = -825837129, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer", price = 12500, hash = -682211828, storage_capacity = 160.0},
			{make = "Imponte", model = "Ruiner", price = 12575, hash = -2039755226, storage_capacity = 160.0},
			{make = "Imponte", model = "Nightshade", price = 15850, hash = -1943285540, storage_capacity = 160.0},
			{make = "Declasse", model = "Sabre Turbo", price = 16775, hash = -1685021548, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator", price = 19400, hash = 80636076, storage_capacity = 160.0},
			{make = "Bravado", model = "Gauntlet", price = 21400, hash = -1800170043, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom", price = 25575, hash = -1790546981, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom Donk", price = 35575, hash = -2039755226, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo", price = 42000, hash = -498054846, storage_capacity = 160.0},
			{make = "Declasse", model = "Tampa", price = 45000, hash = 972671128, storage_capacity = 160.0}
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 10500, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 10500, hash = 1069929536, storage_capacity = 230.0},
			{make = "Vapid", model = "Sadler", price = 25500, hash = -599568815, storage_capacity = 230.0},
			{make = "Bravado", model = "Bison", price = 27110, hash = -16948145, storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 24000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van LR", price = 24000, hash = 1119641113, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking XL", price = 35000, hash = -1189015600, storage_capacity = 230.0},
			{make = "Vapid", model = "Contender", price = 40500, hash = 683047626, storage_capacity = 230.0},
			{make = "Vapid", model = "Guardian", price = 350000, hash =  -2107990196, storage_capacity = 230.0}
		},
		["Compacts"] = {
			{make = "Weedems", model = "Caddy", price = 3000, hash = -537896628, storage_capacity = 80.0},
			{make = "Karin", model = "Dilettante", price = 5500, hash = -1130810103, storage_capacity = 170.0},
			{make = "Benefactor", model = "Panto", price = 6000, hash = -431692672, storage_capacity = 125.0},
			{make = "Declasse", model = "Rhapsody", price = 6500, hash = 841808271, storage_capacity = 125.0},
			{make = "Dinka", model = "Blista Compact", price = 6500, hash = 1039032026, storage_capacity = 135.0},
			{make = "Bollocan", model = "Prairie", price = 8000, hash = -1450650718, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi", price = 8500, hash = -1177863319, storage_capacity = 125.0}
		},
		["Offroads"] = {
			{make = "Canis", model = "Kalahari", price = 10600, hash = 92612664, storage_capacity = 170.0},
			{make = "Declasse", model = "Rancher XL", price = 12500, hash = 1645267888, storage_capacity = 170.0},
			{make = "Nagasaki", model = "Blazer", price = 14000, hash = -2128233223, storage_capacity = 170.0},
			{make = "Coil", model = "Brawler", price = 48500, hash = -1479664699, storage_capacity = 170.0},
			{make = "BF", model = "Bifta", price = 75350, hash = -349601129, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa", price = 30500, hash = -2064372143, storage_capacity = 170.0}
		},
		["Motorcycles"] = {
			{make = "Pegassi", model = "Faggio Sport", price = 1200, hash = -1842748181, storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 5500, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Akuma", price = 7500, hash = 1672195559, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Sanchez", price = 17500, hash = -1453280962, storage_capacity = 30.0},
			{make = "Shitzu", model = "Vader", price = 8500, hash = -140902153, storage_capacity = 30.0},
			{make = "Western", model = "Bagger", price = 10500, hash = -2140431165, storage_capacity = 30.0},
			{make = "LCC", model = "Hexer", price = 12500, hash = 301427732, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Chopper", price = 15000, hash = -570033273, storage_capacity = 30.0},
			{make = "Western", model = "Nightblade", price = 15750, hash = -1606187161, storage_capacity = 30.0},
			{make = "Pegassi", model = "Bati 801", price = 20700, hash = -114291515, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Bobber", price = 21350, hash = -1009268949, storage_capacity = 30.0},
			{make = "Dinka", model = "Thrust", price = 23500, hash = 1836027715, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Carbon RS", price = 30000, hash = 11251904, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Chimera", price = 35000, hash = 67744871, storage_capacity = 30.0},
			{make = "LCC", model = "Sanctus", price = 225000, hash = 1491277511, storage_capacity = 30.0}
		},
		["Vans"] = {
			{make = "Vapid", model = "Speedo", price = 18000, hash = -810318068, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan", price = 19000, hash = -310465116, storage_capacity = 300.0},
			{make = "Vapid", model = "Clown", price = 29599, hash = 728614474, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito", price = 21000, hash = -1743316013, storage_capacity = 300.0},
			{make = "BF", model = "Surfer", price = 22500, hash = 699456151, storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 24000, hash = 1026149675, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo Custom", price = 38000, hash = 1475773103, storage_capacity = 300.0},
			{make = "Brute", model = "Camper", price = 45500, hash = 1876516712, storage_capacity = 300.0},
			{make = "Hennifers", model = "Taco Truck", price = 60500, hash = 1951180813, storage_capacity = 300.0}
		},
		["Sports"] = {
			{make = "Karin", model = "Sultan", price = 39500, hash = 970598228, storage_capacity = 145.0},
			{make = "Ubermacht", model = "Zion Cabrio", price = 40015, hash = -1193103848, storage_capacity = 145.0},
			{make = "Invetero", model = "Coquette", price = 65450, hash = 108773431, storage_capacity = 145.0},
			{make = "Bravado", model = "Buffalo S", price = 67899, hash = 736902334, storage_capacity = 145.0},
			{make = "Benefactor", model = "Surano", price = 72799, hash = 384071873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Massacro", price = 75000, hash = -142942670, storage_capacity = 145.0},
			{make = "Benefactor", model = "Schafter V12", price = 82000, hash = -1485523546, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 94500, hash = -1934452204, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 95000, hash = 196747873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Seven-70", price = 110999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 120000, hash = 1886268224, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy RH8", price = 175000, hash = -566387422, storage_capacity = 145.0},
			{make = "Hijak", model = "Khamelion", price = 225000, hash = 544021352, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan RS", price = 248500, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 250700, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 285500, hash = -1461482751, storage_capacity = 145.0},
			{make = "Dinka", model = "Jester", price = 350000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 370000, hash = -1372848492, storage_capacity = 145.0}
		},
		["Supers"] = {
			{make = "Pegassi", model = "Infernus", price = 500500, hash = 418536135, storage_capacity = 100.0},
			{make = "Vapid", model = "Bullet", price = 650000, hash = -1696146015, storage_capacity = 100.0},
			{make = "Grotti", model = "Cheetah", price = 757000, hash = -1311154784, storage_capacity = 100.0},
			{make = "Pfister", model = "811", price = 758000, hash = -1829802492, storage_capacity = 100.0},
			{make = "Pegassi", model = "Vacca", price = 850000, hash = 338562499, storage_capacity = 100.0},
			{make = "Progen", model = "T20", price = 1050000, hash = 1663218586, storage_capacity = 100.0},
			{make = "Pegassi", model = "Osiris", price = 1250000, hash = 1987142870, storage_capacity = 100.0},
			{make = "Truffade", model = "Adder", price = 1400000, hash = -1216765807, storage_capacity = 100.0},
			{make = "Progen", model = "GP1", price = 1625000, hash = 1234311532, storage_capacity = 100.0},
			{make = "Pegassi", model = "Reaper", price = 1805000, hash = 234062309, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero", price = 2050000, hash = 1034187331, storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 2100000, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 2500000, hash = 1426219628, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB", price = 2650000, hash = -2048333973, storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 2800000, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 3400999, hash = 917809321, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 4000000, hash = 408192225, storage_capacity = 100.0}
		},
		["Classic"] = {
			{make = "Declasse", model = "Tornado", price = 30000, hash = 464687292, storage_capacity = 150.0},
			{make = "Vapid", model = "Peyote", price = 100000, hash = 1830407356, storage_capacity = 135.0},
			{make = "Lampadati", model = "Casco", price = 183007, hash = 941800958, storage_capacity = 135.0},
			{make = "Pegassi", model = "Monroe", price = 250800, hash = -433375717, storage_capacity = 135.0},
			{make = "Grotti", model = "Turismo Classic", price = 295350, hash = -982130927, storage_capacity = 135.0},
			{make = "Grotti", model = "Stinger", price = 200000, hash = 1545842587, storage_capacity = 115.0},
			{make = "Grotti", model = "Stinger GT", price = 315600, hash = -2098947590, storage_capacity = 135.0},
			{make = "Pegassi", model = "Infernus Classic", price = 350750, hash = -1405937764, storage_capacity = 135.0},
			{make = "Albany", model = "Roosevelt Valor", price = 550350, hash = -602287871, storage_capacity = 135.0},
			{make = "Ocelot", model = "Ardent", price = 75000, hash = 159274291, storage_capacity = 130.0},
			{make = "Grotti", model = "Cheetah Clasic", price = 100000, hash = 223240013, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 100000, hash = 1011753235, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 130000, hash = 784565758, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "JB 700", price = 100000, hash = 1051415893, storage_capacity = 120.0},
			{make = "Declasse", model = "Mamba", price = 110000, hash = -1660945322, storage_capacity = 110.0},
			{make = "Albany", model = "Manana", price = 24500, hash = -2124201592, storage_capacity = 140.0},
			{make = "Lampadati", model = "Pigalle", price = 24000, hash = 1078682497, storage_capacity = 125.0},
			{make = "Pegassi", model = "Torero", price = 300000, hash = 1504306544, storage_capacity = 100.0}
		},
		["Sedans"] = {
			{make = "Albany", model = "Emperor", price = 3500, hash = -1883002148, storage_capacity = 165.0},
			{make = "Albany", model = "Washington", price = 9989, hash = 1777363799, storage_capacity = 165.0},
			{make = "Albany", model = "Primo", price = 6000, hash = -1150599089, storage_capacity = 165.0},
			{make = "Karin", model = "Intruder", price = 6595, hash = 886934177, storage_capacity = 165.0},
			{make = "Vulcan", model = "Ingot", price = 9500, hash = -1289722222, storage_capacity = 165.0},
			{make = "Zinconium", model = "Stratum", price = 9500, hash = 1723137093, storage_capacity = 165.0},
			{make = "Vapid", model = "Stanier", price = 13500, hash = -1477580979, storage_capacity = 165.0},
			{make = "Benefactor", model = "Glendale", price = 15000, hash = 75131841, storage_capacity = 165.0},
			{make = "Vulcan", model = "Warrener", price = 15500, hash = 1373123368, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Oracle", price = 55000, hash = -511601230, storage_capacity = 165.0},
			{make = "Enus", model = "Cognoscenti", price = 85500, hash = -2030171296, storage_capacity = 165.0},
			{make = "Enus", model = "Super Diamond", price = 95000, hash = 1123216662, storage_capacity = 165.0},
			{make = "Obey", model = "Tailgater", price = 115000, hash = -1008861746, storage_capacity = 165.0}
		},
		["Specials"] = {
			{make = "Dundreary", model = "Stretch", price = 45000, hash = -1961627517, storage_capacity = 300.0},
			{make = "Maibatsu", model = "Mule", price = 50000, hash = 904750859, storage_capacity = 475.0},
			{make = "Maibatsu", model = "Mule 2", price = 52000, hash = -1050465301, storage_capacity = 475.0},
			{make = "Maibatsu", model = "Mule 3", price = 70000, hash = -2052737935, storage_capacity = 475.0},
			{make = "MTL", model = "Pounder", price = 110000, hash = 2112052861, storage_capacity = 900.0},
			{make = "Declasse", model = "Burrito Lost", price = 100000, hash = -1745203402, storage_capacity = 260.0},
			{make = "Vapid", model = "Slam Van Lost", price = 150000, hash = 833469436, storage_capacity = 260.0},
			{make = "Bati", model = "801 Race", price = 175000, hash = -891462355, storage_capacity = 165.0},
			{make = "Declasse", model = "Stallion Special", price = 500000, hash =  -401643538, storage_capacity = 155.0},
			{make = "Bravado", model = "Buffalo Special", price = 800000, hash = 237764926, storage_capacity = 155.0},
			{make = "Vapid", model = "Dominator Special", price = 825000, hash = -915704871, storage_capacity = 155.0},
			{make = "BF", model = "Raptor", price = 1000000, hash = -674927303, storage_capacity = 30.0},
			{make = "Dewbauchee", model = "Massacro Special", price = 1800000, hash = -631760477, storage_capacity = 130.0},
			{make = "Dinka", model = "Jester Special", price = 2500000, hash = -1106353882, storage_capacity = 120.0}
		}
	}
}

function getPlayerIdentifierEasyMode(source)
	local rawIdentifiers = GetPlayerIdentifiers(source)
	if rawIdentifiers then
		for key, value in pairs(rawIdentifiers) do
			playerIdentifier = value
		end
    else
		print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
	end
	return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

function stringSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function getPlayersLicense(source) -- TODO: UPDATE THIS FUNCTION TO CORRECLATE TO UPDATED DB DOCUMENT STRUCTURE
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local licenses = user.getActiveCharacterData("license")
		for i = 1, #licenses do
			if licenses[i].name == "Driver's License" then
				license = licenses[i]
				return license
			end
		end
		return nil
	end)
end

function alreadyHasVehicle(source, vehName)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			if vehicles[i].model == vehName then
				return true
			end
		end
		return false
	end)
end

function alreadyHasAnyVehicle(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local cars = user.getActiveCharacterData("vehicles")
		if #cars > 0 then
			return true
		else
			return false
		end
	end)
end

RegisterServerEvent("vehShop:buyInsurance")
AddEventHandler("vehShop:buyInsurance", function(userSource)
	print("user source = " .. userSource)
	local INSURANCE_COVERAGE_MONTHLY_COST = 7500
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local insurance = user.getActiveCharacterData("insurance")
		local user_money = user.getActiveCharacterData("money")
		if user_money >= INSURANCE_COVERAGE_MONTHLY_COST then
			local insurancePlan = {
				planName = "T. Ends Auto Insurance",
				type = "auto",
				valid = true,
				purchaseDate = os.date('%m-%d-%Y %H:%M:%S', os.time()),
				purchaseTime = os.time()
			}
			user.setActiveCharacterData("insurance", insurancePlan)
			print("taking $" .. INSURANCE_COVERAGE_MONTHLY_COST .. " from player for auto insurance!")
			user.setActiveCharacterData("money", user_money - INSURANCE_COVERAGE_MONTHLY_COST)
			TriggerClientEvent("vehShop:notify", userSource, "~w~Thanks for purchasing auto insurance coverage! Your coverage expires in ~y~31~w~ days.")
		else
			print("player did not have enough money to buy insurance")
			TriggerClientEvent("vehShop:notify", userSource, "You ~r~don't have enough money~w~ to buy auto insurance coverage!")
		end
	end)
end)

RegisterServerEvent("vehShop:fileClaim")
AddEventHandler("vehShop:fileClaim", function(vehicle_to_claim)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user_vehicles = user.getActiveCharacterData("vehicles")
		local user_bank = user.getActiveCharacterData("bank")
		if user_vehicles then
			for i = 1, #user_vehicles do
				local veh = user_vehicles[i]
				if veh then
					if veh.plate == vehicle_to_claim.plate then
						-- todo: add a realistic time delay for 'processing' before setting stored = true above
						local BASE_FEE = 300
						local PERCENTAGE = .10
						local CLAIM_PROCESSING_FEE = round(BASE_FEE + (PERCENTAGE * vehicle_to_claim.price))
						print("claim fee: $" .. CLAIM_PROCESSING_FEE)
						if CLAIM_PROCESSING_FEE <= user_bank then
							user_vehicles[i].inventory = {} -- empty inventory to prevent duplicating
							user_vehicles[i].stored = true -- set to true for retrieval from garage
							user.setActiveCharacterData("vehicles", user_vehicles)
							user.setActiveCharacterData("bank", user_bank - CLAIM_PROCESSING_FEE)
							if veh.make and veh.model then
								TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. veh.make .. " " .. veh.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
							else
								TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. veh.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
							end
						else
							TriggerClientEvent("usa:notify", userSource, "You don't have enough money to make a claim on that vehicle.")
						end
					end
				end
			end
		end
	end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end

RegisterServerEvent("vehShop:checkPlayerInsurance")
AddEventHandler("vehShop:checkPlayerInsurance", function()
	print("checking for auto insurance!")
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local playerInsurance = user.getActiveCharacterData("insurance")
		if playerInsurance.type == "auto" then
			print("found player auto insurance!")
			if playerHasValidAutoInsurance(playerInsurance) then
				TriggerClientEvent("chatMessage", userSource, "T. END'S INSURANCE", {255, 78, 0}, "You are already insured!")
			else
				print("renewing auto insurance!")
				TriggerClientEvent("chatMessage", userSource, "T. END'S INSURANCE", {255, 78, 0}, "Your auto insurance coverage was ~r~expired~w~! Renewing...")
				TriggerEvent("vehShop:buyInsurance", userSource)
			end
		else
			print("no auto insurance found!")
			TriggerEvent("vehShop:buyInsurance", userSource)
		end
	end)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle)
	local playerIdentifier = getPlayerIdentifierEasyMode(source)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local allLicenses = user.getActiveCharacterData("licenses")
		local license = nil
		local vehicles = user.getActiveCharacterData("vehicles")
		local user_money = user.getActiveCharacterData("money")
		local owner_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		if #vehicles <= MAX_PLAYER_VEHICLES then
			for i = 1, #allLicenses do
				if allLicenses[i].name == "Driver's License" then
					license = allLicenses[i]
					break
				end
			end
			if license ~= nil then
				if license.status == "valid" then
					hash = vehicle.hash
					price = GetVehiclePrice(vehicle)
					if price >= MIN_VEHICLE_PRICE then
						if not alreadyHasVehicle(userSource, vehicleName) then
							if tonumber(price) <= user_money then
								-- todo: change below plate number
								plate = tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
								if vehicles then
									user.setActiveCharacterData("money", user_money - tonumber(price))
									local vehicle = {
										owner = owner_name,
										make = vehicle.make,
										model = vehicle.model,
										hash = hash,
										plate = plate,
										stored = false,
										price = price,
										inventory = {},
										storage_capacity = vehicle.storage_capacity
									}
									local vehicle_key = {
										name = "Key -- " .. plate,
										quantity = 1,
										type = "key",
										owner = owner_name,
										make = vehicle.make,
										model = vehicle.model,
										plate = plate
									}
									--  prevent gui menu from breaking i believe (i think 16 is max # of menu items possible)
									print("buying vehicle")
									table.insert(vehicles, vehicle)
									user.setActiveCharacterData("vehicles", vehicles)
									print("vehicle purchased!")
									print("vehicle.owner = " .. vehicle.owner)
									print("vehicle.model = " .. vehicle.model)
									print("vehicle.plate = " .. vehicle.plate)
									print("vehicle.stored = " .. tostring(vehicle.stored))
									print("vehicle.storage_capacity = " .. vehicle.storage_capacity)
									-- give player the key to the whip
									local inv = user.getActiveCharacterData("inventory")
									table.insert(inv, vehicle_key)
									user.setActiveCharacterData("inventory", inv)
									-- add vehicle plate to locking resource list:
									TriggerEvent("lock:addPlate", vehicle.plate)
									--TriggerEvent("sway:updateDB", userSource)
									TriggerClientEvent("usa:notify", userSource, "Here are the keys! Thanks for your business!")
									TriggerClientEvent("vehShop:spawnPlayersVehicle", userSource, hash, plate)
								end
							else
								TriggerClientEvent("mini:insufficientFunds", userSource, price, "vehicle")
							end
						else
							TriggerClientEvent("vehShop:alreadyOwnVehicle", userSource)
						end
					end
				else
					TriggerClientEvent("mini:invalidLicense", userSource)
				end
			else
				TriggerClientEvent("mini:noLicense", userSource)
			end
		else
			print("NOT buying vehicle...")
			TriggerClientEvent("vehShop:notify", userSource, "Sorry, you can't own more than " .. MAX_PLAYER_VEHICLES .. " vehicles at this time!")
		end
	end)
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if vehicle then
				local sellPrice = round(vehicle.price * .5,0)
				vehicles[i].sellPrice = sellPrice
			end
		end
		print("vehicles loaded! # = " .. #vehicles)
		TriggerClientEvent("vehShop:displayVehiclesToSell", userSource, vehicles)
	end)
end)

RegisterServerEvent("vehShop:loadVehicles")
AddEventHandler("vehShop:loadVehicles", function(check_insurance)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if check_insurance then
			local user_insurance = user.getActiveCharacterData("insurance")
			if user_insurance.type == "auto" then
				print("player has valid auto insurance!")
				local vehicles = user.getActiveCharacterData("vehicles")
				if vehicles then
					print("vehicles loaded! # = " .. #vehicles)
					TriggerClientEvent("vehShop:loadedVehicles", userSource, vehicles, true)
				end
			else
				print("player has no auto insurance!")
				TriggerClientEvent("usa:notify", userSource, "You do not have any auto insurance!")
			end
		else
			local vehicles = user.getActiveCharacterData("vehicles")
			if vehicles then
				print("vehicles loaded! # = " .. #vehicles)
				TriggerClientEvent("vehShop:loadedVehicles", userSource, vehicles, false)
			end
		end
	end)
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if vehicle.plate == toSellVehicle.plate then
				table.remove(vehicles, i)
				local oldMoney = user.getActiveCharacterData("money")
				local vehiclePrice = GetVehiclePrice(toSellVehicle)
				if not vehiclePrice then vehiclePrice = 10000 end
				local newMoney = round(oldMoney + (vehiclePrice * .50),0)
				if (vehicle.price * .50) <= MAX_VEHICLE_SELL_PRICE then
					user.setActiveCharacterData("money", newMoney)
					user.setActiveCharacterData("vehicles", vehicles)
					print("vehicle " .. vehicle.model .. " sold for $" .. newMoney)
					return
				else
					print("*** PLAYER " .. GetPlayerName(userSource) .. " tried to exploit money from the vehicle shop! ***")
					return
				end
			end
		end
	end)
end)

function GetVehiclePrice(vehicle)
	for k, v in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #v do
			if vehicle.hash == v[i].hash then
				print("matching hash found for vehicle price!")
				return v[i].price
			end
		end
		print("no matching hash found to sell! hash: " .. vehicle.hash)
	end
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function playerHasValidAutoInsurance(playerInsurance)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			local reference = playerInsurance.purchaseTime
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			print(wholedays) -- today it prints "1"
			if wholedays < 32 then
				return true -- valid insurance, it was purchased 31 or less days ago
			else
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

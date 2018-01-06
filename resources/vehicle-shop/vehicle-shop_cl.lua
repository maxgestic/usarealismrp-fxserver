local markerX, markerY, markerZ = 120.924,6624.605,31.000 -- paleto
--local markerX, markerY, markerZ = -43.2616, -1097.37, 25.3523 (los santos)
--local spawnX, spawnY, spawnZ = -48.884, -1113.75, 26.4358 -- (los santos)
local spawnX, spawnY, spawnZ = 131.04, 6625.39, 31.71 -- (paleto)

local menu = {}

--[[
Coupes:175
Muscle: 160
Trucks: 325
Compacts:  105
Off-roads : 150
Motorcycle: 30
Vans: 450
Sports: 120
Supers: 85
Classic: 90
Sedans: 150
]]

-- VEHICLES
local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 10995, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 12000, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 15000, hash = -1775728740, storage_capacity = 175.0},
			{make = "Dundreary", model = "Landstalker", price = 15595, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 18000, hash = 1177543287, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 20990, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 19500, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller", price = 28700, hash = 1878062887, storage_capacity = 175.0}
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
			{make = "Willand", model = "Faction Custom Donk", price = 35575, hash = -2039755226, storage_capacity = 160.0}
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
			{make = "Rimka", model = "Taco Truck", price = 60500, hash = 1951180813, storage_capacity = 300.0}
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
			{make = "Karin", model = "Sultan RS", price = 248500, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 250700, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 285500, hash = -1461482751, storage_capacity = 145.0},
			{make = "Dinka", model = "Jester", price = 350000, hash = -1297672541, storage_capacity = 145.0}
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
			{make = "Truffade", model = "Nero", price = 2050000, hash = 1034187331, storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 2100000, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 2500000, hash = 1426219628, storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 2800000, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 3400999, hash = 917809321, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 4000000, hash = 408192225, storage_capacity = 100.0}
		},
		["Classic"] = {
			{make = "Vapid", model = "Peyote", price = 100000, hash = 1830407356, storage_capacity = 135.0},
			{make = "Lampadati", model = "Casco", price = 183007, hash = 941800958, storage_capacity = 135.0},
			{make = "Pegassi", model = "Monroe", price = 250800, hash = -433375717, storage_capacity = 135.0},
			{make = "Grotti", model = "Turismo Classic", price = 295350, hash = -982130927, storage_capacity = 135.0},
			{make = "Grotti", model = "Stinger GT", price = 315600, hash = -2098947590, storage_capacity = 135.0},
			{make = "Pegassi", model = "Infernus Classic", price = 350750, hash = -1405937764, storage_capacity = 135.0},
			{make = "Albany", model = "Roosevelt Valor", price = 550350, hash = -602287871, storage_capacity = 135.0}
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
			{make = "Enus", model = "Super Diamond", price = 95000, hash = 1123216662, storage_capacity = 165.0}
		},
		["Specials"] = {
			{make = "Maibatsu", model = "Mule", price = 50000, hash = 904750859, storage_capacity = 475.0},
			{make = "Maibatsu", model = "Mule 2", price = 52000, hash = -1050465301, storage_capacity = 475.0},
			{make = "Maibatsu", model = "Mule 3", price = 70000, hash = -2052737935, storage_capacity = 475.0},
			{make = "MTL", model = "Pounder", price = 110000, hash = 2112052861, storage_capacity = 900.0},
			{make = "Declasse", model = "Burrito Lost", price = 100000, hash = -1745203402, storage_capacity = 260.0},
			{make = "Declasse", model = "Burrito Lost", price = 100000, hash = -1745203402, storage_capacity = 260.0},
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

RegisterNetEvent("vehShop:spawnPlayersVehicle")
AddEventHandler("vehShop:spawnPlayersVehicle", function(hash, plate)
	Citizen.Trace("spawning players vehicle...")
	local numberHash = tonumber(hash)
	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(numberHash)
		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(numberHash) do
			RequestModel(numberHash)
			Citizen.Wait(0)
		end
		-- Model loaded, continue
		-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(numberHash, spawnX, spawnY, spawnZ, 315.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetVehicleNumberPlateText(vehicle, plate)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
		--SetVehicleAsNoLongerNeeded(vehicle)
	end)

end)

RegisterNetEvent("mini:invalidLicense")
AddEventHandler("mini:invalidLicense", function()

	TriggerEvent("chatMessage", "Dealer", { 255,99,71 }, "^0Come back when your license is valid!")

end)

RegisterNetEvent("mini:noLicense")
AddEventHandler("mini:noLicense", function()

	TriggerEvent("chatMessage", "Dealer", { 255,99,71 }, "^0Come back when you have a license!")

end)

RegisterNetEvent("vehShop:alreadyOwnVehicle")
AddEventHandler("vehShop:alreadyOwnVehicle", function()

	TriggerEvent("chatMessage", "Dealer", { 255,99,71 }, "^0You already own that vehicle!")

end)

RegisterNetEvent("mini:insufficientFunds")
AddEventHandler("mini:insufficientFunds", function(price, purchaseType)
	if purchaseType == "vehicle" then
		TriggerEvent("chatMessage", "Dealer", { 255,99,71 }, "^0You don't have enough money to afford that vehicle! Sorry!")
	end
end)

RegisterNetEvent("vehShop:notify")
AddEventHandler("vehShop:notify", function(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end)

RegisterNetEvent("vehShop:displayVehiclesToSell")
AddEventHandler("vehShop:displayVehiclesToSell", function(vehicles)
	print("vehicles loaded!")
	if vehicles then
		if #vehicles > 0 then
			print("#vehicles " .. #vehicles)
			menu.vehicles = vehicles
		else
			SetNotificationTextEntry("STRING")
			AddTextComponentString("You do not own any vehicles to sell!")
			DrawNotification(0,1)
			menu.page = "home"
		end
	end
end)

RegisterNetEvent("vehShop:loadedVehicles")
AddEventHandler("vehShop:loadedVehicles", function(vehicles, check_insurance)
	if vehicles then
		menu.vehicles = vehicles
	end
	if check_insurance then menu.page = "insurance_claim" end
end)

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

-- MENU CODE
RegisterNetEvent("vehShop-GUI:Title")
AddEventHandler("vehShop-GUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("vehShop-GUI:Option")
AddEventHandler("vehShop-GUI:Option", function(option, cb)
	--print("setting up option button: " .. option)
	cb(Menu.Option(option))
end)

RegisterNetEvent("vehShop-GUI:Bool")
AddEventHandler("vehShop-GUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("vehShop-GUI:Int")
AddEventHandler("vehShop-GUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("vehShop-GUI:StringArray")
AddEventHandler("vehShop-GUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("vehShop-GUI:Update")
AddEventHandler("vehShop-GUI:Update", function()
	Menu.updateSelection()
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)

		--print("drawing marker!")
		DrawMarker(27, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 88, 230, 88, 90, 0, 0, 2, 0, 0, 0, 0)

		if menu.page then
		--	print("menu.page = " .. menu.page)
		end

		if getPlayerDistanceFromShop(markerX, markerY, markerZ) < 6 then
			if IsControlJustPressed(1,38) and not menu.open then
				menu.open = true
				menu.page = "home"
				menu.vehicles = nil
			end
		else
			menu.open = false
		end

		if menu.open == true then

			if menu.page == "home" then

			--	print("setting up home buttons!")
				TriggerEvent("vehShop-GUI:Title", "Home")

				TriggerEvent("vehShop-GUI:Option", "Buy", function(cb) -- todo: complete ability to purchase selected vehicle
					--print("inside of vehShop-GUI:option: 'Buy'")
					if(cb) then
						menu.page = "buy"
					end
				end)


				TriggerEvent("vehShop-GUI:Option", "Sell", function(cb) -- todo: complete this menu
					--print("inside of vehShop-GUI:option: 'Sell'")
					if(cb) then
						menu.page = "sell"
						TriggerServerEvent("vehShop:loadVehiclesToSell")
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Insurance", function(cb) -- todo: complete this menu
					if(cb) then
						menu.page = "insurance"
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Close", function(cb)
					if cb then
						menu.open = false
					end
				end)



			elseif menu.page == "buy" then

			TriggerEvent("vehShop-GUI:Title", "Buy")

			--	print("menu.page: 'buy'!!!")

			--	print("type of vehicle shop items: " .. type(vehicleShopItems))

				for k, v in pairs(vehicleShopItems["vehicles"]) do

				--	print("adding page button = " .. k)
					TriggerEvent("vehShop-GUI:Option", k, function(cb)
						if cb then
							menu.page = k
							--print("setting menu.page = " .. k)
						end
					end)

				end

				TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
					if cb then
						menu.page = "home"
					end
				end)

			elseif menu.page == "sell" then

				TriggerEvent("vehShop-GUI:Title", "Sell")

				-- todo: complete this section
				if menu.vehicles then
					for i = 1, #menu.vehicles do
						local vehicle = menu.vehicles[i]
						if vehicle then
							--print("adding vehicle: " .. vehicle.make .. " " .. vehicle.model .. " to menu")
							local vehName = "Undefined"
							if vehicle.make then
								vehName = vehicle.make .. " " .. vehicle.model
							else
								vehName = vehicle.model
							end
							TriggerEvent("vehShop-GUI:Option", "+ ($" .. comma_value(vehicle.sellPrice) .. ") " .. vehName, function(cb)
								if cb then
									TriggerEvent("usa:notify", "~y~SOLD:~w~ " .. vehName .. "\n~y~PRICE: ~g~$" .. comma_value(vehicle.sellPrice))
									table.remove(menu.vehicles, i)
									TriggerServerEvent("vehShop:sellVehicle", vehicle)
									menu.page = "home"
								end
							end)
						end
					end
				end

				TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
					if cb then
						menu.page = "home"
					end
				end)

			elseif menu.page == "insurance" then

				TriggerEvent("vehShop-GUI:Title", "Insurance")

				TriggerEvent("vehShop-GUI:Option", "Info", function(cb)
					if cb then
						TriggerEvent("chatMessage", "T. END'S INSURANCE", { 255, 78, 0 }, "T. End's insurance will put your mind at ease by making sure you'll always have a ride even if yours gets stolen, lost, or totaled.")
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Make a claim", function(cb)
					if cb then
						TriggerServerEvent("vehShop:loadVehicles", true)
						--menu.page = "insurance_claim"
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "($7,500) Purchase", function(cb)
					if cb then
						menu.open = false
						menu.page = "home"
						TriggerServerEvent("vehShop:checkPlayerInsurance")
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
					if cb then
						menu.page = "home"
					end
				end)

			elseif menu.page == "insurance_claim" then
				TriggerEvent("vehShop-GUI:Title", "Make a claim")
				if menu.vehicles then
					for i = 1, #menu.vehicles do
						local vehicle = menu.vehicles[i]
						if vehicle then
							local vehName = "Undefined"
							if vehicle.make then
								vehName = vehicle.make .. " " .. vehicle.model
							else
								vehName = vehicle.model
							end
							if vehicle.stored == false then
								TriggerEvent("vehShop-GUI:Option", vehName, function(cb)
									if cb then
										--table.remove(menu.vehicles, i)
										TriggerServerEvent("vehShop:fileClaim", vehicle)
										menu.page = "home"
									end
								end)
							end
						end
					end
					TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
						if cb then
							menu.page = "home"
						end
					end)
				end
			else

				--print("in else clause!")

				for k,v in pairs(vehicleShopItems["vehicles"]) do

					if menu.page == k then

						TriggerEvent("vehShop-GUI:Title", menu.page)

						-- todo: do all the vehicles fit on one page?
						for i = 1, #vehicleShopItems["vehicles"][k] do
							local vehicle = vehicleShopItems["vehicles"][k][i]
							--print("adding vehicle: " .. vehicle.make .. " " .. vehicle.model .. " to menu")
							TriggerEvent("vehShop-GUI:Option", "($" .. comma_value(vehicle.price) .. ") " .. vehicle.make .. " " .. vehicle.model .. " (C: ".. vehicle.storage_capacity .. ")", function(cb)
								if cb then
								--	print("player wants to purchase vehicle: " .. vehicle.make .. " " .. vehicle.model)
									-- todo: complete purchase ability here
									TriggerServerEvent("mini:checkVehicleMoney", vehicle)
									menu.open = false
									menu.page = "home"
								end
							end)
						end

						TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
							if cb then
								menu.page = "buy"
							end
						end)

					end

				end

			end

			TriggerEvent("vehShop-GUI:Update")

		end


	end

end)

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

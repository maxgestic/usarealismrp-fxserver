--local markerX, markerY, markerZ = 120.924,6624.605,31.000
local markerX, markerY, markerZ = -43.2616, -1097.37, 25.3523

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
		local spawnX, spawnY, spawnZ = -48.884, -1113.75, 26.4358
		-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(numberHash, spawnX, spawnY, spawnZ, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetVehicleNumberPlateText(vehicle, plate)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
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

RegisterNetEvent("vehShop:insuranceOptionMenu")
AddEventHandler("vehShop:insuranceOptionMenu", function()
	insuranceMenu()
end)

RegisterNetEvent("vehShop:notify")
AddEventHandler("vehShop:notify", function(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end)

RegisterNetEvent("vehShop:displayVehiclesToSell")
AddEventHandler("vehShop:displayVehiclesToSell", function(vehicles)
	ClearMenu()
	if #vehicles > 0 then
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			Menu.addButton(vehicle.model,"sellVehicle", vehicle)
		end
	else
		Menu.hidden = true
		SetNotificationTextEntry("STRING")
		AddTextComponentString("You do not own any vehicles to sell!")
		DrawNotification(0,1)
	end
end)

function sellVehicle(vehicle)
	Menu.hidden = true
	TriggerServerEvent("vehShop:sellVehicle", vehicle)
end

function buyVehicle(params)
	TriggerServerEvent("mini:checkVehicleMoney",params)
	Menu.hidden = true
end

function suvMenu()
	MenuTitle = "SUVs"
	ClearMenu()
	Menu.addButton("Gallivanter Baller ($28,700)","buyVehicle","142944341:28700:Gallivanter Baller")
	Menu.addButton("Benefactor Dubsta ($18,000)","buyVehicle","1177543287:18000:Benefactor Dubsta")
	Menu.addButton("Declasse Granger ($15,000)","buyVehicle","-1775728740:15000:Declasse Granger")
	Menu.addButton("Dundreary Landstalker ($15,595)","buyVehicle","1269098716:15595:Dundreary Landstalker")
	Menu.addButton("Bravado Gresley ($20,990)","buyVehicle","-1543762099:20990:Bravado Gresley")
	Menu.addButton("Albany Cavalcade ($19,500)","buyVehicle","-789894171:19500:Albany Cavalcade")
	Menu.addButton("Canis Seminole ($10,995)","buyVehicle","1221512915:10995:Canis Seminole")
	Menu.addButton("Obey Rocoto ($12,000)","buyVehicle","2136773105:12000:Obey Rocoto")

end

function coupeMenu()
	MenuTitle = "Coupes"
	ClearMenu()
	Menu.addButton("Ocelot Jackal ($24,700)","buyVehicle","-624529134:24700:Ocelot Jackal")
	--Menu.addButton("Ubermacht Zion ($27,450)","buyVehicle","1122289213:27450:Ubermacht Zion")
	Menu.addButton("Dewbauchee Exemplar ($28,070)","buyVehicle","-5153954:28070:Dewbauchee Exemplar")
	Menu.addButton("Ubermacht Sentinel XS ($30,020)","buyVehicle","1349725314:30020:Ubermacht Sentinel XS")
	Menu.addButton("Enus Cognoscenti Carbio ($33,200)","buyVehicle","330661258:33200:Enus Cognoscenti Carbio")
	Menu.addButton("Lampadati Felon ($34,550)","buyVehicle","-391594584:34550:Lampadati Felon")

end

function bicycleMenu()
	MenuTitle = "Bicycles"
	ClearMenu()
	Menu.addButton("Bmx ($500)","buyVehicle","1131912276:600:Bmx")
	Menu.addButton("Cruiser ($500)","buyVehicle","448402357:500:Cruiser")
	Menu.addButton("Fixster ($850)","buyVehicle","-836512833:850:Fixster")
	Menu.addButton("Scorcher ($1,200)","buyVehicle","-186537451:1200:Scorcher")
	Menu.addButton("TriBike ($1,350)","buyVehicle","1127861609:1350:TriBike")
end

function muscleMenu()

	MenuTitle = "Muscle Cars"
	ClearMenu()
	Menu.addButton("Willand Faction ($10,575)","buyVehicle","-2119578145:10575:Willand Faction")
	Menu.addButton("Willand Faction 2 ($25,575)","buyVehicle","-1790546981:25575:Willand Faction 2")
	Menu.addButton("Willand Faction 3 ($35,575)","buyVehicle","-2039755226:35575:Willand Faction 3")
	Menu.addButton("Imponte Nightshade ($15,850)","buyVehicle","-1943285540:15850:Imponte Nightshade")
	Menu.addButton("Albany Buccaneer ($12,500)","buyVehicle","682211828:12500:Albany Buccaneer")
	Menu.addButton("Declasse Sabre Turbo ($16,775)","buyVehicle","-1685021548:16775:Declasse Sabre Turbo")
	Menu.addButton("Imponte Dukes ($10,500)","buyVehicle","723973206:10500:Imponte Dukes")
	Menu.addButton("Imponte Phoenix ($23,375)","buyVehicle","-2095439403:23375:Imponte Phoenix")
	Menu.addButton("Declasse Vigero ($12,500)","buyVehicle","-825837129:12500:Declasse Vigero")
	Menu.addButton("Vapid Dominator ($19,400)","buyVehicle","80636076:19400:Vapid Dominator")
	--Menu.addButton("Bravado Gauntlet ($21,400)","buyVehicle","1800170043:21400:Bravado Gauntlet")

end

function trucksMenu()
	MenuTitle = "Trucks"
	ClearMenu()
	Menu.addButton("Karin Rebel ($10,500)","buyVehicle","-2045594037:10500:Karin Rebel")
	Menu.addButton("Vapid Bobcat XL ($10,500)","buyVehicle","1069929536:10500:Vapid Bobcat XL")
	--Menu.addButton("Vapid Sadler ($25,500)","buyVehicle","599568815:25500:Vapid Sadler")
	--Menu.addButton("Bravado Bison ($27,110)","buyVehicle","16948145:27110:Bravado Bison")
	Menu.addButton("Vapid Sandking XL ($35,000)","buyVehicle"," -1189015600:35000:Vapid Sandking XL")

end

function compactMenu()
	MenuTitle = "Compacts"
	ClearMenu()
	Menu.addButton("Karin Dilettante ($5,500)","buyVehicle","-1130810103:5500:Karin Dilettante")
	Menu.addButton("Declasse Rhapsody ($6,500)","buyVehicle","841808271:6500:Declasse Rhapsody")
	Menu.addButton("Dinka Blista Compact ($6,500)","buyVehicle","1039032026:6500:Dinka Blista Compact")
	Menu.addButton("Weeny Issi ($8,500)","buyVehicle","-1177863319:8500:Weeny Issi")
	Menu.addButton("Bollocan Prairie ($8,000)","buyVehicle","1039032026:8000:Bollocan Prairie")
	Menu.addButton("Benefactor Panto ($6,000)","buyVehicle","-431692672:6000:Benefactor Panto")
end

function offroadMenu()
	MenuTitle = "Offroads"
	ClearMenu()
	Menu.addButton("Canis Kalahari ($10,600)","buyVehicle","92612664:10600:Canis Kalahari")
	Menu.addButton("Canis Mesa ($30,500)","buyVehicle","-2064372143:30500:Canis Mesa")
	Menu.addButton("Declasse Rancher XL ($12,500)","buyVehicle","1645267888:12500:Declasse Rancher XL")
	Menu.addButton("Coil Brawler ($18,500)","buyVehicle","-1479664699:18500:Coil Brawler")
	Menu.addButton("BF Bifta ($24,350)","buyVehicle","0xEB298297:24350:BF Bifta")
	Menu.addButton("Nagasaki Blazer ($14,000)","buyVehicle","-2128233223:14000:Nagasaki Blazer")

end

function motorcycleMenu()
	MenuTitle = "Motorcycles"
	ClearMenu()
	Menu.addButton("Pegassi Faggio Sport ($1,200)","buyVehicle","-1842748181:1200:Pegassi Faggio Sport")
	Menu.addButton("Dinka Akuma ($7,500)","buyVehicle","1672195559:7500:Dinka Akuma")
	Menu.addButton("Maibatsu Sanchez ($7,500)","buyVehicle","-1453280962:7500:Maibatsu Sanchez")
	Menu.addButton("Shitzu Vader ($8,000)","buyVehicle","-140902153:8500:Shitzu Vader")
	Menu.addButton("Western Bagger ($10,500)","buyVehicle","-2140431165:10500:Western Bagger")
	Menu.addButton("Pegassi Bati 801 ($16,700)","buyVehicle","-114291515:16700:Pegassi Bati 801")
	Menu.addButton("Western Zombie Chopper ($15,000)","buyVehicle","-570033273:15000:Western Zombie Chopper")
	Menu.addButton("Western Zombie Bobber ($21,350)","buyVehicle","-1009268949:21350:Western Zombie Bobber")
	Menu.addButton("Western Nightblade ($15,750)","buyVehicle"," -1606187161:15750:Western Nightblade")
	Menu.addButton("LCC Hexer ($12,500)","buyVehicle","301427732:12500:LCC Hexer")
	Menu.addButton("Dinka Enduro ($5,500)","buyVehicle","1753414259:5500:Dinka Enduro")
	Menu.addButton("Dinka Thrust ($23,500)","buyVehicle","1836027715:23500:Dinka Thrust")
	Menu.addButton("LCC Sanctus ($225,000)","buyVehicle","1491277511:225000:LCC Sanctus")
	--Menu.addButton("Nagasaki Chimera ($35,000)","buyVehicle","67744871:35000:Nagasaki Chimera")
	Menu.addButton("Nagasaki Carbon RS ($30,000)","buyVehicle","11251904:30000:Nagasaki Carbon RS")

end

function vansMenu()
	MenuTitle = "Vans"
	ClearMenu()
	Menu.addButton("Declasse Burrito ($21,000)","buyVehicle","-1743316013:21000:Declasse Burrito")
	Menu.addButton("BF Surfer ($22,500)","buyVehicle","699456151:22500:BF Surfer")
	Menu.addButton("Bravado Youga Classic ($24,000)","buyVehicle","1026149675:24000:Bravado Youga Classic")
	Menu.addButton("Vapid Minivan ($19,000)","buyVehicle","-310465116:19000:Vapid Minivan")
	Menu.addButton("Vapid Speedo ($18,000)","buyVehicle","-810318068:18000:Vapid Speedo")
end

function sportsMenu()
	MenuTitle = "Sports Cars"
	ClearMenu()
	Menu.addButton("Annis Elegy RH8 ($95,000)","buyVehicle","-566387422:95000:Annis Elegy RH8")
	Menu.addButton("Invetero Coquette ($65,450)","buyVehicle","108773431:65450:Invetero Coquette")
	Menu.addButton("Dewbauchee Massacro ($75,000)","buyVehicle","-142942670:75000:Dewbauchee Massacro")
	Menu.addButton("Ubermacht Zion Cabrio ($50,015)","buyVehicle","-1193103848:50015:Ubermacht Zion Cabrio")
	--Menu.addButton("Karin Sultan ($37,500)","buyVehicle","-1122289213:37500:Karin Sultan")
	Menu.addButton("Bravado Buffalo S ($57,800)","buyVehicle","736902334:57800:Bravado Buffalo S")
	Menu.addButton("Dewbauchee Specter ($120,000)","buyVehicle","1886268224:35000:Dewbauchee Specter")
	Menu.addButton("Benefactor Surano ($70,000)","buyVehicle","384071873:70000:Benefactor Surano")
	Menu.addButton("Benefactor Schafter V12 ($88,000)","buyVehicle","-1485523546:88000:Benefactor Schafter V12")
	Menu.addButton("Dewbauchee Seven-70 ($98,000)","buyVehicle"," -1757836725:98000:Dewbauchee Seven-70")
	Menu.addButton("Dinka Jester ($200,000)","buyVehicle","-1297672541:200000:Dinka Jester")
	Menu.addButton("Obey 9F ($250,700)","buyVehicle","1032823388:250700:Obey 9F")
	Menu.addButton("Obey 9F Cabrio ($285,500)","buyVehicle","-1461482751:285500:Obey 9F Cabrio")

end

function superCarMenu()
	MenuTitle = "Super Cars"
	ClearMenu()
	Menu.addButton("Pegassi Infernus ($300,500)","buyVehicle","418536135:300500:Pegassi Infernus")
	Menu.addButton("Cheetah ($375,000)","buyVehicle","-1311154784:357000:Cheetah")
	Menu.addButton("Truffade Adder ($1,000,000)","buyVehicle","-1216765807:1000000:Truffade Adder")
	Menu.addButton("Truffade Nero ($1,250,000)","buyVehicle","1034187331:1250000:Truffade Nero")
	Menu.addButton("Pegassi Osiris ($850,000)","buyVehicle","1987142870:800000:Pegassi Osiris")
	Menu.addButton("Pfister 811 ($625,000)","buyVehicle"," -1829802492:625000:Pfister 811")
	Menu.addButton("Pegassi Zentorno ($1,800,000)","buyVehicle","  -1403128555:1800000:Pegassi Zentorno")
	Menu.addButton("Pegassi Tempesta ($1,300,000)","buyVehicle","272929391:1200000:Pegassi Tempesta")
	Menu.addButton("Progen T20 ($750,000)","buyVehicle","1663218586:750000:Progen T20")
	Menu.addButton("Ocelot XA-21 ($3,000,000)","buyVehicle","917809321:3000000:Ocelot XA-21")
	Menu.addButton("Vapid Bullet ($350,000)","buyVehicle"," -1696146015:350000:Vapid Bullet")

end

function classicMenu()
	MenuTitle = "Classic Cars"
	ClearMenu()
	Menu.addButton("Pegassi Infernus Classic ($290,750)","buyVehicle","-1405937764:290750:Pegassi Infernus Classic")
	Menu.addButton("Pegassi Monroe ($210,800)","buyVehicle","-433375717:210800:Pegassi Monroe")
	Menu.addButton("Grotti Stinger GT ($275,600)","buyVehicle","-2098947590:275600:Grotti Stinger")
	Menu.addButton("Vapid Peyote ($100,000)","buyVehicle","1830407356:100000:Vapid Peyote")
	--Menu.addButton("Truffade Z-Type ($350,000)","buyVehicle","75889561:350000:Truffade Z-Type")
	Menu.addButton("Lampadati Casco ($133,777)","buyVehicle","941800958:133777:Lampadati Casco")
	Menu.addButton("Grotti Turismo Classic ($275,350)","buyVehicle","-982130927:275350:Grotti Turismo Classic")
	Menu.addButton("Albany Roosevelt Valor ($350,350)","buyVehicle"," -602287871:350350:Albany Roosevelt Valor")
end

function sedanMenu()
    MenuTitle = "Sedans"
    ClearMenu()
    Menu.addButton("Albany Washington ($7,500)","buyVehicle","1777363799:7500:Albany Washington")
    Menu.addButton("Ubermacht Oracle ($35,000)","buyVehicle","-511601230:35000:Ubermacht Oracle")
    Menu.addButton("Zinconium Stratum ($9,500)","buyVehicle","1723137093:9500:Zinconium Stratum")
    Menu.addButton("Karin Intruder ($6,595)","buyVehicle","886934177:6595:Karin Intruder")
    Menu.addButton("Albany Primo ($6,000)","buyVehicle","-1150599089:6000:Albany Primo")
    Menu.addButton("Albany Emperor ($3,500)","buyVehicle","-1883002148:3500:Albany Emperor")
    Menu.addButton("Enus Super Diamond ($95,000)","buyVehicle","1123216662:95000:Enus Super Diamond")
    Menu.addButton("Vapid Stanier ($13,500)","buyVehicle","-1477580979:13500:Vapid Stanier")
	Menu.addButton("Vulcan Ingot ($9,500)","buyVehicle","-1289722222:9500:Vulcan Ingot")
	Menu.addButton("Enus Cognoscenti ($85,500)","buyVehicle","-2030171296:85500:Vulcan Ingot")

end

function purchaseMenu()
	MenuTitle = "Purchase"
	ClearMenu()
	Menu.addButton("Bicylces","bicycleMenu", nil)
	Menu.addButton("Compacts","compactMenu", nil)
	Menu.addButton("Coupes","coupeMenu", nil)
	Menu.addButton("Sedans","sedanMenu", nil)
	Menu.addButton("Muscle", "muscleMenu", nil)
	Menu.addButton("Offroads","offroadMenu", nil)
	Menu.addButton("SUV","suvMenu", nil)
	Menu.addButton("Trucks","trucksMenu", nil)
	Menu.addButton("Vans","vansMenu", nil)
	Menu.addButton("Sports Cars","sportsMenu", nil)
	Menu.addButton("Classic Cars","classicMenu", nil)
	Menu.addButton("Super Cars","superCarMenu", nil)
	Menu.addButton("Motorcycles","motorcycleMenu", nil)
end

function displayInsuranceInfo()
	Menu.hidden = not Menu.hidden
	TriggerEvent("chatMessage", "T. ENDS INSURANCE", { 255, 78, 0 }, "T. Ends insurance will put your mind at ease by making sure you'll always have a ride even if yours gets stolen, lost, or totaled.")
end

-- only displays when player has no insurance
function buyInsurance()
	Menu.hidden = not Menu.hidden
	TriggerServerEvent("vehShop:buyInsurance")
end

-- only displays when player has no insurance
function insuranceMenu()
	MenuTitle = "Auto Insurance"
	ClearMenu()
	Menu.addButton("Info","displayInsuranceInfo", nil)
	Menu.addButton("($15,000) Buy","buyInsurance", nil)
end

function checkPlayerInsurance()
	TriggerServerEvent("vehShop:checkPlayerInsurance")
end

function sellMenu()
	TriggerServerEvent("vehShop:loadVehiclesToSell")
end

function mainMenu()
	MenuTitle = "Auto Shop"
	ClearMenu()
	Menu.addButton("Buy","purchaseMenu", nil)
	Menu.addButton("Sell","sellMenu", nil)
	Menu.addButton("Insurance","checkPlayerInsurance", nil)
end

function getPlayerDistanceFromShop(shopX,shopY,shopZ)
	-- Get the player coords so that we know where to spawn it
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,shopX,shopY,shopZ,false)
end

local playerNotified = false

Citizen.CreateThread(function()

	Citizen.Wait(5000) -- wait 5 seconds to avoid chat message showing up on first load

	while true do

		Citizen.Wait(0)
		DrawMarker(1, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
		if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 8 and not playerNotified then
			--TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^3Press E to buy a vehicle")
			playerNotified = true
		end
		if IsControlJustPressed(1,Keys["E"]) then

			if getPlayerDistanceFromShop(markerX,markerY,markerZ) < 8 then -- car shop

				mainMenu()                -- Menu to draw
				Menu.hidden = not Menu.hidden    -- Hide/Show the menu

			end

		elseif getPlayerDistanceFromShop(markerX,markerY,markerZ) > 8 then

			playerNotified = false
			Menu.hidden = true

		end

		Menu.renderGUI()     -- Draw menu on each tick if Menu.hidden = false

	end
end)

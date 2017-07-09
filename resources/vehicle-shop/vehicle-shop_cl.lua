--local markerX, markerY, markerZ = 120.924,6624.605,31.000
local markerX, markerY, markerZ = -32.4886, -1111.35, 25.3523

RegisterNetEvent("mini:spawnVehicleAtShop")
AddEventHandler("mini:spawnVehicleAtShop", function(hash, name, plate)

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
		--TriggerServerEvent()
		if vehicle then
			TriggerEvent("chatMessage", "Dealer", { 255,99,71 }, ("^0You now own a %s. Make sure to store it before leaving!"):format(name))
			TriggerServerEvent("vehShop:setHandle", vehicle)
		end

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

function buyVehicle(params)
	TriggerServerEvent("mini:checkVehicleMoney",params)
	Menu.hidden = true -- close menu
end

--[[
]]

function sedanMenu()
	MenuTitle = "Sedans"
	ClearMenu()
	-- v2
	Menu.addButton("'99 BMW 750i ($8,500)","buyVehicle","1777363799:8500:'99 BMW 750i") -- washington
	Menu.addButton("'BMW 535i ($35,000)","buyVehicle","-511601230:35000:BMW 535i") -- oracle2
	Menu.addButton("'91 BMW M5 ($35,000)","buyVehicle","0x506434F6:35000:'91 BMW M5") -- oracle
	Menu.addButton("BMW 750li ($82,495)","buyVehicle","1723137093:82495:BMW 750li") -- stratum
	Menu.addButton("Cadillac CTS V ($85,995)","buyVehicle","886934177:85995:Cadillac CTS V") -- intruder
	Menu.addButton("Audi A8 ($75,000)","buyVehicle","-746882698:75000:Audi A8") -- schwarzer
	Menu.addButton("Audi A8L W12 ($137,900)","buyVehicle","1489967196:137900:Audi A8L W12") -- schafter4
	Menu.addButton("Seat Leon ($19,000)","buyVehicle","-1807623979:19000:Seat Leon") -- asea2
	Menu.addButton("Buick Century ($12,000)","buyVehicle","-1150599089:12000:Buick Century") -- primo
	Menu.addButton("Oldsmobile ($8,500)","buyVehicle","-1883002148:8500:Oldsmobile") --emperor2
	Menu.addButton("'93 Mercedes 600SEL ($17,000)","buyVehicle","1123216662:17000:Mercedes 600SEL") -- superd
	Menu.addButton("'80s Mercedes 560SEL ($16,500)","buyVehicle","-1477580979:16500:'80s Mercedes 560SEL") -- stanier

end

function suvMenu()
	MenuTitle = "SUVs"
	ClearMenu()
	Menu.addButton("Gallivanter Baller ($36,700)","buyVehicle","634118882:16700:Gallivanter Baller")
	Menu.addButton("Benefactor Dubsta ($48,000)","buyVehicle","-394074634:18000:Benefactor Dubsta")
	Menu.addButton("Declasse Granger ($45,000)","buyVehicle","-1775728740:15000:Declasse Granger")
	Menu.addButton("Dundreary Landstalker ($22,595)","buyVehicle","1269098716:22595:Dundreary Landstalker") -- landstalker
	Menu.addButton("Bravado Gresley ($67,990)","buyVehicle","-1543762099:67990:Bravado Gresley")
	Menu.addButton("Albany Cavalcade ($73,000)","buyVehicle","-789894171:73000:Albany Cavalcade")
	Menu.addButton("Canis Seminole ($5,995)","buyVehicle","1221512915:5995:Canis Seminole")
	Menu.addButton("Obey Rocoto ($45,000)","buyVehicle","2136773105:45000:Obey Rocoto") -- rocoto
end

function coupeMenu()
	MenuTitle = "Coupes"
	ClearMenu()
	Menu.addButton("Dewbauchee Exemplar ($23,070)","buyVehicle","-5153954:23070:Dewbauchee Exemplar") -- exemplar
	Menu.addButton("Lampadati Felon GT ($34550)","buyVehicle","-89291282:34550:Lampadati Felon GT") -- felon2
	Menu.addButton("Ocelot Jackal ($110,700)","buyVehicle","-624529134:110700:Ocelot Jackal") -- jackal
	--v2
	Menu.addButton("Enus Windson Cabrio ($198,500)","buyVehicle","-1930048799:198500:Enus Windson Cabrio") -- windsor
	Menu.addButton("Enus Windson ($250,000)","buyVehicle","1581459400:250000:Enus Windson") -- windsor2
	Menu.addButton("Imponte Ruiner ($66,200)","buyVehicle","-227741703:66200:Imponte Ruiner") --ruiner
	Menu.addButton("Pfister Comet ($55,200)","buyVehicle","-1045541610:55200:Pfister Comet") -- comet2
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
	Menu.addButton("Willand Faction ($6,575)","buyVehicle","-2119578145:6575:Willand Faction")
	Menu.addButton("Willand Faction Custom ($8,500)","buyVehicle","-1790546981:8500:Willand Faction Custom")
	Menu.addButton("Willam Faction Custom Donk ($10,500)","buyVehicle","-2039755226:10500:Willam Faction Custom Donk")
	Menu.addButton("Imponte Nightshade ($9,850)","buyVehicle","-1943285540:9850:Imponte Nightshade")
	Menu.addButton("Albany Buccaneer Custom ($12,500)","buyVehicle","-1013450936:12500:Albany Buccaneer Custom")
	Menu.addButton("Declasse Sabre Turbo Custom ($26,775)","buyVehicle","223258115:26775:Declasse Sabre Turbo Custom")
	Menu.addButton("Imponte Dukes ($65,000)","buyVehicle","723973206:65000:Imponte Dukes")
	Menu.addButton("Albany Fränken Stange ($75,000)","buyVehicle","-831834716:75000:Albany Fränken Stange")
	Menu.addButton("Declasse Abdre Turbo ($45,500)","buyVehicle","-1685021548:45500:Declasse Abdre Turbo")
	Menu.addButton("Declasse Vigero ($95,500)","buyVehicle","-825837129:95500:Declasse Vigero") -- vigero
	Menu.addButton("Vapid Dominator ($33,400)","buyVehicle","80636076:33400:Vapid Dominator") -- dominator
end

function trucksMenu()
	MenuTitle = "Trucks"
	ClearMenu()
	Menu.addButton("Karin Rebel ($10,500)","buyVehicle","-2045594037:10500:Karin Rebel")
	Menu.addButton("Vapid Bobcat XL ($10,500)","buyVehicle","1069929536:10500:Vapid Bobcat XL") -- bobcatxl
	Menu.addButton("Vapid Sadler ($16,500)","buyVehicle","-599568815:16500:Vapid Sadler") -- sadler
	Menu.addButton("Vapid Contender ($51,500)","buyVehicle","683047626:51500:Vapid Contender") -- contender
	Menu.addButton("Bravado Bison ($27,110)","buyVehicle","0xFEFD644F:27110:Bravado Bison") -- bison
end

function compactMenu()
	MenuTitle = "Compacts"
	ClearMenu()
	Menu.addButton("Karin Dilettante ($5,500)","buyVehicle","0xBC993509:5500:Karin Dilettante") --v2
	Menu.addButton("Declasse Rhapsody ($7,500)","buyVehicle","841808271:8500:Declasse Rhapsody") --rhapsody
	Menu.addButton("Dinka Blista ($6,500)","buyVehicle","-344943009:6500:Dinka Blista") -- blista
	Menu.addButton("Weeny Issi ($8,500)","buyVehicle","-1177863319:8500:Weeny Issi") -- issi2
	Menu.addButton("Dinka Blista Compact ($7,500)","buyVehicle","1039032026:7500:Dinka Blista Compact") -- blista2
	Menu.addButton("Benefactor Panto ($5,500)","buyVehicle","-431692672:5500:Benefactor Panto")
end

function offroadMenu()
	MenuTitle = "Offroads"
	ClearMenu()
	Menu.addButton("Canis Kalahari ($9,600)","buyVehicle","92612664:9600:Canis Kalahari")
	Menu.addButton("Canis Mesa ($45,500)","buyVehicle","-2064372143:11500:Canis Mesa") -- mesa 3
	Menu.addButton("Declasse Rancher XL ($9,800)","buyVehicle","1645267888:9800:Declasse Rancher XL")
	Menu.addButton("Coil Brawler ($15,000)","buyVehicle","0xA7CE1BC5:15000:Coil Brawler")
	Menu.addButton("BF Bifta ($35,000)","buyVehicle","0xEB298297:10000:BF Bifta")
	Menu.addButton("Vapid Sandking XL ($45,000)","buyVehicle","0xB9210FD0:45000:Vapid Sandking XL")
end

function motorcycleMenu()
	MenuTitle = "Motorcycles"
	ClearMenu()
	Menu.addButton("Pegassi Faggio ($1,000)","buyVehicle","55628203:1000:Pegassi Faggio")
	Menu.addButton("Dinka Akuma ($8,300)","buyVehicle","0x63ABADE7:8300:Dinka Akuma")
	Menu.addButton("Maibatsu Sanchez ($7,500)","buyVehicle","788045382:7500:Maibatsu Sanchez")
	Menu.addButton("Shitzu Vader ($9,500)","buyVehicle","-140902153:9500:Shitzu Vader")
	Menu.addButton("Western Bagger ($7,500)","buyVehicle","0x806B9CC3:7850:Western Bagger")
	Menu.addButton("Pegassi Bati 801 ($8,000)","buyVehicle","0xF9300CC5:8000:Pegassi Bati 801")
	Menu.addButton("Western Zombie Chopper ($13,000)","buyVehicle","-570033273:13000:Western Zombie Chopper")
	Menu.addButton("Western Zombie Bobber ($19,000)","buyVehicle","-1009268949:19000:Western Zombie Bobber")
	Menu.addButton("Western Nightblade ($20,000)","buyVehicle"," -1606187161:20000:Western Nightblade")
	Menu.addButton("LCC Hexer ($6,500)","buyVehicle","301427732:6500:LCC Hexer")
	Menu.addButton("Dinka Enduro ($6,500)","buyVehicle","1753414259:6500:Dinka Enduro")
	Menu.addButton("Dinka Thrust ($6,500)","buyVehicle","1836027715:6500:Dinka Thrust")
	Menu.addButton("Western Sovereign ($7,500)","buyVehicle","743478836:7500:Western Sovereign")
	Menu.addButton("Nagasaki Blazer ($7,000)","buyVehicle","-2128233223:7000:Nagasaki Blazer")
end

function vansMenu()
	MenuTitle = "Vans"
	ClearMenu()
	Menu.addButton("Declasse Burrito ($13,000)","buyVehicle","0xAFBB2CA4:13000:Declasse Burrito")
	Menu.addButton("BF Surfer ($17,000)","buyVehicle","699456151:17000:BF Surfer")
	Menu.addButton("Bravado Rumpo Custom ($16,000)","buyVehicle","1475773103:16000:Bravado Rumpo Custom")
	--v2
	Menu.addButton("Vapid Minivan ($19,000)","buyVehicle","-310465116:19000:Vapid Minivan")
end

function sportsMenu()
	MenuTitle = "Sports Cars"
	ClearMenu()
	Menu.addButton("Annis Elegy RH8 ($109,990)","buyVehicle","-566387422:109990:Annis Elegy RH8")
	Menu.addButton("Invetero Coquette ($55,450)","buyVehicle","108773431:55450:Invetero Coquette")
	Menu.addButton("Karin Futo ($50,000)","buyVehicle","2016857647:30000:Karin Futo")
	-- v2
	Menu.addButton("Dewbauchee Massacro ($38,000)","buyVehicle","-142942670:38000:Dewbauchee Massacro") -- massacro
	Menu.addButton("Bravado Gauntlet ($35,000)","buyVehicle","-1800170043:35000:Bravado Gauntlet") -- gauntlet
	Menu.addButton("Ubermacht Zion Cabrio ($36,015)","buyVehicle","-1193103848:36015:Ubermacht Zion Cabrio") -- zion2
	Menu.addButton("Karin Sultan RS ($40,000)","buyVehicle","-295689028:40000:Karin Sultan RS") -- sultanrs
	Menu.addButton("Ubermacht Zion ($17,999)","buyVehicle","-1122289213:17999:Ubermacht Zion") -- zion
	Menu.addButton("Grotti Stinger ($35,000)","buyVehicle","1545842587:35000:Grotti Stinger") -- stinger
	Menu.addButton("Benefactor Surano ($45,000)","buyVehicle","384071873:45000:Benefactor Surano")
end

function superCarMenu()
	MenuTitle = "Super Cars"
	ClearMenu()
	Menu.addButton("Obey 9F ($350,700)","buyVehicle","1032823388:350700:Obey 9F")
	Menu.addButton("Obey 9F Cabrio ($400,500)","buyVehicle","-1461482751:400500:Obey 9F Cabrio")
	Menu.addButton("Grotti Carbonizzare ($350,800)","buyVehicle","2072687711:350800:Grotti Carbonizzare") -- carbonizzare
	Menu.addButton("Pegassi Infernus ($209,500)","buyVehicle"," 418536135:209500:Pegassi Infernus") -- vacca
	Menu.addButton("Bravado Banshee ($219,000)","buyVehicle","-1041692462:219000:Bravado Banshee")
	Menu.addButton("Cheetah ($375,000)","buyVehicle","-1311154784:357000:Cheetah") -- cheetah
	Menu.addButton("Truffade Adder ($2,000,000)","buyVehicle","0xB779A091:2000000:Truffade Adder") -- adder
	Menu.addButton("Maibatsu Penumbra ($275,000)","buyVehicle","-377465520:275000:Maibatsu Penumbra") -- penumbra
	Menu.addButton("Progen T20 ($1,500,000)","buyVehicle","1663218586:1500000:Progen T20") --t20
	Menu.addButton("Dinka Jester ($350,000)","buyVehicle","-1297672541:350000:Dinka Jester")
end

function classicMenu()
	MenuTitle = "Classic Cars"
	ClearMenu()
	Menu.addButton("Pegassi Infernus Classic ($220,750)","buyVehicle"," -1405937764:220750:Pegassi Infernus Classic")
	Menu.addButton("Pegassi Monroe ($180,800)","buyVehicle","-433375717:180800:Pegassi Monroe")
	Menu.addButton("Grotti Stinger ($270,600)","buyVehicle","1545842587:270600:Grotti Stinger")
	Menu.addButton("Vapid Peyote ($150,000)","buyVehicle","1830407356:150000:Vapid Peyote")
	Menu.addButton("Truffade Z-Type ($750,000)","buyVehicle","75889561:750000:Vapid Peyote")
	Menu.addButton("Lampadati Casco ($133,777)","buyVehicle","941800958:133777:Lampadati Casco")
	Menu.addButton("Grotti Turismo Classic ($310,350)","buyVehicle","-982130927:310350:Grotti Turismo Classic")
end

function vehicleMenu()
	MenuTitle = "Vehicles"
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

function mainMenu()
	MenuTitle = "Auto Shop"
	ClearMenu()
	Menu.addButton("Vehicles","vehicleMenu", nil)
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

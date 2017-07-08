--local markerX, markerY, markerZ = 120.924,6624.605,31.000
local markerX, markerY, markerZ = -43.2616, -1097.37, 25.3523

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
	Menu.addButton("Baller 4 ($36,700)","buyVehicle","634118882:16700:Baller 4")
	Menu.addButton("Baller 6 ($47,000)","buyVehicle","666166960:17000:Baller 6")
	Menu.addButton("Dubsta2 ($48,000)","buyVehicle","-394074634:18000:Dubsta2")
	Menu.addButton("Granger ($45,000)","buyVehicle","-1775728740:15000:Granger")
	Menu.addButton("XLS2 ($48,900)","buyVehicle","-432008408:18900:XLS2")
	--v2
	Menu.addButton("Subaru Forester ($22,595)","buyVehicle","1269098716:22595:Subaru Forester") -- landstalker
	Menu.addButton("Jeep Cherokee SRT8 ($67,990)","buyVehicle","-1543762099:67990:Jeep Cherokee SRT8")
	Menu.addButton("Cadillac Escalade ($73,000)","buyVehicle","-789894171:73000:Cadillac Escalade")
	Menu.addButton("Range Rover Vogue ($85,650)","buyVehicle","142944341:85650:Range Rover Vogue") -- baller2
	Menu.addButton("Mercedes G65 ($160,000)","buyVehicle","1177543287:160000:Mercedes G65")

end

function coupeMenu()
	MenuTitle = "Coupes"
	ClearMenu()
	Menu.addButton("Toyota Camry ($23,070)","buyVehicle","-5153954:23070:Toyota Camry") -- exemplar
	Menu.addButton("Infiniti G37s ($34550)","buyVehicle","-89291282:34550:Infiniti G37s") -- felon2
	Menu.addButton("Audi RS 7 ($110,700)","buyVehicle","-624529134:110700:Audi RS 7") -- jackal
	--v2
	Menu.addButton("Bentley Continental ($198,500)","buyVehicle","-1930048799:198500:Bentley Continental") -- windsor
	Menu.addButton("Bentley Continental [tuned] ($250,000)","buyVehicle","1581459400:250000:Bentley Continental [tuned]") -- windsor2
	Menu.addButton("BMW M4 ($66,200)","buyVehicle","-227741703:66200:BMW M4") --ruiner
	Menu.addButton("Porsche GT4 ($55,200)","buyVehicle","-1045541610:55200:Porsche GT4") -- comet2
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
	Menu.addButton("Faction ($6,575)","buyVehicle","-2119578145:6575:Faction")
	Menu.addButton("Faction 2 ($8,500)","buyVehicle","-1790546981:8500:Faction 2")
	Menu.addButton("Faction 3 ($10,500)","buyVehicle","-2039755226:10500:Faction 3")
	Menu.addButton("Nightshade ($9,850)","buyVehicle","-1943285540:9850:Nightshade")
	Menu.addButton("Buccaneer 2 ($12,500)","buyVehicle","-1013450936:12500:Buccaneer 2")
	Menu.addButton("SabreGT2 ($26,775)","buyVehicle","223258115:26775:SabreGT2")
	Menu.addButton("Virgo ($9,975)","buyVehicle","-899509638:9975:Virgo")
	Menu.addButton("'70 Dodge Charger 1 ($65,000)","buyVehicle","723973206:65000:'70 Dodge Charger 1")
	Menu.addButton("'70 Dodge Charger 2 ($75,000)","buyVehicle","-831834716:75000:'70 Dodge Charger 2")
	Menu.addButton("'70 Chevy Chevelle ($45,500)","buyVehicle","-1685021548:45500:'70 Chevy Chevelle")
	Menu.addButton("'Dodge Challenger R/T ($95,500)","buyVehicle","-825837129:95500:Dodge Challenger R/T") -- vigero
	Menu.addButton("Chevrolet Bel Air ($38,600)","buyVehicle","464687292:38600:Chevrolet Bel Air")
	Menu.addButton("Ford Mustang GT ($33,400)","buyVehicle","80636076:33400:Ford Mustang GT") -- dominator

end

function trucksMenu()
	MenuTitle = "Trucks"
	ClearMenu()
	Menu.addButton("Rebel 2 ($10,500)","buyVehicle","-2045594037:10500:Rebel 2")
	Menu.addButton("Chevy 4x4 ($10,500)","buyVehicle","1069929536:10500:Chevy 4x4") -- bobcatxl
	Menu.addButton("Sadler ($16,500)","buyVehicle","-599568815:16500:Sadler") -- sadler
	Menu.addButton("Contender ($51,500)","buyVehicle","683047626:51500:Contender") -- contender
	Menu.addButton("Ford F150 ($27,110)","buyVehicle","0xFEFD644F:27110:Ford F150") -- bison
	Menu.addButton("RatLoader 2 ($20,000)","buyVehicle","-589178377:20000:RatLoader 2")
end

function compactMenu()
	MenuTitle = "Compacts"
	ClearMenu()
	Menu.addButton("Dilettante ($5,500)","buyVehicle","0xBC993509:5500:Dilettante")
	--v2
	Menu.addButton("Daewoo Tico ($7,500)","buyVehicle","841808271:8500:Daewoo Tico") --rhapsody
	Menu.addButton("Daewoo Matiz ($6,500)","buyVehicle","-344943009:6500:Daewoo Matiz") -- blista
	Menu.addButton("Fiat 26p ($8,500)","buyVehicle","-1177863319:8500:Fiat 26p") -- issi2
	Menu.addButton("'97 Honda Civic ($7,500)","buyVehicle","1039032026:7500:'97 Honda Civic") -- blista2
end

function offroadMenu()
	MenuTitle = "Offroads"
	ClearMenu()
	Menu.addButton("Kalahari ($9,600)","buyVehicle","92612664:9600:Kalahari")
	Menu.addButton("Jeep 2 ($45,500)","buyVehicle","-2064372143:11500:Jeep 2") -- mesa 3
	Menu.addButton("RancherXL ($9,800)","buyVehicle","1645267888:9800:Rancher XL")
	Menu.addButton("Brawler ($15,000)","buyVehicle","0xA7CE1BC5:15000:Brawler")
	Menu.addButton("Dune Buggy ($35,000)","buyVehicle","0xEB298297:10000:Bifta")
	Menu.addButton("Sandking ($45,000)","buyVehicle","0xB9210FD0:45000:Sandking")
	-- v2
	Menu.addButton("2000 Jeep Cherokee ($5,995)","buyVehicle","1221512915:5995:2000 Jeep Cherokee")
	Menu.addButton("Jeep Rubicon ($38,500)","buyVehicle","914654722:38500:Jeep Rubicon") -- mesa
end

function motorcycleMenu()
	MenuTitle = "Motorcycles"
	ClearMenu()
	Menu.addButton("Scooter ($1,000)","buyVehicle","55628203:1000:Scooter")
	Menu.addButton("Akuma ($8,300)","buyVehicle","0x63ABADE7:8300:Akuma")
	Menu.addButton("Sanchez ($7,500)","buyVehicle","788045382:7500:Sanchez")
	Menu.addButton("Sanchez  2 ($9,500)","buyVehicle","-1453280962:9500:Sanchez 2")
	Menu.addButton("Vader ($9,500)","buyVehicle","-140902153:9500:Vader")
	Menu.addButton("Bagger ($7,500)","buyVehicle","0x806B9CC3:7850:Bagger")
	Menu.addButton("Bati ($8,000)","buyVehicle","0xF9300CC5:8000:Bati")
	Menu.addButton("Zombie ($13,000)","buyVehicle","-570033273:13000:Zombie")
	-- add the nightblade
	-- remove turismo-r
	Menu.addButton("Hexer ($6,500)","buyVehicle","301427732:6500:Hexer")
	Menu.addButton("Enduro ($6,500)","buyVehicle","1753414259:6500:Enduro")
	Menu.addButton("Thrust ($6,500)","buyVehicle","1836027715:6500:Thrust")
	Menu.addButton("Innovation ($9,500)","buyVehicle","1836027715:9500:Innovation")
	Menu.addButton("Sovereign ($7,500)","buyVehicle","743478836:7500:Sovereign")
	Menu.addButton("Quad Bike ($7,000)","buyVehicle","-2128233223:7000:Quad Bike")
	Menu.addButton("Quad Bike 2 ($7,700)","buyVehicle","-48031959:7700:Quad Bike 2")
end

function vansMenu()
	MenuTitle = "Vans"
	ClearMenu()
	Menu.addButton("Burrito ($13,000)","buyVehicle","0xAFBB2CA4:13000:Burrito")
	Menu.addButton("Rumpo3 ($16,000)","buyVehicle","1475773103:16000:Rumpo3")
	--v2
	Menu.addButton("Dodge Caravan ($19,000)","buyVehicle","-310465116:19000:Dodge Caravan")
end

function sportsMenu()
	MenuTitle = "Sports Cars"
	ClearMenu()
	Menu.addButton("Nissan GTR ($109,990)","buyVehicle","-566387422:109990:Nissan GTR")
	Menu.addButton("Coquette ($55,450)","buyVehicle","108773431:55450:Coquette")
	Menu.addButton("Feltzer3 ($70,000)","buyVehicle","-1566741232:60000:Feltzer3")
	Menu.addButton("Futo ($50,000)","buyVehicle","2016857647:30000:Futo")
	-- v2
	Menu.addButton("1998 Toyota Supra ($38,000)","buyVehicle","-142942670:38000:1998 Toyota Supra") -- massacro
	Menu.addButton("'99 BMW M5 e39 ($35,000)","buyVehicle","-1800170043:35000:'99 BMW M5 e39") -- gauntlet
	Menu.addButton("Audi Q7 ($45,000)","buyVehicle","2136773105:45000:Audi Q7") -- rocoto
	Menu.addButton("Subaru WRX STI ($36,015)","buyVehicle","-1193103848:36015:Subaru WRX STI") -- zion2
	Menu.addButton("Subaru WRX STI 2 ($40,000)","buyVehicle","-295689028:40000:Subaru WRX STI 2") -- sultanrs
	Menu.addButton("'99 Nissan Skyline R34 ($17,999)","buyVehicle","-1122289213:17999:'99 Nissan Skyline R34") -- zion
	Menu.addButton("Mercedes SL500 ($35,000)","buyVehicle","1545842587:35000:Mercedes SL500") -- stinger
	 -- add: surano

end

function superCarMenu()
	MenuTitle = "Super Cars"
	ClearMenu()
	Menu.addButton("Ferrari 488 Spider ($272,700)","buyVehicle","1032823388:272700:Ferrari 488 Spider")
	Menu.addButton("Lamborghini Huracan ($350,800)","buyVehicle","2072687711:350800:Lamborghini Huracan") -- carbonizzare
	Menu.addButton("Lamborghini Gallardo Spyder ($209,500)","buyVehicle","338562499:209500:Lamborghini Gallardo Spyder") -- vacca
	Menu.addButton("'09 Ferrari F430 ($219,000)","buyVehicle","-1041692462:219000:'09 Ferrari F430")
	Menu.addButton("Lexuas LFA ($375,000)","buyVehicle","-1311154784:357000:Lexus LFA") -- cheetah
	Menu.addButton("Bugatti Chiron ($2,000,000)","buyVehicle","0xB779A091:2000000:Bugatti Chiron") -- adder
	Menu.addButton("Ford GT ($195,000)","buyVehicle","-377465520:195000:Ford GT") -- penumbra
	Menu.addButton("McLaren P1 ($1,500,000)","buyVehicle","1663218586:1500000:McLaren P1") --t20
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

--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 500

-- prevent memory edit cheaters
local MIN_VEHICLE_PRICE = 500
local MAX_VEHICLE_SELL_PRICE = .50 * 4000000

-- VEHICLES
local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 12995, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 13000, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 30000, hash = -1775728740, storage_capacity = 185.0},
			{make = "Dundreary", model = "Landstalker", price = 25595, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 50000, hash = 1177543287, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 2", price = 80000, hash = -394074634, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 6x6", price = 160000, hash = -1237253773, storage_capacity = 215.0},
			{make = "Phatom", model = "FQ2", price = 20000, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 20990, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 19500, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller", price = 28700, hash = 634118882, storage_capacity = 200.0},
			{make = "Enus", model = "Huntley", price = 29700, hash = 486987393, storage_capacity = 200.0},
			{make = "Mammoth", model = "Patriot", price = 35700, hash = -808457413, storage_capacity = 200.0}
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 24700, hash = -624529134, storage_capacity = 135.0},
			{make = "BMW", model = "M6", price = 100000, hash = -1122289213, storage_capacity = 140.0},
			{make = "Dewbauchee", model = "Exemplar", price = 28070, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel", price = 30020, hash = "sentinel2", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 40020, hash = "sentinel", storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Carbio", price = 33200, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 34550, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 105550, hash = -1930048799, storage_capacity = 135.0},
			{make = "Nissan", model = "370z", price = 40550, hash = -377465520, storage_capacity = 135.0},
			{make = "Pfister", model = "Comet 1", price = 55550, hash = -1045541610, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 2", price = 55550, hash = -2022483795, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 5", price = 95000, hash = "comet5", storage_capacity = 125.0},
			--{make = "Benefactor", model = "Schwartzer", price = 80000, hash = "schwarzer", storage_capacity = 135.0}
			--{make = "Annis", model = "Savestra", price = 120000, hash = "savestra", storage_capacity = 125.0}
		},
		["Muscles"] = {
			{make = "Willand", model = "Faction", price = 10500, hash = -2119578145, storage_capacity = 160.0},
			{make = "Imponte", model = "Dukes", price = 10500, hash = 723973206, storage_capacity = 160.0},
			{make = "Declasse", model = "Vigero", price = 12500, hash = -825837129, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer", price = 12500, hash = -682211828, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer 2", price = 28000, hash = -1013450936, storage_capacity = 150.0},
			{make = "Imponte", model = "Ruiner", price = 12575, hash = -227741703, storage_capacity = 160.0},
			{make = "Imponte", model = "Nightshade", price = 15850, hash = -1943285540, storage_capacity = 160.0},
			{make = "1969 Ford", model = "Mustang Boss 302", price = 16775, hash = -1685021548, storage_capacity = 130.0},
			{make = "Vapid", model = "Dominator", price = 19400, hash = 80636076, storage_capacity = 160.0},
			{make = "Dodge", model = "Challenger", price = 75400, hash = -1800170043, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom", price = 25575, hash = -1790546981, storage_capacity = 160.0},
			{make = "Willand", model = "Faction Custom Donk", price = 35575, hash = -2039755226, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo", price = 42000, hash = -498054846, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo 2", price = 45000, hash = -899509638, storage_capacity = 130.0},
			{make = "Declasse", model = "Voodoo", price = 45000, hash = 2006667053, storage_capacity = 130.0},
			{make = "Declasse", model = "Tampa", price = 45000, hash = 972671128, storage_capacity = 160.0},
			{make = "Vapid", model = "Chino Custom", price = 45000, hash = -1361687965, storage_capacity = 160.0},
			{make = "Vapid", model = "Ellie", price = 155000, hash = "ellie", storage_capacity = 100.0},
			{make = "Declasse", model = "Sabre GT", price = 35000, hash = -1685021548, storage_capacity = 155.0},
			{make = "Declasse", model = "Sabre Turbo Custom", price = 65000, hash = 223258115, storage_capacity = 130.0},
			{make = "Declasse", model = "Stallion", price = 40000, hash = 1923400478, storage_capacity = 155.0},
			{make = "Cheval", model = "Picador", price = 35000, hash = "picador", storage_capacity = 170.0}
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 10500, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 10500, hash = 1069929536, storage_capacity = 230.0},
			{make = "Ford", model = "F350 Super Duty", price = 55000, hash = -599568815, storage_capacity = 250.0},
			{make = "Bravado", model = "Bison", price = 27110, hash = -16948145, storage_capacity = 230.0},
			{make = "Declasse", model = "Yosemite", price = 30000, hash = "yosemite", storage_capacity = 230.0},
			{make = "Vapid", model = "Riata", price = 40000, hash = "riata", storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 24000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van LR", price = 24000, hash = 1119641113, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking", price = 35000, hash = -1189015600, storage_capacity = 230.0},
			--{make = "Lifted Dodge", model = "Ram", price = 120000, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking 2", price = 120000, hash = 989381445, storage_capacity = 230.0},
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
			{make = "Canis", model = "Mesa", price = 30500, hash = -2064372143, storage_capacity = 170.0},
			{make = "Vapid", model = "Trophy Truck", price = 50000, hash = 101905590, storage_capacity = 100.0},
			{make = "Vapid", model = "Trophy Truck 2", price = 70000, hash = -663299102, storage_capacity = 100.0},
			{make = "Canis", model = "Kamacho", price = 150000, hash = "kamacho", storage_capacity = 130.0}
		},
		["Motorcycles"] = {
			{make = "Pegassi", model = "Faggio", price = 1200, hash = -1842748181, storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 12500, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Akuma", price = 17500, hash = 1672195559, storage_capacity = 30.0},
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
			{make = "Nagasaki", model = "Chimera", price = 35000, hash = 6774487, storage_capacity = 30.0},
			--{make = "LCC", model = "Innovation", price = 60000, hash = 2006142190, storage_capacity = 30.0},
			{make = "LCC", model = "Sanctus", price = 200000, hash = 1491277511, storage_capacity = 30.0},
			{make = "Western", model = "Daemon", price = 28000, hash = 2006142190, storage_capacity = 30.0},
			{make = "Western", model = "Daemon 2", price = 38000, hash = -1404136503, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Manchez", price = 28000, hash = -1523428744, storage_capacity = 30.0},
			{make = "Western", model = "Sovereign", price = 18000, hash = 743478836, storage_capacity = 30.0},
			{make = "Western", model = "Wolfsbane", price = 27500, hash = -618617997, storage_capacity = 30.0},
			{make = "Principe", model = "Lectro", price = 27500, hash = "lectro", storage_capacity = 30.0},
			{make = "LCC", model = "Avarus", price = 53000, hash = "avarus", storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio Mod", price = 15000, hash = 55628203, storage_capacity = 50.0},
			{make = "Pegassi", model = "Faggio Sport", price = 17000, hash = -1289178744, storage_capacity = 60.0},
			{make = "Shitzu", model = "Defiler", price = 37000, hash = 822018448, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou", price = 95000, hash = 1265391242, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou Drag", price = 115000, hash = -255678177, storage_capacity = 60.0},
			{make = "Western", model = "Ratbike", price = 28000, hash = 1873600305, storage_capacity = 45.0},
			{make = "Pegassi", model = "Esskey", price = 45000, hash = 2035069708, storage_capacity = 45.0},
			{make = "Pegassi", model = "Vortex", price = 50000, hash = -609625092, storage_capacity = 45.0}
		},
		["Vans"] = {
			{make = "Vapid", model = "Speedo", price = 18000, hash = -810318068, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan", price = 19000, hash = -310465116, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan 2", price = 45000, hash = -1126264336, storage_capacity = 250.0},
			{make = "Vapid", model = "Clown", price = 29599, hash = 728614474, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 1", price = 21000, hash = -1346687836, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 2", price = 21000, hash = -907477130, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 3", price = 21000, hash = -1743316013, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 4", price = 21000, hash = 893081117, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 5", price = 21000, hash = 1132262048, storage_capacity = 300.0},
			{make = "BF", model = "Surfer", price = 22500, hash = 699456151, storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 24000, hash = 1026149675, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo 1", price = 18000, hash = 1162065741, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo 3", price = 38000, hash = 1475773103, storage_capacity = 300.0},
			{make = "Brute", model = "Camper", price = 45500, hash = 1876516712, storage_capacity = 300.0},
			{make = "Hennifers", model = "Taco Truck", price = 60500, hash = 1951180813, storage_capacity = 300.0}
		},
		["Sports"] = {
			{make = "BMW", model = "M5", price = 102000, hash = 970598228, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Zion Cabrio", price = 40015, hash = -1193103848, storage_capacity = 145.0},
			{make = "Invetero", model = "Coquette", price = 65450, hash = 108773431, storage_capacity = 145.0},
			{make = "Benefactor", model = "Surano", price = 72799, hash = 384071873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Massacro", price = 75000, hash = -142942670, storage_capacity = 145.0},
			{make = "Dodge", model = "Charger", price = 79995, hash = 736902334, storage_capacity = 135.0},
			{make = "Benefactor", model = "Schafter V12", price = 82000, hash = -1485523546, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 94500, hash = -1934452204, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 95000, hash = 196747873, storage_capacity = 145.0},
			{make = "Mercedes", model = "CL65 AMG", price = 100000, hash = -746882698, storage_capacity = 145.0},
			{make = "Vapid", model = "Flash GT", price = 90000, hash = "flashgt", storage_capacity = 125.0},
			{make = "Dewbauchee", model = "Seven-70", price = 110999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 120000, hash = 1886268224, storage_capacity = 145.0},
			{make = "Nissan", model = "GT-R", price = 175000, hash = -566387422, storage_capacity = 145.0},
			{make = "Hijak", model = "Khamelion", price = 225000, hash = 544021352, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan RS", price = 248500, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 250700, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 285500, hash = -1461482751, storage_capacity = 145.0},
			{make = "Dinka", model = "Jester", price = 350000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 370000, hash = -1372848492, storage_capacity = 145.0},
			{make = "Vapid", model = "GB200", price = 120000, hash = "gb200", storage_capacity = 100.0},
			{make = "Lampadati", model = "Furore GT", price = 110000, hash = -1089039904, storage_capacity = 100.0},
			{make = "Grotti", model = "Bestia GTS", price = 150000, hash = 1274868363, storage_capacity = 120.0},
			{make = "Bravado", model = "Banshee 990R", price = 190000, hash = 633712403, storage_capacity = 100.0}
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
			{make = "Pegassi", model = "Reaper", price = 1705000, hash = 234062309, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero", price = 1750000, hash = 1034187331, storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 1600000, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 1500000, hash = 1426219628, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB", price = 1650000, hash = -2048333973, storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 1800000, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 2400999, hash = 917809321, storage_capacity = 100.0},
			--{make = "Ferrari", model = "California", price = 650000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Carbonizzare", price = 650000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 2800000, hash = 408192225, storage_capacity = 100.0},
			{make = "Progen", model = "Tyrus", price = 2900000, hash = 2067820283, storage_capacity = 100.0},
			{make = "Annis", model = "RE7B", price = 2900000, hash = -1232836011, storage_capacity = 100.0},
			{make = "Ubermacht", model = "SC1", price = 1500000, hash = "SC1", storage_capacity = 100.0},
			{make = "Overflod", model = "Autarch", price = 2500000, hash = "autarch", storage_capacity = 100.0}
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
			{make = "Grotti", model = "Cheetah Clasic", price = 100000, hash = 223240013, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 100000, hash = 1011753235, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 130000, hash = 784565758, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "JB 700", price = 100000, hash = 1051415893, storage_capacity = 120.0},
			{make = "Declasse", model = "Mamba", price = 110000, hash = -1660945322, storage_capacity = 110.0},
			{make = "Albany", model = "Manana", price = 24500, hash = -2124201592, storage_capacity = 140.0},
			{make = "Lampadati", model = "Pigalle", price = 24000, hash = 1078682497, storage_capacity = 125.0},
			{make = "Pegassi", model = "Torero", price = 300000, hash = 1504306544, storage_capacity = 100.0},
			{make = "Declasse", model = "Tornado 6", price = 30000, hash = -1558399629, storage_capacity = 100.0},
			{make = "Truffade", model = "ZType", price = 500000, hash = "ztype", storage_capacity = 100.0},
			{make = "", model = "BType", price = 95000, hash = 117401876, storage_capacity = 100.0},
			{make = "", model = "BType 2", price = 125000, hash = -831834716, storage_capacity = 100.0},
			{make = "Grotti", model = "GT 500", price = 100000, hash = "gt500", storage_capacity = 100.0},
			{make = "Albany", model = "Hermes", price = 100000, hash = "hermes", storage_capacity = 100.0},
			{make = "Karin", model = "190 Z", price = 100000, hash = "z190", storage_capacity = 100.0},
			{make = "Vapid", model = "Hustler", price = 100000, hash = "hustler", storage_capacity = 100.0}
		},
		["Sedans"] = {
			{make = "Albany", model = "Emperor", price = 3500, hash = -1883002148, storage_capacity = 165.0},
			{make = "Albany", model = "Washington", price = 9989, hash = 1777363799, storage_capacity = 165.0},
			{make = "Karin", model = "Intruder", price = 6595, hash = 886934177, storage_capacity = 165.0},
			{make = "Vulcan", model = "Ingot", price = 9500, hash = -1289722222, storage_capacity = 165.0},
			{make = "Zinconium", model = "Stratum", price = 9500, hash = 1723137093, storage_capacity = 165.0},
			{make = "Vapid", model = "Stanier", price = 13500, hash = -1477580979, storage_capacity = 165.0},
			{make = "Benefactor", model = "Glendale", price = 15000, hash = 75131841, storage_capacity = 165.0},
			{make = "Vulcan", model = "Warrener", price = 15500, hash = 1373123368, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Oracle", price = 55000, hash = -511601230, storage_capacity = 165.0},
			{make = "Enus", model = "Cognoscenti", price = 85500, hash = -2030171296, storage_capacity = 165.0},
			{make = "Enus", model = "Super Diamond", price = 95000, hash = 1123216662, storage_capacity = 165.0},
			{make = "Chrysler", model = "300 SRT8", price = 60000, hash = -304802106, storage_capacity = 175.0},
			{make = "Audi", model = "A8", price = 60000, hash = -1008861746, storage_capacity = 155.0},
			{make = "Mercedes", model = "E63 AMG", price = 80000, hash = -1255452397, storage_capacity = 155.0},
			{make = "Maserati", model = "Quattroporte", price = 150000, hash = 1909141499, storage_capacity = 155.0},
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
		},
		["Electric"] = {
			{make = "Coil", model = "Raider", price = 300000, hash = "raiden", storage_capacity = 150.0},
			{make = "Coil", model = "Voltic", price = 55550, hash = "voltic", storage_capacity = 135.0},
			{make = "Pfister", model = "Neon", price = 55550, hash = "neon", storage_capacity = 135.0},
			{make = "Cheval", model = "Surge", price = 55550, hash = "surge", storage_capacity = 135.0}
		}
	}
}

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
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local licenses = user.getActiveCharacterData("license")
		for i = 1, #licenses do
			if licenses[i].name == "Driver's License" then
				license = licenses[i]
				return license
			end
		end
		return nil
	--end)
end

function alreadyHasVehicle(source, vehName)
	--TriggerEvent('es:getPlayerFromId', source, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(source)
		local vehicles = user.getActiveCharacterData("vehicles")
		for i = 1, #vehicles do
			if vehicles[i].model == vehName then
				return true
			end
		end
		return false
	--end)
end

function alreadyHasAnyVehicle(source)
	--TriggerEvent('es:getPlayerFromId', source, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(source)
		local cars = user.getActiveCharacterData("vehicles")
		if #cars > 0 then
			return true
		else
			return false
		end
	--end)
end

RegisterServerEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function()
	TriggerClientEvent("vehicle-shop:loadItems", source, vehicleShopItems)
end)

RegisterServerEvent("vehShop:buyInsurance")
AddEventHandler("vehShop:buyInsurance", function(userSource)
	--print("user source = " .. userSource)
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
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		local user_vehicles = user.getActiveCharacterData("vehicles")
		local user_bank = user.getActiveCharacterData("bank")
		if user_vehicles then
			for i = 1, #user_vehicles do
				local veh = user_vehicles[i]
				if veh then
					if veh.plate == vehicle_to_claim.plate then
						local BASE_FEE = 300
						local PERCENTAGE = .10
						local CLAIM_PROCESSING_FEE = round(BASE_FEE + (PERCENTAGE * vehicle_to_claim.price))
						if CLAIM_PROCESSING_FEE <= user_bank then
							-- set vehicle stats --
							user_vehicles[i].inventory = {} -- empty inventory to prevent duplicating
							user_vehicles[i].stored = true -- set to true for retrieval from garage
							user_vehicles[i].impounded = false
							user.setActiveCharacterData("vehicles", user_vehicles)
							-- remove money --
							user.setActiveCharacterData("bank", user_bank - CLAIM_PROCESSING_FEE)
							-- notifiy --
							if veh.make and veh.model then
								TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. veh.make .. " " .. veh.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
							else
								TriggerClientEvent("usa:notify", userSource, "Filed an insurance claim for your " .. veh.model .. ".\n~y~Fee:~w~ $" .. CLAIM_PROCESSING_FEE)
							end
							-- remove vehicle damages if any --
							TriggerClientEvent("garage:removeDamages", userSource, veh.plate)
						else
							TriggerClientEvent("usa:notify", userSource, "You don't have enough money to make a claim on that vehicle.")
						end
					end
				end
			end
		end
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end

RegisterServerEvent("vehShop:checkPlayerInsurance")
AddEventHandler("vehShop:checkPlayerInsurance", function()
	print("checking for auto insurance!")
	local userSource = tonumber(source)
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
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
	--end)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle, property)
	print("checking vehicle money")
	print("location: " .. type(location))
	local playerIdentifier = GetPlayerIdentifiers(source)[1]
	local userSource = tonumber(source)
	--TriggerEvent('es:getPlayerFromId', userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
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
								--plate = tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9)) .. tostring(math.random(1,9))
								plate = generate_random_number_plate()
								if vehicles then
									user.setActiveCharacterData("money", user_money - tonumber(price))
									-- give money to car dealership owner --
									if property then
										TriggerEvent("properties:addMoney", property.name, round(0.40 * price, 0))
									end
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
								TriggerClientEvent("usa:notify", userSource, "Not enough money for that vehicle!")
							end
						else
							TriggerClientEvent("usa:notify", userSource, "Already have that vehicle!")
						end
					end
				else
					TriggerClientEvent("usa:notify", userSource, "Come back when your license is valid!")
				end
			else
				TriggerClientEvent("usa:notify", userSource, "Come back when you have a driver's license!")
			end
		else
			TriggerClientEvent("vehShop:notify", userSource, "Sorry, you can't own more than " .. MAX_PLAYER_VEHICLES .. " vehicles at this time!")
		end
	--end)
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
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
	--end)
end)

RegisterServerEvent("vehShop:loadVehicles")
AddEventHandler("vehShop:loadVehicles", function(check_insurance)
	local vehicles_to_send = {}
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
		if check_insurance then
			local user_insurance = user.getActiveCharacterData("insurance")
			if user_insurance.type == "auto" then
				print("player has valid auto insurance!")
				local vehicles = user.getActiveCharacterData("vehicles")
				if vehicles then
					for i = 1, #vehicles do
						if not vehicles[i].stored then
							table.insert(vehicles_to_send, vehicles[i])
						end
					end
					print("vehicles loaded! # = " .. #vehicles_to_send)
					TriggerClientEvent("vehShop:loadedVehicles", userSource, vehicles_to_send, true)
				end
			else
				print("player has no auto insurance!")
				TriggerClientEvent("chatMessage", userSource, "T. END'S INSURANCE", {255, 78, 0}, "You do not have any auto insurance! Can't make a claim!")
				TriggerClientEvent("vehShop:loadedVehicles", userSource, vehicles_to_send, true)
			end
		else
			local vehicles = user.getActiveCharacterData("vehicles")
			if vehicles then
				for i = 1, #vehicles do
					if not vehicles[i].stored then
						table.insert(vehicles_to_send, vehicles[i])
					end
				end
				print("vehicles loaded! # = " .. #vehicles_to_send)
				TriggerClientEvent("vehShop:loadedVehicles", userSource, vehicles_to_send)
			end
		end
	--end)
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local userSource = tonumber(source)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
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
	--end)
end)

function GetVehiclePrice(vehicle)
	print("vehicle: " .. vehicle.make .. " " .. vehicle.model)
	for k, v in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #v do
			local name1 = vehicle.make .. " " .. vehicle.model
			local name2 = v[i].make .. " " .. v[i].model
			if name1 == name2 then
				print("matching hash found for vehicle price!")
				return v[i].price
			end
		end
		print("Error getting vehicle price! no matching hash found to sell!")
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

function generate_random_number_plate()
	local charset = {
		numbers = {},
		letters = {}
	}
	-- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
	for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
	for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
	local number_plate = ""
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
	print("created random plate: ")
	return number_plate
end

--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

local SHOPS = {
	{name = "Paleto Bay", store_x = 120.9, store_y = 6624.605, store_z = 31.0, vehspawn_x = 131.04, vehspawn_y = 6625.39, vehspawn_z = 31.71, vehspawn_heading = 315.0},
	{name = "Los Santos", store_x = -43.2616, store_y = -1097.37, store_z = 25.5523, vehspawn_x = -48.884, vehspawn_y = -1113.75, vehspawn_z = 26.4358, vehspawn_heading = 315.0}
}


local markerX, markerY, markerZ = 120.924,6624.605,31.000 -- paleto
--local markerX, markerY, markerZ = -43.2616, -1097.37, 25.3523 (los santos)
--local spawnX, spawnY, spawnZ = -48.884, -1113.75, 26.4358 -- (los santos)
local spawnX, spawnY, spawnZ = 131.04, 6625.39, 31.71 -- (paleto)

local menu = {
	key = 38
}

-- VEHICLES
local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 10995, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 12000, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 30000, hash = -1775728740, storage_capacity = 185.0},
			{make = "Dundreary", model = "Landstalker", price = 15595, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 18000, hash = 1177543287, storage_capacity = 175.0},
			{make = "Phatom", model = "FQ2", price = 20000, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 20990, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 19500, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller", price = 28700, hash = 634118882, storage_capacity = 200.0}
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 24700, hash = -624529134, storage_capacity = 135.0},
			{make = "BMW", model = "M6", price = 100000, hash = -1122289213, storage_capacity = 140.0},
			{make = "Dewbauchee", model = "Exemplar", price = 28070, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 30020, hash = 1349725314, storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Carbio", price = 33200, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 34550, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 105550, hash = -1930048799, storage_capacity = 135.0},
			{make = "Nissan", model = "370z", price = 40550, hash = -377465520, storage_capacity = 135.0},
			{make = "Pfister", model = "Comet 1", price = 55550, hash = -1045541610, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 2", price = 55550, hash = -2022483795, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 5", price = 95000, hash = GetHashKey("comet5"), storage_capacity = 125.0},
			--{make = "Annis", model = "Savestra", price = 120000, hash = GetHashKey("savestra"), storage_capacity = 125.0}
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
			{make = "Albany", model = "Virgo", price = 22000, hash = -498054846, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo 2", price = 45000, hash = -899509638, storage_capacity = 130.0},
			{make = "Declasse", model = "Voodoo", price = 45000, hash = 2006667053, storage_capacity = 130.0},
			{make = "Declasse", model = "Tampa", price = 45000, hash = 972671128, storage_capacity = 160.0},
			{make = "Vapid", model = "Chino Custom", price = 45000, hash = -1361687965, storage_capacity = 160.0},
			{make = "Vapid", model = "Ellie", price = 155000, hash = GetHashKey("ellie"), storage_capacity = 100.0},
			{make = "Declasse", model = "Sabre GT", price = 35000, hash = -1685021548, storage_capacity = 155.0},
			{make = "Declasse", model = "Sabre Turbo Custom", price = 65000, hash = 223258115, storage_capacity = 130.0},
			{make = "Declasse", model = "Stallion", price = 35000, hash = 1923400478, storage_capacity = 155.0}
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 10500, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 10500, hash = 1069929536, storage_capacity = 230.0},
			{make = "Ford", model = "F350 Super Duty", price = 55000, hash = -599568815, storage_capacity = 250.0},
			{make = "Bravado", model = "Bison", price = 27110, hash = -16948145, storage_capacity = 230.0},
			{make = "Declasse", model = "Yosemite", price = 30000, hash = GetHashKey("yosemite"), storage_capacity = 230.0},
			{make = "Vapid", model = "Riata", price = 40000, hash = GetHashKey("riata"), storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 24000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van LR", price = 24000, hash = 1119641113, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking", price = 35000, hash = -1189015600, storage_capacity = 230.0},
			{make = "Lifted Dodge", model = "Ram", price = 120000, hash = 989381445, storage_capacity = 230.0},
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
			{make = "Canis", model = "Kamacho", price = 150000, hash = GetHashKey("kamacho"), storage_capacity = 130.0}
		},
		["Motorcycles 1"] = {
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
			{make = "Western", model = "Wolfsbane", price = 27500, hash = -618617997, storage_capacity = 30.0}
		},
		["Motorcycles 2"] = {
			{make = "Principe", model = "Lectro", price = 27500, hash = GetHashKey("lectro"), storage_capacity = 30.0},
			{make = "LCC", model = "Avarus", price = 53000, hash = GetHashKey("avarus"), storage_capacity = 30.0},
			{make = "Pegassi", model = "Faggio Mod", price = 15000, hash = 55628203, storage_capacity = 50.0},
			{make = "Pegassi", model = "Faggio Sport", price = 17000, hash = -1289178744, storage_capacity = 60.0},
			{make = "Shitzu", model = "Defiler", price = 57000, hash = 822018448, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou", price = 65000, hash = 1265391242, storage_capacity = 60.0},
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
		["Sports 1"] = {
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
			{make = "Vapid", model = "Flash GT", price = 90000, hash = GetHashKey("flashgt"), storage_capacity = 125.0}
		},
		["Sports 2"] = {
			{make = "Dewbauchee", model = "Seven-70", price = 110999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 120000, hash = 1886268224, storage_capacity = 145.0},
			{make = "Nissan", model = "GT-R", price = 175000, hash = -566387422, storage_capacity = 145.0},
			{make = "Hijak", model = "Khamelion", price = 225000, hash = 544021352, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan RS", price = 248500, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 250700, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 285500, hash = -1461482751, storage_capacity = 145.0},
			{make = "Dinka", model = "Jester", price = 350000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 370000, hash = -1372848492, storage_capacity = 145.0},
			{make = "Vapid", model = "GB200", price = 120000, hash = GetHashKey("gb200"), storage_capacity = 100.0}
		},
		["Supers 1"] = {
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
			{make = "Ocelot", model = "XA-21", price = 2400999, hash = 917809321, storage_capacity = 100.0}
		},
		["Supers 2"] = {
			{make = "Ferrari", model = "California", price = 650000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 2800000, hash = 408192225, storage_capacity = 100.0},
			{make = "Progen", model = "Tyrus", price = 2900000, hash = 2067820283, storage_capacity = 100.0},
			{make = "Annis", model = "RE7B", price = 2900000, hash = -1232836011, storage_capacity = 100.0},
			{make = "Ubermacht", model = "SC1", price = 1500000, hash = GetHashKey("SC1"), storage_capacity = 100.0},
			{make = "Overflod", model = "Autarch", price = 2500000, hash = GetHashKey("autarch"), storage_capacity = 100.0}
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
			{make = "Pegassi", model = "Torero", price = 300000, hash = 1504306544, storage_capacity = 100.0}
		},
		["Classic 2"] = {
			{make = "Declasse", model = "Tornado 6", price = 30000, hash = -1558399629, storage_capacity = 100.0},
			{make = "Truffade", model = "ZType", price = 500000, hash = GetHashKey("ztype"), storage_capacity = 100.0},
			{make = "", model = "BType", price = 95000, hash = 117401876, storage_capacity = 100.0},
			{make = "", model = "BType 2", price = 125000, hash = -831834716, storage_capacity = 100.0},
			{make = "Grotti", model = "GT 500", price = 100000, hash = GetHashKey("gt500"), storage_capacity = 100.0},
			{make = "Albany", model = "Hermes", price = 100000, hash = GetHashKey("hermes"), storage_capacity = 100.0},
			{make = "Karin", model = "190 Z", price = 100000, hash = GetHashKey("z190"), storage_capacity = 100.0},
			{make = "Vapid", model = "Hustler", price = 100000, hash = GetHashKey( "hustler"), storage_capacity = 100.0}
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
			{make = "Chrystler", model = "300 SRT8", price = 60000, hash = -304802106, storage_capacity = 175.0},
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
			{make = "Coil", model = "Raider", price = 300000, hash = GetHashKey("raiden"), storage_capacity = 150.0},
			{make = "Coil", model = "Voltic", price = 55550, hash = GetHashKey("voltic"), storage_capacity = 135.0},
			{make = "Pfister", model = "Neon", price = 55550, hash = GetHashKey("neon"), storage_capacity = 135.0},
			{make = "Cheval", model = "Surge", price = 55550, hash = GetHashKey("surge"), storage_capacity = 135.0}
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
			Citizen.Wait(100)
		end
		-- Model loaded, continue
		-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
		local vehicle = CreateVehicle(numberHash, menu.closest_store.vehspawn_x, menu.closest_store.vehspawn_y, menu.closest_store.vehspawn_z, menu.closest_store.vehspawn_heading --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		SetVehicleNumberPlateText(vehicle, plate)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		--SetVehicleAsNoLongerNeeded(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
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
		--menu.vehicles = vehicles
		menu.vehicles = {}
		for i = 1, #vehicles do
			if not vehicles[i].stored_location then
				table.insert(menu.vehicles, vehicles[i]) -- add only vehicles not stored at a property (prevent duplication by making a claim when stored at your house)
			end
		end
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
	----------------
	-- draw blips --
	----------------
	addBlips()
	while true do
		local me = GetPlayerPed(-1)
		------------------
		-- draw markers --
		------------------
		for k = 1, #SHOPS do
			if getPlayerDistanceFromShop(SHOPS[k].store_x, SHOPS[k].store_y, SHOPS[k].store_z) < 40 then
				DrawMarker(27, SHOPS[k].store_x, SHOPS[k].store_y, SHOPS[k].store_z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 88, 230, 88, 90, 0, 0, 2, 0, 0, 0, 0)
			end
			-----------------------------------------------------------
			-- watch for entering store and menu open keypress event --
			-----------------------------------------------------------
			if getPlayerDistanceFromShop(SHOPS[k].store_x, SHOPS[k].store_y, SHOPS[k].store_z) < 3 then
				if not menu.open then
					drawTxt("Press [~y~E~w~] to open the vehicle shop menu",7,1,0.5,0.8,0.5,255,255,255,255)
				end
				if IsControlJustPressed(1, menu.key) and not menu.open then
					menu.open = true
					menu.page = "home"
					menu.vehicles = nil
					menu.closest_store = SHOPS[k]
					print("set closest store!")
				end
			else
			--[[ NOTE: need to save closest location for this to work
				menu.open = false
				menu.page = "home"
				if menu.preview then
					if menu.preview.handle then -- remove preview car if applicable
						deleteCar(menu.preview.handle)
						menu.preview.handle = nil
					end
				end
				--]]
			end
		end

		if menu.open == true then

			if menu.page == "home" then

			--	print("setting up home buttons!")
				TriggerEvent("vehShop-GUI:Title", "Home")

				TriggerEvent("vehShop-GUI:Option", "Buy", function(cb)
					--print("inside of vehShop-GUI:option: 'Buy'")
					if(cb) then
						menu.page = "buy"
					end
				end)


				TriggerEvent("vehShop-GUI:Option", "Sell", function(cb)
					--print("inside of vehShop-GUI:option: 'Sell'")
					if(cb) then
						menu.page = "sell"
						TriggerServerEvent("vehShop:loadVehiclesToSell")
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Insurance", function(cb)
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
							if vehName and vehicle.sellPrice then
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

			elseif menu.page == "preview" then

				TriggerEvent("vehShop-GUI:Title", menu.preview.name)

				PreviewVehicle()

				TriggerEvent("vehShop-GUI:Option", "Purchase", function(cb)
					if cb then
						local playerCoords = GetEntityCoords(me, false)
						TriggerEvent("properties:getPropertyGivenCoords", playerCoords.x, playerCoords.y, playerCoords.z, function(property)
							TriggerServerEvent("mini:checkVehicleMoney", menu.preview.vehicle, property)
						end)
						menu.open = false
						menu.page = "home"
						deleteCar(menu.preview.handle) -- remove preview vehicle
						menu.preview.handle = nil
					end
				end)

				TriggerEvent("vehShop-GUI:Option", "Back", function(cb)
					if cb then
						menu.page = menu.preview.previous_page
						deleteCar(menu.preview.handle) -- remove preview vehicle
						menu.preview.handle = nil
						SetEntityCoords(me, table.unpack(menu.preview.previous_coords))
					end
				end)

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

									menu.page = "preview"
									menu.preview = {
										name = vehicle.make .. " " .. vehicle.model,
										hash = vehicle.hash,
										handle = nil,
										vehicle = vehicle,
										previous_coords = GetEntityCoords(me),
										previous_page = k
									}

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

	Wait(1)
	end

end)


--------------------------------
-- handle the vehicle preview --
--------------------------------
function PreviewVehicle()
	if not menu.preview.handle then
		-- spawn vehicle (networked = false, to remain invisible while previewing to prevent others from blocking the view)
		-- remove collision
		-- put player inside
		local numberHash = tonumber(menu.preview.hash)
		-- thread code stuff below was taken from an example on the wiki
		-- Create a thread so that we don't 'wait' the entire game
		Citizen.CreateThread(function()
			-- Request the model so that it can be spawned
			RequestModel(numberHash)
			-- Check if it's loaded, if not then wait and re-request it.
			while not HasModelLoaded(numberHash) do
				Citizen.Wait(100)
			end
			-- Model loaded, continue
			-- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
			local vehicle = CreateVehicle(numberHash, menu.closest_store.vehspawn_x, menu.closest_store.vehspawn_y, menu.closest_store.vehspawn_z, menu.closest_store.vehspawn_heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
			menu.preview.handle = vehicle
			--SetVehicleNumberPlateText(vehicle, plate)
			SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
			--SetVehicleAsNoLongerNeeded(vehicle)
			--SetEntityAsMissionEntity(vehicle, true, true)
			--SetVehicleHasBeenOwnedByPlayer(vehicle, true)
			SetVehicleOnGroundProperly(vehicle)
			SetVehRadioStation(vehicle, "OFF")
			SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
			SetVehicleEngineOn(vehicle, true, false, false)
			FreezeEntityPosition(vehicle, true)
			SetVehicleDoorsLocked(vehicle, 4)
		end)
		Wait(1000)
	end
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function comma_value(amount)
	if not amount then return end
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function addBlips()
	for i = 1, #SHOPS do
		local blip = AddBlipForCoord(SHOPS[i].store_x, SHOPS[i].store_y, SHOPS[i].store_z)
		SetBlipSprite(blip, 225)
		SetBlipColour(blip, 76)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Car Dealership")
		EndTextCommandSetBlipName(blip)
	end
end

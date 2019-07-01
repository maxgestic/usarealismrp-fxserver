--# by: minipunch
--# for: USA REALISM RP
--# simple vehicle shop script to preview and purchase a vehicle

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("vehicle-shop", "vehicles", nil)

local price, vehicleName, hash, plate
local MAX_PLAYER_VEHICLES = 500

-- VEHICLES
local vehicleShopItems = {
	["vehicles"] = {
		["Suvs"] = {
			{make = "Canis", model = "Seminole", price = 10550, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 27197, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 15050, hash = -1775728740, storage_capacity = 185.0},
			{make = "Dundreary", model = "Landstalker", price = 24650, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Streiter", price = 31945, hash = "streiter", storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 35469, hash = 1177543287, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 2", price = 44420, hash = -394074634, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 6x6", price = 85897, hash = -1237253773, storage_capacity = 215.0},
			{make = "Phatom", model = "FQ2", price = 27369, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 20548, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 21989, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller LE", price = 47457, hash = 1878062887, storage_capacity = 200.0},
			{make = "Gallivanter", model = "Baller", price = 21150, hash = 634118882, storage_capacity = 200.0},
			{make = "Enus", model = "Huntley", price = 35489, hash = 486987393, storage_capacity = 200.0},
			{make = "Mammoth", model = "Patriot", price = 19784, hash = -808457413, storage_capacity = 200.0},
			{make = "Emperor", model = "Habenaro", price = 7559, hash = "habanero", storage_capacity = 200.0},
			{make = "Karin", model = "BeeJay XL", price = 23145, hash = "bjxl", storage_capacity = 200.0},
			{make = "Benefactor", model = "XLS", price = 29999, hash = "xls", storage_capacity = 200.0}
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 31900, hash = -624529134, storage_capacity = 135.0},
			{make = "Dewbauchee", model = "Exemplar", price = 47980, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel", price = 23500, hash = "sentinel2", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 24890, hash = "sentinel", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel Classic", price = 33870, hash = "sentinel3", storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Cabrio", price = 75643, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 37640, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 78543, hash = -1930048799, storage_capacity = 135.0},
			{make = "Albany", model = "Alpha", price = 21980, hash = 767087018, storage_capacity = 135.0},
			{make = "Pfister", model = "Comet 1", price = 34987, hash = -1045541610, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 2", price = 46965, hash = -2022483795, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 3", price = 59765, hash = "comet5", storage_capacity = 125.0},
			{make = "Ocelot", model = "Pariah", price = 77912, hash = "pariah", storage_capacity = 145.0},
			{make = "Lampadati", model = "Michelli GT", price = 48540, hash = "michelli", storage_capacity = 110.0},
			{make = "Ocelot", model = "F620", price = 37458, hash = "f620", storage_capacity = 145.0},
			{make = "Benefactor", model = "Schwartzer", price = 42977, hash = "schwarzer", storage_capacity = 135.0},
			{make = "Annis", model = "Savestra", price = 25560, hash = "savestra", storage_capacity = 125.0}
		},
		["Muscles"] = {
			{make = "Willard", model = "Faction", price = 10750, hash = -2119578145, storage_capacity = 160.0},
			{make = "Imponte", model = "Dukes", price = 15800, hash = 723973206, storage_capacity = 160.0},
			{make = "Declasse", model = "Vigero", price = 17430, hash = -825837129, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer", price = 16800, hash = -682211828, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer 2", price = 22870, hash = -1013450936, storage_capacity = 150.0},
			{make = "Imponte", model = "Ruiner", price = 9850, hash = -227741703, storage_capacity = 160.0},
			{make = "Imponte", model = "Nightshade", price = 26890, hash = -1943285540, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator", price = 15670, hash = 80636076, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator 3", price = 38650, hash = "dominator3", storage_capacity = 140.0},
			{make = "Albany", model = "Virgo 1", price = 10980, hash = -498054846, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo 2", price = 19430, hash = -899509638, storage_capacity = 130.0},
			{make = "Declasse", model = "Voodoo", price = 12970, hash = 2006667053, storage_capacity = 130.0},
			{make = "Declasse", model = "Tampa", price = 17876, hash = 972671128, storage_capacity = 160.0},
			{make = "Vapid", model = "Ellie", price = 42980, hash = "ellie", storage_capacity = 100.0},
			{make = "Declasse", model = "Sabre GT", price = 15970, hash = -1685021548, storage_capacity = 155.0},
			{make = "Declasse", model = "Stallion", price = 16540, hash = 1923400478, storage_capacity = 155.0},
			{make = "Declasse", model = "Impaler", price = 12867, hash = "impaler", storage_capacity = 155.0},
			{make = "Cheval", model = "Picador", price = 10750, hash = "picador", storage_capacity = 170.0},
			{make = "Vapid", model = "Blade", price = 36540, hash = "blade", storage_capacity = 170.0},
			{make = "Vapid", model = "Hotknife", price = 70890, hash = "hotknife", storage_capacity = 170.0},
			{make = "Imponte", model = "Phoenix", price = 28470, hash = "phoenix", storage_capacity = 170.0}
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 7800, hash = "rebel", storage_capacity = 230.0},
			{make = "Karin", model = "Rebel 2", price = 12601, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 18870, hash = 1069929536, storage_capacity = 230.0},
			{make = "Bravado", model = "Bison", price = 19899, hash = -16948145, storage_capacity = 230.0},
			{make = "Declasse", model = "Yosemite", price = 24446, hash = "yosemite", storage_capacity = 230.0},
			{make = "Vapid", model = "Riata", price = 29878, hash = "riata", storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 15000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking", price = 34320, hash = -1189015600, storage_capacity = 230.0},
			--{make = "Lifted Dodge", model = "Ram", price = 38000, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking 2", price = 40320, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Contender", price = 38649, hash = 683047626, storage_capacity = 230.0},
			{make = "Vapid", model = "Guardian", price = 98999, hash =  -2107990196, storage_capacity = 230.0},
			{make = "Bravado", model = "Rat-Truck", price = 29213, hash =  "ratloader2", storage_capacity = 230.0},
			{make = "Bravado", model = "Duneloader", price = 20899, hash =  "dloader", storage_capacity = 230.0},
		},
		["Compacts"] = {
			{make = "Nagasaki", model = "Caddy", price = 1200, hash = -537896628, storage_capacity = 80.0},
			{make = "Karin", model = "Dilettante", price = 3980, hash = -1130810103, storage_capacity = 170.0},
			{make = "Benefactor", model = "Panto", price = 5969, hash = -431692672, storage_capacity = 125.0},
			{make = "Declasse", model = "Rhapsody", price = 7650, hash = 841808271, storage_capacity = 125.0},
			{make = "Dinka", model = "Blista Compact", price = 7450, hash = 1039032026, storage_capacity = 135.0},
			{make = "Bollokan", model = "Prairie", price = 6760, hash = -1450650718, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi", price = 7760, hash = -1177863319, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi Classic", price = 10020, hash = "issi3", storage_capacity = 125.0},
			{make = "Grotti", model = "Brioso", price = 17570, hash = "brioso", storage_capacity = 125.0},
			{make = "Karin", model = "Futo", price = 7760, hash = "futo", storage_capacity = 125.0},
			{make = "Rune", model = "Cheburek", price = 12650, hash = "cheburek", storage_capacity = 115.0},
		},
		["Offroads"] = {
			{make = "Canis", model = "Kalahari", price = 17888, hash = 92612664, storage_capacity = 170.0},
			{make = "Declasse", model = "Rancher XL", price = 10540, hash = 1645267888, storage_capacity = 170.0},
			{make = "Coil", model = "Brawler", price = 41540, hash = -1479664699, storage_capacity = 170.0},
			{make = "BF", model = "Bifta", price = 33760, hash = -349601129, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa 2", price = 25640, hash = -2064372143, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa", price = 12650, hash = 914654722, storage_capacity = 170.0},
			{make = "Canis", model = "Kamacho", price = 57000, hash = "kamacho", storage_capacity = 130.0},
			{make = "Dune", model = "Buggy", price = 12430, hash = -1661854193, storage_capacity = 70.0},
			{make = "BF", model = "Injection", price = 5430, hash = 1126868326, storage_capacity = 70.0},
			{make = "Canis", model = "Bodhi", price = 17320, hash = "bodhi2", storage_capacity = 70.0},
		},
		["Motorcycles"] = {
			{make = "Pegassi", model = "Faggio", price = 1369, hash = -1842748181, storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 6750, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Akuma", price = 8760, hash = 1672195559, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Sanchez", price = 12880, hash = -1453280962, storage_capacity = 30.0},
			{make = "Shitzu", model = "Vader", price = 19402, hash = -140902153, storage_capacity = 30.0},
			{make = "Western", model = "Bagger", price = 14000, hash = -2140431165, storage_capacity = 30.0},
			{make = "LCC", model = "Hexer", price = 14765, hash = 301427732, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Chopper", price = 16540, hash = -570033273, storage_capacity = 30.0},
			{make = "Western", model = "Nightblade", price = 19200, hash = -1606187161, storage_capacity = 30.0},
			{make = "Pegassi", model = "Bati 801", price = 17430, hash = -114291515, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Bobber", price = 23430, hash = -1009268949, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Carbon RS", price = 23500, hash = 11251904, storage_capacity = 30.0},
			{make = "Western", model = "Daemon", price = 18540, hash = 2006142190, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Manchez", price = 23200, hash = -1523428744, storage_capacity = 30.0},
			{make = "Western", model = "Sovereign", price = 22999, hash = 743478836, storage_capacity = 30.0},
			{make = "Principe", model = "Lectro", price = 27540, hash = "lectro", storage_capacity = 30.0},
			{make = "Shitzu", model = "Defiler", price = 23760, hash = 822018448, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou", price = 31589, hash = 1265391242, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou Drag", price = 37980, hash = -255678177, storage_capacity = 60.0},
			{make = "Western", model = "Ratbike", price = 4987, hash = 1873600305, storage_capacity = 45.0},
			{make = "Pegassi", model = "Vortex", price = 32709, hash = -609625092, storage_capacity = 45.0}
		},
		["Vans"] = {
			{make = "Vapid", model = "Speedo", price = 16760, hash = -810318068, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan", price = 8500, hash = -310465116, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan 2", price = 13980, hash = -1126264336, storage_capacity = 250.0},
			{make = "Vapid", model = "Clown", price = 15599, hash = 728614474, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 1", price = 20900, hash = -1346687836, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 2", price = 20900, hash = -907477130, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 3", price = 20900, hash = -1743316013, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 4", price = 20900, hash = 893081117, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 5", price = 20900, hash = 1132262048, storage_capacity = 300.0},
			{make = "BF", model = "Surfer", price = 8970, hash = 699456151, storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 17676, hash = 1026149675, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo 3", price = 38432, hash = 1475773103, storage_capacity = 300.0},
			{make = "Brute", model = "Camper", price = 24500, hash = 1876516712, storage_capacity = 300.0},
			{make = "Brute", model = "Taco Van", price = 20500, hash = 1951180813, storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam", price = 14500, hash = "moonbeam", storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam 2", price = 20500, hash = "moonbeam2", storage_capacity = 300.0},
			{make = "Zirconium", model = "Journey", price = 7570, hash = "journey", storage_capacity = 350.0}
		},
		["Sports"] = {
			{make = "Ubermacht", model = "Zion Cabrio", price = 25540, hash = -1193103848, storage_capacity = 145.0},
			{make = "Invetero", model = "Coquette", price = 51760, hash = 108773431, storage_capacity = 145.0},
			{make = "Benefactor", model = "Surano", price = 59870, hash = 384071873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Massacro", price = 71650, hash = -142942670, storage_capacity = 145.0},
			{make = "Benefactor", model = "Schafter V12", price = 43776, hash = -1485523546, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 42430, hash = -1934452204, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 29789, hash = 196747873, storage_capacity = 145.0},
			{make = "Vapid", model = "Flash GT", price = 47654, hash = "flashgt", storage_capacity = 125.0},
			{make = "Dewbauchee", model = "Seven-70", price = 64999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 68700, hash = 1886268224, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan RS", price = 35000, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 56890, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 64453, hash = -1461482751, storage_capacity = 145.0},
			{make = "Obey", model = "Omnis", price = 50500, hash = "omnis", storage_capacity = 125.0},
			{make = "Dinka", model = "Jester", price = 65000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 39532, hash = -1372848492, storage_capacity = 145.0},
			{make = "Vapid", model = "GB200", price = 69756, hash = "gb200", storage_capacity = 100.0},
			{make = "Lampadati", model = "Furore GT", price = 61876, hash = -1089039904, storage_capacity = 100.0},
			{make = "Grotti", model = "Bestia GTS", price = 62876, hash = 1274868363, storage_capacity = 120.0},
			{make = "Benefactor", model = "Feltzer", price = 61432, hash = "feltzer2", storage_capacity = 100.0}
		},
		["Supers"] = {
			{make = "Pegassi", model = "Infernus", price = 128621, hash = 418536135, storage_capacity = 100.0},
			{make = "Vapid", model = "Bullet", price = 126897, hash = -1696146015, storage_capacity = 100.0},
			{make = "Grotti", model = "Cheetah", price = 138442, hash = -1311154784, storage_capacity = 100.0},
			{make = "Pfister", model = "811", price = 122645, hash = -1829802492, storage_capacity = 100.0},
			{make = "Pegassi", model = "Vacca", price = 126392, hash = 338562499, storage_capacity = 100.0},
			{make = "Progen", model = "T20", price = 194846, hash = 1663218586, storage_capacity = 100.0},
			{make = "Pegassi", model = "Osiris", price = 165328, hash = 1987142870, storage_capacity = 100.0},
			{make = "Truffade", model = "Adder", price = 153524, hash = -1216765807, storage_capacity = 100.0},
			{make = "Progen", model = "GP1", price = 147535, hash = 1234311532, storage_capacity = 100.0},
			{make = "Pegassi", model = "Reaper", price = 143956, hash = 234062309, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero", price = 156439, hash = 1034187331, storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 157864, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 164539, hash = 1426219628, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB", price = 168904, hash = -2048333973, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB Custom", price = 189476, hash = "italigtb2", storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 197454, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 209875, hash = 917809321, storage_capacity = 100.0},
			--{make = "Ferrari", model = "California", price = 130000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Carbonizzare", price = 142164, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 243643, hash = 408192225, storage_capacity = 100.0},
			{make = "Progen", model = "Tyrus", price = 246758, hash = 2067820283, storage_capacity = 100.0},
			{make = "Annis", model = "RE7B", price = 247647, hash = -1232836011, storage_capacity = 100.0},
			{make = "Ubermacht", model = "SC1", price = 176543, hash = "SC1", storage_capacity = 100.0},
			{make = "Ocelot", model = "Penetrator", price = 173970, hash = "penetrator", storage_capacity = 110.0},
			{make = "Emperor", model = "ETR 1", price = 182347, hash = "sheava", storage_capacity = 110.0},
			{make = "Grotti", model = "Itali GTO", price = 186754, hash = "italigto", storage_capacity = 110.0},
			{make = "Overflod", model = "Autarch", price = 256708, hash = "autarch", storage_capacity = 100.0},
			{make = "Overflod", model = "Tyrant", price = 289074, hash = "tyrant", storage_capacity = 100.0},
			{make = "Cheval", model = "Taipan", price = 195375, hash = "taipan", storage_capacity = 110.0},
			{make = "Pegassi", model = "Tezeract", price = 254584, hash = "tezeract", storage_capacity = 110.0},
			{make = "Grotti", model = "Visione", price = 295794, hash = "visione", storage_capacity = 110.0},
			{make = "Dewbauchee", model = "Vagner", price = 384638, hash = "vagner", storage_capacity = 110.0}
		},
		["Classic"] = {
			{make = "Declasse", model = "Tornado", price = 9250, hash = 464687292, storage_capacity = 150.0},
			{make = "Vapid", model = "Peyote", price = 16700, hash = 1830407356, storage_capacity = 135.0},
			{make = "Lampadati", model = "Casco", price = 59990, hash = 941800958, storage_capacity = 135.0},
			{make = "Pegassi", model = "Monroe", price = 57750, hash = -433375717, storage_capacity = 135.0},
			{make = "Grotti", model = "Turismo Classic", price = 62550, hash = -982130927, storage_capacity = 135.0},
			{make = "Grotti", model = "Stinger", price = 56420, hash = 1545842587, storage_capacity = 115.0},
			{make = "Grotti", model = "Stinger GT", price = 68858, hash = -2098947590, storage_capacity = 135.0},
			{make = "Pegassi", model = "Infernus Classic", price = 63500, hash = -1405937764, storage_capacity = 135.0},
			{make = "Albany", model = "Roosevelt Valor", price = 52985, hash = -602287871, storage_capacity = 135.0},
			{make = "Grotti", model = "Cheetah Classic", price = 53330, hash = 223240013, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 46564, hash = 1011753235, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 41430, hash = 784565758, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "JB 700", price = 57689, hash = 1051415893, storage_capacity = 120.0},
			{make = "Declasse", model = "Mamba", price = 41956, hash = -1660945322, storage_capacity = 110.0},
			{make = "Albany", model = "Manana", price = 12969, hash = -2124201592, storage_capacity = 140.0},
			{make = "Lampadati", model = "Pigalle", price = 18999, hash = 1078682497, storage_capacity = 125.0},
			{make = "Pegassi", model = "Torero", price = 58150, hash = 1504306544, storage_capacity = 100.0},
			{make = "Truffade", model = "ZType", price = 85000, hash = "ztype", storage_capacity = 100.0},
			{make = "Albany", model = "Roosevelt", price = 58000, hash = 117401876, storage_capacity = 100.0},
			{make = "Grotti", model = "GT 500", price = 65932, hash = "gt500", storage_capacity = 100.0},
			{make = "Albany", model = "Hermes", price = 39650, hash = "hermes", storage_capacity = 100.0},
			{make = "Karin", model = "190 Z", price = 25430, hash = "z190", storage_capacity = 100.0},
			{make = "Vulcar", model = "Fagaloa", price = 56320, hash = "fagaloa", storage_capacity = 170.0}
			--{make = "Lampadati", model = "Viseris", price = 65000, hash = "viseris", storage_capacity = 170.0}
			--{make = "Ocelot", model = "Swinger", price = 63000, hash = "swinger", storage_capacity = 100.0}
		},
		["Sedans"] = {
			{make = "Albany", model = "Emperor", price = 2050, hash = -1883002148, storage_capacity = 165.0},
			{make = "Albany", model = "Emperor 2", price = 9176, hash = -685276541, storage_capacity = 165.0},
			{make = "Albany", model = "Washington", price = 5846, hash = 1777363799, storage_capacity = 165.0},
			{make = "Karin", model = "Intruder", price = 6490, hash = 886934177, storage_capacity = 165.0},
			{make = "Vulcar", model = "Ingot", price = 4876, hash = -1289722222, storage_capacity = 165.0},
			{make = "Zinconium", model = "Stratum", price = 3847, hash = 1723137093, storage_capacity = 165.0},
			{make = "Vapid", model = "Stanier", price = 5484, hash = -1477580979, storage_capacity = 165.0},
			{make = "Benefactor", model = "Glendale", price = 15047, hash = 75131841, storage_capacity = 165.0},
			{make = "Vulcar", model = "Warrener", price = 12846, hash = 1373123368, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Oracle", price = 28834, hash = -511601230, storage_capacity = 165.0},
			{make = "Enus", model = "Cognoscenti", price = 54733, hash = -2030171296, storage_capacity = 165.0},
			{make = "Enus", model = "Super Diamond", price = 52247, hash = 1123216662, storage_capacity = 165.0},
			{make = "Albany", model = "Primo", price = 7682, hash = "primo", storage_capacity = 155.0},
			{make = "Albany", model = "Primo Custom", price = 15336, hash = "primo2", storage_capacity = 155.0},
			{make = "Cheval", model = "Fugitive", price = 13746, hash = "fugitive", storage_capacity = 155.0},
			{make = "Benefactor", model = "Schafter", price = 35846, hash = "schafter2", storage_capacity = 155.0},
			{make = "Dundreary", model = "Regina", price = 8937, hash = "regina", storage_capacity = 155.0},
			{make = "Pegassi", model = "Toros", price = 57632, hash = "toros", storage_capacity = 155.0},
			{make = "Ubermacht", model = "Revolter", price = 49634, hash = "revolter", storage_capacity = 155.0} -- has miniguns in LSC
		},
		["Specials"] = {
			{make = "Dundreary", model = "Stretch", price = 17575, hash = -1961627517, storage_capacity = 300.0},
			{make = "Maibatsu", model = "Mule 3", price = 49432, hash = -2052737935, storage_capacity = 475.0},
			{make = "MTL", model = "Pounder", price = 90452, hash = 2112052861, storage_capacity = 900.0},
			{make = "Declasse", model = "Burrito Lost", price = 22342, hash = -1745203402, storage_capacity = 260.0},
			{make = "Vapid", model = "Slam Van Lost", price = 25545, hash = 833469436, storage_capacity = 260.0},
			{make = "Declasse", model = "Stallion Special", price = 39956, hash =  -401643538, storage_capacity = 155.0},
			{make = "Bravado", model = "Buffalo Special", price = 39364, hash = 237764926, storage_capacity = 155.0},
			{make = "Vapid", model = "Dominator Special", price = 39868, hash = -915704871, storage_capacity = 155.0},
			{make = "Dewbauchee", model = "Massacro Special", price = 72857, hash = -631760477, storage_capacity = 130.0},
			{make = "Dinka", model = "Jester Special", price = 80765, hash = -1106353882, storage_capacity = 120.0},
			{make = "Vapid", model = "Benson", price = 69573, hash = "benson", storage_capacity = 500.0},
		},
		["Electric"] = {
			{make = "Coil", model = "Raider", price = 50000, hash = "raiden", storage_capacity = 150.0},
			{make = "Coil", model = "Voltic", price = 37564, hash = "voltic", storage_capacity = 135.0},
			{make = "Pfister", model = "Neon", price = 48674, hash = "neon", storage_capacity = 135.0},
			{make = "Cheval", model = "Surge", price = 17453, hash = "surge", storage_capacity = 135.0},
			{make = "Coil", model = "Cyclone", price = 74372, hash = "cyclone", storage_capacity = 135.0},
			{make = "Hijak", model = "Khamelion", price = 34637, hash = 544021352, storage_capacity = 145.0},
		}
	}
}

RegisterServerEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function()
	TriggerClientEvent("vehicle-shop:loadItems", source, vehicleShopItems)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle, business)
	local playerIdentifier = GetPlayerIdentifiers(source)[1]
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	local vehicles = char.get("vehicles")
	local money = char.get("money")
	local owner_name = char.getFullName()
	if license and license.status == "valid" then
		local hash = vehicle.hash
		local price = tonumber(GetVehiclePrice(vehicle))
		if tonumber(price) <= money then
			local plate = generate_random_number_plate()
			if vehicles then
				char.removeMoney(price)
				local vehicle = {
					owner = owner_name,
					make = vehicle.make,
					model = vehicle.model,
					hash = hash,
					plate = plate,
					stored = false,
					price = price,
					inventory = exports["usa_vehinv"]:NewInventory(vehicle.storage_capacity),
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

				table.insert(vehicles, vehicle.plate)
				char.set("vehicles", vehicles)
				char.giveItem(vehicle_key, 1)
				AddVehicleToDB(vehicle)

				TriggerEvent("lock:addPlate", vehicle.plate)
				TriggerClientEvent("usa:notify", source, "Here are the keys! Thanks for your business!")
				TriggerClientEvent("vehShop:spawnPlayersVehicle", source, hash, plate)

				if business then
					exports["usa-businesses"]:GiveBusinessCashPercent(business, price)
				end
			end
		else
			TriggerClientEvent("usa:notify", source, "Not enough money for that vehicle!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Come back when you have a valid driver's license!")
	end
end)

RegisterServerEvent("vehShop:loadVehiclesToSell")
AddEventHandler("vehShop:loadVehiclesToSell", function()
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(source)
	local vehicles = char.get("vehicles")
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getVehiclesToSellWithPlates"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3], -- model
						price = data.rows[i].value[4], -- price
						_rev = data.rows[i].value[5] -- _rev
					}
					table.insert(responseVehArray, veh)
				end
			end
			TriggerClientEvent("vehShop:displayVehiclesToSell", usource, responseVehArray)
		end
	end, "POST", json.encode({
		keys = vehicles
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end)

RegisterServerEvent("vehShop:sellVehicle")
AddEventHandler("vehShop:sellVehicle", function(toSellVehicle)
	local char = exports["usa-characters"]:GetCharacter(source)
	local vehicles = char.get("vehicles")
	for i = 1, #vehicles do
		if vehicles[i] == toSellVehicle.plate then
			table.remove(vehicles, i)
			char.set("vehicles", vehicles)
			break
		end
	end
	-- remove from DB / take money --
	RemoveVehicleFromDB(toSellVehicle, function(err, resp)
		local vehiclePrice = GetVehiclePrice(toSellVehicle)
		char.giveMoney((vehiclePrice * .50))
	end)
end)

function GetVehiclePrice(vehicle)
	for k, v in pairs(vehicleShopItems["vehicles"]) do
		for i = 1, #v do
			local name1 = vehicle.make .. " " .. vehicle.model
			local name2 = v[i].make .. " " .. v[i].model
			if name1 == name2 then
				return v[i].price
			end
		end
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
	return number_plate
end

-- Insert new vehicle into DB --
function AddVehicleToDB(vehicle)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		couchdb.createDocumentWithId("vehicles", vehicle, vehicle.plate, function(success)
			if success then
				--print("* Vehicle created in DB!! *")
			else
				--print("* Error: vehicle was not created in DB!! *")
			end
		end)
	end)
end

-- Delete vehicle from DB --
function RemoveVehicleFromDB(vehicle, cb)
	PerformHttpRequest("http://127.0.0.1:5984/".."vehicles".."/".. vehicle.plate .."?rev=" .. vehicle._rev, function(err, rText, headers)
		RconPrint("\nerr = " .. err)
		RconPrint("\nrText = " .. rText)
		cb(err, rText)
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

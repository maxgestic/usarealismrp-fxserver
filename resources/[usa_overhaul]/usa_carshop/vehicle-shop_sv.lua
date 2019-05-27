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
			{make = "Canis", model = "Seminole", price = 30567, hash = 1221512915, storage_capacity = 175.0},
			{make = "Obey", model = "Rocoto", price = 32896, hash = 2136773105, storage_capacity = 175.0},
			{make = "Declasse", model = "Granger", price = 42110, hash = -1775728740, storage_capacity = 185.0},
			{make = "Dundreary", model = "Landstalker", price = 36590, hash = 1269098716, storage_capacity = 175.0},
			{make = "Benefactor", model = "Streiter", price = 51675, hash = "streiter", storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta", price = 38745, hash = 1177543287, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 2", price = 43971, hash = -394074634, storage_capacity = 175.0},
			{make = "Benefactor", model = "Dubsta 6x6", price = 87425, hash = -1237253773, storage_capacity = 215.0},
			{make = "Phatom", model = "FQ2", price = 22877, hash = -1137532101, storage_capacity = 175.0},
			{make = "Bravado", model = "Gresley", price = 25199, hash = -1543762099, storage_capacity = 175.0},
			{make = "Albany", model = "Cavalcade", price = 34999, hash = -789894171, storage_capacity = 175.0},
			{make = "Gallivanter", model = "Baller LE", price = 55320, hash = 1878062887, storage_capacity = 200.0},
			{make = "Gallivanter", model = "Baller", price = 19654, hash = 634118882, storage_capacity = 200.0},
			{make = "Enus", model = "Huntley", price = 33765, hash = 486987393, storage_capacity = 200.0},
			{make = "Mammoth", model = "Patriot", price = 39860, hash = -808457413, storage_capacity = 200.0},
			{make = "Emperor", model = "Habenaro", price = 16890, hash = "habanero", storage_capacity = 200.0},
			{make = "Karin", model = "BeeJay XL", price = 28189, hash = "bjxl", storage_capacity = 200.0},
			{make = "Benefactor", model = "XLS", price = 43880, hash = "xls", storage_capacity = 200.0}
		},
		["Coupes"] = {
			{make = "Ocelot", model = "Jackal", price = 37600, hash = -624529134, storage_capacity = 135.0},
			{make = "Dewbauchee", model = "Exemplar", price = 59980, hash = -5153954, storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel", price = 23000, hash = "sentinel2", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel XS", price = 27890, hash = "sentinel", storage_capacity = 135.0},
			{make = "Ubermacht", model = "Sentinel Classic", price = 39870, hash = "sentinel3", storage_capacity = 135.0},
			{make = "Enus", model = "Cognoscenti Cabrio", price = 89643, hash = 330661258, storage_capacity = 135.0},
			{make = "Lampadati", model = "Felon", price = 75640, hash = -391594584, storage_capacity = 135.0},
			{make = "Enus", model = "Windsor Cabrio", price = 238543, hash = -1930048799, storage_capacity = 135.0},
			{make = "Albany", model = "Alpha", price = 18980, hash = 767087018, storage_capacity = 135.0},
			{make = "Pfister", model = "Comet 1", price = 56987, hash = -1045541610, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 2", price = 78965, hash = -2022483795, storage_capacity = 125.0},
			{make = "Pfister", model = "Comet 3", price = 90765, hash = "comet5", storage_capacity = 125.0},
			{make = "Ocelot", model = "Pariah", price = 376912, hash = "pariah", storage_capacity = 145.0},
			{make = "Lampadati", model = "Michelli GT", price = 76540, hash = "michelli", storage_capacity = 110.0},
			{make = "Ocelot", model = "F620", price = 65458, hash = "f620", storage_capacity = 145.0},
			{make = "Benefactor", model = "Schwartzer", price = 87977, hash = "schwarzer", storage_capacity = 135.0},
			{make = "Annis", model = "Savestra", price = 83560, hash = "savestra", storage_capacity = 125.0}
		},
		["Muscles"] = {
			{make = "Willard", model = "Faction", price = 13750, hash = -2119578145, storage_capacity = 160.0},
			{make = "Imponte", model = "Dukes", price = 19800, hash = 723973206, storage_capacity = 160.0},
			{make = "Declasse", model = "Vigero", price = 27430, hash = -825837129, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer", price = 20800, hash = -682211828, storage_capacity = 160.0},
			{make = "Albany", model = "Buccaneer 2", price = 29870, hash = -1013450936, storage_capacity = 150.0},
			{make = "Imponte", model = "Ruiner", price = 12850, hash = -227741703, storage_capacity = 160.0},
			{make = "Imponte", model = "Nightshade", price = 27890, hash = -1943285540, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator", price = 34670, hash = 80636076, storage_capacity = 160.0},
			{make = "Vapid", model = "Dominator 3", price = 97650, hash = "dominator3", storage_capacity = 140.0},
			{make = "Albany", model = "Virgo 1", price = 17980, hash = -498054846, storage_capacity = 160.0},
			{make = "Albany", model = "Virgo 2", price = 25430, hash = -899509638, storage_capacity = 130.0},
			{make = "Declasse", model = "Voodoo", price = 23970, hash = 2006667053, storage_capacity = 130.0},
			{make = "Declasse", model = "Tampa", price = 26876, hash = 972671128, storage_capacity = 160.0},
			{make = "Vapid", model = "Ellie", price = 65980, hash = "ellie", storage_capacity = 100.0},
			{make = "Declasse", model = "Sabre GT", price = 24970, hash = -1685021548, storage_capacity = 155.0},
			{make = "Declasse", model = "Stallion", price = 16540, hash = 1923400478, storage_capacity = 155.0},
			{make = "Declasse", model = "Impaler", price = 12867, hash = "impaler", storage_capacity = 155.0},
			{make = "Cheval", model = "Picador", price = 26750, hash = "picador", storage_capacity = 170.0},
			{make = "Vapid", model = "Blade", price = 36540, hash = "blade", storage_capacity = 170.0},
			{make = "Vapid", model = "Hotknife", price = 137890, hash = "hotknife", storage_capacity = 170.0},
			{make = "Imponte", model = "Phoenix", price = 24470, hash = "phoenix", storage_capacity = 170.0}
		},
		["Trucks"] = {
			{make = "Karin", model = "Rebel", price = 19800, hash = "rebel", storage_capacity = 230.0},
			{make = "Karin", model = "Rebel 2", price = 27601, hash = -2045594037, storage_capacity = 230.0},
			{make = "Vapid", model = "Bobcat XL", price = 34870, hash = 1069929536, storage_capacity = 230.0},
			{make = "Bravado", model = "Bison", price = 57899, hash = -16948145, storage_capacity = 230.0},
			{make = "Declasse", model = "Yosemite", price = 32446, hash = "yosemite", storage_capacity = 230.0},
			{make = "Vapid", model = "Riata", price = 39878, hash = "riata", storage_capacity = 230.0},
			{make = "Vapid", model = "Slam Van", price = 24000, hash = 729783779, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking", price = 67320, hash = -1189015600, storage_capacity = 230.0},
			--{make = "Lifted Dodge", model = "Ram", price = 120000, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Sandking 2", price = 67320, hash = 989381445, storage_capacity = 230.0},
			{make = "Vapid", model = "Contender", price = 97649, hash = 683047626, storage_capacity = 230.0},
			{make = "Vapid", model = "Guardian", price = 189999, hash =  -2107990196, storage_capacity = 230.0},
			{make = "Bravado", model = "Rat-Truck", price = 34213, hash =  "ratloader2", storage_capacity = 230.0},
			{make = "Bravado", model = "Duneloader", price = 54899, hash =  "dloader", storage_capacity = 230.0},
		},
		["Compacts"] = {
			{make = "Nagasaki", model = "Caddy", price = 1350, hash = -537896628, storage_capacity = 80.0},
			{make = "Karin", model = "Dilettante", price = 5680, hash = -1130810103, storage_capacity = 170.0},
			{make = "Benefactor", model = "Panto", price = 11769, hash = -431692672, storage_capacity = 125.0},
			{make = "Declasse", model = "Rhapsody", price = 18650, hash = 841808271, storage_capacity = 125.0},
			{make = "Dinka", model = "Blista Compact", price = 13450, hash = 1039032026, storage_capacity = 135.0},
			{make = "Bollokan", model = "Prairie", price = 14760, hash = -1450650718, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi", price = 9760, hash = -1177863319, storage_capacity = 125.0},
			{make = "Weeny", model = "Issi Classic", price = 4320, hash = "issi3", storage_capacity = 125.0},
			{make = "Grotti", model = "Brioso", price = 24570, hash = "brioso", storage_capacity = 125.0},
			{make = "Karin", model = "Futo", price = 8760, hash = "futo", storage_capacity = 125.0},
			{make = "Rune", model = "Cheburek", price = 18650, hash = "cheburek", storage_capacity = 115.0},
		},
		["Offroads"] = {
			{make = "Canis", model = "Kalahari", price = 23888, hash = 92612664, storage_capacity = 170.0},
			{make = "Declasse", model = "Rancher XL", price = 17540, hash = 1645267888, storage_capacity = 170.0},
			{make = "Coil", model = "Brawler", price = 176540, hash = -1479664699, storage_capacity = 170.0},
			{make = "BF", model = "Bifta", price = 134760, hash = -349601129, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa 2", price = 37640, hash = -2064372143, storage_capacity = 170.0},
			{make = "Canis", model = "Mesa", price = 17650, hash = 914654722, storage_capacity = 170.0},
			{make = "Canis", model = "Kamacho", price = 476000, hash = "kamacho", storage_capacity = 130.0},
			{make = "Dune", model = "Buggy", price = 75430, hash = -1661854193, storage_capacity = 70.0},
			{make = "BF", model = "Injection", price = 23430, hash = 1126868326, storage_capacity = 70.0},
			{make = "Canis", model = "Bodhi", price = 54320, hash = "bodhi2", storage_capacity = 70.0},
		},
		["Motorcycles"] = {
			{make = "Pegassi", model = "Faggio", price = 3650, hash = -1842748181, storage_capacity = 30.0},
			{make = "Dinka", model = "Enduro", price = 32650, hash = 1753414259, storage_capacity = 30.0},
			{make = "Dinka", model = "Akuma", price = 59760, hash = 1672195559, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Sanchez", price = 23880, hash = -1453280962, storage_capacity = 30.0},
			{make = "Shitzu", model = "Vader", price = 75402, hash = -140902153, storage_capacity = 30.0},
			{make = "Western", model = "Bagger", price = 14000, hash = -2140431165, storage_capacity = 30.0},
			{make = "LCC", model = "Hexer", price = 29765, hash = 301427732, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Chopper", price = 32540, hash = -570033273, storage_capacity = 30.0},
			{make = "Western", model = "Nightblade", price = 43200, hash = -1606187161, storage_capacity = 30.0},
			{make = "Pegassi", model = "Bati 801", price = 75430, hash = -114291515, storage_capacity = 30.0},
			{make = "Western", model = "Zombie Bobber", price = 23430, hash = -1009268949, storage_capacity = 30.0},
			{make = "Nagasaki", model = "Carbon RS", price = 128500, hash = 11251904, storage_capacity = 30.0},
			{make = "Western", model = "Daemon", price = 18540, hash = 2006142190, storage_capacity = 30.0},
			{make = "Maibatsu", model = "Manchez", price = 53200, hash = -1523428744, storage_capacity = 30.0},
			{make = "Western", model = "Sovereign", price = 21999, hash = 743478836, storage_capacity = 30.0},
			{make = "Principe", model = "Lectro", price = 76540, hash = "lectro", storage_capacity = 30.0},
			{make = "Shitzu", model = "Defiler", price = 65760, hash = 822018448, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou", price = 176589, hash = 1265391242, storage_capacity = 60.0},
			{make = "Shitzu", model = "Hakuchou Drag", price = 187980, hash = -255678177, storage_capacity = 60.0},
			{make = "Western", model = "Ratbike", price = 11987, hash = 1873600305, storage_capacity = 45.0},
			{make = "Pegassi", model = "Vortex", price = 98709, hash = -609625092, storage_capacity = 45.0}
		},
		["Vans"] = {
			{make = "Vapid", model = "Speedo", price = 23760, hash = -810318068, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan", price = 13000, hash = -310465116, storage_capacity = 300.0},
			{make = "Vapid", model = "Minivan 2", price = 21980, hash = -1126264336, storage_capacity = 250.0},
			{make = "Vapid", model = "Clown", price = 29599, hash = 728614474, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 1", price = 36900, hash = -1346687836, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 2", price = 36900, hash = -907477130, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 3", price = 36900, hash = -1743316013, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 4", price = 36900, hash = 893081117, storage_capacity = 300.0},
			{make = "Declasse", model = "Burrito 5", price = 36900, hash = 1132262048, storage_capacity = 300.0},
			{make = "BF", model = "Surfer", price = 8970, hash = 699456151, storage_capacity = 300.0},
			{make = "Bravado", model = "Youga Classic", price = 54676, hash = 1026149675, storage_capacity = 300.0},
			{make = "Bravado", model = "Rumpo 3", price = 123432, hash = 1475773103, storage_capacity = 300.0},
			{make = "Brute", model = "Camper", price = 45500, hash = 1876516712, storage_capacity = 300.0},
			{make = "Brute", model = "Taco Van", price = 60500, hash = 1951180813, storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam", price = 40500, hash = "moonbeam", storage_capacity = 300.0},
			{make = "Declasse", model = "Moonbeam 2", price = 90500, hash = "moonbeam2", storage_capacity = 300.0},
			{make = "Zirconium", model = "Journey", price = 9870, hash = "journey", storage_capacity = 350.0}
		},
		["Sports"] = {
			{make = "Ubermacht", model = "Zion Cabrio", price = 27540, hash = -1193103848, storage_capacity = 145.0},
			{make = "Invetero", model = "Coquette", price = 58760, hash = 108773431, storage_capacity = 145.0},
			{make = "Benefactor", model = "Surano", price = 154870, hash = 384071873, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Massacro", price = 187650, hash = -142942670, storage_capacity = 145.0},
			{make = "Benefactor", model = "Schafter V12", price = 89776, hash = -1485523546, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Rapid GT", price = 76430, hash = -1934452204, storage_capacity = 145.0},
			{make = "Annis", model = "Elegy Retro Custom", price = 365789, hash = 196747873, storage_capacity = 145.0},
			{make = "Vapid", model = "Flash GT", price = 278654, hash = "flashgt", storage_capacity = 125.0},
			{make = "Dewbauchee", model = "Seven-70", price = 439999, hash = -1757836725, storage_capacity = 145.0},
			{make = "Dewbauchee", model = "Specter", price = 489700, hash = 1886268224, storage_capacity = 145.0},
			{make = "Karin", model = "Sultan RS", price = 176850, hash = -295689028, storage_capacity = 145.0},
			{make = "Obey", model = "9F", price = 365890, hash = 1032823388, storage_capacity = 145.0},
			{make = "Obey", model = "9F Cabrio", price = 389453, hash = -1461482751, storage_capacity = 145.0},
			{make = "Obey", model = "Omnis", price = 290500, hash = "omnis", storage_capacity = 125.0},
			{make = "Dinka", model = "Jester", price = 423000, hash = -1297672541, storage_capacity = 145.0},
			{make = "Karin", model = "Kuruma", price = 234532, hash = -1372848492, storage_capacity = 145.0},
			{make = "Vapid", model = "GB200", price = 104756, hash = "gb200", storage_capacity = 100.0},
			{make = "Lampadati", model = "Furore GT", price = 245876, hash = -1089039904, storage_capacity = 100.0},
			{make = "Grotti", model = "Bestia GTS", price = 321876, hash = 1274868363, storage_capacity = 120.0},
			{make = "Benefactor", model = "Feltzer", price = 176432, hash = "feltzer2", storage_capacity = 100.0}
		},
		["Supers"] = {
			{make = "Pegassi", model = "Infernus", price = 498621, hash = 418536135, storage_capacity = 100.0},
			{make = "Vapid", model = "Bullet", price = 576897, hash = -1696146015, storage_capacity = 100.0},
			{make = "Grotti", model = "Cheetah", price = 698442, hash = -1311154784, storage_capacity = 100.0},
			{make = "Pfister", model = "811", price = 732645, hash = -1829802492, storage_capacity = 100.0},
			{make = "Pegassi", model = "Vacca", price = 776392, hash = 338562499, storage_capacity = 100.0},
			{make = "Progen", model = "T20", price = 834846, hash = 1663218586, storage_capacity = 100.0},
			{make = "Pegassi", model = "Osiris", price = 865328, hash = 1987142870, storage_capacity = 100.0},
			{make = "Truffade", model = "Adder", price = 893524, hash = -1216765807, storage_capacity = 100.0},
			{make = "Progen", model = "GP1", price = 947535, hash = 1234311532, storage_capacity = 100.0},
			{make = "Pegassi", model = "Reaper", price = 1439568, hash = 234062309, storage_capacity = 100.0},
			{make = "Truffade", model = "Nero", price = 1564397, hash = 1034187331, storage_capacity = 100.0},
			{make = "Pegassi", model = "Tempesta", price = 1578642, hash = 272929391, storage_capacity = 100.0},
			{make = "Vapid", model = "FMJ", price = 1645394, hash = 1426219628, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB", price = 1689047, hash = -2048333973, storage_capacity = 100.0},
			{make = "Progen", model = "Itali GTB Custom", price = 1894765, hash = "italigtb2", storage_capacity = 100.0},
			{make = "Pegassi", model = "Zentorno", price = 1974542, hash = -1403128555, storage_capacity = 100.0},
			{make = "Ocelot", model = "XA-21", price = 2098757, hash = 917809321, storage_capacity = 100.0},
			--{make = "Ferrari", model = "California", price = 650000, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Carbonizzare", price = 342164, hash = 2072687711, storage_capacity = 100.0},
			{make = "Grotti", model = "Turismo R", price = 2436436, hash = 408192225, storage_capacity = 100.0},
			{make = "Progen", model = "Tyrus", price = 2467585, hash = 2067820283, storage_capacity = 100.0},
			{make = "Annis", model = "RE7B", price = 2476475, hash = -1232836011, storage_capacity = 100.0},
			{make = "Ubermacht", model = "SC1", price = 1765437, hash = "SC1", storage_capacity = 100.0},
			{make = "Ocelot", model = "Penetrator", price = 843979, hash = "penetrator", storage_capacity = 110.0},
			{make = "Emperor", model = "ETR 1", price = 1323475, hash = "sheava", storage_capacity = 110.0},
			{make = "Grotti", model = "Itali GTO", price = 1567548, hash = "italigto", storage_capacity = 110.0},
			{make = "Overflod", model = "Autarch", price = 2567080, hash = "autarch", storage_capacity = 100.0},
			{make = "Overflod", model = "Tyrant", price = 2890747, hash = "tyrant", storage_capacity = 100.0},
			{make = "Cheval", model = "Taipan", price = 1253754, hash = "taipan", storage_capacity = 110.0},
			{make = "Pegassi", model = "Tezeract", price = 2545846, hash = "tezeract", storage_capacity = 110.0},
			{make = "Grotti", model = "Visione", price = 2957943, hash = "visione", storage_capacity = 110.0},
			{make = "Dewbauchee", model = "Vagner", price = 3846385, hash = "vagner", storage_capacity = 110.0}
		},
		["Classic"] = {
			{make = "Declasse", model = "Tornado", price = 15250, hash = 464687292, storage_capacity = 150.0},
			{make = "Vapid", model = "Peyote", price = 30700, hash = 1830407356, storage_capacity = 135.0},
			{make = "Lampadati", model = "Casco", price = 89990, hash = 941800958, storage_capacity = 135.0},
			{make = "Pegassi", model = "Monroe", price = 149750, hash = -433375717, storage_capacity = 135.0},
			{make = "Grotti", model = "Turismo Classic", price = 257550, hash = -982130927, storage_capacity = 135.0},
			{make = "Grotti", model = "Stinger", price = 128420, hash = 1545842587, storage_capacity = 115.0},
			{make = "Grotti", model = "Stinger GT", price = 205858, hash = -2098947590, storage_capacity = 135.0},
			{make = "Pegassi", model = "Infernus Classic", price = 187500, hash = -1405937764, storage_capacity = 135.0},
			{make = "Albany", model = "Roosevelt Valor", price = 322985, hash = -602287871, storage_capacity = 135.0},
			{make = "Grotti", model = "Cheetah Classic", price = 185330, hash = 223240013, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Classic", price = 124564, hash = 1011753235, storage_capacity = 120.0},
			{make = "Invetero", model = "Coquette Blackfin", price = 165430, hash = 784565758, storage_capacity = 120.0},
			{make = "Dewbauchee", model = "JB 700", price = 137689, hash = 1051415893, storage_capacity = 120.0},
			{make = "Declasse", model = "Mamba", price = 143956, hash = -1660945322, storage_capacity = 110.0},
			{make = "Albany", model = "Manana", price = 14969, hash = -2124201592, storage_capacity = 140.0},
			{make = "Lampadati", model = "Pigalle", price = 479999, hash = 1078682497, storage_capacity = 125.0},
			{make = "Pegassi", model = "Torero", price = 198150, hash = 1504306544, storage_capacity = 100.0},
			{make = "Truffade", model = "ZType", price = 500000, hash = "ztype", storage_capacity = 100.0},
			{make = "Albany", model = "Roosevelt", price = 95000, hash = 117401876, storage_capacity = 100.0},
			{make = "Grotti", model = "GT 500", price = 78932, hash = "gt500", storage_capacity = 100.0},
			{make = "Albany", model = "Hermes", price = 125650, hash = "hermes", storage_capacity = 100.0},
			{make = "Karin", model = "190 Z", price = 95430, hash = "z190", storage_capacity = 100.0},
			{make = "Vulcar", model = "Fagaloa", price = 56320, hash = "fagaloa", storage_capacity = 170.0}
			--{make = "Lampadati", model = "Viseris", price = 140000, hash = "viseris", storage_capacity = 170.0}
			--{make = "Ocelot", model = "Swinger", price = 120000, hash = "swinger", storage_capacity = 100.0}
		},
		["Sedans"] = {
			{make = "Albany", model = "Emperor", price = 5676, hash = -1883002148, storage_capacity = 165.0},
			{make = "Albany", model = "Emperor 2", price = 13876, hash = -685276541, storage_capacity = 165.0},
			{make = "Albany", model = "Washington", price = 25846, hash = 1777363799, storage_capacity = 165.0},
			{make = "Karin", model = "Intruder", price = 16490, hash = 886934177, storage_capacity = 165.0},
			{make = "Vulcar", model = "Ingot", price = 13876, hash = -1289722222, storage_capacity = 165.0},
			{make = "Zinconium", model = "Stratum", price = 12847, hash = 1723137093, storage_capacity = 165.0},
			{make = "Vapid", model = "Stanier", price = 15484, hash = -1477580979, storage_capacity = 165.0},
			{make = "Benefactor", model = "Glendale", price = 13047, hash = 75131841, storage_capacity = 165.0},
			{make = "Vulcar", model = "Warrener", price = 14846, hash = 1373123368, storage_capacity = 165.0},
			{make = "Ubermacht", model = "Oracle", price = 24834, hash = -511601230, storage_capacity = 165.0},
			{make = "Enus", model = "Cognoscenti", price = 84733, hash = -2030171296, storage_capacity = 165.0},
			{make = "Enus", model = "Super Diamond", price = 137247, hash = 1123216662, storage_capacity = 165.0},
			{make = "Albany", model = "Primo", price = 27482, hash = "primo", storage_capacity = 155.0},
			{make = "Albany", model = "Primo Custom", price = 94336, hash = "primo2", storage_capacity = 155.0},
			{make = "Cheval", model = "Fugitive", price = 22746, hash = "fugitive", storage_capacity = 155.0},
			{make = "Benefactor", model = "Schafter", price = 39846, hash = "schafter2", storage_capacity = 155.0},
			{make = "Dundreary", model = "Regina", price = 15937, hash = "regina", storage_capacity = 155.0},
			{make = "Pegassi", model = "Toros", price = 184632, hash = "toros", storage_capacity = 155.0},
			{make = "Ubermacht", model = "Revolter", price = 184634, hash = "revolter", storage_capacity = 155.0} -- has miniguns in LSC
		},
		["Specials"] = {
			{make = "Dundreary", model = "Stretch", price = 76575, hash = -1961627517, storage_capacity = 300.0},
			{make = "Maibatsu", model = "Mule 3", price = 65432, hash = -2052737935, storage_capacity = 475.0},
			{make = "MTL", model = "Pounder", price = 127452, hash = 2112052861, storage_capacity = 900.0},
			{make = "Declasse", model = "Burrito Lost", price = 65342, hash = -1745203402, storage_capacity = 260.0},
			{make = "Vapid", model = "Slam Van Lost", price = 86545, hash = 833469436, storage_capacity = 260.0},
			{make = "Declasse", model = "Stallion Special", price = 50956, hash =  -401643538, storage_capacity = 155.0},
			{make = "Bravado", model = "Buffalo Special", price = 45364, hash = 237764926, storage_capacity = 155.0},
			{make = "Vapid", model = "Dominator Special", price = 65868, hash = -915704871, storage_capacity = 155.0},
			{make = "Dewbauchee", model = "Massacro Special", price = 134857, hash = -631760477, storage_capacity = 130.0},
			{make = "Dinka", model = "Jester Special", price = 564765, hash = -1106353882, storage_capacity = 120.0},
			{make = "Vapid", model = "Benson", price = 109573, hash = "benson", storage_capacity = 500.0},
		},
		["Electric"] = {
			{make = "Coil", model = "Raider", price = 134563, hash = "raiden", storage_capacity = 150.0},
			{make = "Coil", model = "Voltic", price = 87564, hash = "voltic", storage_capacity = 135.0},
			{make = "Pfister", model = "Neon", price = 198674, hash = "neon", storage_capacity = 135.0},
			{make = "Cheval", model = "Surge", price = 32453, hash = "surge", storage_capacity = 135.0},
			{make = "Coil", model = "Cyclone", price = 564372, hash = "cyclone", storage_capacity = 135.0},
			{make = "Hijak", model = "Khamelion", price = 254637, hash = 544021352, storage_capacity = 145.0},
		}
	}
}

RegisterServerEvent("vehicle-shop:loadItems")
AddEventHandler("vehicle-shop:loadItems", function()
	TriggerClientEvent("vehicle-shop:loadItems", source, vehicleShopItems)
end)

RegisterServerEvent("mini:checkVehicleMoney")
AddEventHandler("mini:checkVehicleMoney", function(vehicle, property)
	local playerIdentifier = GetPlayerIdentifiers(source)[1]
	local char = exports["usa-characters"]:GetCharacter(source)
	local license = char.getItem("Driver's License")
	local vehicles = char.get("vehicles")
	local money = char.get("money")
	local owner_name = char.getFullName()
	if license and license.status == "valid" then
		local hash = vehicle.hash
		local price = GetVehiclePrice(vehicle)
		if tonumber(price) <= money then
			local plate = generate_random_number_plate()
			if vehicles then
				char.removeMoney(tonumber(price))
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

				table.insert(vehicles, vehicle.plate)
				char.set("vehicles", vehicles)
				char.giveItem(vehicle_key, 1)
				AddVehicleToDB(vehicle)

				TriggerEvent("lock:addPlate", vehicle.plate)
				TriggerClientEvent("usa:notify", source, "Here are the keys! Thanks for your business!")
				TriggerClientEvent("vehShop:spawnPlayersVehicle", source, hash, plate)
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

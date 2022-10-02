local WEBHOOK_URL = GetConvar("core-rob-truck-webhook", "")

notifications = {}

notifications.noitem = "You dont have the item needed for this action."
notifications.nopolice = "Not enough cops online."
notifications.policenotification = "Armored Bank Truck stopped transmitting to dispatch. Immediate assistance required. ^1 APPROACH WITH CAUTION^0."

logs = {}

logs.active = true -- if you want to have logs put "TRUE" if not put "FALSE".
logs.log = {
	["start"] = { -- This is the log that is used when a player starts the robbery.
		webhook = WEBHOOK_URL, -- This is the webhook that you have to set.
		title = "Truck Robbery",-- title of the embed message
		msg = "The robbery just got started.", -- message , for more control check server/functions.lua
		avatar = "https://imgur.com/jOcxS1Q.png", -- webhook avatar
		username = "Nuno Radio Man Robberies", -- webhook username
		footer = "Nuno Radio Man Robberies", -- embeded footer.
	},
	["giveitem"] = { -- This is the log that is used when a player gets a reward from the script.
		webhook = WEBHOOK_URL, -- This is the webhook that you have to set.
		title = "Truck Robbery", -- title of the embed message
		msg = "Received", -- message , for more control check server/functions.lua
		avatar = "https://imgur.com/jOcxS1Q.png", -- webhook avatar
		username = "Nuno Radio Man Robberies", -- webhook username
		footer = "Nuno Radio Man Robberies", -- embeded footer.
	},
}

cfg = {}

cfg.framework = "standalone" --esx,qbcore,vrp,vrpex,nunoradioman,standalone | Check server/functions.lua

cfg.updateserverside = true -- this makes sure the player has the correct list, IF YOU HAVE 500+ PLAYERS AND RUNNING ALL OF THE SCRIPTS PUT THIS "FALSE"

cfg.policejob = "police" -- police group [This is unused]
cfg.policeneeded = 4 -- police count

cfg.resettimer = 1 -- hour
cfg.npcrespawntimer = 300 -- seconds
cfg.explosivetime = 10 -- seconds

cfg.doestheplayerneedtohavebag = true -- if true the ped needs to have bag
cfg.bagsavailable = {9, 10, 11, 61, 62, 102, 103, 106, 107} -- if true these are the bags that are allowed

cfg.bombitem = "Sticky Bomb"
cfg.bombitem_text = "[E] Place Bomb"
cfg.bombitem_key = 51

cfg.collectitem = "money"
cfg.collectitem_amount = {950,1500} -- min: $19,000 | max: $30,000
cfg.collectitem_text = "[E] Collect"
cfg.collectitem_key = 51

cfg.randomitem = "Stolen Goods" -- if you dont want a random item to be given put nil
cfg.randomitem_amount = {1,3}
cfg.randomitem_chance = 50 -- 0 % to 100 %

cfg.amountofitemsdrop = 20

cfg.hacklocations = {
    [1] = {
        hash = GetHashKey("hei_prop_hei_securitypanel"),
        pos = {960.78088378906, 20.591073989868, 111.28333282471,147.50}, -- Casino
        offset = {0.0,0.32,0.15},

        minigame = {
			event = "CORE_ROB_MINIGAMES:VoltLab_c",
            data = {
                timer = 25, -- seconds
            },
		},

        item_needed = "Bank Laptop",
        item_amount_needed = 1,
        item_needed_remove_chance = 15, -- 0 / 100 %

        checkforpolice = true,
        text = "[E] Hack",
        text_key = 51,
    },
    [2] = {
        hash = GetHashKey("hei_prop_hei_securitypanel"),
        pos = {287.75985717773, -304.81823730469, 49.864246368408,249.98}, -- Hawick Ave
        offset = {0.0,0.32,0.15},

        minigame = {
			event = "CORE_ROB_MINIGAMES:DataCrack_c",
            data = {
                background = 5, -- 0 to 6 | MUST BE INTEGER
                difficulty = "hard", -- "easy" "medium" "hard" "veryhard"
                datacracks = 7, -- min is 1, max is 11, this is how much datacracks you want.
            },
		},
        item_needed = "Bank Laptop",
        item_amount_needed = 1,
        item_needed_remove_chance = 10, -- 0 / 100 %

        checkforpolice = true,
        text = "[E] Hack",
        text_key = 51,
    },
    [3] = {
        hash = GetHashKey("hei_prop_hei_securitypanel"),
        pos = {-2947.6867675781, 485.52276611328, 15.458961486816,88.46}, -- Great Ocean
        offset = {0.0,0.25,0.15},

        minigame = {
			event = "CORE_ROB_MINIGAMES:DataCrack_c",
            data = {
                background = 2, -- 0 to 6 | MUST BE INTEGER
                difficulty = "medium", -- "easy" "medium" "hard" "veryhard"
                datacracks = 8, -- min is 1, max is 11, this is how much datacracks you want.
            },
		},

        item_needed = "Bank Laptop",
        item_amount_needed = 1,
        item_needed_remove_chance = 10, -- 0 / 100 %

        checkforpolice = true,
        text = "[E] Hack",
        text_key = 51,
    },
}
cfg.robbery = {
    status = false,
    open_status = false,
    money = 0,
    positions = {
        [1] = {-5.2697372436523,-669.75061035156,32.338115692139,190.14},
        [2] = {267.74966430664, 141.31587219238, 104.25, 339.80},
        [3] = {2549.9602050781, -597.13110351563, 64.205673217773, 100.39},
    },
    vehicle_net_id = 0,
    npcs = {
        {
            net_id = 0,
            hash = GetHashKey("s_m_m_armoured_01"),
			weapon = GetHashKey("WEAPON_CARBINERIFLE"),
        },
        {
            net_id = 0,
            hash = GetHashKey("s_m_m_armoured_01"),
			weapon = GetHashKey("WEAPON_CARBINERIFLE"),
        },
    },
}
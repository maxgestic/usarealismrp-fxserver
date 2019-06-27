storeWeapons = {
  ["Melee"] = {
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 200, legality = "legal", quantity = 1, weight = 5, objectModel = "p_cs_police_torch_s" },
    { name = "Hammer", type = "weapon", hash = 1317494643, price = 50, legality = "legal", quantity = 1, weight = 5, objectModel = "prop_tool_hammer" },
    { name = "Knife", type = "weapon", hash = -1716189206, price = 200, legality = "legal", quantity = 1, weight = 3, objectModel = "w_me_knife_01" },
    { name = "Bat", type = "weapon", hash = -1786099057, price = 100, legality = "legal", quantity = 1, weight = 10, objectModel = "w_me_bat" },
    { name = "Crowbar", type = "weapon", hash = -2067956739, price = 150, legality = "legal", quantity = 1, weight = 10, objectModel = "w_me_crowbar" },
    { name = "Hatchet", type = "weapon", hash = -102973651, price = 250, legality = "legal", quantity = 1, weight = 8, objectModel = "w_me_hatchet" },
    { name = "Wrench", type = "weapon", hash = 419712736, price = 400, legality = "legal", quantity = 1, weight = 10, objectModel = "prop_tool_wrench" },
    { name = "Machete", type = "weapon", hash = -581044007, price = 250, legality = "legal", quantity = 1, weight = 7, objectModel = "prop_ld_w_me_machette" },
    { name = "Nightstick", type = "weapon", hash = 1737195953, price = 500, legality = "legal", quantity = 1, weight = 7, objectModel = "w_me_nightstick" }

  },
  ["Handguns"] = {
    { name = "Pistol", type = "weapon", hash = 453432689, price = 600, legality = "legal", quantity = 1, weight = 6, objectModel = "w_pi_pistol" },
    { name = "Heavy Pistol", type = "weapon", hash = -771403250, price = 1500, legality = "legal", quantity = 1, weight = 9, objectModel = "w_pi_heavypistol" },
    { name = ".50 Caliber", type = "weapon", hash = -1716589765, price = 2000, legality = "legal", quantity = 1, weight = 8, objectModel = "w_pi_pistol50" },
    { name = "SNS Pistol", type = "weapon", hash = -1076751822, price = 800, legality = "legal", quantity = 1, weight = 3, objectModel = "w_pi_sns_pistol" },
    { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 800, legality = "legal", quantity = 1, weight = 6, objectModel = "w_pi_combatpistol" },
    { name = "MK2", type = "weapon", hash = 3219281620, price = 1250, legality = "legal", quantity = 1, weight = 6 },
    { name = "Vintage Pistol", type = "weapon", hash = 137902532, price = 1250, legality = "legal", quantity = 1, weight = 9, objectModel = "w_pi_vintage_pistol" },
    --{ name = "Stun Gun", type = "weapon", hash = 911657153, price = 1500, legality = "legal", quantity = 1, weight = 5, objectModel = "w_pi_stungun" }
    --{ name = "Marksman Pistol", type = "weapon", hash = -598887786, price = 1000, legality = "legal", quantity = 1, weight = 15 }

  },
  ["Shotguns"] = {
    { name = "Pump Shotgun", type = "weapon", hash = 487013001, price = 4000, legality = "legal", quantity = 1, weight = 20, objectModel = "w_sg_pumpshotgun" },
    { name = "Bullpup Shotgun", type = "weapon", hash = -1654528753, price = 6000, legality = "legal", quantity = 1, weight = 25, objectModel = "w_sg_bullpupshotgun" },
    { name = "Musket", type = "weapon", hash = -1466123874, price = 1500, legality = "legal", quantity = 1, weight = 30, objectModel = "w_ar_musket" },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 10000, legality = "legal", quantity = 1, weight = 50, objectModel = "w_lr_firework" }
  },
  ["Extras"] = {
    { name = "Parachute", type = "weapon", hash = "GADGET_PARACHUTE", price = 500, legality = "legal", quantity = 1, weight = 20, objectModel = "prop_parachute" },
    { name = "Body Armor", type = "misc", price = 1000, legality = "legal", quantity = 1, weight = 20, objectModel = "prop_bodyarmour_03" }
  }
}

-- MAKE SURE YOU CHANGE THE sv_storeWeapons VARIABLE IN THE SERVER .LUA FILE SO PRICES MATCH!!!!!!!
-- Todo: make the prices load in from the server side so we don't have to update two files when a change needs to be made

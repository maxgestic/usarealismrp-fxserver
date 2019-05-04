storeWeapons = {
  ["Melee"] = {
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 200, legality = "legal", quantity = 1, weight = 5 },
    { name = "Hammer", type = "weapon", hash = 0x4E875F73, price = 50, legality = "legal", quantity = 1, weight = 5 },
    { name = "Knife", type = "weapon", hash = 0x99B507EA, price = 200, legality = "legal", quantity = 1, weight = 3 },
    { name = "Bat", type = "weapon", hash = 0x958A4A8F, price = 100, legality = "legal", quantity = 1, weight = 10 },
    { name = "Crowbar", type = "weapon", hash = -2067956739, price = 150, legality = "legal", quantity = 1, weight = 10 },
    { name = "Hatchet", type = "weapon", hash = -102973651, price = 250, legality = "legal", quantity = 1, weight = 8 },
    { name = "Wrench", type = "weapon", hash = 419712736, price = 400, legality = "legal", quantity = 1, weight = 10 },
    { name = "Machete", type = "weapon", hash = -581044007, price = 250, legality = "legal", quantity = 1, weight = 7 },
    { name = "Nightstick", type = "weapon", hash = 1737195953, price = 500, legality = "legal", quantity = 1, weight = 7}

  },
  ["Handguns"] = {
    { name = "Pistol", type = "weapon", hash = 0x1B06D571, price = 600, legality = "legal", quantity = 1, weight = 6 },
    { name = "Heavy Pistol", type = "weapon", hash = -771403250, price = 1500, legality = "legal", quantity = 1, weight = 9 },
    { name = ".50 Caliber", type = "weapon", hash = -1716589765, price = 2000, legality = "legal", quantity = 1, weight = 8 },
    { name = "SNS Pistol", type = "weapon", hash = -1076751822, price = 800, legality = "legal", quantity = 1, weight = 3 },
    { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 800, legality = "legal", quantity = 1, weight = 6 },
    { name = "Revolver", type = "weapon", hash = -1045183535, price = 1800, legality = "legal", quantity = 1, weight = 8 },
    { name = "MK2", type = "weapon", hash = 3219281620, price = 1250, legality = "legal", quantity = 1, weight = 6 },
    { name = "Vintage Pistol", type = "weapon", hash = 137902532, price = 1250, legality = "legal", quantity = 1, weight = 9 },
    { name = "Stun Gun", type = "weapon", hash = 911657153, price = 1500, legality = "legal", quantity = 1, weight = 5 }
    --{ name = "Marksman Pistol", type = "weapon", hash = -598887786, price = 1000, legality = "legal", quantity = 1, weight = 15 }

  },
  ["Shotguns"] = {
    { name = "Pump Shotgun", type = "weapon", hash = 0x1D073A89, price = 4000, legality = "legal", quantity = 1, weight = 20 },
    { name = "Bullpup", type = "weapon", hash = 0x9D61E50F, price = 6000, legality = "legal", quantity = 1, weight = 25 },
    { name = "Musket", type = "weapon", hash = -1466123874, price = 1500, legality = "legal", quantity = 1, weight = 30 },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 10000, legality = "legal", quantity = 1, weight = 50}
  },
  ["Extras"] = {
    { name = "Parachute", type = "weapon", hash = GetHashKey("GADGET_PARACHUTE"), price = 500, legality = "legal", quantity = 1, weight = 20 },
    { name = "Body Armor", type = "misc", price = 1000, legality = "legal", quantity = 1, weight = 20 }
  }
}

-- MAKE SURE YOU CHANGE THE sv_storeWeapons VARIABLE IN THE SERVER .LUA FILE SO PRICES MATCH!!!!!!!
-- Todo: make the prices load in from the server side so we don't have to update two files when a change needs to be made

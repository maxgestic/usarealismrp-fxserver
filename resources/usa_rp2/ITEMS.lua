local ITEMS = {
    { name = "Large Firework", type = "misc", price = 2000, legality = "legal", quantity = 5, weight = 15, objectModel = "ind_prop_firework_03" },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 5000, legality = "legal", quantity = 1, weight = 35, objectModel = "w_lr_firework" },
    { name = "Firework Projectile", legality = "legal", type = "ammo", price = 400, weight = 15, quantity = 1 },
    { name = "Vape", price = 400, type = "misc", quantity = 1, legality = "legal", weight = 3, objectModel = "ba_prop_battle_vape_01", blockedInPrison = true},
    { name = "Speaker", price = 5000, legality = "legal", quantity = 1, type = "misc", weight = 20, objectModel = "sm_prop_smug_speaker" },
    { name = "Katana", hash = GetHashKey("WEAPON_KATANAS"), type = "weapon", legality = "legal", price = 3000, weight = 10, quantity = 1, objectModel = "w_me_katana_lr"},
    { name = "Ninja Star", type = "weapon", hash = GetHashKey("WEAPON_NINJASTAR"), weight = 5.0, quantity = 1 },
	{ name = "Ninja Star 2", type = "weapon", hash = GetHashKey("WEAPON_NINJASTAR2"), weight = 5.0, quantity = 1 },
    { name = "Rock", type = "weapon", hash = GetHashKey("WEAPON_ROCK"), weight = 5.0, quantity = 1 },
    { name = "Bat", type = "weapon", hash = GetHashKey("WEAPON_BAT"), weight = 15.0, quantity = 1 },
    { name = "The Bleeder", price = 20, type = "food", substance = 60.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_burg1" },
    { name = "Heart Stopper", price = 40, type = "food", substance = 100.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_food_burg2" },
    { name = "Foot Long Dog", price = 25, type = "food", substance = 70.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_cs_hotdog_02" },
    { name = "Veggie Gasm Burger", price = 35, type = "food", substance = 85.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_food_burg2" },
    { name = "Torpedo Sandwich", price = 15, type = "food", substance = 55.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_sandwich_01" },
    {name = "Doughnuts", price = 10, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_donut_01"},
    {name = "Chicken Nuggets", price = 8, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_food_cb_nugets"},
    {name = "Fried Chicken Burger", price = 20, type = "food", substance = 40.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_cb_burg01"},
    {name = "Fries", price = 10, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_chips"},
    {name = "Curly Fries", price = 5, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_chips"},
    {name = "Pepsi", price = 15, type = "drink", substance = 75.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Orange Fanta", price = 15, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Dr Pepper", price = 15, type = "drink", substance = 70.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Smoothie Special", price = 40, type = "drink", substance = 100.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    { name = "Filet", type = "tradingCard", src = { front = 'usarrp-filet.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Queen", type = "tradingCard", src = { front = 'usarrp-queen.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Emma", type = "tradingCard", src = { front = 'usarrp-emma.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "The Joker", type = "tradingCard", src = { front = 'joker.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Narlee", type = "tradingCard", src = { front = 'narlee.png', back = 'backcard.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Red Eyes B. Dragon", type = "tradingCard", src = { front = 'red-eyes-black-dragon.jpg', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Dark Magician", type = "tradingCard", src = { front = 'dark-magician.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Blue Eyes White Dragon", type = "tradingCard", src = { front = 'blue-eyes-white-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Dark Magician Girl", type = "tradingCard", src = { front = 'dark-magician-girl.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Exodia Head", type = "tradingCard", src = { front = 'exodia.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Shooting Magestic Star Dragon", type = "tradingCard", src = { front = 'shooting-magestic-star-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Toon Blue Eyes Dragon", type = "tradingCard", src = { front = 'toon-blue-eye-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
}

for i = 1, #ITEMS do
    if ITEMS[i].type and ITEMS[i].type == "weapon" then
        ITEMS[i].notStackable = true
    end
end

exports("getItem", function(name)
    for i = 1, #ITEMS do
        if ITEMS[i].name == name then
            return json.decode(json.encode(ITEMS[i]))
        end
    end
end)

exports("getItemWithFieldVal", function(name, field, val)
    for i = 1, #ITEMS do
        if ITEMS[i].name == name then
            if ITEMS[i][field] and ITEMS[i][field] == val then
                return json.decode(json.encode(ITEMS[i]))
            end
        end
    end
end)

exports("getAllItemsByFieldVal", function(field, val)
    local ret = {}
    for i = 1, #ITEMS do
        if ITEMS[i][field] and ITEMS[i][field] == val then
            local itemCopy = json.decode(json.encode(ITEMS[i]))
            table.insert(ret, itemCopy)
        end
    end
    return ret
end)
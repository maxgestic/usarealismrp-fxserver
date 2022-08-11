local ITEMS = {
    { name = "Large Firework", type = "misc", price = 2000, legality = "legal", quantity = 5, weight = 15, objectModel = "ind_prop_firework_03" },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 5000, legality = "legal", quantity = 1, weight = 35, objectModel = "w_lr_firework" },
    { name = "Firework Projectile", legality = "legal", type = "ammo", price = 400, weight = 15, quantity = 1 },
    { name = "Vape", price = 400, type = "misc", quantity = 1, legality = "legal", weight = 3, objectModel = "ba_prop_battle_vape_01", blockedInPrison = true},
    { name = "Speaker", price = 5000, legality = "legal", quantity = 1, type = "misc", weight = 20, objectModel = "sm_prop_smug_speaker" },
    { name = "Katana", hash = GetHashKey("WEAPON_KATANAS"), type = "weapon", legality = "legal", price = 3000, weight = 10, quantity = 1, objectModel = "w_me_katana_lr"},
    { name = "Ninja Star", type = "weapon", hash = GetHashKey("WEAPON_NINJASTAR"), weight = 5.0, quantity = 1 },
	{ name = "Ninja Star 2", type = "weapon", hash = GetHashKey("WEAPON_NINJASTAR2"), weight = 5.0, quantity = 1 },
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
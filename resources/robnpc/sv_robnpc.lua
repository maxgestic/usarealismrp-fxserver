RegisterServerEvent("Mugging:GiveReward")

local items = {
    {name = 'Packaged Weed', type = 'drug', price = 150, legality = 'illegal', quantity = 1, weight = 2.0, objectModel = "bkr_prop_weed_bag_01a"},
    {name = "Packaged Meth", price = 500, type = "drug", quantity = 1, legality = "illegal", weight = 2.0, objectModel = "bkr_prop_meth_smallbag_01a"},
    {name = "Stolen Goods", price = math.random(50, 300), legality = "illegal", quantity = 1, type = "misc", weight = 2.0 },
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


AddEventHandler('Mugging:GiveReward', function(securityToken)
    if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
    local char = exports["usa-characters"]:GetCharacter(source)
    local reward = math.random(20,150)
    local PERCENT_CHANCE_ITEM = math.random()
    if PERCENT_CHANCE_ITEM <= 0.25 then
        local randomItem = items[math.random(#items)]
        if not char.canHoldItem(randomItem) then
            TriggerClientEvent("usa:notify", source, "Inventory full")
            return
        end
        char.giveItem(randomItem)
        TriggerClientEvent("usa:notify", source, "You stole a ".. randomItem.name)
    elseif PERCENT_CHANCE_ITEM >= 0.70 then
        TriggerClientEvent("usa:notify", source, "That person had nothing on them!")
    elseif PERCENT_CHANCE_ITEM > 0.25 and PERCENT_CHANCE_ITEM < 0.70 then
        char.giveMoney(reward)
        TriggerClientEvent("usa:notify", source, "You stole $".. reward)
    end

end)
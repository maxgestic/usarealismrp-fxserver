RegisterServerEvent("Mugging:GiveReward")

local items = {
    {name = 'Packaged Weed', type = 'drug', price = 150, legality = 'illegal', quantity = 1, weight = 2.0, objectModel = "bkr_prop_weed_bag_01a"},
	{name = "Packaged Meth", price = 500, type = "drug", quantity = 1, legality = "illegal", weight = 2.0, objectModel = "bkr_prop_meth_smallbag_01a"}
}


AddEventHandler('Mugging:GiveReward', function()
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
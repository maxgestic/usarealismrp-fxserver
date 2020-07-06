local common = {
    {name = "Aluminum", type = "misc", price = 100, legality = "legal", quantity = 1, weight = 5.0},
    {name = "Copper", type = "misc", price = 75, legality = "legal", quantity = 1, weight = 10.0},
    {name = "Iron", type = "misc", price = 125, legality = "legal", quantity = 1, weight = 15.0}
}

local rare = {
    {name = "Diamond", type = "misc", price = 600, legality = "legal", quantity = 1, weight = 25.0},
    {name = "Gold", type = "misc", price = 800, legality = "legal", quantity = 1, weight = 35.0},
}

RegisterServerEvent('mining:doesUserHaveCorrectItems')
AddEventHandler('mining:doesUserHaveCorrectItems', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem('Pick Axe') then
        TriggerClientEvent("mining:startMining", source)
    else
        TriggerClientEvent("usa:notify", source, "You do not have the sufficient tools to mine!")
    end
end)

RegisterServerEvent('mining:giveUserMiningGoods')
AddEventHandler('mining:giveUserMiningGoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local brokenPick = math.random()
    if brokenPick < 0.40 then
        local success = math.random()

        if success <= 0.50 then
            TriggerClientEvent("usa:notify", source, "You didn't find anything!")
        elseif success >= 0.60 then
            local commonItem = common[math.random(#common)]
            if char.canHoldItem(commonItem) then
                char.giveItem(commonItem)
                TriggerClientEvent("usa:notify", source, "You found (" .. commonItem.quantity .. "x) " .. commonItem.name)
            else
                TriggerClientEvent("usa:notify", source, "Inventory full")
            end
        elseif success > 0.50 and success < 0.60 then
            local rareItem = rare[math.random(#rare)]
            if char.canHoldItem(rareItem) then
                char.giveItem(rareItem)
                TriggerClientEvent("usa:notify", source, "You found (" .. rareItem.quantity .. "x) " .. rareItem.name)
            else
                TriggerClientEvent("usa:notify", source, "Inventory full")
            end
        end
    else
        char.removeItem("Pick Axe")
        TriggerClientEvent("usa:notify", source, "Your Pick Axe Broke!")
    end
end)

RegisterServerEvent('mining:sellMinedItems')
AddEventHandler('mining:sellMinedItems', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    for i = 1, #common do
        if char.hasItem(common[i]) then
            char.giveMoney(common[i].price)
            char.removeItem(common[i])
            TriggerClientEvent("usa:notify", source, "You Sold " .. common[i].name .. " for $" .. common[i].price)
        end
    end
    for j = 1, #rare do
        if char.hasItem(rare[j]) then
            char.giveMoney(rare[j].price)
            char.removeItem(rare[j])
            TriggerClientEvent("usa:notify", source, "You Sold " .. rare[j].name .. " for $" .. rare[j].price)
        end
    end
end)
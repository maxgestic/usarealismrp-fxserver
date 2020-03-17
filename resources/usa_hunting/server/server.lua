local REWARD_RANGES = {
    fur = {
        low = 100,
        high = 175
    },
    meat = {
        low = 85,
        high = 175
    }
}

RegisterServerEvent("hunting:skinforfurandmeat")
AddEventHandler("hunting:skinforfurandmeat", function(ped)
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
    local fur = {
        name = "Animal Fur",
        legality = "legal",
        quantity = 1,
        type = 'misc',
        weight = math.random(5, 20)
    }
    local meat = {
        name = "Butchered Meat",
        legality = "legal",
        quantity = math.random(1, 5),
        type = 'misc',
        weight = 5
    }
    if char.canHoldItem(fur) then
        char.giveItem(fur)
    else
        TriggerClientEvent('usa:notify', usource, 'Inventory is full!')
    end

    if char.canHoldItem(meat) then
        char.giveItem(meat)
    else
        TriggerClientEvent('usa:notify', usource, 'Inventory is full!')
    end

    TriggerClientEvent("hunting:skinforfurandmeat", source, ped)
end)

RegisterServerEvent("hunting:sellFur")
AddEventHandler("hunting:sellFur", function()
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
    if char.hasItem("Animal Fur") then
        char.removeItem("Animal Fur", 1)
        local reward = math.random(REWARD_RANGES.fur.low, REWARD_RANGES.fur.high)
        char.giveMoney(reward)
        TriggerClientEvent('usa:notify', usource, 'You have been paid $' .. reward)
    else
        TriggerClientEvent('usa:notify', usource, 'You do not have any fur for sale!')
    end
    TriggerClientEvent("hunting:sellFur", source)
end)

RegisterServerEvent("hunting:sellMeat")
AddEventHandler("hunting:sellMeat", function()
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
    if char.hasItem("Butchered Meat") then
        char.removeItem("Butchered Meat", 1)
        local reward = math.random(REWARD_RANGES.fur.low, REWARD_RANGES.fur.high)
        char.giveMoney(reward)
        TriggerClientEvent('usa:notify', usource, 'You have been paid $' .. reward)
    else
        TriggerClientEvent('usa:notify', usource, 'You do not have any meat to sell!')
    end

    TriggerClientEvent("hunting:sellMeat", source)
end)
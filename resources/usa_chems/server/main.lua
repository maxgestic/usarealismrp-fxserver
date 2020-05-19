local aluminum_price = 1500
local thermite = {
    name = "Thermite",
    legality = "illegal",
    quantity = 2,
    type = "misc",
    weight = 20
}

RegisterNetEvent('chems:buyAluminum')
AddEventHandler('chems:buyAluminum', function()
    local src = source
    local char = exports["usa-characters"]:GetCharacter(source)
    local cash = char.get('money')
    local powder = {
        name = "Aluminum Powder",
        legality = "legal",
        quantity = 1,
        type = "misc",
        weight = 4
    }
    if char.canHoldItem(powder) then
        if cash >= aluminum_price then
            char.removeMoney(aluminum_price)
            char.giveItem(powder)
            TriggerClientEvent("usa:notify", src, "You have purchased 1 bag of " .. powder.name)
        else
            TriggerClientEvent("usa:notify", src, 'You dont have enough money!')
        end
    else
        TriggerClientEvent("usa:notify", src, "Inventory is full!")
    end
end)

RegisterNetEvent('chems:checkForAllChems')
AddEventHandler('chems:checkForAllChems', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.canHoldItem(thermite) then
        if char.hasItem('Iron Oxide') and char.hasItem('Aluminum Powder') and char.hasItem('Ceramic Tubing') then
            char.removeItem('Iron Oxide', 1)
            char.removeItem('Aluminum Powder', 1)
            char.removeItem('Ceramic Tubing', 1)
            TriggerClientEvent('chems:performChemicalMixing', source)
        else
            TriggerClientEvent("usa:notify", source, 'You dot have all of the relevant materials')
            return
        end
    else
        TriggerClientEvent("usa:notify", source, 'Your inventory is full, free up some space!')
    end
end)

RegisterNetEvent('chems:successCheck')
AddEventHandler('chems:successCheck', function()
    local src = source
    local char = exports["usa-characters"]:GetCharacter(source)

    if char.canHoldItem(thermite) then
        char.giveItem(thermite)
        TriggerClientEvent("usa:notify", src, "You mixed it correctly and created " .. thermite.quantity .. "(x) " .. thermite.name)
    end
end)
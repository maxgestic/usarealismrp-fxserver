local thermite = {
    name = "Thermite",
    legality = "illegal",
    quantity = 2,
    type = "misc",
    weight = 20
}

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
            TriggerClientEvent("usa:notify", source, "You don't have all of the relevant materials")
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
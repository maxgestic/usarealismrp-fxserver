local robbable = true
local COPS_NEEDED_TO_ROB = 4
local STORE_ROBBERY_TIMEOUT = 10800000

-- Check if player has thermite to use
RegisterServerEvent('jewelleryheist:doesUserHaveThermiteToUse')
AddEventHandler('jewelleryheist:doesUserHaveThermiteToUse', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if robbable then
        if char.hasItem("Thermite") then
            char.removeItem('Thermite')
            TriggerClientEvent('jewelleryheist:doesUserHaveThermiteToUse', source, true)
            robbable = false;
            SetTimeout(STORE_ROBBERY_TIMEOUT, function()
                robbable = true
            end)
        else
            TriggerClientEvent('jewelleryheist:doesUserHaveThermiteToUse', source, false)
        end
    else
        TriggerClientEvent('usa:notify', 'You cannot commit a jewellery heist yet')
    end
end)

RegisterServerEvent('jewelleryheist:doesUserHaveGoodsToSell')
AddEventHandler('jewelleryheist:doesUserHaveGoodsToSell', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem("Stolen Goods") then
        TriggerClientEvent('jewelleryheist:doesUserHaveGoodsToSell', source, true)
    else
        TriggerClientEvent('jewelleryheist:doesUserHaveGoodsToSell', source, false)
    end
end)

RegisterServerEvent('jewelleryheist:sellstolengoods')
AddEventHandler('jewelleryheist:sellstolengoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local purchaseAmount = math.random(600, 1250)
    if char.hasItem("Stolen Goods") then
        char.removeItem("Stolen Goods", 1)
        char.giveMoney(purchaseAmount)
        TriggerClientEvent('usa:notify', source, 'You have been paid $'.. exports.globals:comma_value(purchaseAmount) ..'~s~.')
    end
end)


-- Use thermite to open the doors
RegisterServerEvent('jewelleryheist:stolengoods')
AddEventHandler('jewelleryheist:stolengoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local stolenGoods = {
        name = "Stolen Goods",
        legality = "illegal",
        quantity = math.random(0, 3),
        type = "misc",
        weight = 2
    }
    if char.canHoldItem(stolenGoods) then
        char.giveItem(stolenGoods)
        TriggerClientEvent("usa:notify", source, "You have taken (" .. stolenGoods.quantity .. ")x stolen goods.")
    else
        TriggerClientEvent("usa:notify", source, "Inventory is full!")
    end
end)

-- Payout stolen goods
RegisterServerEvent('jewelleryheist:thermite')
AddEventHandler('jewelleryheist:thermite', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem("Thermite") then
        char.removeItem("Thermite", 1)
    end
end)
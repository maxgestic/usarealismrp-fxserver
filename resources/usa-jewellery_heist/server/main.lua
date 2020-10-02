local COPS_NEEDED_TO_ROB = 4
local STORE_ROBBERY_TIMEOUT = 2 * 60 * 60 * 1000 -- 2 hour cooldown
local hasDoorBeenThermited = false -- prevent people from stealing Jewellery by emoting through the door and skipping thermite stage

local JewelleryCases = {
    {x = -628.0, y = -233.83, z = 38.06, robbed = false}, 
    {x = -626.86, y = -233.0, z = 38.06, robbed = false},
    {x = -624.66, y = -230.9, z = 38.06, robbed = false},
    {x = -624.12, y = -228.11, z = 38.06, robbed = false},
    {x = -624.88, y = -227.88, z = 38.06, robbed = false},
    {x = -623.84, y = -227.17, z = 38.06, robbed = false},
    {x = -620.47, y = -226.66, z = 38.06, robbed = false},
    {x = -619.66, y = -227.83, z = 38.06, robbed = false},
    {x = -618.31, y = -229.46, z = 38.06, robbed = false},
    {x = -617.68, y = -230.49, z = 38.06, robbed = false},
    {x = -619.51, y = -230.55, z = 38.06, robbed = false},
    {x = -619.19, y = -233.72, z = 38.06, robbed = false},
    {x = -620.28, y = -234.39, z = 38.06, robbed = false},
    {x = -620.06, y = -233.37, z = 38.06, robbed = false},
    {x = -623.05, y = -233.12, z = 38.06, robbed = false},
    {x = -625.63, y = -237.73, z = 38.06, robbed = false},
    {x = -626.65, y = -238.41, z = 38.06, robbed = false},
    {x = -625.9, y = -234.73, z = 38.06, robbed = false},
    {x = -626.83, y = -235.45, z = 3.06, robbed = false},
    {x = -621.14, y = -228.32, z = 38.06, robbed = false},
    {x = -626.92, y = -235.47, z = 38.06, robbed = false}
}

RegisterServerEvent("jewelleryheist:loadCases")
AddEventHandler("jewelleryheist:loadCases", function()
    TriggerClientEvent("jewelleryheist:loadCases", source, JewelleryCases)
end)

RegisterServerEvent('jewelleryheist:doesUserHaveThermiteToUse')
AddEventHandler('jewelleryheist:doesUserHaveThermiteToUse', function()
    local src = source
    local char = exports["usa-characters"]:GetCharacter(source)
    if not hasDoorBeenThermited then
        exports.globals:getNumCops(function(numCops)
            if numCops >= COPS_NEEDED_TO_ROB then
                if char.hasItem("Thermite") then
                    hasDoorBeenThermited = true
                    TriggerClientEvent("jewelleryheist:plantThermite", src)
                else
                    TriggerClientEvent("usa:notify", src, "You have no thermite!")
                end
            else 
                TriggerClientEvent('usa:notify', src, 'The electrical box looks damaged!')
            end
        end)
    else
        TriggerClientEvent('usa:notify', src, 'The electrical box is already busted!')
    end
end)

RegisterServerEvent('jewelleryheist:plantThermite')
AddEventHandler('jewelleryheist:plantThermite', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    char.removeItem('Thermite')
    TriggerClientEvent('doormanager:thermiteDoor', source)
    SetTimeout(STORE_ROBBERY_TIMEOUT + math.random(0, 45 * 60 * 1000), function()
        resetHeistState()
    end)
end)

RegisterServerEvent('jewelleryheist:doesUserHaveGoodsToSell')
AddEventHandler('jewelleryheist:doesUserHaveGoodsToSell', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem("Stolen Goods") then
        TriggerClientEvent('jewelleryheist:sellGoods', source)
    else
        TriggerClientEvent("usa:notify", source, "You have no stolen goods to sell!")
    end
end)

RegisterServerEvent('jewelleryheist:sellstolengoods')
AddEventHandler('jewelleryheist:sellstolengoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local purchaseAmount = math.random(700, 2000)
    if char.hasItem("Stolen Goods") then
        char.removeItem("Stolen Goods", 1)
        char.giveMoney(purchaseAmount)
        TriggerClientEvent('usa:notify', source, 'You have been paid $'.. exports.globals:comma_value(purchaseAmount) ..'~s~.')
    end
end)

RegisterServerEvent('jewelleryheist:stolengoods')
AddEventHandler('jewelleryheist:stolengoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local stolenGoods = {
        name = "Stolen Goods",
        legality = "illegal",
        quantity = math.random(1, 3),
        type = "misc",
        weight = 2
    }
    if char.canHoldItem(stolenGoods) then
        char.giveItem(stolenGoods)
        TriggerClientEvent("usa:notify", source, "You have taken " .. stolenGoods.quantity .. " stolen goods!")
    else
        TriggerClientEvent("usa:notify", source, "Inventory is full!")
    end
end)

RegisterServerEvent("jewelleryheist:attemptSmashNGrab")
AddEventHandler("jewelleryheist:attemptSmashNGrab", function(caseIndex)
    if hasDoorBeenThermited then
        if JewelleryCases[caseIndex].robbed then
            TriggerClientEvent("usa:notify", source, "That case has already been robbed!")
            return
        else 
            JewelleryCases[caseIndex].robbed = true
            TriggerClientEvent("jewelleryheist:performSmashNGrab", source)
            TriggerClientEvent("jewelleryheist:caseSmashed", -1, caseIndex)
        end
    end
end)

RegisterServerEvent("jewelleryheist:hasDoorBeenThermited")
AddEventHandler("jewelleryheist:hasDoorBeenThermited", function(cb)
    cb(hasDoorBeenThermited)
end)

function resetHeistState()
    hasDoorBeenThermited = false
    for i = 1, #JewelleryCases do
        JewelleryCases[i].robbed = false
    end
    TriggerEvent('doormanager:lockThermitableDoors')
    TriggerClientEvent("jewelleryheist:resetCases", -1)
end
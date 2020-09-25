local COPS_NEEDED_TO_ROB = 4
local FLEECA_COOLDOWN = 2 * 60 * 60 * 1000 -- 2hr cooldown base
local DRILL_PRICE = 1500

local drilling_spots = {
    -- Legion
    {x = 149.04, y = -1044.62, z = 29.35, drilled = false},
    {x = 150.2, y = -1045.12, z = 29.35, drilled = false},
    {x = 151.23, y = -1046.25, z = 29.35, drilled = false},
    {x = 150.2, y = -1045.12, z = 29.35, drilled = false},
    {x = 150.6, y = -1049.12, z = 29.35, drilled = false},
    {x = 150.01, y = -1050.45, z = 29.35, drilled = false},
    {x = 149.2, y = -1051.11, z = 29.35, drilled = false},
    {x = 148.01, y = -1050.59, z = 29.35, drilled = false},
    {x = 146.78, y = -1050.26, z = 29.35, drilled = false},
    {x = 146.56, y = -1049.14, z = 29.35, drilled = false},
    {x = 147.15, y = -1047.8, z = 29.35, drilled = false},
    -- Harmony
    {x = 1174.45, y = 2710.73, z = 38.07, drilled = false},
    {x = 1173.07, y = 2710.82, z = 38.07, drilled = false},
    {x = 1171.88, y = 2711.82, z = 38.07, drilled = false},
    {x = 1171.32, y = 2714.32, z = 38.07, drilled = false},
    {x = 1171.31, y = 2715.7, z = 38.07, drilled = false},
    {x = 1172.07, y = 2716.76, z = 38.07, drilled = false},
    {x = 1173.27, y = 2716.8, z = 38.07, drilled = false},
    {x = 1174.53, y = 2716.84, z = 38.07, drilled = false},
    {x = 1175.18, y = 2715.94, z = 38.07, drilled = false},
    {x = 1175.18, y = 2714.46, z = 38.07, drilled = false},
    -- Paleto
    {x = -106.63, y = 6473.1, z = 31.63, drilled = false},
    {x = -107.42, y = 6473.83, z = 31.63, drilled = false},
    {x = -107.81, y = 6475.41, z = 31.63, drilled = false},
    {x = -106.6, y = 6477.95, z = 31.63, drilled = false},
    {x = -105.8, y = 6478.52, z = 31.63, drilled = false},
    {x = -105.33, y = 6479.23, z = 31.63, drilled = false},
    {x = -104.42, y = 6479.44, z = 31.63, drilled = false},
    {x = -103.4, y = 6478.35, z = 31.63, drilled = false},
    {x = -102.4, y = 6477.41, z = 31.63, drilled = false},
    {x = -102.27, y = 6476.36, z = 31.63, drilled = false},
    {x = -103.3, y = 6475.23, z = 31.67, drilled = false},

}

local items = {
    {name = 'Packaged Weed', type = 'drug', price = 150, legality = 'illegal', quantity = 1, weight = 2.0, objectModel = "bkr_prop_weed_bag_01a"},
    {name = "Packaged Blue Meth", price = 500, type = "drug", quantity = 1, legality = "illegal", weight = 2.0, objectModel = "bkr_prop_meth_smallbag_01a"},
    {name = "Stolen Goods", price = math.random(50, 300), legality = "illegal", quantity = 1, type = "misc", weight = 2.0 },
    {name = "LSD Vial", price = 6, type = "drug", quantity = 1, legality = "illegal", weight = 5.0, objectModel = "prop_cs_pour_tube"},
    {name = 'Heavy Pistol', type = 'weapon', hash = -771403250, price = 4500, legality = 'illegal', quantity = 1, weight = 15, objectModel = "w_pi_heavypistol"},
    {name = 'Advanced Pick', type = 'illegal', price = 800, legality = 'illegal', quantity = 1, weight = 7.0},
}

RegisterServerEvent('fleeca:loadDrillingSpots')
AddEventHandler('fleeca:loadDrillingSpots', function()
    TriggerClientEvent('fleeca:loadDrillingSpots', source, drilling_spots)
end)

RegisterServerEvent('fleeca:doesUserHaveDrill')
AddEventHandler('fleeca:doesUserHaveDrill', function(box)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(source)
    exports.globals:getNumCops(function(numCops)
        if numCops >= COPS_NEEDED_TO_ROB then
            if char.hasItem('Drill') then
                attemptDrilling(box, src)
            else
                TriggerClientEvent("usa:notify", src, 'How can you drill locks with no drill?!')
            end
        else
            TriggerClientEvent("usa:notify", src, 'Drill battery is flat! Try again later!')
        end
    end)
end)

function attemptDrilling(depositBox, source)
    if drilling_spots[depositBox].drilled then
        TriggerClientEvent("usa:notify", source, "This box has already been drilled")
    else
        drilling_spots[depositBox].drilled =  true
        TriggerClientEvent('fleeca:startDrilling', source)
        SetTimeout(FLEECA_COOLDOWN + math.random(0, 1 * 60 * 60 * 1000), function() -- randomise
            resetFleeca(source)
        end)
    end
end

RegisterServerEvent('fleeca:drilledGoods')
AddEventHandler('fleeca:drilledGoods', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local payout = math.random()
    local cash = math.random(300, 3100)

    if payout <= 0.20 then
        local randomItem = items[math.random(#items)]
        if char.canHoldItem(randomItem) then
            char.giveItem(randomItem)
            TriggerClientEvent("usa:notify", source, "You stole ".. randomItem.name)
        else
            TriggerClientEvent("usa:notify", source, "Inventory is full!")
        end
    else
        char.giveMoney(cash)
        TriggerClientEvent("usa:notify", source, "You stole $".. cash .. ' from the deposit box!')
    end
end)

RegisterServerEvent('fleeca:purchaseDrill')
AddEventHandler('fleeca:purchaseDrill', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local cash = char.get('money')
    local drill = {
        name = "Drill",
        legality = "legal",
        quantity = 1,
        type = "misc",
        weight = 10,
        objectModel = "hei_prop_heist_drill"
    }

    if char.canHoldItem(drill) then
        if cash >= DRILL_PRICE then
            char.giveItem(drill)
            char.removeMoney(DRILL_PRICE)
            TriggerClientEvent("usa:notify", source, "You have purchased a " .. drill.name)
        else
            TriggerClientEvent("usa:notify", source, "You do not have enough cash!")
        end
    else
        TriggerClientEvent("usa:notify", source, 'Inventory full!')
    end

end)

function resetFleeca(src)
    for i = 1, #drilling_spots do
        if drilling_spots[i].drilled then
            drilling_spots[i].drilled = false
        end
    end
    TriggerClientEvent('fleeca:reset911', src)
end
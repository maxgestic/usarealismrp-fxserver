RegisterServerEvent("doormanager:s_openDoor")
AddEventHandler("doormanager:s_openDoor", function(doorId)
    -- Source
    local src = source
    -- Get the status of the door
    local isDoorLocked = GetDoorStatus(doorId)

    if (isDoorLocked == 1) then
        if (playerJob == "cop" ) then
            -- Client Event to open door
            TriggerClientEvent("doormanager:c_openDoor", -1, doorId)
            -- Update door status in DB
            SetDoorStatus(doorId, 0)
        else

        end
    end
end)

-- Check if player has thermite to use
RegisterServerEvent('jewelleryheist:doesUserHaveThermiteToUse')
AddEventHandler('jewelleryheist:doesUserHaveThermiteToUse', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local thermite = {
        name = "Thermite",
        legality = "illegal",
        quantity = math.random(0, 2),
        type = "misc",
        weight = 2
    }

    char.giveItem(thermite)
    if char.hasItem("Thermite") then
        TriggerClientEvent('jewelleryheist:doesUserHaveThermiteToUse', source, true)
    else
        TriggerClientEvent('jewelleryheist:doesUserHaveThermiteToUse', source, false)
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
        quantity = math.random(0, 2),
        type = "misc",
        weight = 2
    }
    if char.canHoldItem(stolenGoods) then
        char.giveItem(stolenGoods)
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
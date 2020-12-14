exports["globals"]:PerformDBCheck("usa-burger_shot", "burgershot")

local ENABLE_CRIMINAL_HISTORY_CHECK = false

local fine = 3000

local ITEMS = {
    ["Burgers"] = {
        {name = "Cheeseburger", price = 20, type = "food", substance = 60.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_burg1"},
        {name = "Big Whopper", price = 40, type = "food", substance = 100.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_food_burg2"},
        {name = "Foot Long Dog", price = 25, type = "food", substance = 70.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_cs_hotdog_02"},
        {name = "Veggie Gasm Burger", price = 35, type = "food", substance = 85.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_food_burg2"},
        {name = "Torpedo Sandwich", price = 15, type = "food", substance = 55.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_sandwich_01"},
    },
    ["Fry"] = {
        {name = "Doughnuts", price = 10, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_donut_01"},
        {name = "Chicken Nuggets", price = 8, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 3, objectModel = "prop_food_cb_nugets"},
        {name = "Fried Chicken Burger", price = 20, type = "food", substance = 40.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_cb_burg01"},
        {name = "Fries", price = 10, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_chips"},
        {name = "Curly Fries", price = 5, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_chips"}
    },
    ["Soda"] = {
        {name = "Pepsi", price = 15, type = "drink", substance = 75.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
        {name = "Orange Fanta", price = 15, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
        {name = "Dr Pepper", price = 15, type = "drink", substance = 70.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
        {name = "Smoothie Special", price = 40, type = "drink", substance = 100.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    }
}

RegisterServerEvent("burgerjob:loadItems")
AddEventHandler("burgerjob:loadItems", function()
    TriggerClientEvent("burgerjob:loadItems", source, ITEMS)
end)

RegisterServerEvent("burgerjob:startJob")
AddEventHandler("burgerjob:startJob", function(location)
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
        if char.get("job") == 'civ' then
            char.set("job", "BurgerShotEmployee")
            TriggerClientEvent("burgerjob:startJob", usource, location)
        end
end)

RegisterServerEvent("burgerjob:quitJob")
AddEventHandler("burgerjob:quitJob", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.get("job") == 'BurgerShotEmployee' then
        char.set("job", "civ")
        TriggerClientEvent("burgerjob:quitJob", source)
    end
end)

function checkStrikes(char, src)
    BurgerHelper.getStrikes(char.get("_id"), function(strikes)
        TriggerClientEvent('burgerjob:checkStrikes', src, strikes)
    end)
end

RegisterServerEvent("burgerjob:checkCriminalHistory")
AddEventHandler("burgerjob:checkCriminalHistory", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if ENABLE_CRIMINAL_HISTORY_CHECK then
        local criminal_history = char.get("criminalHistory")
        if #criminal_history > 0 then
            for i = 1, #criminal_history do
                if hasCriminalRecord(criminal_history[i].charges) then
                    TriggerClientEvent("usa:notify", source, "Unfortunately you have a pretty serious criminal background therefore, we are unable to hire you.")
                    return
                end
            end
        end
    end
    checkStrikes(char, source)
end)

RegisterServerEvent("burgerjob:addStrike")
AddEventHandler("burgerjob:addStrike", function()
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
    local ident = char.get("_id")
    BurgerHelper.addStrike(ident, "strikes", function(updatedVal)
        TriggerClientEvent("usa:notify", usource, "You have " .. updatedVal .. " strike(s)!")
    end)
end)


TriggerEvent('es:addCommand', 'paybsfine', function(source, args, char)
    local usource = source
    local char = exports["usa-characters"]:GetCharacter(usource)
    local ident = char.get("_id")
    if char.get('money') >= fine then
        char.removeMoney(fine)
        BurgerHelper.clearStrikes(ident, 'strikes', function()
            TriggerClientEvent('usa:notify', usource, 'Your strikes have been cleared. Don\'t let me down and make the same mistake again!')
        end)
    else
        TriggerClientEvent('usa:notify', usource, 'You do not have the funds!')
    end
end, {
    help = "Pay off your strikes so you can work at Burger Shot again.",
})

RegisterServerEvent("burgerjob:removecashforingredients")
AddEventHandler("burgerjob:removecashforingredients", function(category, index)
    local item = ITEMS[category][index]
    local char = exports["usa-characters"]:GetCharacter(source)
    local money = char.get("money")
    if money >= item.price then
        if char.canHoldItem(item) then
            char.removeMoney(item.price)
            char.giveItem(item)
        else
            TriggerClientEvent("usa:notify", source, "Inventory full!")
        end
    else
        TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
end)

RegisterServerEvent("burgerjob:forceRemoveJob")
AddEventHandler("burgerjob:forceRemoveJob", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    char.set("job", "civ")
    TriggerClientEvent("burgerjob:quitJob", source)
end)

function hasCriminalRecord(charges)
    local numbers = {
        '187', '192', '206', '207', '211', '245', '459', '600', '646.9', '16590', '18720', '29800', '30605', '33410', '2331', '2800.2', '2800.3', '2800.4', '51-50', '5150'
    }

    if charges then
        for _, code in pairs(numbers) do
            if string.find(charges, code) then
                return true
            end
        end
        return false
    end
end
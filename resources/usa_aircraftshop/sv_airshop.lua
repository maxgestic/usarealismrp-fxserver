local ITEMS = {
    helicopters = {
        ["Havok"] = { name = "Havok", hash = "havok", price = 65000},
        ["Frogger"] = { name = "Frogger", hash = "frogger", price = 75000},
        ["Supervolito"] = { name = "Supervolito", hash = "supervolito", price = 75000},
        ["Swift"] = { name = "Swift", hash = "swift", price = 85000},
        ["Swift 2"] = { name = "Swift 2", hash = "swift2", price = 90000}
    },
    planes = {
        ["Cuban 800"] = { name = "Cuban 800", hash = "cuban800", price = 70000},
        ["Dodo"] = { name = "Dodo", hash = "dodo", price = 85000},
        ["Duster"] = { name = "Duster", hash = "duster", price = 50000},
        ["Mammatus"] = { name = "Mammatus", hash = "mammatus", price = 80000},
        ["Stunt"] = { name = "Stunt", hash = "stunt", price = 85000},
        ["Microlight"] = { name = "Microlight", hash = "microlight", price = 45000},
        ["Alpha Z1"] = { name = "Alpha Z!", hash = "alphaz1", price = 110000},
        ["Seabreeze"] = { name = "Seabreeze", hash = "seabreeze", price = 100000},
        ["Velum"] = { name = "Velum", hash = "velum", price = 85000},
        ["Vestra"] = { name = "Vestra", hash = "vestra", price = 150000},
        ["Nimbus"] = { name = "Nimbus", hash = "nimbus", price = 150000},
        ["Shamal"] = { name = "Shamal", hash = "shamal", price = 150000},
        ["Luxor"] = { name = "Luxor", hash = "luxor", price = 150000},
        ["Luxor 2"] = { name = "Luxor 2", hash = "luxor2", price = 155000}
    }
}

local LICENSE_PURCHASE_PRICE = 5000

local RENTAL_PERCENTAGE = 0.40
local CLAIM_PERCENTAGE = 0.30

RegisterServerEvent('aircraft:requestOpenMenu')
AddEventHandler('aircraft:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local license = char.getItem("Aircraft License")
  if license and license.status == "valid" then
    TriggerClientEvent('aircraft:openMenu', source, (char.get("aircraft") or {}))
  else
    TriggerClientEvent('usa:notify', source, 'No license! Hold E to purchase one for $' .. exports["globals"]:comma_value(LICENSE_PURCHASE_PRICE))
  end
end)

RegisterServerEvent('aircraft:loadItems')
AddEventHandler('aircraft:loadItems', function()
    TriggerClientEvent("aircraft:loadItems", source, ITEMS)
end)

-- # note: plate == first 8 digits of aircraft.id
RegisterServerEvent('aircraft:requestReturn')
AddEventHandler('aircraft:requestReturn', function(plate)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = char.get("aircraft")
    for i = 1, #aircraft do 
        if tostring(aircraft[i].id):sub(1, 8) == plate then
            aircraft[i].stored = true
            char.set("aircraft", aircraft)
            TriggerClientEvent("usa:notify", source, "Aircraft returned!")
            return
        end
    end
end)

RegisterServerEvent('aircraft:requestRent')
AddEventHandler('aircraft:requestRent', function(category, name, business)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = ITEMS[category][name]
    if char.get("money") >= aircraft.price then 
        char.removeMoney(RENTAL_PERCENTAGE * aircraft.price)
        if business then
            exports["usa-businesses"]:GiveBusinessCashPercent(business, RENTAL_PERCENTAGE * aircraft.price)
        end
        TriggerClientEvent("aircraft:spawn", source, aircraft.hash)
    else 
        TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
end)

RegisterServerEvent('aircraft:requestPurchase')
AddEventHandler('aircraft:requestPurchase', function(category, name, business)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = ITEMS[category][name]
    if char.get("money") >= aircraft.price then 
        char.removeMoney(aircraft.price)
        if business then 
            exports["usa-businesses"]:GiveBusinessCashPercent(business, aircraft.price)
        end
        local charAircraft = char.get("aircraft")
        aircraft.id = math.random(99999999)
        aircraft.stored = false
        table.insert(charAircraft, aircraft)
        char.set("aircraft", charAircraft)
        TriggerClientEvent("aircraft:spawn", source, aircraft.hash, aircraft.id)
    else 
        TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
end)

RegisterServerEvent('aircraft:requestSell')
AddEventHandler('aircraft:requestSell', function(id)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = char.get("aircraft")
    for i = 1, #aircraft do
        if aircraft[i].id == id then
            char.giveMoney(0.50*aircraft[i].price)
            TriggerClientEvent("usa:notify", source, aircraft[i].name .. " sold for $" .. exports.globals:comma_value(0.50*aircraft[i].price))
            table.remove(aircraft, i)
            char.set("aircraft", aircraft)
            return
        end
    end
end)

RegisterServerEvent('aircraft:requestRetrieval')
AddEventHandler('aircraft:requestRetrieval', function(id)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = char.get("aircraft")
    for i = 1, #aircraft do
        if aircraft[i].id == id then
            if aircraft[i].stored then
                aircraft[i].stored = false
                char.set("aircraft", aircraft)
                TriggerClientEvent("aircraft:spawn", source, aircraft[i].hash, aircraft[i].id)
            else 
                TriggerClientEvent("usa:notify", source, "Not stored!")
            end
            return
        end
    end
end)

RegisterServerEvent('aircraft:claim')
AddEventHandler('aircraft:claim', function(id)
    local char = exports["usa-characters"]:GetCharacter(source)
    local aircraft = char.get("aircraft")
    for i = 1, #aircraft do
        if aircraft[i].id == id then
            local fee = CLAIM_PERCENTAGE * aircraft[i].price
            if char.get("money") >= fee then
                char.removeMoney(fee)
                aircraft[i].stored = true
                char.set("aircraft", aircraft)
                TriggerClientEvent("usa:notify", source, aircraft[i].name .. " claimed for $" .. exports.globals:comma_value(fee))
            else
                TriggerClientEvent("usa:notify", source, "Not enough money!")
            end
            return
        end
    end
end)
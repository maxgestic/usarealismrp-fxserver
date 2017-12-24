local prices = {
  boats = {
    ["Nagasaki Dinghy"] = 15000,
    ["Nagasaki Dinghy 2"] = 15000,
    ["Dinka Marquis"] = 25000,
    ["Speedophile Seashark"] = 8000,
    ["Cuban Jetmax"] = 35000,
    ["Lampadati Toro"] = 40000,
    ["Lampadati Toro 2"] = 40000,
    ["Tug"] = 50000,
    ["Shitzu Squalo"] = 30000,
    ["Shitzu Tropic"] = 30000,
    ["Shitzu Suntrap"] = 20000,
    ["Submersible"] = 100000,
    ["Submersible 2"] = 100000
  }
}

RegisterServerEvent("boatshop:rentVehicle")
AddEventHandler("boatshop:rentVehicle", function(vehicle, coords)
    print("vehicle.name = " .. vehicle.name)
    print("vehicle.price = " .. vehicle.price)
    print("vehicle.hash = " .. vehicle.hash)
    local price = prices.boats[vehicle.name]
    print("rental boat price = $" .. price)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                user.setActiveCharacterData("money", user_money - price)
                print("calling spawnAircraft")
                TriggerClientEvent("boatshop:spawnSeacraft", userSource, vehicle.hash, coords)
            else
                print("player did not have enough money")
            end
        end
    end)
end)

RegisterServerEvent("boatshop:returnedVehicle")
AddEventHandler("boatshop:returnedVehicle", function(item)
    local userSource = tonumber(source)
    local price = prices.boats[item.name]
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local returnAmount = .25*price
        local rounded = round(returnAmount, 0)
        local user_money = user.getActiveCharacterData("money")
        user.setActiveCharacterData("money", user_money + rounded)
    end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

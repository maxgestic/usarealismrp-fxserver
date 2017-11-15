RegisterServerEvent("boatshop:rentVehicle")
AddEventHandler("boatshop:rentVehicle", function(vehicle)
    print("vehicle.name = " .. vehicle.name)
    print("vehicle.price = " .. vehicle.price)
    print("vehicle.hash = " .. vehicle.hash)
    local price = vehicle.price
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        print("inside of get player from id")
        if user then
            print("user existed")
            local user_money = user.getActiveCharacterData("money")
            if user_money >= price then
                user.setActiveCharacterData("money", user_money - price)
                print("calling spawnAircraft")
                TriggerClientEvent("boatshop:spawnSeacraft", userSource, vehicle.hash)
            else
                print("player did not have enough money")
            end
        end
    end)
end)

RegisterServerEvent("boatshop:returnedVehicle")
AddEventHandler("boatshop:returnedVehicle", function(item)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local returnAmount = .25*item.price
        local rounded = round(returnAmount, 0)
        local user_money = user.getActiveCharacterData("money")
        user.setActiveCharacterData("money", user_money + rounded)
    end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

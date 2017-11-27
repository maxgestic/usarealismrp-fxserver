RegisterServerEvent("airshop:rentVehicle")
AddEventHandler("airshop:rentVehicle", function(vehicle)
    print("vehicle.name = " .. vehicle.name)
    print("vehicle.price = " .. vehicle.price)
    print("vehicle.hash = " .. vehicle.hash)
    local price = vehicle.price
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        print("inside of get player from id")
        if user then
            local user_money = user.getActiveCharacterData("money")
            print("user existed")
            if user_money >= price then
                local new_money = user_money - price
                user.setActiveCharacterData("money", new_money)
                print("calling spawnAircraft")
                TriggerClientEvent("airshop:spawnAircraft", userSource, vehicle.hash)
            else
                print("player did not have enough money")
            end
        end
    end)
end)

RegisterServerEvent("airshop:returnedVehicle")
AddEventHandler("airshop:returnedVehicle", function(item)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_money = user.getActiveCharacterData("money")
        local returnAmount = .25*item.price
        local rounded = round(returnAmount, 0)
        local new_money = user_money + rounded
        user.setActiveCharacterData("money", new_money)
    end)
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

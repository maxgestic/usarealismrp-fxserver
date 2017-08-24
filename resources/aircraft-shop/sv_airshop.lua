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
            print("user existed")
            if user.getMoney() >= price then
                user.removeMoney(price)
                print("calling spawnAircraft")
                TriggerClientEvent("airshop:spawnAircraft", userSource, vehicle.hash)
            else
                print("player did not have enough money")
            end
        end
    end)
end)

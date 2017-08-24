RegisterServerEvent("airshop:rentVehicle")
AddEventHandler("airshop:rentVehicle", function(vehicle)
    local price = vehicle.price
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            if user.getMoney() >= price then
                user.removeMoney(price)
                TriggerClientEvent("airshop:spawnAircraft", userSource, vehicle.hash)
            end
        end
    end)
end)

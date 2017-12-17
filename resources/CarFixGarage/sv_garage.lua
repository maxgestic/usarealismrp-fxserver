local repair_price = 325

RegisterServerEvent("carFix:checkPlayerMoney")
AddEventHandler("carFix:checkPlayerMoney", function()
    print("insde carfix:checkPlayerMoney!!")
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_money = user.getActiveCharacterData("money")
        if user_money >= repair_price then
            print("player had enough money!")
            user.setActiveCharacterData("money", user_money - repair_price)
            TriggerClientEvent("carFix:repairVehicle", userSource)
        else
            TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to repair you vehicle! Cost: $" .. repair_price)
        end
    end)
end)

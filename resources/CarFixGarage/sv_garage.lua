RegisterServerEvent("carFix:checkPlayerMoney")
AddEventHandler("carFix:checkPlayerMoney", function(engineHealth, bodyHealth)
    print("insde carfix:checkPlayerMoney!!")
    print("body health = " .. bodyHealth)
    print("engine health = " .. engineHealth)
    local userSource = tonumber(source)
    local repair_price = 325
    local engine_diff, body_diff = 0.0, 0.0
    engine_diff = 1000.0 - engineHealth
    body_diff = 1000.0 - bodyHealth
    local added_cost = 9 * (body_diff + engine_diff)
    repair_price = repair_price + added_cost
    print("final repair cost after damages: $" .. repair_price)
    if repair_price > 325 then
      TriggerEvent("es:getPlayerFromId", userSource, function(user)
          local user_money = user.getActiveCharacterData("money")
          local user_job = user.getActiveCharacterData("job")
          if user_job == "sheriff" or user_job == "ems" or user_job == "fire" then
            print("repairing emergency vehicle!")
            TriggerClientEvent("carFix:repairVehicle", userSource)
          elseif user_money >= repair_price and user_job ~= "sheriff" and user_job ~= "ems" or user_job ~= "fire" then
              print("player had enough money!")
              user.setActiveCharacterData("money", user_money - round(repair_price, 0))
              TriggerClientEvent("carFix:repairVehicle", userSource)
          else
              TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to repair your vehicle! Cost: $" .. repair_price)
          end
      end)
    else
      TriggerClientEvent("usa:notify", userSource, "Your vehicle does not need any repairs!")
    end
end)

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

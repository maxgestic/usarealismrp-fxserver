RegisterServerEvent("carFix:checkPlayerMoney")
AddEventHandler("carFix:checkPlayerMoney", function(engineHealth, bodyHealth)
  --print("insde carfix:checkPlayerMoney!!")
  --print("body health = " .. bodyHealth)
  --print("engine health = " .. engineHealth)
  local userSource = tonumber(source)
  --if not engineHealth then engineHealth = 0.0 end
  --if not bodyHealth then bodyHealth = 0.0 end
  local repair_price = 825
  --local engine_diff, body_diff = 0.0, 0.0
  --engine_diff = 1000.0 - engineHealth
  --  body_diff = 1000.0 - bodyHealth
  --local added_cost = 8 * (body_diff + engine_diff)
  --repair_price = repair_price + added_cost
  --if engineHealth < 1000.0 or bodyHealth < 1000.0 then
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_money = user.getActiveCharacterData("money")
    local user_job = user.getActiveCharacterData("job")
    if user_job == "sheriff" or user_job == "ems" or user_job == "fire" then
      --print("repairing emergency vehicle!")
      TriggerClientEvent("carFix:repairVehicle", userSource)
    elseif user_money >= repair_price and user_job ~= "sheriff" and user_job ~= "ems" or user_job ~= "fire" then
      --print("final repair cost after damages: $" .. repair_price)
      --print("player had enough money!")
      --if not repair_price then print("error: no repair_price!") repair_price = 325 end
      if not user_money then print("error: no user-money!") end
      user.setActiveCharacterData("money", user_money - repair_price)
      TriggerClientEvent("carFix:repairVehicle", userSource)
    else
      TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to repair your vehicle! Cost: $" .. repair_price)
    end
  end)
  --else
  --  TriggerClientEvent("usa:notify", userSource, "Your vehicle does not need any repairs!")
  --end
end)

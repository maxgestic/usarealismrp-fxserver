RegisterServerEvent("carFix:checkPlayerMoney")
AddEventHandler("carFix:checkPlayerMoney", function(engineHealth, bodyHealth)
  local userSource = tonumber(source)
  local repair_price = 825
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_money = user.getActiveCharacterData("money")
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "ems" or user_job == "fire" then
    TriggerClientEvent("carFix:repairVehicle", userSource)
  elseif user_money >= repair_price and user_job ~= "sheriff" and user_job ~= "ems" and user_job ~= "fire" then
    if not user_money then print("error: no user-money!") end
    user.setActiveCharacterData("money", user_money - repair_price)
    TriggerClientEvent("carFix:repairVehicle", userSource)
  else
    TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to repair your vehicle! Cost: $" .. repair_price)
  end
end)

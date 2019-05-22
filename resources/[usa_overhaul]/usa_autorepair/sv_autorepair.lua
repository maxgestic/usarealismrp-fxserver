local REPAIR_COST = 300

RegisterServerEvent("autoRepair:checkMoney")
AddEventHandler("autoRepair:checkMoney", function()
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_money = user.getActiveCharacterData("money")
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "ems" or user_job == "fire" or user_job == "dai" then
    TriggerClientEvent("autoRepair:repairVehicle", userSource)
  else
    if user_money - REPAIR_COST >= 0 then
      user.setActiveCharacterData("money", user_money - REPAIR_COST)
      TriggerClientEvent("autoRepair:repairVehicle", userSource)
    else
      TriggerClientEvent("usa:notify", userSource, '~y~You cannot afford this purchase.')
    end
  end
end)

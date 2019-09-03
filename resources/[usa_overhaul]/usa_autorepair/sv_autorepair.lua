local REPAIR_COST = 300

RegisterServerEvent("autoRepair:checkMoney")
AddEventHandler("autoRepair:checkMoney", function(business)
  local char = exports["usa-characters"]:GetCharacter(source)
  local job = char.get("job")
  if job == "sheriff" or job == "ems" or job == "fire" or job == "dai" then
    TriggerClientEvent("autoRepair:repairVehicle", source)
  else
    if char.get("money") - REPAIR_COST >= 0 then
      char.removeMoney(REPAIR_COST)
      TriggerClientEvent("autoRepair:repairVehicle", source)
    else
      TriggerClientEvent("usa:notify", source, 'You cannot afford this purchase!')
    end
  end
  if business then
    exports["usa-businesses"]:GiveBusinessCashPercent(business, REPAIR_COST)
  end
end)

-- TODO: dynamic-afy the repair cost to use engine and body health from client
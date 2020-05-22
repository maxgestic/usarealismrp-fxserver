local items = {
  {name = 'Advanced Pick', type = 'illegal', price = 800, legality = 'illegal', quantity = 1, weight = 7.0},
  {name = "Iron Oxide", legality = "legal", quantity = 1, type = "misc", weight = 8, price = 950}
}

RegisterServerEvent("chopshop:reward")
AddEventHandler("chopshop:reward", function(veh_name, damage, property)
  local char = exports["usa-characters"]:GetCharacter(source)
  local reward = math.random(200, 900)
  local payout = math.random()
  local numTroopers = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
  if numTroopers == 0 then
    damage = math.ceil(0.10 * damage)
    reward = math.ceil(0.20 * reward) -- only give 20% of regular reward if no cops
  end

  if payout <= 0.04 then
    local randomItem = items[math.random(#items)]
    if char.canHoldItem(randomItem) then
      char.giveItem(randomItem)
      TriggerClientEvent("usa:notify", source, "Thanks for your help! We dont have any cash right now so take this instead " .. randomItem.name)
    else
      TriggerClientEvent("usa:notify", source, "Inventory full!")
    end
  else
    local finalReward = math.max(reward - damage, 0)
    char.giveMoney(finalReward)
    TriggerClientEvent("usa:notify", source, "Thanks! Here is $" .. finalReward .. "!", "^0Thanks! Here is $" .. finalReward .. "!")
  end
end)
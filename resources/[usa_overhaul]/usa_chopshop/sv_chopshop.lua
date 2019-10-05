RegisterServerEvent("chopshop:reward")
AddEventHandler("chopshop:reward", function(veh_name, damage, property)
  local char = exports["usa-characters"]:GetCharacter(source)
  local reward = math.random(200, 1500)
  local numTroopers = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
  if numTroopers == 0 then
    damage = math.ceil(0.10 * damage)
    reward = math.ceil(0.20 * reward) -- only give 20% of regular reward if no cops
  end
  char.giveMoney(reward - damage)
  print("damage was: " .. damage)
  TriggerClientEvent("usa:notify", source, "Thanks! Here is $" .. reward - damage .. "!", "^0Thanks! Here is $" .. reward - damage .. "!")
end)
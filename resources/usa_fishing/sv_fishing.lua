local fishItems = {
  {name = "Trout", quantity = 1, worth = 85, type = "fish", weight = math.random(1, 6), legality = "legal"},
  {name = "Flounder", quantity = 1, worth = 110, type = "fish", weight = math.random(2, 7), legality = "legal"},
  {name = "Halibut", quantity = 1, worth = 125, type = "fish", weight = math.random(3, 8), legality = "legal"}
}

RegisterServerEvent("fish:giveFish")
AddEventHandler("fish:giveFish", function(fish)
  local fish = fishItems[fish]
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.canHoldItem(fish) then
    char.giveItem(fish, 1)
  else
    TriggerClientEvent("usa:notify", source, "Inventory is full!")
  end
end)

RegisterServerEvent("fish:sellFish")
AddEventHandler("fish:sellFish", function(fish)
  local fish = fishItems[fish]
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem(fish) then
    char.removeItem(fish, 1)
    char.giveMoney(fish.worth)
    TriggerClientEvent("usa:notify", source, "You have sold (1x) " .. fish.name .. " for $" .. fish.worth)
  else
    TriggerClientEvent("usa:notify", source, "You have no fish to sell!")
  end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

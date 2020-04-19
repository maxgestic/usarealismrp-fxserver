local fishItems = {
  {name = "Trout", quantity = 1, worth = 65, type = "fish", weight = 5, legality = "legal"},
  {name = "Flounder", quantity = 1, worth = 90, type = "fish", weight = 5, legality = "legal"},
  {name = "Halibut", quantity = 1, worth = 105, type = "fish", weight = 5, legality = "legal"}
}

local seaFishItems = {
  {name = "Yellowfin Tuna", quantity = 1, worth = 300, type = "seafish", weight = 10, legality = "legal"},
  {name = "Swordfish", quantity = 1, worth = 400, type = "seafish", weight = 15, legality = "legal"}
}

RegisterServerEvent("fish:giveFish")
AddEventHandler("fish:giveFish", function()
  local fish = fishItems[math.random(#fishItems)]
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.canHoldItem(fish) then
    char.giveItem(fish, 1)
    TriggerClientEvent('usa:notify', source, 'You have caught a ~y~' .. fish.name .. '~s~!')
  else
    TriggerClientEvent("usa:notify", source, "Inventory is full!")
  end
end)

RegisterServerEvent("fish:giveSeaFish")
AddEventHandler("fish:giveSeaFish", function(fish)
  local fish = seaFishItems[math.random(#seaFishItems)]
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.canHoldItem(fish) then
    char.giveItem(fish, 1)
    TriggerClientEvent('usa:notify', source, 'You have caught a ~y~' .. fish.name .. '~s~!')
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
    char.giveMoney(fish.worth + math.random(0, 50))
    TriggerClientEvent("usa:notify", source, "You have sold (1x) " .. fish.name .. " for $" .. fish.worth)
  else
    TriggerClientEvent("usa:notify", source, "You have no fish to sell!")
  end
end)

RegisterServerEvent("fish:sellSeaFish")
AddEventHandler("fish:sellSeaFish", function(fish)
  local fish = seaFishItems[fish]
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem(fish) then
    char.removeItem(fish, 1)
    char.giveMoney(fish.worth + math.random(0, 85))
    TriggerClientEvent("usa:notify", source, "You have sold (1x) " .. fish.name .. " for $" .. fish.worth)
  else
    TriggerClientEvent("usa:notify", source, "You have no fish to sell!")
  end
end)

RegisterServerEvent("fishing:checkForPole")
AddEventHandler("fishing:checkForPole", function(spotHeading)
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem("Fishing Pole") then
    if spotHeading then
      TriggerClientEvent("fishing:startDockFishing", source, spotHeading)
    else
      TriggerClientEvent("fishing:startSeaFishing", source)
    end
  else 
    TriggerClientEvent("usa:notify", source, "You need a fishing pole!")
  end
end)
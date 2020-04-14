local fishItems = {
  {name = "Trout", quantity = 1, worth = 85, type = "fish", weight = 0, legality = "legal"},
  {name = "Flounder", quantity = 1, worth = 110, type = "fish", weight = 0, legality = "legal"},
  {name = "Halibut", quantity = 1, worth = 125, type = "fish", weight = 0, legality = "legal"},
}

local seaFishItems = {
  {name = "Yellowfin Tuna", quantity = 1, worth = 800, type = "seafish", weight = 0, legality = "legal"},
  {name = "Swordfish", quantity = 1, worth = 1000, type = "seafish", weight = 0, legality = "legal"}
}

RegisterServerEvent("fish:giveFish")
AddEventHandler("fish:giveFish", function(fish)
  local fish = fishItems[fish]
    fish.weight = math.random(1, 15)

  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem(fish) and char.sameWeight(fish) then
    fish.notStackable = false
  else
    fish.notStackable = true
  end
  if char.canHoldItem(fish) then
    char.giveItem(fish, 1)
  else
    TriggerClientEvent("usa:notify", source, "Inventory is full!")
  end
end)

RegisterServerEvent("fish:giveSeaFish")
AddEventHandler("fish:giveSeaFish", function(fish)
  local fish = seaFishItems[fish]
  fish.weight = math.random(10, 55)
  local char = exports["usa-characters"]:GetCharacter(source)
  if char.hasItem(fish) and char.sameWeight(fish) then
    fish.notStackable = false
  else
    fish.notStackable = true
  end
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
    char.giveMoney(fishValues(fish))
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
    char.giveMoney(fishValues(fish))
    TriggerClientEvent("usa:notify", source, "You have sold (1x) " .. fish.name .. " for $" .. fish.worth)
  else
    TriggerClientEvent("usa:notify", source, "You have no fish to sell!")
  end
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function fishValues(fish)
  if fish.name == 'Trout' then
    if fish.weight <= 5 then
      fish.worth = 20
    elseif fish.weight > 5 and fish.weight <= 10 then
      fish.worth = 60
    else
      fish.worth = 85
    end
  elseif fish.name == 'Flounder' then
    if fish.weight <= 5 then
      fish.worth = 30
    elseif fish.weight > 5 and fish.weight <= 10 then
      fish.worth = 80
    else
      fish.worth = 110
    end
  elseif fish.name == 'Halibut' then
    if fish.weight <= 5 then
      fish.worth = 45
    elseif fish.weight > 5 and fish.weight <= 10 then
      fish.worth = 95
    else
      fish.worth = 125
    end
  elseif fish.name == 'Yellowfin Tuna' then
    if fish.weight <= 10 then
      fish.worth = 250
    elseif fish.weight > 10 and fish.weight < 25 then
      fish.worth = 500
    else
      fish.worth = 800
    end
  elseif fish.name == 'Swordfish' then
    if fish.weight <= 10 then
      fish.worth = 300
    elseif fish.weight > 10 and fish.weight < 30 then
      fish.worth = 670
    else
      fish.worth = 1000
    end
  end
  return fish.worth
end

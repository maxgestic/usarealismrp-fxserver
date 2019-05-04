local fishItems = {
  {name = "Trout", quantity = 1, worth = 25, type = "fish", weight = 10, legality = "legal"},
  {name = "Flounder", quantity = 1, worth = 30, type = "fish", weight = 10, legality = "legal"},
  {name = "Halibut", quantity = 1, worth = 50, type = "fish", weight = 10, legality = "legal"}
}

RegisterServerEvent("fish:giveFish")
AddEventHandler("fish:giveFish", function(fish)
  local userSource = tonumber(source)
  local fish = fishItems[fish]
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    if user.getCanActiveCharacterHoldItem(fish) then
      local inventory = user.getActiveCharacterData("inventory")
      for i = 1, #inventory do
        local item = inventory[i]
        if item then
          if item.name == fish.name then
            print("found fish " .. item.name .. " in player's inventory already! incrementing..")
            inventory[i].quantity = item.quantity + 1
            user.setActiveCharacterData("inventory", inventory)
            return
          end
        end
      end
      print("adding fish to player inventory!")
      table.insert(inventory, fish)
      user.setActiveCharacterData("inventory", inventory)
    else
      TriggerClientEvent("usa:notify", userSource, "Inventory is full!")
    end
  --end)
end)

RegisterServerEvent("fish:sellFish")
AddEventHandler("fish:sellFish", function(fish)
  local userSource = tonumber(source)
  local fish = fishItems[fish]
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local inventory = user.getActiveCharacterData("inventory")
    for i = 1, #inventory do
      local item = inventory[i]
      if item then
        if item.name == fish.name then
          print("found fish " .. item.name .. " in player's inventory already! selling..")
          if item.quantity > 1 then
            inventory[i].quantity = item.quantity - 1
          else
            table.remove(inventory, i)
          end
          user.setActiveCharacterData("inventory", inventory)
          local user_money = user.getActiveCharacterData("money")
          user.setActiveCharacterData("money", user_money + item.worth)
          TriggerClientEvent("usa_rp:notify", userSource, "You have sold (1x) " .. item.name .. " for $" .. item.worth)
          return
        end
      end
    end
    TriggerClientEvent("usa:notify", userSource, "You have no fish to sell!")
  --end)
end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

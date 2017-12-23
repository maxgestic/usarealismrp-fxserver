RegisterServerEvent("fishing:giveFish")
AddEventHandler("fishing:giveFish", function(fish)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local inventory = user.getActiveCharacterData("inventory")
        for i = 1, #inventory do
            local item = inventory[i]
            if item.name == fish.name then
                print("found fish " .. item.name .. " in player's inventory already! incrementing..")
                inventory[i].quantity = item.quantity + 1
                user.setActiveCharacterData("inventory", inventory)
                return
            end
        end
        print("adding fish to player inventory!")
        table.insert(inventory, fish)
        user.setActiveCharacterData("inventory", inventory)
    end)
end)

RegisterServerEvent("fishing:sellFish")
AddEventHandler("fishing:sellFish", function()
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local inventory = user.getActiveCharacterData("inventory")
    for i = 1, #inventory do
      local item = inventory[i]
      if item then
        if item.type == "fish" then
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
  end)
end)

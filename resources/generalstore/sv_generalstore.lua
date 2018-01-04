function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(item)
  local userSource = source
  TriggerEvent('es:getPlayerFromId', userSource, function(user)
    if user.getCanActiveCharacterCurrentHoldItem(item) then
      local user_money = user.getActiveCharacterData("money")
      if user_money >= item.price then
        user.setActiveCharacterData("money", user_money - item.price)
        if item.name ~= "Cell Phone" then
          local inventory = user.getActiveCharacterData("inventory")
          for i = 1, #inventory do
            if inventory[i] then
              if inventory[i].name == item.name then
                inventory[i].quantity = inventory[i].quantity + 1
                user.setActiveCharacterData("inventory", inventory)
                TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. item.name)
                return
              end
            end
          end
          -- not already in player inventory at this point, so add it
          table.insert(inventory, item)
          user.setActiveCharacterData("inventory", inventory)
          TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. item.name)
        else
          --Generate number
          --Add Registered Owner
          --print(os.time())
          item.number = string.sub(tostring(os.time()), -8)
          item.owner = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
          item.name = item.name .. " - " .. item.number
          local inventory = user.getActiveCharacterData("inventory")
          table.insert(inventory, item)
          user.setActiveCharacterData("inventory", inventory)
          print(item.number .. " ---- " .. item.owner)
          TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. item.name)
        end
      else
        -- not enough money
        TriggerClientEvent("usa:notify", userSource, "You don't have enough money!")
      end
    else
      TriggerClientEvent("usa:notify", userSource, "Inventory full.")
    end
  end)
end)

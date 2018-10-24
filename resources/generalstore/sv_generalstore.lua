--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_ITEMS = {
  ["Food"] = {
    {name = "Tuna Sandwich", price = 5, type = "food", substance = 40.0, quantity = 1, legality = "legal", weight = 4},
    {name = "Chocolate Pizza", price = 15, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 5},
    {name = "Cheeseburger", price = 12, type = "food", substance = 55.0, quantity = 1, legality = "legal", weight = 4},
    {name = "Kosher Hot Dog", price = 9, type = "food", substance = 45.0, quantity = 1, legality = "legal", weight = 4},
    {name = "Microwave Burrito", price = 4, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 4},
    {name = "Peanut Butter Cups", price = 5, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Half Dozen Donuts", price = 12, type = "food", substance = 5.0, quantity = 6, legality = "legal", weight = 2},
    {name = "Taco", price = 1, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Nachos", price = 3, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2},
    {name = "Walkers Milk Chocolate Toffee", price = 15, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 2},
    {name = "Sea Salt & Vinegar Chips", price = 2, type = "food", substance = 7.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Cheetos", price = 2, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Flaming Hot Cheetos", price = 3, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Doritos", price = 3, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Curly Fries", price = 6, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2}
  },
  ["Drinks"] = {
    {name = "Water", price = 5, type = "drink", substance = 70.0, quantity = 1, legality = "legal", weight = 4},
    {name = "Arizona Iced Tea", price = 3, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Gatorade", price = 4, type = "drink", substance = 70.0, quantity = 1, legality = "legal", weight = 2},
    {name = "Caramel Iced Coffee", price = 1, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Mocha Iced Coffee", price = 1, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Slurpee", price = 4, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 2},
    {name = "Pepsi", price = 2, type = "drink", substance = 9.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Dr. Pepper", price = 2, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Grape Soda", price = 2, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 1},
    {name = "Monster Energy Drink", price = 6, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 2},
    {name = "Four Loko (8%)", price = 8, type = "alcohol", substance = 6.0, quantity = 1, legality = "legal", weight = 2, strength = 0.04},
    {name = "Corona Light Beer (4%)", price = 10, type = "alcohol", substance = 8.0, quantity = 4, legality = "legal", weight = 1, strength = 0.01},
    {name = "Jack Daniels Whiskey (40%)", price = 35, type = "alcohol", substance = 10.0, quantity = 1, legality = "legal", weight = 4, strength = 0.20},
    {name = "Champagne (12.5%)", price = 60, type = "alcohol", substance = 18.0, quantity = 1, legality = "legal", weight = 6, strength = 0.06},
    {name = "Everclear Vodka (90%)", price = 35, type = "alcohol", substance = 5.0, quantity = 1, legality = "legal", weight = 4, strength = 0.45}
  },
  ["Vehicle"] = {
    { name = "Repair Kit", price = 500, type = "vehicle", quantity = 1, legality = "legal", weight = 8}
  },
  ["Electronics"] = {
    { name = "Cell Phone", price = 900, type = "misc", quantity = 1, legality = "legal", contacts = {}, conversations = {}, weight = 1}
  },
  ["Misc"] = {
    { name = "First Aid Kit", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 5},
    { name = "Large Scissors", price = 40, type = "misc", quantity = 1, legality = "legal", weight = 5},
    { name = "Sturdy Rope", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 4},
    { name = "Bag", price = 70, type = "misc", quantity = 1, legality = "legal", weight = 3},
    { name = "The Daily Weazel", price = 2, type = "misc", quantity = 1, legality = "legal", weight = 1},
    { name = "Condoms", price = 3, type = "misc", quantity = 3, legality = "legal", weight = 1},
    { name = "KY Intense Gel", price = 15, type = "misc", quantity = 1, legality = "legal", weight = 1},
    { name = "Viagra", price = 100, type = "misc", quantity = 10, legality = "legal", weight = 1},
    { name = "Tent", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 20},
    { name = "Wood", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 30},
    { name = "Chair", price = 25, type = "misc", quantity = 1, legality = "legal", weight = 20},
    { name = "Vortex Optics Binoculars", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 2},
    { name = "Toolkit", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 20}
  }
}

function GetServerPrice(item)
  for category, items in pairs(GENERAL_STORE_ITEMS) do
    for i = 1, #items do
      if items[i].name == item.name then
        return items[i].price
      end
    end
  end
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(property, item)
  local userSource = source
  item.price = GetServerPrice(item)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
    if user.getCanActiveCharacterHoldItem(item) then
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
                if property and property ~= 0 then
                  -- give to owner of property --
                  TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * item.price))
                end
                return
              end
            end
          end
          -- not already in player inventory at this point, so add it
          table.insert(inventory, item)
          user.setActiveCharacterData("inventory", inventory)
          TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. item.name)
          if property and property ~= 0 then
            -- give to owner of property
            --print("adding money from general store to property: " .. property.name)
            TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * item.price))
          end
        else
          item.number = string.sub(tostring(os.time()), -8)
          item.owner = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
          item.name = item.name .. " - " .. item.number
          exports["usa-phone"]:CreateNewPhone(item)
          -- insert dummie item --
          local inventory = user.getActiveCharacterData("inventory")
          table.insert(inventory, item)
          user.setActiveCharacterData("inventory", inventory)
          print(item.number .. " ---- " .. item.owner)
          TriggerClientEvent("usa:notify", userSource, "Purchased: ~y~" .. item.name)
          if property and property ~= 0 then
            -- give to owner of property
            --print("adding money from general store to property: " .. property.name)
            TriggerEvent("properties:addMoney", property.name, math.ceil(0.40 * item.price))
          end
        end
      else
        -- not enough money
        TriggerClientEvent("usa:notify", userSource, "You don't have enough money!")
      end
    else
      TriggerClientEvent("usa:notify", userSource, "Inventory full.")
    end
  --end)
end)

RegisterServerEvent("generalStore:loadItems")
AddEventHandler("generalStore:loadItems", function()
  print("**loading general store items!**")
  TriggerClientEvent("generalStore:loadItems", source, GENERAL_STORE_ITEMS)
end)

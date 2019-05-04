--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_ITEMS = {
  ["Food"] = {
    {name = "Tuna Sandwich", price = 3, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_sandwich_01"},
    {name = "Chocolate Pizza", price = 10, type = "food", substance = 25.0, quantity = 1, legality = "legal", weight = 5, objectModel = "ng_proc_food_chips01a"},
    {name = "Cheeseburger", price = 6, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_cs_burger_01"},
    {name = "Kosher Hot Dog", price = 3, type = "food", substance = 35.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_cs_hotdog_01"},
    {name = "Microwave Burrito", price = 2, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 4, objectModel = "prop_food_bs_burger2"},
    {name = "Peanut Butter Cups", price = 3, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_food_chips01a"},
    {name = "Donut", price = 8, type = "food", substance = 5.0, quantity = 6, legality = "legal", weight = 2, objectModel = "prop_donut_01"},
    {name = "Taco", price = 2, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 1, objectModel = "prop_taco_01"},
    {name = "Nachos", price = 3, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2, objectModel = "ng_proc_food_chips01b"},
    {name = "Walkers Milk Chocolate Toffee", price = 8, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 2, objectModel = "ng_proc_food_chips01a"},
    {name = "Sea Salt & Vinegar Chips", price = 2, type = "food", substance = 7.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_food_chips01a"},
    {name = "Cheetos", price = 2, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_food_chips01a"},
    {name = "Flaming Hot Cheetos", price = 2, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_food_chips01c"},
    {name = "Doritos", price = 3, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_food_chips01b"},
    {name = "Curly Fries", price = 5, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_chips"}
  },
  ["Drinks"] = {
    {name = "Water", price = 3, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 4, objectModel = "ba_prop_club_water_bottle"},
    {name = "Arizona Iced Tea", price = 1, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ba_prop_club_water_bottle"},
    {name = "Gatorade", price = 4, type = "drink", substance = 70.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_energy_drink"},
    {name = "Caramel Iced Coffee", price = 2, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 1, objectModel = "prop_food_coffee"},
    {name = "Mocha Iced Coffee", price = 2, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 1, objectModel = "prop_food_coffee"},
    {name = "Slurpee", price = 4, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_food_juice01"},
    {name = "Pepsi", price = 4, type = "drink", substance = 9.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Dr. Pepper", price = 3, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Grape Soda", price = 2, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 1, objectModel = "ng_proc_sodacan_01b"},
    {name = "Monster Energy Drink", price = 6, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 2, objectModel = "prop_energy_drink", blockedInPrison = true},
    {name = "Four Loko (8%)", price = 8, type = "alcohol", substance = 6.0, quantity = 1, legality = "legal", weight = 2, strength = 0.04, objectModel = "prop_energy_drink", blockedInPrison = true},
    {name = "Corona Light Beer (4%)", price = 6, type = "alcohol", substance = 8.0, quantity = 4, legality = "legal", weight = 1, strength = 0.03, objectModel = "prop_beer_bottle", blockedInPrison = true},
    {name = "Jack Daniels Whiskey (40%)", price = 20, type = "alcohol", substance = 10.0, quantity = 1, legality = "legal", weight = 4, strength = 0.08, objectModel = "prop_whiskey_bottle", blockedInPrison = true},
    {name = "Champagne (12.5%)", price = 40, type = "alcohol", substance = 18.0, quantity = 1, legality = "legal", weight = 6, strength = 0.06, objectModel = "prop_whiskey_bottle", blockedInPrison = true},
    {name = "Everclear Vodka (90%)", price = 35, type = "alcohol", substance = 5.0, quantity = 1, legality = "legal", weight = 4, strength = 0.10, objectModel = "prop_vodka_bottle", blockedInPrison = true}
  },
  ["Electronics"] = {
    { name = "Cell Phone", price = 650, type = "misc", quantity = 1, legality = "legal", contacts = {}, conversations = {}, weight = 1, objectModel = "prop_npc_phone_02", blockedInPrison = true}
  },
  ["Misc"] = {
    { name = "First Aid Kit", price = 80, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "v_ret_ta_firstaid", blockedInPrison = true},
    { name = "The Daily Weazel", price = 2, type = "misc", quantity = 1, legality = "legal", weight = 1, objectModel = "prop_cs_newspaper"},
    { name = "Condoms", price = 5, type = "misc", quantity = 3, legality = "legal", weight = 1, objectModel = "ng_proc_candy01a", blockedInPrison = true},
    { name = "KY Intense Gel", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 1, objectModel = "v_res_d_lube", blockedInPrison = true},
    { name = "Viagra", price = 10, type = "misc", quantity = 10, legality = "legal", weight = 1, objectModel = "prop_cs_pills", blockedInPrison = true},
  }
}

local HARDWARE_STORE_ITEMS = {
  ["Vehicle"] = {
    { name = "Repair Kit", price = 250, type = "vehicle", quantity = 1, legality = "legal", weight = 8, objectModel = "imp_prop_tool_box_01a"}
  },
  ["Electronics"] = {
    { name = "Cell Phone", price = 500, type = "misc", quantity = 1, legality = "legal", contacts = {}, conversations = {}, weight = 1, objectModel = "prop_npc_phone_02"}
  },
  ["Misc"] = {
    {name = 'Lockpick', type = 'misc', price = 400, legality = 'legal', quantity = 1, weight = 5},
    { name = "First Aid Kit", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "v_ret_ta_firstaid"},
    { name = "Large Scissors", price = 15, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "prop_cs_scissors"},
    { name = "Sturdy Rope", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 4, objectModel = "prop_devin_rope_01  "},
    { name = "Bag", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 3, objectModel = "prop_paper_bag_01"},
    { name = "Ludde's Lube", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 1, objectModel = "v_res_d_lube"},
    { name = "Tent", price = 200, type = "misc", quantity = 1, legality = "legal", weight = 20, objectModel = "prop_cs_box_step"},
    { name = "Wood", price = 75, type = "misc", quantity = 1, legality = "legal", weight = 30, objectModel = "prop_cs_box_step"},
    { name = "Chair", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 20, objectModel = "prop_cs_box_step"},
    { name = "Vortex Optics Binoculars", price = 150, type = "misc", quantity = 1, legality = "legal", weight = 2, objectModel = "prop_binoc_01"}
  }
}

function GetServerPrice(item, store)
  for category, items in pairs(store) do
    for i = 1, #items do
      if items[i].name == item.name then
        return items[i].price
      end
    end
  end
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(property, item, store, inPrison)
  local userSource = source
  if store == 'GENERAL' then
    item.price = GetServerPrice(item, GENERAL_STORE_ITEMS)
  elseif store == 'HARDWARE' then
    item.price = GetServerPrice(item, HARDWARE_STORE_ITEMS)
  end
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  if inPrison and item.blockedInPrison then
    TriggerClientEvent('usa:notify', userSource, 'We don\'t sell that here!')
    return
  end
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

RegisterServerEvent("hardwareStore:loadItems")
AddEventHandler("hardwareStore:loadItems", function()
  print("**loading hardware store items!**")
  TriggerClientEvent("hardwareStore:loadItems", source, HARDWARE_STORE_ITEMS)
end)

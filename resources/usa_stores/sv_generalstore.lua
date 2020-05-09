--# by minipunch
--# for USA REALISM rp
--# Made for the 24/7 stores as general stores for various items

local GENERAL_STORE_ITEMS = {
  ["Food"] = {
    {name = "Tuna Sandwich", price = 40, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_sandwich_01"},
    {name = "Chocolate Pizza", price = 35, type = "food", substance = 18.0, quantity = 1, legality = "legal", weight = 6, objectModel = "ng_proc_food_chips01a"},
    {name = "Cheeseburger", price = 40, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_cs_burger_01"},
    {name = "Kosher Hot Dog", price = 40, type = "food", substance = 20.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_cs_hotdog_01"},
    {name = "Microwave Burrito", price = 40, type = "food", substance = 15.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_food_bs_burger2"},
    {name = "Peanut Butter Cups", price = 35, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 5, objectModel = "ng_proc_food_chips01a"},
    {name = "Taco", price = 40, type = "food", substance = 10.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_taco_01"},
    {name = "Nachos", price = 40, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 11, objectModel = "ng_proc_food_chips01b"},
    {name = "Walkers Milk Chocolate Toffee", price = 35, type = "food", substance = 9.0, quantity = 1, legality = "legal", weight = 5, objectModel = "ng_proc_food_chips01a"},
    {name = "Sea Salt & Vinegar Chips", price = 35, type = "food", substance = 7.0, quantity = 1, legality = "legal", weight = 7, objectModel = "ng_proc_food_chips01a"},
    {name = "Cheetos", price = 35, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 7, objectModel = "ng_proc_food_chips01a"},
    {name = "Flaming Hot Cheetos", price = 35, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 7, objectModel = "ng_proc_food_chips01c"},
    {name = "Doritos", price = 35, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 7, objectModel = "ng_proc_food_chips01b"},
    {name = "Curly Fries", price = 35, type = "food", substance = 12.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_food_chips"}
  },
  ["Drinks"] = {
    {name = "Water", price = 25, type = "drink", substance = 40.0, quantity = 1, legality = "legal", weight = 10, objectModel = "ba_prop_club_water_bottle"},
    {name = "Arizona Iced Tea", price = 25, type = "drink", substance = 50.0, quantity = 1, legality = "legal", weight = 10, objectModel = "ba_prop_club_water_bottle"},
    {name = "Gatorade", price = 25, type = "drink", substance = 50.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_energy_drink"},
    {name = "Caramel Iced Coffee", price = 25, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_food_coffee"},
    {name = "Mocha Iced Coffee", price = 25, type = "drink", substance = 20.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_food_coffee"},
    {name = "Slurpee", price = 40, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 15, objectModel = "prop_food_juice01"},
    {name = "Pepsi", price = 25, type = "drink", substance = 9.0, quantity = 1, legality = "legal", weight = 10, objectModel = "ng_proc_sodacan_01b"},
    {name = "Dr. Pepper", price = 25, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 10, objectModel = "ng_proc_sodacan_01b"},
    {name = "Grape Soda", price = 25, type = "drink", substance = 8.0, quantity = 1, legality = "legal", weight = 10, objectModel = "ng_proc_sodacan_01b"},
    {name = "Monster Energy Drink", price = 25, type = "drink", substance = 22.0, quantity = 1, legality = "legal", weight = 10, objectModel = "prop_energy_drink", blockedInPrison = true},
    {name = "Four Loko (8%)", price = 35, type = "alcohol", substance = 6.0, quantity = 1, legality = "legal", weight = 10, strength = 0.04, objectModel = "prop_energy_drink", blockedInPrison = true},
    {name = "Corona Light Beer (4%)", price = 35, type = "alcohol", substance = 8.0, quantity = 4, legality = "legal", weight = 10, strength = 0.03, objectModel = "prop_beer_bottle", blockedInPrison = true},
    {name = "Jack Daniels Whiskey (40%)", price = 80, type = "alcohol", substance = 10.0, quantity = 1, legality = "legal", weight = 12, strength = 0.08, objectModel = "prop_whiskey_bottle", blockedInPrison = true},
    {name = "Champagne (12.5%)", price = 100, type = "alcohol", substance = 18.0, quantity = 1, legality = "legal", weight = 10, strength = 0.06, objectModel = "prop_whiskey_bottle", blockedInPrison = true},
    {name = "Everclear Vodka (90%)", price = 80, type = "alcohol", substance = 5.0, quantity = 1, legality = "legal", weight = 10, strength = 0.10, objectModel = "prop_vodka_bottle", blockedInPrison = true}
  },
  ["Electronics"] = {
    { name = "Cell Phone", price = 650, type = "misc", quantity = 1, legality = "legal", contacts = {}, conversations = {}, weight = 3, objectModel = "prop_npc_phone_02", blockedInPrison = true}
  },
  ["Misc"] = {
    { name = "First Aid Kit", price = 80, type = "misc", quantity = 1, legality = "legal", weight = 15, objectModel = "v_ret_ta_firstaid", blockedInPrison = true},
    { name = "The Daily Weazel", price = 2, type = "misc", quantity = 1, legality = "legal", weight = 9, objectModel = "prop_cs_newspaper"},
    { name = "Condoms", price = 5, type = "misc", quantity = 3, legality = "legal", weight = 8, objectModel = "ng_proc_candy01a", blockedInPrison = true},
    { name = "KY Intense Gel", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 6, objectModel = "v_res_d_lube", blockedInPrison = true},
    { name = "Viagra", price = 10, type = "misc", quantity = 10, legality = "legal", weight = 5, objectModel = "prop_cs_pills", blockedInPrison = true},
    { name = "RAW Papers", price = 10, type = "misc", quantity = 5, legality = "legal", weight = 1, objectModel = "prop_cs_pills", blockedInPrison = true},
    { name = "Bic Lighter", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 1, objectModel = "prop_cs_pills", blockedInPrison = true}
  }
}

local HARDWARE_STORE_ITEMS = {
  ["Vehicle"] = {
    { name = "Repair Kit", price = 250, type = "vehicle", quantity = 1, legality = "legal", weight = 20, objectModel = "imp_prop_tool_box_01a"}
  },
  ["Electronics"] = {
    { name = "Cell Phone", price = 650, type = "misc", quantity = 1, legality = "legal", contacts = {}, conversations = {}, weight = 3, objectModel = "prop_npc_phone_02", blockedInPrison = true}
  },
  ["Misc"] = {
    {name = 'Razor Blade', type = 'misc', price = 60, legality = 'legal', quantity = 1, residue = false, weight = 3},
    { name = "First Aid Kit", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 15, objectModel = "v_ret_ta_firstaid"},
    { name = "Large Scissors", price = 15, type = "misc", quantity = 1, legality = "legal", weight = 5, objectModel = "prop_cs_scissors"},
    { name = "Sturdy Rope", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 15, objectModel = "prop_devin_rope_01  "},
    { name = "Bag", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 15, objectModel = "prop_paper_bag_01"},
    { name = "Ludde's Lube", price = 10, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "v_res_d_lube"},
    { name = "Tent", price = 200, type = "misc", quantity = 1, legality = "legal", weight = 50, objectModel = "prop_cs_box_step"},
    { name = "Wood", price = 75, type = "misc", quantity = 1, legality = "legal", weight = 50, objectModel = "prop_cs_box_step"},
    { name = "Chair", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 60, objectModel = "prop_cs_box_step"},
    { name = "Vortex Optics Binoculars", price = 150, type = "misc", quantity = 1, legality = "legal", weight = 10, objectModel = "prop_binoc_01"},
    { name = "Shovel", price = 75, type = "misc", quantity = 1, legality = "legal", weight = 30, objectModel = "prop_tool_shovel"},
    { name = "Watering Can", price = 75, type = "misc", quantity = 1, legality = "legal", weight = 20, objectModel = "prop_wateringcan"},
    { name = "Fertilizer", price = 75, type = "misc", quantity = 5, legality = "legal", weight = 5}
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

function AddGeneralStoreItem(category, item)
  table.insert(GENERAL_STORE_ITEMS[category], item)
end

RegisterServerEvent("generalStore:buyItem")
AddEventHandler("generalStore:buyItem", function(item, store, inPrison, business)
  local char = exports["usa-characters"]:GetCharacter(source)
  if store == 'GENERAL' then
    item.price = GetServerPrice(item, GENERAL_STORE_ITEMS)
  elseif store == 'HARDWARE' then
    item.price = GetServerPrice(item, HARDWARE_STORE_ITEMS)
  end
  if inPrison and item.blockedInPrison then
    TriggerClientEvent('usa:notify', source, 'We don\'t sell that here!')
    return
  end
  if char.canHoldItem(item) then
    if char.get("money") >= item.price then
      char.removeMoney(item.price)
      if item.name == "Cell Phone" then
        item.number = string.sub(tostring(os.time()), -8)
        item.owner = char.getName()
        item.name = item.name .. " - " .. item.number
        exports["usa-phone"]:CreateNewPhone(item)
      end
      char.giveItem(item, item.quantity or 1)
      TriggerClientEvent("usa:notify", source, "Purchased: ~y~" .. item.name)
      if business then
        exports["usa-businesses"]:GiveBusinessCashPercent(business, item.price)
      end
    else
      TriggerClientEvent("usa:notify", source, "You don't have enough money!")
    end
  else
    TriggerClientEvent("usa:notify", source, "Your inventory is full!")
  end
end)

RegisterServerEvent("generalStore:loadItems")
AddEventHandler("generalStore:loadItems", function()
  TriggerClientEvent("generalStore:loadItems", source, GENERAL_STORE_ITEMS)
end)

RegisterServerEvent("hardwareStore:loadItems")
AddEventHandler("hardwareStore:loadItems", function()
  TriggerClientEvent("hardwareStore:loadItems", source, HARDWARE_STORE_ITEMS)
end)
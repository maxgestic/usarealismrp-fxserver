local data = {
    harvest_item_requirement = "Large Scissors",
    harvest_item = {
      name = "Weed Bud",
      quantity = 1,
      weight = 4.0,
      type = "drug",
      legality = "illegal",
      objectModel = "bkr_prop_weed_bud_01a"
    },
    processed_item = {
      name = "Packaged Weed",
      quantity = 1,
      weight = 2.0,
      type = "drug",
      legality = "illegal",
      objectModel = "bkr_prop_weed_bag_01a"
    }
}

RegisterServerEvent("weed:checkItem")
AddEventHandler("weed:checkItem", function(stage)
  if stage == "Harvest" then
    item_name = data.harvest_item_requirement
  elseif stage == "Process" then
    item_name = data.harvest_item.name
  end
  if item_name then
    local userSource = tonumber(source)
    local user = exports["essentialmode"]:getPlayerFromId(userSource)
    local inventory = user.getActiveCharacterData("inventory")
    for i = 1, #inventory do
      local item = inventory[i]
      if item.name == item_name then
        if stage == "Harvest" then
          TriggerClientEvent("weed:continueHarvesting", userSource)
          if not item.residue then item.residue = true TriggerClientEvent('usa:notify', userSource, 'Your Large Scissors have an odor of marijuana.') end
          user.setActiveCharacterData('inventory', inventory)
        elseif stage == "Process" then
          TriggerClientEvent("weed:continueProcessing", userSource)
        end
        return
      end
    end
    -- no materials:
    if stage == "Harvest" then
      TriggerClientEvent("usa:notify", userSource, "You need ~y~" .. data.harvest_item_requirement .. "~s~ to harvest!")
    elseif stage == "Process" then
      TriggerClientEvent("usa:notify", userSource, "You don't have any ~y~" .. data.harvest_item.name .. "~s~ to process!")
    end
  end
end)

RegisterServerEvent("weed:rewardItem")
AddEventHandler("weed:rewardItem", function(stage)
  local userSource = tonumber(source)
  if stage == "Harvest" then
    print("giving player harvested item: " .. data.harvest_item.name)
    TriggerEvent("usa:insertItem", data.harvest_item, data.harvest_item.quantity, userSource)
    TriggerClientEvent("evidence:weedScent", userSource)
  elseif stage == "Process" then
    --TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user = exports["essentialmode"]:getPlayerFromId(userSource)
      local inventory = user.getActiveCharacterData("inventory")
      for i = 1, #inventory do
        local item = inventory[i]
        if item then
          if item.name == data.harvest_item.name then
            if item.quantity > 1 then
              inventory[i].quantity = inventory[i].quantity - 1
            else
              table.remove(inventory, i)
            end
            user.setActiveCharacterData("inventory", inventory)
            print("giving player processed item: " .. data.processed_item.name)
            TriggerEvent("usa:insertItem", data.processed_item, data.processed_item.quantity, userSource)
            TriggerClientEvent("evidence:weedScent", userSource)
            return
          end
        end
      end
      -- at this point, item was not found
      TriggerClientEvent("usa:notify", userSource, "You don't have any " .. data.harvest_item.name .. " to process!")
    --end)
  end
end)
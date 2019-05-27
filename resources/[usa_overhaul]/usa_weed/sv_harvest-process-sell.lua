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
  local char = exports["usa-characters"]:GetCharacter(source)
  if stage == "Harvest" then
    item_name = data.harvest_item_requirement
    if char.hasItem(item_name) then
      TriggerClientEvent("weed:continueHarvesting", source)
      if not item.residue then item.residue = true TriggerClientEvent('usa:notify', source, 'Your Large Scissors have an odor of marijuana.') end
      char.modifyItem(item_name, "residue", true)
    else
      TriggerClientEvent("usa:notify", source, "You need ~y~" .. data.harvest_item_requirement .. "~s~ to harvest!")
    end
  elseif stage == "Process" then
    item_name = data.harvest_item.name
    if char.hasItem(item_name) then
      TriggerClientEvent("weed:continueProcessing", source)
    else
      TriggerClientEvent("usa:notify", source, "You don't have any ~y~" .. data.harvest_item.name .. "~s~ to process!")
  end
end)

RegisterServerEvent("weed:rewardItem")
AddEventHandler("weed:rewardItem", function(stage)
  local char = exports["usa-characters"]:GetCharacter(source)
  if stage == "Harvest" then
    if char.canHoldItem(data.harvest_item) then
      char.giveItem(data.harvest_item)
    else
      TriggerClientEvent('usa:notify', source, 'Your inventory is full!')
    end
  elseif stage == "Process" then
    if char.hasItem(data.harvest_item) then
      if char.canHoldItem(data.processed_item) then
        char.giveItem(data.processed_item)
      else
        TriggerClientEvent('usa:notify', source, 'Your inventory is full!')
      end
    else
      TriggerClientEvent("usa:notify", userSource, "You don't have any " .. data.harvest_item.name .. " to process!")
    end
  end
  TriggerClientEvent("evidence:weedScent", source)
end)
local REWARDS = {
  ["Sand"] = {
    harvest_item_requirement = "Shovel",
    harvest_item = {
      name = "Raw Sand",
      quantity = 1,
      weight = 8.0,
      type = "misc",
      legality = "legal",
      objectModel = "prop_cs_box_step"
    },
    processed_item = {
      name = "Processed Sand",
      quantity = 1,
      weight = 8.0,
      type = "misc",
      legality = "legal",
      objectModel = "prop_cs_box_step"
    },
    reward_amount = math.random(50, 80)
  }
}

RegisterServerEvent("HPS:checkItem")
AddEventHandler("HPS:checkItem", function(job_name, process_time, stage)
  local item_name = "undefined"
  if stage == "Harvest" then
    item_name = REWARDS[job_name].harvest_item_requirement
  elseif stage == "Process" then
    item_name = REWARDS[job_name].harvest_item.name
  elseif stage == "Sale" then
    item_name = REWARDS[job_name].processed_item.name
  end
  local character = exports["usa-characters"]:GetCharacter(source)
  local item = character.getItem(item_name)
  if item then
    if stage == "Harvest" then
      TriggerClientEvent("HPS:continueHarvesting", source, job_name, process_time)
    elseif stage == "Process" then
      TriggerClientEvent("HPS:continueProcessing", source, job_name, process_time)
    elseif stage == "Sale" then
      character.removeItem(item_name, 1)
      character.giveMoney(REWARDS[job_name].reward_amount)
      TriggerClientEvent("usa:notify", source, "Here is the cash!")
      TriggerClientEvent("usa:playAnimation", source, "anim@move_m@trash", "pickup", -8, 1, -1, 53, 0, 0, 0, 0, 3)
    end
  else
    -- no materials:
    if stage == "Harvest" then
      TriggerClientEvent("usa:notify", source, "You need " .. REWARDS[job_name].harvest_item_requirement .. " to gather!")
    elseif stage == "Process" then
      TriggerClientEvent("usa:notify", source, "Don't have any " .. REWARDS[job_name].harvest_item.name .. " to process!")
    elseif stage == "Sale" then
      TriggerClientEvent("usa:notify", source, "Don't have any " .. REWARDS[job_name].processed_item.name .. " to sell!")
    end
  end
end)

RegisterServerEvent("HPS:rewardItem")
AddEventHandler("HPS:rewardItem", function(job_name, stage)
  for job, data in pairs(REWARDS) do
    if job == job_name then
      local char = exports["usa-characters"]:GetCharacter(source)
      if stage == "Harvest" then
        if char.canHoldItem(data.harvest_item) then
            char.giveItem(data.harvest_item)
        else
          TriggerClientEvent("usa:notify", source, "Inventory full!")
        end
      elseif stage == "Process" then
        if char.canHoldItem(data.processed_item) then
          char.removeItem(data.harvest_item.name, 1)
          data.processed_item.quantity = 1
          char.giveItem(data.processed_item)
        else
          TriggerClientEvent("usa:notify", source, "Inventory full!")
        end
      end
    end
  end
end)

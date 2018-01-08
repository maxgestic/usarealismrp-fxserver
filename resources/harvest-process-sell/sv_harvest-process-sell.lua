local REWARDS = {
  ["Weed"] = {
    harvest_item_requirement = "Large Scissors",
    harvest_item = {
      name = "Weed Bud",
      quantity = 1,
      weight = 8.0,
      type = "drug",
      legality = "illegal"
    },
    processed_item = {
      name = "Hash",
      quantity = 1,
      weight = 6.0,
      type = "drug",
      legality = "illegal"
    },
    reward_amount = 80
  }
}

--------------
-- todo: add required items like scissors, bags and butane/dishes for harvest / processing respectively
-- todo: add information and waypoint directions from the ped at harvest/process
--------------


RegisterServerEvent("HPS:checkItem")
AddEventHandler("HPS:checkItem", function(job_name, process_time, stage)
  --print("stage: " .. stage)
  local item_name = "undefined"
  if stage == "Harvest" then
    item_name = REWARDS[job_name].harvest_item_requirement
  elseif stage == "Process" then
    item_name = REWARDS[job_name].harvest_item.name
  elseif stage == "Sale" then
    item_name = REWARDS[job_name].processed_item.name
  end
  --print("item_name: " .. item_name)
  if item_name then
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
      local inventory = user.getActiveCharacterData("inventory")
      for i = 1, #inventory do
        local item = inventory[i]
        if item then
          if item.name == item_name then
            if stage == "Harvest" then
              TriggerClientEvent("HPS:continueHarvesting", userSource, job_name, process_time)
            elseif stage == "Process" then
              TriggerClientEvent("HPS:continueProcessing", userSource, job_name, process_time)
            elseif stage == "Sale" then
              -- remove item:
              if item.quantity > 1 then
                inventory[i].quantity = inventory[i].quantity - 1
              else
                table.remove(inventory, i)
              end
              user.setActiveCharacterData("inventory", inventory)
              -- give money:
              local user_money = user.getActiveCharacterData("money")
              user.setActiveCharacterData("money", user_money + REWARDS[job_name].reward_amount)
              TriggerClientEvent("usa:notify", userSource, "Here is the cash!")
              local anim = {dict = "anim@move_m@trash", name = "pickup"}
              TriggerClientEvent("usa:playAnimation", userSource, anim.name, anim.dict, 3)
            end
            return
          end
        end
      end
      -- no materials:
      if stage == "Harvest" then
        TriggerClientEvent("usa:notify", userSource, "You need " .. REWARDS[job_name].harvest_item_requirement .. " to harvest!")
      elseif stage == "Process" then
        TriggerClientEvent("usa:notify", userSource, "Don't have any " .. string.lower(job_name) .. " to process!")
      elseif stage == "Sale" then
        TriggerClientEvent("usa:notify", userSource, "Don't have any " .. string.lower(job_name) .. " to sell!")
      end
    end)
  end
end)

RegisterServerEvent("HPS:rewardItem")
AddEventHandler("HPS:rewardItem", function(job_name, stage)
  local userSource = tonumber(source)
  --print("source: " .. userSource)
  for job, data in pairs(REWARDS) do
    if job == job_name then
      if stage == "Harvest" then
        print("giving player harvested item: " .. data.harvest_item.name)
        TriggerEvent("usa:insertItem", data.harvest_item, data.harvest_item.quantity, userSource)
      elseif stage == "Process" then
        TriggerEvent("es:getPlayerFromId", userSource, function(user)
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
                return
              end
            end
          end
          -- at this point, item was not found
          TriggerClientEvent("usa:notify", userSource, "You don't have enough " .. data.harvest_item.name .. " to process!")
        end)
      end
    end
  end
end)

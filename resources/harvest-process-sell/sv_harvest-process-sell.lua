local REWARDS = {
  ["Weed"] = {
    item = {
      name = "Raw Weed",
      quantity = 1,
      weight = 8.0,
      type = "drug",
      legality = "legal"
    }
  }
}

RegisterServerEvent("HPS:rewardItem")
AddEventHandler("HPS:rewardItem", function(item_name)
  for job, item in pairs(REWARDS) do
    if job == item_name then
      print("giving player harvested item: " .. item.name)
      TriggerEvent("usa:insertItem", item, item.quantity)
    end
  end
end)

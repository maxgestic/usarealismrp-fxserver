TriggerEvent('es:addCommand', 'tent', function(source, args, user)
  TriggerEvent("usa:getPlayerItem", tonumber(source), "Tent", function(item)
    if item then
      TriggerClientEvent("camping:tent", tonumber(source))
      TriggerEvent("usa:removeItem", item, 1, tonumber(source))
    else
      TriggerClientEvent("usa:notify", tonumber(source), "You do not have a tent to place!")
    end
  end)
end, { help = "Place a tent down (must have a tent)." })

TriggerEvent('es:addCommand', 'campfire', function(source, args, user)
  TriggerEvent("usa:getPlayerItem", tonumber(source), "Wood", function(item)
   if item then
      TriggerClientEvent("camping:campfire", tonumber(source))
      TriggerEvent("usa:removeItem", item, 1, tonumber(source))
    else
     TriggerClientEvent("usa:notify", tonumber(source), "You do not have wood to place!")
    end
  end)
end, { help = "Start a campfire (must have wood)." })

TriggerEvent('es:addCommand', 'chair', function(source, args, user)
  TriggerEvent("usa:getPlayerItem", tonumber(source), "Chair", function(item)
    if item then
      TriggerClientEvent("camping:chair", tonumber(source))
      TriggerEvent("usa:removeItem", item, 1, tonumber(source))
    else
      TriggerClientEvent("usa:notify", tonumber(source), "You do not have a chair to place!")
    end
  end)
end, { help = "Place down a chair (must have a chair)." })

TriggerEvent('es:addCommand', 'delete', function(source, args, user)
  TriggerClientEvent("camping:delete", tonumber(source))
end, { help = "Delete the camping object in front of you." })

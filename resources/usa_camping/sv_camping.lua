TriggerEvent('es:addCommand', 'tent', function(source, args, char)
  if char.hasItem("Tent") then
    TriggerClientEvent("camping:tent", tonumber(source))
    char.removeItem("Tent", 1)
  else
    TriggerClientEvent("usa:notify", tonumber(source), "You do not have a tent to place!")
  end
end, { help = "Place a tent down (must have a tent)" })

TriggerEvent('es:addCommand', 'campfire', function(source, args, char)
  if char.hasItem("Wood") then
    TriggerClientEvent("camping:campfire", tonumber(source))
    char.removeItem("Wood", 1)
  else
    TriggerClientEvent("usa:notify", tonumber(source), "You do not have wood to place!")
  end
end, { help = "Start a campfire (must have wood)" })

TriggerEvent('es:addCommand', 'chair', function(source, args, char)
  if char.hasItem("Chair") then
    TriggerClientEvent("camping:chair", tonumber(source))
    char.removeItem("Chair", 1)
  else
    TriggerClientEvent("usa:notify", tonumber(source), "You do not have a chair to place!")
  end
end, { help = "Place down a chair (must have a chair)" })

TriggerEvent('es:addCommand', 'delete', function(source, args, char)
  TriggerClientEvent("camping:delete", tonumber(source))
end, { help = "Delete the camping object in front of you" })


local SPOTLIGHTS = {}

TriggerEvent('es:addJobCommand', 'spotlight', {"sheriff", "ems", "corrections", "fire"}, function(source, args, user)
  TriggerClientEvent("spotlight:spotlight", source)
end, {
	help = "Toggle spot light on / off. Use arrow keys to navigate."
})

TriggerEvent('es:addJobCommand', 's', {"sheriff", "ems", "corrections", "fire"}, function(source, args, user)
  TriggerClientEvent("spotlight:spotlight", source)
end, {
	help = "Toggle spot light on / off. Use arrow keys to navigate."
})

RegisterServerEvent("spotlight:addSpotlight")
AddEventHandler("spotlight:addSpotlight", function(spotlight)
  table.insert(SPOTLIGHTS, spotlight)
  TriggerClientEvent("spotlight:syncSpotlights", -1, SPOTLIGHTS)
end)

RegisterServerEvent("spotlight:updateSpotlight")
AddEventHandler("spotlight:updateSpotlight", function(spotlight)
  for i = 1, #SPOTLIGHTS do
    if SPOTLIGHTS[i].uuid == spotlight.uuid then
      SPOTLIGHTS[i] = spotlight
      break
    end
  end
  TriggerClientEvent("spotlight:syncSpotlight", -1, spotlight)
end)

RegisterServerEvent("spotlight:removeSpotlight")
AddEventHandler("spotlight:removeSpotlight", function(spotlight)
  for i = 1, #SPOTLIGHTS do
    if SPOTLIGHTS[i].uuid == spotlight.uuid then
      table.remove(SPOTLIGHTS, i)
      break
    end
  end
  TriggerClientEvent("spotlight:syncSpotlights", -1, SPOTLIGHTS)
end)

RegisterServerEvent("spotlight:checkJob")
AddEventHandler("spotlight:checkJob", function()
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "fire" then
    TriggerClientEvent("spotlight:spotlight", source)
  end
end)

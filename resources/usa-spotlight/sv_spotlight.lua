
local SPOTLIGHTS = {}

local MAX_SPOTLIGHT_RUN_TIME_MINUTES = 15

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
    spotlight.last_used_time = os.time()
    print("spotlight start time: " .. spotlight.last_used_time)
    table.insert(SPOTLIGHTS, spotlight)
    TriggerClientEvent("spotlight:syncSpotlights", -1, SPOTLIGHTS)
end)

RegisterServerEvent("spotlight:updateSpotlight")
AddEventHandler("spotlight:updateSpotlight", function(spotlight)
  for i = 1, #SPOTLIGHTS do
    if SPOTLIGHTS[i].uuid == spotlight.uuid then
      SPOTLIGHTS[i] = spotlight
      SPOTLIGHTS[i].last_used_time = os.time()
      spotlight.last_used_time = SPOTLIGHTS[i].last_used_time
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

------------------------------------------------------------------------------------------------
-- Remove any stale (spotlights that have been accidentally left on) spotlights --
------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(MAX_SPOTLIGHT_RUN_TIME_MINUTES * 60 * 1000)
        for i = 1, #SPOTLIGHTS do
            if SPOTLIGHTS[i].last_used_time then
                local minutes_from_last_update = math.floor(os.difftime(os.time(), SPOTLIGHTS[i].last_used_time) / (60))
                if minutes_from_last_update > MAX_SPOTLIGHT_RUN_TIME_MINUTES then
                    table.remove(SPOTLIGHTS, i)
                    TriggerClientEvent("spotlight:syncSpotlights", -1, SPOTLIGHTS)
                end
            end
        end
    end
end)

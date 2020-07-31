local BlacklistedEvents = Events;

for i=1, #BlacklistedEvents, 1 do
  RegisterServerEvent(BlacklistedEvents[i])
    AddEventHandler(BlacklistedEvents[i], function()
        print("punishing player for injecting event: " .. BlacklistedEvents[i])
        TriggerEvent('scrambler:injectionDetected', BlacklistedEvents[i], source, true) -- todo: handle server/client event tagging (bool param) properly
    end)
end
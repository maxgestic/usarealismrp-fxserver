
webhookURL = "https://discordapp.com/api/webhooks/618094411003199509/IeXSWsln5hPo83l5wles9m62kEAKAJQUry6cZvV0MQzCLa6mYgBZOEVdtwwjpC1MUwoh"

local BlacklistedEvents = Events;

for i=1, #BlacklistedEvents, 1 do
  RegisterServerEvent(BlacklistedEvents[i])
    AddEventHandler(BlacklistedEvents[i], function()
      --[[
        local id = source;
        local ids = ExtractIdentifiers(id);
        local steam = ids.steam:gsub("steam:", "");
        local steamDec = tostring(tonumber(steam,16));
        steam = "https://steamcommunity.com/profiles/" .. steamDec;
        local gameLicense = ids.license;
        local discord = ids.discord;
        -- todo: punish player here...
        print("punishing player for injecting event: " .. BlacklistedEvents[i])
        --]]
        TriggerEvent('scrambler:injectionDetected', BlacklistedEvents[i], source, true) -- todo: handle server/client event tagging properly
    end)
end
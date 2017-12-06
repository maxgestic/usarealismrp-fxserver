-- 12 hours = 43200 seconds
local restartTimeHours = 12
local restartTimeSeconds = 12 * 60 * 60
local restartTimeMilliseconds = restartTimeSeconds * 1000
function sendRestartNotification()
    Citizen.CreateThreadNow(function()
        SetTimeout(restartTimeMilliseconds-120000, function()
            print("****sending 1 minute 30 second warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 2 MINUTES!!!")
            end
        end)
        SetTimeout(restartTimeMilliseconds-60000, function()
            print("****sending 30 second warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "^1SERVER RESTARTING IN 60 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
            end
        end)
    end)
end

sendRestartNotification()

-- 12 hours = 43200 seconds
local restartTimeHours = 12
local restartTimeSeconds = 12 * 60 * 60
function sendRestartNotification()
    SetTimeout(restartTimeSeconds-90000, function()
        print("****sending 1 minute 30 second warning...****")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 1 MINUTE!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 1 MINUTE!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 1 MINUTE!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 1 MINUTE!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "SERVER RESTARTING IN 1 MINUTE!!!")
    end)
    SetTimeout(restartTimeSeconds-30000, function()
        print("****sending 30 second warning...****")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "^1SERVER RESTARTING IN 30 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "^1SERVER RESTARTING IN 30 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "^1SERVER RESTARTING IN 30 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
        TriggerClientEvent("chatMessage", -1, "", {0, 0, 0}, "^1SERVER RESTARTING IN 30 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
    end)
end

sendRestartNotification()

-- 12 hours = 43200 seconds
local restartTimeHours = 24
local restartTimeSeconds = restartTimeHours * 60 * 60
local restartTimeMilliseconds = restartTimeSeconds * 1000
function sendRestartNotification()
    Citizen.CreateThreadNow(function()
        SetTimeout(restartTimeMilliseconds-600000, function()
            print("****sending 10 minute warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {255, 255, 255}, "SERVER RESTARTING IN 10 MINUTES!!!")
            end
        end)
        SetTimeout(restartTimeMilliseconds-190000, function()
            print("****sending 1.5 minute warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {255, 255, 255}, "^1SERVER RESTARTING IN 60 SECONDS! ^3DISCONNECT OR RISK DATA LOSS!!!")
            end
        end)
    end)
end

sendRestartNotification()

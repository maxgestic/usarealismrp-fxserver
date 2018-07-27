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

-- TODO: prevent joining on server start within certain time (breaks queue and doesn't let anyone join if people spam join after a restart?)
local SECONDS_TO_DELAY = 30
local ABLE_TO_JOIN = false

Citizen.CreateThread(function()
  Wait(SECONDS_TO_DELAY * 1000)
  ABLE_TO_JOIN = true
end)

AddEventHandler('playerConnecting', function(name, setReason)
  if not ABLE_TO_JOIN then
    print("** Person tried to join too earlier, rejecting connection! **")
    setReason("Please wait " .. SECONDS_TO_DELAY .. " seconds before joining.")
    CancelEvent()
  end
end)

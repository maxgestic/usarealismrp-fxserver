------------------------------------------
-- Server join delay after start up --
------------------------------------------
local SECONDS_TO_DELAY = 120
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

local CHECK_TIME = 60000 -- every minute
------------------------------
-- Send restart message --
-------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(CHECK_TIME)
        local date = os.date("*t", os.time())
        if date.hour == 3 and date.min == 20 then
            print("****sending 10 minute warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {255, 255, 255}, "SERVER RESTARTING IN 10 MINUTES!!!")
            end
        elseif date.hour == 3 and date.min == 29 then
            print("****sending 1 minute warning...****")
            for i = 1, 8 do
                TriggerClientEvent("chatMessage", -1, "", {255, 255, 255}, "^1SERVER RESTARTING IN 60 SECONDS! ^3DISCONNECT NOW OR RISK DATA LOSS!!!")
            end
        end
    end
end)

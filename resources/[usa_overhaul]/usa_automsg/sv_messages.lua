
local sentWarnings = {
    tenMinute = false,
    twoMinute = false
}

local CHECK_TIME = 10000 -- every 10 secs
------------------------------
-- Send restart message --
-------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(CHECK_TIME)
        local date = os.date("*t", os.time())
        if date.hour == 3 and date.min == 20 and not sentWarnings.tenMinute then
            for i = 1, 3 do
                TriggerClientEvent('chatMessage', -1, '^8^*[SERVER] ^3Server restarting in 10 minutes!')
            end
            print('SERVER: Restarting in 10 minutes!')
            sentWarnings.tenMinute = true
        elseif date.hour == 3 and date.min == 28 and not sentWarnings.twoMinute then
            print("SERVER: Restarting!")
            for i = 1, 4 do
                TriggerClientEvent('chatMessage', -1, '^8^*[SERVER] ^rServer is restarting, disconnect now or risk data loss!')
            end
            exports["usa_utils"]:SendPreRestartServerMonitorDiscordMsg()
            sentWarnings.twoMinute = true
        elseif date.hour == 15 and date.min == 20 and not sentWarnings.tenMinute then 
            for i = 1, 3 do
                TriggerClientEvent('chatMessage', -1, '^8^*[SERVER] ^3Server restarting in 10 minutes!')
            end
            print('SERVER: Restarting in 10 minutes!')
            sentWarnings.tenMinute = true
        elseif date.hour == 15 and date.min == 28 and not sentWarnings.twoMinute then 
            print("SERVER: Restarting!")
            for i = 1, 4 do
                TriggerClientEvent('chatMessage', -1, '^8^*[SERVER] ^rServer is restarting, disconnect now or risk data loss!')
            end
            exports["usa_utils"]:SendPreRestartServerMonitorDiscordMsg()
            sentWarnings.twoMinute = true
        end
    end
end)
local CHECK_TIME = 10000 -- every 10 secs
------------------------------
-- Send restart message --
-------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(CHECK_TIME)
        local date = os.date("*t", os.time())
        if date.hour == 3 and date.min == 20 then
            TriggerClientEvent('restart:notify', -1, 10)
            print('SERVER: Restarting in 10 minutes!')
        elseif date.hour == 3 and date.min == 28 then
            for i = 1, 4 do
                TriggerClientEvent('chatMessage', -1, '^8^*[SERVER] ^rServer is restarting, disconnect now or risk data loss!')
                print("SERVER: Restarting!")
            end
        end
    end
end)

RegisterServerEvent('restart:updateStatus')
AddEventHandler('restart:updateStatus', function()
    local date = os.date("*t", os.time())
    if date.hour == 3 then
        local timeUntilRestart = 20 - date.min
        TriggerClientEvent('restart:notify', -1, timeUntilRestart)
    end
end)

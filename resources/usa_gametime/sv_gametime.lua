local h = 6
local m = 0
local s = 0

local gta_seconds_per_real_second = 5
local loopwhole = 1000 / gta_seconds_per_real_second
local looptime = loopwhole % 1 >= 0.5 and math.ceil(loopwhole) or math.floor(loopwhole)

Citizen.CreateThread(function()
    local timer = 0
    while true do
        Citizen.Wait(looptime)
        timer = timer + 1
        s = s + 1
        
        if s >= 60 then
            s = 0
            m = m + 1
        end
        
        if m >= 60 then
            m = 0
            h = h + 1
        end
        
        if h >= 24 then
            h = 0
        end
        
        if timer >= 60 * gta_seconds_per_real_second then
            timer = 0
            TriggerClientEvent("gametime:serversync", -1, h, m, s, gta_seconds_per_real_second)
        end
    end
end)

RegisterServerEvent("gametime:requesttime")
AddEventHandler("gametime:requesttime", function()
    TriggerClientEvent("gametime:serversync", -1, h, m, s, gta_seconds_per_real_second)
end)

TriggerEvent('es:addGroupCommand', 'time', 'admin', function(source, args, char)
    local hour = tonumber(args[2])
    if hour then
        h = hour
        m = 0
        s = 0
        TriggerClientEvent("gametime:serversync", -1, h, m, s, gta_seconds_per_real_second)
        TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has set the time to ^2'..hour..':00:00^0.')
        TriggerClientEvent('usa:notify', source, 'Time has been set, updating...')
    else
        TriggerClientEvent('usa:notify', source, 'Hour to set not specified!')
    end
end, {
    help = "Set the server time.",
    params = {
        { name = "h", help = "hour" }
    }
})
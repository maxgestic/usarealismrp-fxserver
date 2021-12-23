local minipunchDiscordID = "<@178016707292561409>"
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/618094411003199509/IeXSWsln5hPo83l5wles9m62kEAKAJQUry6cZvV0MQzCLa6mYgBZOEVdtwwjpC1MUwoh"

local enabled = true -- let's turn off for now

AddEventHandler('scrambler:injectionDetected', function(name, source, isServerEvent)
    if enabled then
        local eventType = 'client'
        if isServerEvent then
            eventType = 'server'
        end
        local msg = 'Player id [' .. source .. ' / ' .. (GetPlayerIdentifiers(source)[1] or 'N/A') .. '] attempted to use ' .. eventType .. ' event [' .. name .. ']'
        exports.globals:SendDiscordLog(WEBHOOK_URL, msg)
        exports["es_admin"]:BanPlayer(source, "Modding (code injection). If you feel this was a mistake please let a staff member know.")
    end
end)

RegisterServerEvent("utils:toggleInjectionDetection")
AddEventHandler("utils:toggleInjectionDetection", function(status)
    print("setting antimodder banning to: " .. tostring(status))
    enabled = status
end)
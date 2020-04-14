local minipunchDiscordID = "<@178016707292561409>"
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/618094411003199509/IeXSWsln5hPo83l5wles9m62kEAKAJQUry6cZvV0MQzCLa6mYgBZOEVdtwwjpC1MUwoh"

RegisterServerEvent('LCAC:ViolationDetected')
AddEventHandler('LCAC:ViolationDetected', function(reason, ban, ban2)
    local msg = 'Player id [' .. source .. ' / ' .. (GetPlayerIdentifiers(source)[1] or 'N/A') .. '] was banned for LCAC violation!'
    exports.globals:SendDiscordLog(WEBHOOK_URL, msg .. " " .. minipunchDiscordID)
    exports["es_admin"]:BanPlayer(source, "Modding (" .. reason .. "). If you feel this was a mistake please let a staff member know.")
end)
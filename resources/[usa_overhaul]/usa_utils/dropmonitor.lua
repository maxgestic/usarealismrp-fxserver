local CHECK_INTVERAL_SECONDS = 10
local DROPPED_AMOUNT_LG = 20
local DROPPED_AMOUNT_MD = 10
local DROPPED_AMOUNT_SM = 5

local lastRecordedAmount = 0

local WEBHOOK_URL = "https://discordapp.com/api/webhooks/613598358568828938/YVkkUeUF75IrnA9rsnV1A_O-rX---wd4gOl1-T627P1FY5gBmfYx638ZTszo4LxXLEmZ"

local statistics = {
    ["playerDrops"] = 0,
    ["abnormalDrops"] = 0
}

Citizen.CreateThread(function()
    while true do 
        local curCount = #GetPlayers()
        if curCount < lastRecordedAmount then
            local numDropped = lastRecordedAmount - curCount
            if numDropped >= DROPPED_AMOUNT_MD then
                local msg = "\nMedium player drop event detected!\nAt least " .. numDropped .. " player(s) dropped in no more than " .. DROPPED_AMOUNT_MD .. " seconds!"
                SendDiscordLog(WEBHOOK_URL, msg)
            end
        end
        lastRecordedAmount = #GetPlayers()
        Wait(CHECK_INTVERAL_SECONDS * 1000)
    end
end)

AddEventHandler("playerDropped", function(reason)
    if (not reason:find("Exited")) then
        local timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
        local msg = "\nPlayer dropped with reason: " .. reason .. " at " .. timestamp
        SendDiscordLog(WEBHOOK_URL, msg)
        statistics["abnormalDrops"] = statistics["abnormalDrops"] + 1
    end
    statistics["playerDrops"] = statistics["playerDrops"] + 1
end)

function SendDiscordLog(url, msg, stat)
    if stat then
        msg = msg .. "\n**Requested Stat:** " .. statistics[stat]
    end
    PerformHttpRequest(url, function(err, text, headers)
        if text then
            print(text)
        end
    end, "POST", json.encode({
        embeds = {
            {
                description = msg,
                color = 524288,
                author = {
                    name = "Server Monitor"
                }
            }
        }
    }), { ["Content-Type"] = 'application/json' })
end

function SendServerMonitorDiscordMsg(msg, stat)
    SendDiscordLog(WEBHOOK_URL, msg, stat)
end

AddEventHandler('rconCommand', function(commandName, args)
    if commandName:lower() == 'numdrops' then
        RconPrint("Recorded # of drops since last restart: " ..  statistics["playerDrops"])
        RconPrint("\nRecorded # of abnormal drops since last restart: " ..  statistics["abnormalDrops"])
        CancelEvent()
    end
  end)
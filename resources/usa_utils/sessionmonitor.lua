local CHECK_INTVERAL_SECONDS = 35
local DROPPED_AMOUNT_LG = 20
local DROPPED_AMOUNT_MD = 10
local DROPPED_AMOUNT_SM = 5

local lastRecordedAmount = 0

local WEBHOOK_URL = GetConvar("server-monitor-webhook", "")

local SECONDS_BEFORE_ACCEPTING_CONNECTIONS = 30
local SERVER_START_TIME = os.time()

local statistics = {
    ["playerDrops"] = 0,
    ["abnormalDrops"] = 0,
    ["players"] = {
        uniqueCount = 0,
        recorded = {}
    },
    ["startTime"] = os.time(),
    ["crashes"] = {}
}

Citizen.CreateThread(function()
    while true do 
        local curCount = #GetPlayers()
        if curCount < lastRecordedAmount then
            local numDropped = lastRecordedAmount - curCount
            if numDropped >= DROPPED_AMOUNT_MD then
                local date = os.date("*t", os.time())
                if (date.hour == 3 and date.min >= 20 and date.min <= 35) or (date.hour == 15 and date.min >= 20 and date.min <= 35) then
                    -- ignore player drops during server restarts
                    print("SKIPPING PLAYER DROP ALERT, SERVER RESTARTING!!! hour is " .. date.hour .. " and min is " .. date.min)
                else
                    local msg = "\nSignificant player drop event detected!\nAt least " .. numDropped .. " player(s) dropped in no more than " .. CHECK_INTVERAL_SECONDS .. " seconds! <@178016707292561409>"
                    SendDiscordLog(WEBHOOK_URL, msg)
                end
            end
        end
        lastRecordedAmount = #GetPlayers()
        Wait(CHECK_INTVERAL_SECONDS * 1000)
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local secondsFromStart = exports.globals:GetSecondsFromTime(SERVER_START_TIME)
    if secondsFromStart < SECONDS_BEFORE_ACCEPTING_CONNECTIONS then
        print("Preventing connection attempt from " .. playerName .. " due to joining too early.")
        setKickReason("Please wait " .. SECONDS_BEFORE_ACCEPTING_CONNECTIONS - secondsFromStart .. " more seconds before connecting.")
        CancelEvent()
    end
end)

AddEventHandler('es:playerLoaded', function(source, user)
    local ident = GetPlayerIdentifiers(source)[1]
    local entry = statistics["players"].recorded[ident]
    if not entry and ident then
        statistics["players"].recorded[ident] = true
        statistics["players"].uniqueCount = statistics["players"].uniqueCount + 1
    end
end)

AddEventHandler("playerDropped", function(reason)
    TriggerEvent("high_callback:drop", source)

    print("player drop reason: " .. (reason or "NULL"))
    reason = reason:lower()
    if reason:find("game crashed") or reason:find("timed out") then
        local timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
        local msg = "\nPlayer " .. GetPlayerName(source) .. " (#" .. source .. " / " .. GetPlayerIdentifiers(source)[1] .. ") dropped with reason: " .. reason .. " at " .. timestamp
        SendDiscordLog(WEBHOOK_URL, msg)
        statistics["abnormalDrops"] = statistics["abnormalDrops"] + 1
        if not statistics["crashes"][reason] then 
            statistics["crashes"][reason] = 1
        else 
            statistics["crashes"][reason] = statistics["crashes"][reason] + 1
        end
    end
    statistics["playerDrops"] = statistics["playerDrops"] + 1
end)

function SendDiscordLog(url, msg, stat)
    if stat then
        msg = msg .. "\n**Requested Stat:** " .. statistics[stat]
    end
    PerformHttpRequest(url, function(err, text, headers)
    end, "POST", json.encode({
        content = msg
    }), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function SendServerMonitorDiscordMsg(msg, stat)
    SendDiscordLog(WEBHOOK_URL, msg, stat)
end

function SendPreRestartServerMonitorDiscordMsg()
    local abnormalDropPercentage = math.floor(exports.globals:round(statistics["abnormalDrops"] / statistics["playerDrops"], 2) * 100)
    local msg = "\nAt server restart:\nRegular player drops: " .. statistics["playerDrops"] .. "\nAbnormal player drops: " .. statistics["abnormalDrops"] .. "\n# of unique players: " .. statistics["players"].uniqueCount .. "\nAbnormal drop percentage since last restart: " ..  abnormalDropPercentage .. "%" .. "\nMost frequent crash: " .. GetMostFrequentPlayerDropReason()
    SendDiscordLog(WEBHOOK_URL, msg)
end

AddEventHandler('rconCommand', function(commandName, args)
    commandName = commandName:lower()
    if commandName == 'showstats' then
        local abnormalDropPercentage = math.floor(exports.globals:round(statistics["abnormalDrops"] / statistics["playerDrops"], 2) * 100)
        RconPrint("Recorded # of drops since last restart: " ..  statistics["playerDrops"] .. ".")
        RconPrint("\nRecorded # of abnormal drops since last restart: " ..  statistics["abnormalDrops"] .. ".")
        RconPrint("\nRecorded # of unique player joins since last restart: " ..  statistics["players"].uniqueCount .. ".")
        RconPrint("\nAbnormal drop percentage since last restart: " ..  abnormalDropPercentage .. "%")
        RconPrint("\nThe most frequent player drop reason so far is: " .. GetMostFrequentPlayerDropReason())
        RconPrint("\nServer Uptime: " .. exports["globals"]:GetHoursFromTime(statistics["startTime"]) .. " hour(s).")
        CancelEvent()
    elseif commandName == "crashstats" then
        RconPrint("Today's Crash Statistics (reason / count):")
        -- fill an array to sort --
        local crashes = {}
        for reason, count in pairs(statistics["crashes"]) do 
            table.insert(crashes, {reason = reason, count = count})
        end
        -- sort by count --
        table.sort(crashes, function(a, b) 
            if a.count > b.count then
                return true
            else 
                return false
            end
        end)
        -- print --
        for i = 1, #crashes do 
            local reason = crashes[i].reason
            local count = crashes[i].count
            RconPrint("\n" .. reason .. " happened " .. count .. " time(s).")
        end
        CancelEvent()
    elseif commandName == "saferestartmode" then
        local status = args[1]
        local val = true
        if status ~= "true" and status ~= "false" then
            RconPrint("options: true, false")
            return
        elseif status == "true" then
            val = false
        elseif status == "false" then
            val = true
        end
        RconPrint("Safe mode restart: " .. status .. "\n")
        TriggerEvent("anticheese:toggleViolationDetection", val)
        TriggerEvent("LCAC:setEnabled", val)
        CancelEvent()
    end
end)

function GetMostFrequentPlayerDropReason()
    local mostFreq = {
        count = -1,
        str = "N/A"
    }
    for reason, count in pairs(statistics["crashes"]) do
        if count > mostFreq.count then 
            mostFreq.count = count
            mostFreq.str = reason
        end
    end
    return mostFreq.str
end

function RunPreRestartSaveEvents()
    print("[usa_utils] Triggering pre-restart save events!")
    TriggerEvent("cultivation:saveAllPlants")
end

-- save disk space by compacting this stock CouchDB "_global_changes" database --
PerformHttpRequest("http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. "/_global_changes/_compact", function(err, rText, headers)
end, "POST", "", {["Content-Type"] = "application/json", Authorization = "Basic " .. exports["essentialmode"]:getAuth()})
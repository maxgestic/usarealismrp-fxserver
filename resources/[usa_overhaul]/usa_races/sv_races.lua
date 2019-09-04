local hostedRaces = {}

local hasMenuOpen = {} -- help update clients in real time

local MINIMUM_PARTICIPANTS = 0

TriggerEvent('es:addCommand', 'hostrace', function(source, args, char, location)
    local bet = math.abs(tonumber(args[2]))
    local minutes = tonumber(args[3])
    table.remove(args, 1)
    table.remove(args, 1)
    table.remove(args, 1)
    local title = table.concat(args, " ")
    if not bet then 
        TriggerClientEvent("usa:notify", source, "You must enter a bet amount for this race!")
        return
    end
    if not minutes then 
        TriggerClientEvent("usa:notify", source, "You must enter how many minutes from now the race should start!")
        return
    end
    if hostedRaces[source] then
        TriggerClientEvent("usa:notify", source, "You are already hosting a race!")
        return
    end
    if title == "" or not title then 
        title = char.getName() .. "'s Race"
    end
    TriggerClientEvent("races:getNewRaceCoords", source, bet, minutes, title)
end, {
    help = "Host a race to bet on.",
    params = {
        { name = "bet", help = "The betting amount for the race." },
        { name = "minutes", help = "The minutes until the race starts." },
        { name = "title", help = "The title of the race." }
    }
})

TriggerEvent('es:addCommand', 'joinrace', function(source, args, char)
    local races = {}
    for hostId, raceInfo in pairs(hostedRaces) do 
        table.insert(races, raceInfo)
    end
    TriggerClientEvent("races:toggleMenu", source, true, {races = races, myId = source})
end, {
    help = "See available races to join."
})

AddEventHandler("playerDropped", function(reason) -- cleaning up
    if hasMenuOpen[source] then 
        hasMenuOpen = nil
    end
end)

RegisterNetEvent("races:openedRaceList")
AddEventHandler("races:openedRaceList", function()
    if not hasMenuOpen[source] then 
        hasMenuOpen[source] = true
    end
end)

RegisterNetEvent("races:closedRaceList")
AddEventHandler("races:closedRaceList", function()
    if hasMenuOpen[source] then
        hasMenuOpen[source] = nil
    end
end)

RegisterNetEvent("races:askStartUntilTime")
AddEventHandler("races:askStartUntilTime", function(host)
    local raceInfo = hostedRaces[host]
    local timeUntilStartStr = "The race is going to begin in "
    local secondsUntilStart = raceInfo.minutesUntilStart * 60 - GetSecondsFromStart(raceInfo.registerTimeServer)
    local minsTillStart = math.floor(secondsUntilStart / 60)
    if minsTillStart > 0 then 
        timeUntilStartStr = timeUntilStartStr .. "less than a minute! Get ready to start!"
    else 
        timeUntilStartStr = timeUntilStartStr .. minsTillStart .. " minute(s)!"
    end
    TriggerClientEvent("usa:notify", source, timeUntilStartStr)
end)

RegisterNetEvent("races:raceWon")
AddEventHandler("races:raceWon", function(host)
    if hostedRaces[host] then 
        hostedRaces[host].winner = source
        -- end race --
        local pot = 0
        for i = 1, #hostedRaces[host].participants do 
            local participant = hostedRaces[host].participants[i]
            TriggerClientEvent("races:endRace", participant.source)
            local isWinner = participant.source == source
            if not isWinner then 
                pot = pot + hostedRaces[host].bet
                local participantChar = exports["usa-characters"]:GetCharacter(participant.source)
                participantChar.removeMoney(hostedRaces[host].bet)
                print("removing $" .. hostedRaces[host].bet .. " from source " .. participant.source)
            end
        end
        -- reward winner --
        local char = exports["usa-characters"]:GetCharacter(source)
        char.giveMoney(pot)
        TriggerClientEvent("usa:notify", hostedRaces[host].winner, "You ~g~won~w~! You earned: $" .. pot, "^0You ^2won^0! You earned: $" .. pot)
        print("player won $" .. pot .. " for winning a race!")
        hostedRaces[host] = nil
        UpdateClientsRealtime()
    end
end)

RegisterNetEvent("races:leaveRace")
AddEventHandler("races:leaveRace", function(host, noNotify)
    if hostedRaces[host] and not hostedRaces[host].started then 
        for i = 1, #hostedRaces[host].participants do 
            local participant = hostedRaces[host].participants[i]
            if participant.source == source then 
                if not noNotify then
                    TriggerClientEvent("races:endRace", participant.source, "You left the race!")
                end
                table.remove(hostedRaces[host].participants, i)
                local count = GetHostedRaceParticipantCount(host)
                if count < 0 then 
                    hostedRaces[host] = nil
                end
                UpdateClientsRealtime()
                return
            end
        end
    else 
        TriggerClientEvent("usa:notify", source, "Can't leave now! Race in progress!")
    end
end)

RegisterNetEvent("races:removeParticipant")
AddEventHandler("races:removeParticipant", function(host)
    if hostedRaces[host] then 
        for i = 1, #hostedRaces[host].participants do 
            local participant = hostedRaces[host].participants[i]
            if participant.source == source then 
                table.remove(hostedRaces[host].participants, i)
                local count = GetHostedRaceParticipantCount(host)
                if count <= 0 then 
                    hostedRaces[host] = nil
                end
                UpdateClientsRealtime()
                return
            end
        end
    else 
        TriggerClientEvent("usa:notify", source, "Can't leave now! Race in progress!")
    end
end)

RegisterNetEvent("races:joinRace")
AddEventHandler("races:joinRace", function(host)
    if not hostedRaces[host] then 
        TriggerClientEvent("usa:notify", source, "Invalid race!")
        return
    end
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.get("job") ~= "civ" then
        TriggerClientEvent("usa:notify", source, "Can't race while on the job!")
        return
    end
    if char.get("money") < hostedRaces[host].bet then
        TriggerClientEvent("usa:notify", source, "Not enough cash to enter race!")
        return
    end
    if hostedRaces[host].started then 
        TriggerClientEvent("usa:notify", source, "That race already started!")
        return
    end
    local newRacer = {name = char.getName(), source = char.get("source")}
    for i = 1, #hostedRaces[host].participants do -- notify racers that a new racer joined
        local r = hostedRaces[host].participants[i]
        TriggerClientEvent("usa:notify", r.source, newRacer.name .. " has joined the race!", "^0" .. newRacer.name .. " has joined the race!")
    end
    table.insert(hostedRaces[host].participants, newRacer)
    local timeUntilStartStr = "The race is going to begin in "
    local secondsUntilStart = hostedRaces[host].minutesUntilStart * 60 - GetSecondsFromStart(hostedRaces[host].registerTimeServer)
    local minsTillStart = math.floor(secondsUntilStart / 60)
    if minsTillStart <= 0 then 
        timeUntilStartStr = timeUntilStartStr .. "less than a minute! Hurry up and get to the waypoint!"
    else 
        timeUntilStartStr = timeUntilStartStr .. minsTillStart .. " minute(s)! Get to the waypoint!"
    end
    TriggerClientEvent("races:confirmJoin", source, hostedRaces[host], timeUntilStartStr)
    UpdateClientsRealtime()
end)

RegisterNetEvent("races:deleteRace")
AddEventHandler("races:deleteRace", function(host)
    local raceInfo = hostedRaces[host]
    for i = 1, #raceInfo.participants do 
        TriggerClientEvent("races:endRace", raceInfo.participants[i].source)
    end
    hostedRaces[host] = nil
    UpdateClientsRealtime()
end)

RegisterNetEvent("races:gotNewRaceCoords")
AddEventHandler("races:gotNewRaceCoords", function(start, finish, bet, minutes, title)
    local char = exports["usa-characters"]:GetCharacter(source)
    local newRace = {
        host = {
            source = source,
            name = char.getName()
        },
        title = title,
        participants = {},
        bet = bet,
        started = false,
        registerTimeServer = os.time(),
        minutesUntilStart = minutes,
        start = {
            coords = start
        },
        finish = {
            coords = finish
        }
    }
    hostedRaces[source] = newRace
    TriggerClientEvent("usa:notify", source, "You have registered a race with bet amount of $" .. newRace.bet, "^0You have registered a race with bet amount of $" .. newRace.bet ..". It will begin in " .. minutes .. " minute(s)!")
    UpdateClientsRealtime()
end)

--* race start event here, send start event to all participating clients
Citizen.CreateThread(function()
    local lastRecordedSecond = -1
    while true do 
        for hostId, raceInfo in pairs(hostedRaces) do
            local participants = raceInfo.participants
            local secondsUntilStart = raceInfo.minutesUntilStart * 60 - GetSecondsFromStart(raceInfo.registerTimeServer)
            if not raceInfo.started then
                if secondsUntilStart == 30 then
                    if lastRecordedSecond ~= secondsUntilStart then
                        lastRecordedSecond = secondsUntilStart 
                        for i = 1, #participants do
                            TriggerClientEvent("usa:notify", participants[i].source, "Race starts in ~y~30 seconds~w~!", "^0Race starts in ^330 seconds^0! Stay near the starting point!")
                            if not participants[i].waypointSet then 
                                TriggerClientEvent("races:setWaypoint", participants[i].source, raceInfo.finish.coords, "Race Finish")
                                participants[i].waypointSet = true
                            end
                            TriggerEvent("InteractSound_SV:PlayOnOne", participants[i].source, "1beep", 0.7)
                        end
                    end
                elseif secondsUntilStart <= 10 then
                    if #participants > MINIMUM_PARTICIPANTS then
                        if secondsUntilStart <= 10 and secondsUntilStart >= 1 then -- 10 second count down
                            if lastRecordedSecond ~= secondsUntilStart then
                                lastRecordedSecond = secondsUntilStart 
                                for i = 1, #participants do
                                    if secondsUntilStart >= 5 then
                                        TriggerClientEvent("chatMessage", participants[i].source, "", {}, "^1" .. secondsUntilStart)
                                    else 
                                        TriggerClientEvent("chatMessage", participants[i].source, "", {}, "^3" .. secondsUntilStart)
                                    end
                                    TriggerEvent("InteractSound_SV:PlayOnOne", participants[i].source, "1beep", 0.7)
                                end
                            end
                        elseif secondsUntilStart == 0 then -- start race
                            for i = 1, #participants do
                                TriggerClientEvent("races:startRace", participants[i].source)
                                TriggerEvent("InteractSound_SV:PlayOnOne", participants[i].source, "race-start-beep", 0.45)
                            end
                            raceInfo.started = true
                        end
                    else              
                        EndRace(hostId, "Not enough participants!")
                    end
                end
            end
        end
        Wait(10)
    end
end)

function EndRace(host, reason)
    for i = 1, #hostedRaces[host].participants do 
        local participant = hostedRaces[host].participants[i]
        TriggerClientEvent("races:endRace", participant.source, reason)
    end
    hostedRaces[host] = nil
    UpdateClientsRealtime()
end

function GetSecondsFromStart(time)
	return math.floor(os.difftime(os.time(), time))
end

function UpdateClientsRealtime()
    for id, open in pairs(hasMenuOpen) do 
        TriggerClientEvent("races:updateRaces", id, hostedRaces)
    end
end

function GetHostedRaceParticipantCount(host)
    local count = 0
    for i = 1, #hostedRaces[host].participants do 
        count = count + 1
    end
    return count
end
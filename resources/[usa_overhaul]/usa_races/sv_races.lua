local hostedRaces = {}

TriggerEvent('es:addCommand', 'hostrace', function(source, args, char, location)
    local bet = tonumber(args[2])
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
    TriggerClientEvent("races:toggleMenu", source, true, races)
end, {
    help = "See available races to join."
})

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
        -- TODO: update GUI here
        -- reward winner --
        local char = exports["usa-characters"]:GetCharacter(source)
        char.giveMoney(pot)
        TriggerClientEvent("usa:notify", hostedRaces[host].winner, "You ~g~won~w~! You earned: $" .. pot, "^0You ^2won^0! You earned: $" .. pot)
        print("player won $" .. pot .. " for winning a race!")
        hostedRaces[host] = nil
    end
end)

RegisterNetEvent("races:removeParticipant")
AddEventHandler("races:removeParticipant", function(host)
    if hostedRaces[host] then 
        for i = 1, #hostedRaces[host].participants do 
            local participant = hostedRaces[host].participants[i]
            if participant.source == source then 
                table.remove(hostedRaces[host].participants, i)
                --- TODO: update GUI here for all clients with GUI open
                return
            end
        end
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
        TriggerClientEvent("usa:notify", r.get("source"), newRacer.name .. " has joined the race!", "^0" .. newRacer.name .. " has joined the race!")
    end
    table.insert(hostedRaces[host].participants, newRacer)
    -- TODO: update GUI here for all clients with GUI open
    local timeUntilStartStr = "The race is going to begin in "
    local secondsUntilStart = hostedRaces[host].minutesUntilStart * 60 - GetSecondsFromStart(hostedRaces[host].registerTimeServer)
    local minsTillStart = math.floor(secondsUntilStart / 60)
    if minsTillStart <= 0 then 
        timeUntilStartStr = timeUntilStartStr .. "less than a minute! Hurry up and get to the waypoint!"
    else 
        timeUntilStartStr = timeUntilStartStr .. minsTillStart .. " minute(s)! Get to the waypoint!"
    end
    TriggerClientEvent("races:confirmJoin", source, hostedRaces[host], timeUntilStartStr)
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
end)

--* race start event here, send start event to all participating clients
Citizen.CreateThread(function()
    local lastRecordedSecond = -1
    while true do 
        for hostId, raceInfo in pairs(hostedRaces) do
            local secondsUntilStart = raceInfo.minutesUntilStart * 60 - GetSecondsFromStart(raceInfo.registerTimeServer)
            if not raceInfo.started and secondsUntilStart <= 10 then
                local participants = raceInfo.participants
                if #participants > 1 then
                    if secondsUntilStart <= 10 and secondsUntilStart >= 1 then -- 10 second count down
                        if lastRecordedSecond ~= secondsUntilStart then
                            lastRecordedSecond = secondsUntilStart 
                            for i = 1, #participants do
                                if secondsUntilStart >= 5 then
                                    TriggerClientEvent("chatMessage", participants[i].source, "", {}, "^1" .. secondsUntilStart)
                                else 
                                    TriggerClientEvent("chatMessage", participants[i].source, "", {}, "^3" .. secondsUntilStart)
                                end
                                if not participants[i].waypointSet then 
                                    TriggerClientEvent("races:setWaypoint", participants[i].source, raceInfo.finish.coords, "Race Finish")
                                    participants[i].waypointSet = true
                                end
                            end
                        end
                    elseif secondsUntilStart == 0 then -- start race
                        for i = 1, #participants do
                            TriggerClientEvent("races:startRace", participants[i].source)
                        end
                        raceInfo.started = true
                    end
                else
                    EndRace(hostId)
                end
            end
        end
        Wait(10)
    end
end)

function EndRace(host)
    for i = 1, #hostedRaces[host].participants do 
        local participant = hostedRaces[host].participants[i]
        TriggerClientEvent("races:endRace", participant.source)
    end
    hostedRaces[host] = nil
end

function GetSecondsFromStart(time)
	return math.floor(os.difftime(os.time(), time))
end
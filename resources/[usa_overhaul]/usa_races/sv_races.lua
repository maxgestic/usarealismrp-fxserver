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
        { name = "bet", help = "The betting amount for the race." }
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

RegisterNetEvent("races:removeParticipant")
AddEventHandler("races:removeParticipant", function(host)
    if hostedRaces[host] then 
        for i = 1, #hostedRaces[host].participants do 
            local participant = hostedRaces[host].participants[i]
            if participant.source == source then 
                table.remove(hostedRaces[host].participants, i)
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
    --[[
    if host == source then 
        TriggerClientEvent("usa:notify", source, "You can't join your own race!")
        return
    end
    --]]
    local char = exports["usa-characters"]:GetCharacter(source)
    table.insert(hostedRaces[host].participants, {name = char.getName(), source = char.get("source")})
    -- TODO: update race data for all clients with GUI open here so it updats in "realtime"
    --riggerClientEvent("usa:notify", source, "You have been enrolled in " .. hostedRaces[host].title .. "! Head to the waypoint!", "^0You have been enrolled in " .. hostedRaces[host].title .. "! Head to the waypoint!")
    TriggerClientEvent("races:confirmJoin", source, hostedRaces[host])
end)

RegisterNetEvent("races:gotNewRaceCoords")
AddEventHandler("races:gotNewRaceCoords", function(start, finish, bet, minutes, title, registerTime)
    local char = exports["usa-characters"]:GetCharacter(source)
    local newRace = {
        host = {
            source = source,
            name = char.getName()
        },
        title = title,
        participants = {},
        bet = bet,
        registerTime = registerTime,
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
local hostedRaces = {}

TriggerEvent('es:addCommand', 'hostrace', function(source, args, char)
    print("hostrace command entered")
    local bet = tonumber(args[2])
    if not bet then 
        TriggerClientEvent("usa:notify", source, "You must enter a bet amount for this race!")
        return
    end
    if hostedRaces[source] then
        TriggerClientEvent("usa:notify", source, "You are already hosting a race!")
        return
    end
    local char = exports["usa-characters"]:GetCharacter(source)
    local newRace = {
        host = {
            source = source,
            name = char.getName()
        },
        title = "Default Race Title",
        participants = {},
        bet = bet
    }
    hostedRaces[source] = newRace
    TriggerClientEvent("usa:notify", source, "You have registered a race with bet amount of $" .. newRace.bet)
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

RegisterNetEvent("races:joinRace")
AddEventHandler("races:joinRace", function(host)
    if not hostedRaces[host] or host == source then 
        TriggerClientEvent("usa:notify", source, "Invalid race!")
        return
    end
    local char = exports["usa-characters"]:GetCharacter(source)
    table.insert(hostedRaces[host].participants, {name = char.getName(), source = char.get("source")})
end)
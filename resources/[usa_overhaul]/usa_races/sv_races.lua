local hostedRaces = {}

TriggerEvent('es:addCommand', 'hostrace', function(source, args, char)
    local bet = tonumber(args[2])
    if hostedRaces[source] then
        TriggerClientEvent("usa:notify", source, "You are already hosting a race!")
        return
    end
    local newRace = {
        host = source,
        participants = {},
        bet = bet
    }
    hostedRaces[source] = newRace
end, {
    help = "Host a race to bet on.",
    params = {
        { name = "bet", help = "The betting amount for the race." }
    }
})

TriggerEvent('es:addCommand', 'joinrace', function(source, args, char)
    TriggerClientEvent("races:openMenu", source)
end, {
    help = "See available races to join."
})
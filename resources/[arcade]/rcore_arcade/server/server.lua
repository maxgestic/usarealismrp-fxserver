RegisterNetEvent("rcore_arcade:buyTicket")
AddEventHandler("rcore_arcade:buyTicket", function(ticket)
    local data = Config.ticketPrice[ticket]
    local char = exports["usa-characters"]:GetCharacter(source)
    local cash = char.get("money")

    if cash >= data.price then
        char.removeMoney(data.price);
        TriggerClientEvent("rcore_arcade:ticketResult", source, ticket);
    else
        TriggerClientEvent("rcore_arcade:nomoney", source);
    end
end)
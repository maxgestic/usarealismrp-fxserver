RegisterServerEvent("blackjack:win")
AddEventHandler("blackjack:win", function(bet)
    print("won blackjack game, bet: " .. bet)
    if tonumber(bet) < 20000 then
        local player = exports["essentialmode"]:getPlayerFromId(source)
        player.setActiveCharacterData("money", player.getActiveCharacterData("money") + bet)
    else
        TriggerClientEvent("usa:notify", source, "Your bet was too high to pay out.")
    end
end)

RegisterServerEvent("blackjack:lose")
AddEventHandler("blackjack:lose", function(bet)
    print("lost blackjack game, bet: " .. bet)
    if tonumber(bet) >= 0 then
        local player = exports["essentialmode"]:getPlayerFromId(source)
        player.setActiveCharacterData("money", player.getActiveCharacterData("money") - bet)
    end
end)

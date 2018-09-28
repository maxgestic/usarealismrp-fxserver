RegisterServerEvent("blackjack:win")
AddEventHandler("blackjack:win", function(bet)
    --print("won blackjack game, bet: " .. bet)
    if tonumber(bet) < 20000 then
        local player = exports["essentialmode"]:getPlayerFromId(source)
        player.setActiveCharacterData("money", player.getActiveCharacterData("money") + bet)
    else
        TriggerClientEvent("usa:notify", source, "Your bet was too high to pay out.")
    end
end)

RegisterServerEvent("blackjack:lose")
AddEventHandler("blackjack:lose", function(bet)
    --print("lost blackjack game, bet: " .. bet)
    if tonumber(bet) >= 0 then
        local player = exports["essentialmode"]:getPlayerFromId(source)
        player.setActiveCharacterData("money", player.getActiveCharacterData("money") - bet)
    end
end)

RegisterServerEvent("blackjack:checkMoney")
AddEventHandler("blackjack:checkMoney", function(bet)
  --print("Checking player money for casino bet of: " .. bet)
  local player = exports["essentialmode"]:getPlayerFromId(source)
  local money = player.getActiveCharacterData("money")
  if tonumber(bet) <= money then
    --print("Player had enough money to bet!")
    TriggerClientEvent("blackjack:startNewGame", source)
  else
    --print("Player did not have enough money to bet!")
    TriggerClientEvent("usa:notify", source, "You don't have that much to bet!")
  end
end)

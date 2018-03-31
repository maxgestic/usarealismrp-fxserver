--# made by: minipunch
--# for: USA REALISM RP

local BARBER_FEE = 300

RegisterServerEvent("barber:checkout")
AddEventHandler("barber:checkout", function(customizations, property)
	local usource = source
  local player = exports["essentialmode"]:getPlayerFromId(usource)
  local player_money = player.getActiveCharacterData("money")
  --local cost = CalculateCost(purchased_tattoos)
  --print("checking out with total tattoo cost(s) of : $" .. cost)
  if player_money >= BARBER_FEE then
    player.setActiveCharacterData("money", player_money - BARBER_FEE)
    local appearance = player.getActiveCharacterData("appearance")
		appearance.head_customizations = customizations
    player.setActiveCharacterData("appearance", appearance)
		print("barber shop customizations saved!")
		TriggerClientEvent("usa:notify", usource, "~y~You payed: ~w~$" .. BARBER_FEE)
    if property then
      TriggerEvent("properties:addMoney", property.name, math.floor(0.75 * BARBER_FEE, 0))
    end
  else
    TriggerClientEvent("usa:notify", usource, "You don't have enough money to pay the total: $" .. cost)
  end
end)

local SV_ITEMS = { -- must be kept in sync with one in cl_bike-shop.lua --
  {name = "BMX", price = 500, hash = 1131912276},
  {name = "Cruiser", price = 500, hash = 448402357},
  {name = "Fixster", price = 850, hash = -836512833},
  {name = "Scorcher", price = 1200, hash = -186537451},
  {name = "TriBike", price = 1450, hash = 1127861609}
}

RegisterServerEvent("bikeShop:requestPurchase")
AddEventHandler("bikeShop:requestPurchase", function(index)
  local userSource = source
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local bike = SV_ITEMS[index]
  local user_money = user.getActiveCharacterData("money")
  if bike.price <= user_money then -- see if user has enough money
    user.setActiveCharacterData("money", user_money - bike.price)
    TriggerClientEvent("usa:notify", userSource, "You have purchased a ~r~" .. bike.name .. ".")
    TriggerClientEvent("bikeShop:spawnBike", userSource, bike)
    TriggerClientEvent("bikeShop:toggleMenu", userSource, false)
  else
    TriggerClientEvent("usa:notify", userSource, "Not enough money!")
  end
end)

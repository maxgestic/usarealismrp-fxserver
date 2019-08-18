local pets = {
	["Cat"]  		= {hash = 1462895032, price = 600},
	["Husky"] 		= {hash = 1318032802, price = 1050},
	["Pug"] 		= {hash = 1832265812, price = 650},
	["Poodle"] 		= {hash = 1125994524, price = 950},
	["Rottweiler"] 	= {hash = -1788665315, price = 900},
	["Retriever"] 	= {hash = 882848737, price = 900},
	["Shepherd"] 	= {hash = 1126154828, price = 900},
	["Westy"] 		= {hash = -1384627013, price = 650}
}

TriggerEvent('es:addCommand', 'pet', function(source, args, user)
  local option = args[2]
  if option == "tp" then
    TriggerClientEvent("pets:TP", source)
  elseif option == "veh" then
    TriggerClientEvent("pets:LoadIntoVehicle", source)
  elseif option == "stay" then
    TriggerClientEvent("pets:stay", source)
  elseif option == "name" then
    TriggerClientEvent("pets:toggleName", source)
  elseif option == "store" then
    TriggerEvent("pets:storePet", source)
  elseif option == "retrieve" then
    TriggerEvent("pets:retrievePet", source)
  else
    TriggerClientEvent("usa:notify", source, "Invalid options. Options: veh, tp, stay, name, store, retrieve")
  end
end, {
	help = "[veh] Load pet into vehicle, [tp] bring pet to you, [stay] make pet stay, or [name] to toggle name display, [store] to store pet, [retrieve] to retrieve pet",
	params = {
		{ name = "option", help = "Options: 'veh', 'tp', 'stay', 'name', 'store', 'retrieve' without the quote marks" }
	}
})

RegisterServerEvent("pets:checkMoney")
AddEventHandler("pets:checkMoney", function(name, info, x, y, z, my_pet)
  local player_money = exports["usa-characters"]:GetCharacterField(source, "money")
  local petPrice = pets[name].price
  if player_money >= petPrice then
    -- save pet to player --
    local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
    if not pets then pets = {} end
    if #pets > 0 then
      TriggerClientEvent("usa:notify", source, "Sorry. You can only own one pet at the moment!")
      return
    end
    -- remove money --
		exports["usa-characters"]:SetCharacterField(source, "money", player_money - petPrice)
    -- spawn pet --
    TriggerClientEvent("pets:givePet", source, name, info.hash, x, y, z)
    local new_pet = {
      hash = info.hash,
      name = my_pet.name,
      showName = true,
      price = petPrice
    }
    table.insert(pets, new_pet)
		exports["usa-characters"]:SetCharacterField(source, "pets", pets)
    TriggerClientEvent("usa:notify", source, "You have purchased a " .. name .. " for $" .. petPrice .. "!")
  else
    TriggerClientEvent("usa:notify", source, "Not enough money for that pet!")
  end
end)

RegisterServerEvent("pets:sellPet")
AddEventHandler("pets:sellPet", function(my_pet)
  local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
  if not pets then pets = {} end
  if #pets > 0 then
    TriggerClientEvent("usa:notify", source, "You have returned " .. pets[1].name .. "!")
    TriggerClientEvent("pets:remove", source)
    table.remove(pets, 1) -- remove pet (only one ownable at the time of this writing)
		exports["usa-characters"]:SetCharacterField(source, "pets", pets)
  else
    TriggerClientEvent("usa:notify", source, "No pets to sell!")
  end
end)

RegisterServerEvent("pets:changeName")
AddEventHandler("pets:changeName", function(name)
  local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
  if #pets > 0 then
    local copy = pets[1].name
    pets[1].name = name
    exports["usa-characters"]:SetCharacterField(source, "pets", pets)
    TriggerClientEvent("usa:notify", source, copy .. "'s name has been changed to: " .. name)
  end
end)

RegisterServerEvent("pets:showName")
AddEventHandler("pets:showName", function(status)
  local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
  if #pets > 0 then
    pets[1].showName = status
    exports["usa-characters"]:SetCharacterField(source, "pets", pets)
  end
end)

RegisterServerEvent("pets:deleteForAll")
AddEventHandler("pets:deleteForAll", function(netId)
  TriggerClientEvent("pets:deleteForAll", -1, netId)
end)

RegisterServerEvent("pets:storePet")
AddEventHandler("pets:storePet", function(source)
  local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
  if #pets > 0 then
    if not pets[1].stored then
      pets[1].stored = true -- use pets at index 1 because at the time of this writing, only 1 pet is ownable
      exports["usa-characters"]:SetCharacterField(source, "pets", pets)
      TriggerClientEvent("pets:storePet", source)
    else
      TriggerClientEvent("usa:notify", source, "Your pet is already stored!")
    end
  else
    TriggerClientEvent("usa:notify", source, "You do not have any pets to store!")
  end
end)

RegisterServerEvent("pets:retrievePet")
AddEventHandler("pets:retrievePet", function(source)
  local pets = exports["usa-characters"]:GetCharacterField(source, "pets")
  if #pets > 0 then
    if pets[1].stored then
      pets[1].stored = false
      exports["usa-characters"]:SetCharacterField(source, "pets", pets)
      TriggerClientEvent("pets:setPet", source, pets)
    else
      TriggerClientEvent("usa:notify", source, "Your pet is not stored!")
    end
  else
    TriggerClientEvent("usa:notify", source, "You do not have any pets to retrieve!")
  end
end)

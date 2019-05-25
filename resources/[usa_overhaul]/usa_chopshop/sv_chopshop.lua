local VEHICLES = {
  --{name = "ORACLE", reward = 5000},
  {name = "ORACLE2", reward = 300},
  {name = "FLATBED", reward = 400},
  {name = "SADLER", reward = 400}, -- ford 150
  {name = "EMPEROR", reward = 100},
  {name = "BFINJECT", reward = 150},
  {name = "SANCHEZ02", reward = 200},
  {name = "REBEL02", reward = 300},
  {name = "SEMINOLE", reward = 250},
  {name = "BOBCATXL", reward = 300},
  {name = "BUFFALO", reward = 400}, -- chrystler 300
  {name = "RUINER", reward = 250},
  {name = "BLISTA2", reward = 300},
  {name = "TORNADO3", reward = 150},
  {name = "SABREGT", reward = 400}, -- ford mustang boss
  {name = "FUGITIVE", reward = 400}, -- masseratti quattroporte
  {name = "DUBSTA", reward = 300},
  {name = "PEYOTE", reward = 250},
  {name = "SANDKING", reward = 300}
}

local vehiclesWanted = {}

RegisterServerEvent("chopshop:startJob")
AddEventHandler("chopshop:startJob", function()
  local usource = source
  for player, vehicles in pairs(vehiclesWanted) do
    if player == source then
      return
    end
  end
  local wanted_vehicles = {}
  for i = 1, 5 do
    local random_vehicle = VEHICLES[math.random(#VEHICLES)]
    table.insert(wanted_vehicles, random_vehicle)
    print("inserted: " .. random_vehicle.name)
  end
  vehiclesWanted[source] = wanted_vehicles
  TriggerClientEvent("chopshop:startJob", usource, wanted_vehicles)
end)

RegisterServerEvent("chopshop:reward")
AddEventHandler("chopshop:reward", function(veh_name, damage, property)
  local usource = source
  local user = exports["essentialmode"]:getPlayerFromId(usource)
  for player, vehicles in pairs(vehiclesWanted) do
    if player == source then
      for i = #vehicles, 1, -1 do
        if string.lower(vehicles[i].name) == string.lower(veh_name) then
          local user_money = user.getActiveCharacterData("money")
          local reward = GetRewardFromName(veh_name)
          if (reward - damage) >= 0 then
            user.setActiveCharacterData("money", user_money + (reward - damage))
            TriggerClientEvent("usa:notify", usource, "~y~Reward:~w~ $" .. (reward - damage) .. "\nThere was $" .. damage .. " in damages.")
          	if property then
          		-- give money to property owner --
          		TriggerEvent("properties:addMoney", property.name, math.floor(0.75 * (reward - damage), 0))
          	end
          else
            TriggerClientEvent("usa:notify", usource, "This vehicle is too damaged. I am not giving you any money for this!")
          end
          print("chop shop turn in damage: -$" .. damage)
          table.remove(vehiclesWanted[source], i)
        end
      end
    end
  end
end)

RegisterServerEvent('chopshop:resetJob')
AddEventHandler('chopshop:resetJob', function()
  vehiclesWanted[source] = nil
end)

function GetRewardFromName(name)
  for i = 1, #VEHICLES do
    if string.lower(name) == string.lower(VEHICLES[i].name) then
      return VEHICLES[i].reward
    end
  end
  return 0
end

AddEventHandler('playerDropped', function()
  vehiclesWanted[source] = nil
end)

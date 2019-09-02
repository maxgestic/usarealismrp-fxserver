local VEHICLES = {
  --{name = "ORACLE", reward = 5000},
  {name = "ORACLE2", reward = 400},
  {name = "FLATBED", reward = 500},
  {name = "SADLER", reward = 500},
  {name = "EMPEROR", reward = 200},
  {name = "BFINJECT", reward = 250},
  {name = "SANCHEZ02", reward = 300},
  {name = "REBEL02", reward = 400},
  {name = "SEMINOLE", reward = 350},
  {name = "BOBCATXL", reward = 400},
  {name = "BUFFALO", reward = 500},
  {name = "RUINER", reward = 350},
  {name = "BLISTA2", reward = 400},
  {name = "TORNADO3", reward = 250},
  {name = "SABREGT", reward = 500},
  {name = "FUGITIVE", reward = 500},
  {name = "DUBSTA", reward = 400},
  {name = "PEYOTE", reward = 350},
  {name = "SANDKING", reward = 400}
}

local vehiclesWanted = {}

RegisterServerEvent("chopshop:startJob")
AddEventHandler("chopshop:startJob", function()
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
  TriggerClientEvent("chopshop:startJob", source, wanted_vehicles)
end)

RegisterServerEvent("chopshop:reward")
AddEventHandler("chopshop:reward", function(veh_name, damage, property)
  local char = exports["usa-characters"]:GetCharacter(source)
  for player, vehicles in pairs(vehiclesWanted) do
    if player == source then
      for i = #vehicles, 1, -1 do
        if string.lower(vehicles[i].name) == string.lower(veh_name) then
          local reward = GetRewardFromName(veh_name)
          if (reward - damage) >= 0 then
            char.giveMoney((reward - damage))
            print('CHOPSHOP: Player '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has received money['..reward..'] minus damage['..damage..'] after chopping vehicle!')
            TriggerClientEvent("usa:notify", source, "~y~Reward:~w~ $" .. (reward - damage) .. "\nThere was $" .. damage .. " in damages.")
          else
            TriggerClientEvent("usa:notify", source, "This vehicle is too damaged. I am not giving you any money for this!")
          end
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

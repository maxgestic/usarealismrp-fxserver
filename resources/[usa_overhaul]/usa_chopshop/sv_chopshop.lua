local VEHICLES = {
  --{name = "ORACLE", reward = 5000},
  {name = "ORACLE2", reward = 600},
  {name = "FLATBED", reward = 700},
  {name = "SADLER", reward = 700},
  {name = "EMPEROR", reward = 500},
  {name = "BFINJECT", reward = 450},
  {name = "SANCHEZ02", reward = 500},
  {name = "REBEL02", reward = 600},
  {name = "SEMINOLE", reward = 550},
  {name = "BOBCATXL", reward = 600},
  {name = "BUFFALO", reward = 700},
  {name = "RUINER", reward = 550},
  {name = "BLISTA2", reward = 600},
  {name = "TORNADO3", reward = 450},
  {name = "SABREGT", reward = 700},
  {name = "FUGITIVE", reward = 700},
  {name = "DUBSTA", reward = 600},
  {name = "PEYOTE", reward = 550},
  {name = "SANDKING", reward = 600}
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

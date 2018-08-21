local VEHICLES = {
  --{name = "ORACLE", reward = 5000},
  {name = "ORACLE2", reward = 5000},
  {name = "FLATBED", reward = 8000},
  {name = "SADLER", reward = 8000}, -- ford 150
  {name = "EMPEROR", reward = 3000},
  {name = "BFINJECT", reward = 3200},
  {name = "SANCHEZ02", reward = 3000},
  {name = "REBEL02", reward = 3300},
  {name = "SEMINOLE", reward = 3300},
  {name = "BOBCATXL", reward = 4300},
  {name = "BUFFALO", reward = 4300}, -- chrystler 300
  {name = "RUINER", reward = 4100},
  {name = "BLISTA2", reward = 4100},
  {name = "SCRAP", reward = 4000},
  {name = "TORNADO3", reward = 2500},
  {name = "SABREGT", reward = 6000}, -- ford mustang boss
  {name = "FUGITIVE", reward = 7000}, -- masseratti quattroporte
  {name = "DUBSTA", reward = 5700},
  {name = "PEYOTE", reward = 4700},
  {name = "SANDKING", reward = 6400}
}

RegisterServerEvent("chopshop:startJob")
AddEventHandler("chopshop:startJob", function()
  local usource = source
  local wanted_vehicles = {}
  for i = 1, 5 do
    local random_vehicle = VEHICLES[math.random(#VEHICLES)]
    table.insert(wanted_vehicles, random_vehicle)
    print("inserted: " .. random_vehicle.name)
  end
  TriggerClientEvent("chopshop:startJob", usource, wanted_vehicles)
end)

RegisterServerEvent("chopshop:reward")
AddEventHandler("chopshop:reward", function(veh_name, damage, property)
  local usource = source
  local player = exports["essentialmode"]:getPlayerFromId(usource)
  local user_money = player.getActiveCharacterData("money")
  local reward = GetRewardFromName(veh_name)
  if (reward - damage) >= 0 then
    player.setActiveCharacterData("money", user_money + (reward - damage))
    TriggerClientEvent("usa:notify", usource, "~y~Reward:~w~ $" .. (reward - damage) .. "\nThere was $" .. damage .. " in damages.")
	if property then
		-- give money to property owner --
		TriggerEvent("properties:addMoney", property.name, math.floor(0.75 * (reward - damage), 0))
	end
  else
    TriggerClientEvent("usa:notify", usource, "This vehicle is too damaged. I am not giving you any money for this!")
  end
  print("chop shop turn in damage: -$" .. damage)
end)

function GetRewardFromName(name)
  for i = 1, #VEHICLES do
    if string.lower(name) == string.lower(VEHICLES[i].name) then
      return VEHICLES[i].reward
    end
  end
  return 0
end

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "makepedskillable" then
        RconPrint("Making all peds killable!")
        TriggerEvent("es:getPlayers", function(players)
            for id, person in pairs(players) do
                if id and person then
                    if person.getGroup() == "owner" then
                        TriggerClientEvent("makepedskillable", id)
                        CancelEvent()
                        return
                    end
                end
            end
        end)
    end
end)

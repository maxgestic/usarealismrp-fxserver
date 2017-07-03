--[[ Gets called the first time a player spawns in the server.
AddEventHandler('es:firstSpawn', function(source)
    print("Hello world!")
end)
--]]
function getPlayerIdentifierEasyMode(source)
   local rawIdentifiers = GetPlayerIdentifiers(source)
   if rawIdentifiers then
       for key, value in pairs(rawIdentifiers) do
           playerIdentifier = value
       end
   else
       print("IDENTIFIERS DO NOT EXIST OR WERE NOT RETIREVED PROPERLY")
   end
   return playerIdentifier -- should usually be only 1 identifier according to the wiki
end

local spawns = {
   --{x = 14.8507, y = 6504.93, z = 31.3922}, --paleto
   --{x = 177.847, y = 6637.57, z = 31.5804},--paleto
  -- {x = 453.987, y = 6516.02, z = 29.3487},--paleto
   --{x = -390.91, y = 6214.86, z = 31.4899}--paleto
   {x = 391.611, y = -948.984, z = 29.3978}, -- atlee & sinner st
   {x = 95.2552, y = -1310.8, z = 29.2921} -- near strip club
}

local playerIdentifier, playerJob

function getWeaponsFromInventory(inventory)
    local weapons = {}
    local index = 1
    if #inventory > 0 then
        for i = 1, #inventory do
            if i <= #inventory then
                if inventory[i].type == "weapon" then
                    weapons[index] = inventory[i].hash
                    index = index + 1
                end
            end
        end
    end
    return weapons
end

-- end of utils

RegisterServerEvent('es:firstSpawn')
AddEventHandler('es:firstSpawn', function()
    print("Hello world!")

    --[[
   local randomSpawnPointIndex = math.random(1, (#spawns or 0) +1)
   local selectedSpawn = spawns[randomSpawnPointIndex]

   -- players spawn location based on job
   local spawnX = 0
   local spawnY = 0
   local spawnZ = 0

   TriggerEvent('es:getPlayerFromId', source, function(user)
       --local job = user.job
      -- print("job = " .. job)
       if job then
           if job == "civ" then
               -- random spawn
               spawnX = selectedSpawn.x
               spawnY = selectedSpawn.y
               spawnZ = selectedSpawn.z
           elseif job == "cop" or job == "sheriff" then
               -- pd paleto bay
               --spawnX = -447.141
               --spawnY = 6009.42
              -- spawnZ = 31.7164
              spawnX = 451.255
              spawnY = -992.41
              spawnZ = 30.6896
           elseif job == "ems" or job == "fire" then
               -- fire station paleto bay
               --spawnX = -373.171
               --spawnY = 6123.17
               --spawnZ = 31.4402
               spawnX =  360.31
               spawnY = -590.445
               spawnZ = 28.6563
           end
        end
   end)

   -- Spawn the player at: X, Y Z
   -- model is set by the loadout mod
   TriggerClientEvent('es_example_gamemode:spawnPlayer', source, "s_m_y_sheriff_01",451.255,-992.41,30.6896, 0.0)
   ]]
end)
--[[
AddEventHandler('es:playerLoaded', function(source)
   TriggerEvent('es:getPlayerFromId', source, function(user)
       local playerWeapons, playerModel
       local inventory = user.inventory
       playerWeapons = getWeaponsFromInventory(inventory)
		if playerWeapons then
			print("player " .. GetPlayerName(source) .. " spawned with #playerWeapons = " .. #playerWeapons)
		end
        -- Activate the money for the current player
        user:setMoney(user.getMoney())
        -- Send the player some information regarding the money
        TriggerClientEvent('chatMessage', source, "INFO", {255, 165, 0}, "^5You currently have: ^3$" .. tonumber(user.money))
        if user.job == "sheriff" then
            playerWeapons = {"WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_CARBINERIFLE" ,"WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        elseif user.job == "ems" or user.job == "fire" then
            playerWeapons = {"WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}
        end

        -- retrieve player's model from database
      	local executed_query = MySQL:executeQuery("SELECT model FROM users WHERE identifier = '@identifier'",{['@identifier'] = getPlayerIdentifierEasyMode(source)})
        local result = MySQL:getResults(executed_query, {'model'})
        playerModel = result[1].model

       TriggerClientEvent("mini:giveLoadout", source, playerWeapons, playerModel)

       -- set never wanted to be on
       TriggerClientEvent('mini:disableWantedLevel', source)
       -- spawn custom NPCs
       TriggerClientEvent("mini:spawnClothingStoreNpcs", source)
    end)

end)
--]]
-- this command is to get your cop weapons back after dying
TriggerEvent('es:addCommand', 'loadout', function(source, args, user)

   weapons = {"WEAPON_COMBATPISTOL", "WEAPON_CARBINERIFLE", "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_PUMPSHOTGUN", "WEAPON_FLAREGUN", "WEAPON_FLASHLIGHT", "WEAPON_FIREEXTINGUISHER"}

   if user.job == "sheriff" then
       TriggerClientEvent("mini_gamemode:giveWeapons", source, weapons)
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3You have been given a sheriff's deputy loadout.")
   else
       TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, "^3Only sheriff deputies are allowed to use /loadout!")
   end

end)
--]]

local armoryItems = { -- must match client.lua
  { name = "Flashlight", type = "weapon", hash = -1951375401, price = 50, legality = "legal", quantity = 1, weight = 2 },
  { name = "Nightstick", type = "weapon", hash = 1737195953, price = 250, legality = "legal", quantity = 1, weight = 3 },
  { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 400, legality = "legal", quantity = 1, weight = 4 },
  { name = "Stun Gun", type = "weapon", hash = 911657153, price = 700, legality = "legal", quantity = 1, weight = 4 }
}

AddEventHandler('rconCommand', function(commandName, args)
  if commandName:lower() == 'whitelist' then
    local playerId = table.remove(args, 1)
    local wl_type = table.remove(args, 1)
    local rank = tonumber(table.remove(args, 1)) -- 0 for unwhitelist, remove whitelist
    --RconPrint(type)
    if not GetPlayerName(playerId) then
      RconPrint("\nError: player with id #" .. playerId .. " does not exist!")
      CancelEvent()
      return
    elseif not wl_type then
      RconPrint("\nYou must enter a whitelist type: police or  ems")
      CancelEvent()
      return
    elseif not rank then
      RconPrint("\nYou must enter a rank for that player: 0 to un-whitelist. 1 is probationary deputy, 7 is max.")
      CancelEvent()
      return
    end

    if wl_type == "police" then
      TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
        if(user)then
          if rank > 0 then
            user.setActiveCharacterData("policeRank", rank)
            RconPrint("DEBUG: " .. playerId .. "'s police rank has been set to: " .. rank .. "!")
            TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for police, rank: " .. rank)
          else
            user.setActiveCharacterData("policeRank", 0)
            user.setActiveCharacterData("job", "civ")
            RconPrint("DEBUG: " .. playerId .. " un-whitelisted as police.")
          end
        end
      end)
    elseif wl_type == "ems" then
      TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
        if(user)then
          if rank > 0 then
            user.setActiveCharacterData("emsRank", rank)
            RconPrint("DEBUG: " .. playerId .. "'s EMS rank has been set to: " .. rank .. "!")
            TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for EMS, rank: " .. rank)
          else
            user.setActiveCharacterData("emsRank", 0)
            user.setActiveCharacterData("job", "civ")
            RconPrint("DEBUG: " .. playerId .. " un-whitelisted as EMS.")
          end
        end
      end)
    elseif wl_type == "judge" then
      TriggerEvent("es:getPlayerFromId", tonumber(playerId), function(user)
        if(user)then
          if rank > 0 then
            user.setActiveCharacterData("judgeRank", rank)
            RconPrint("DEBUG: " .. playerId .. "'s judge rank has been set to: " .. rank .. "!")
            TriggerClientEvent('chatMessage', tonumber(playerId), "CONSOLE", {255, 255, 255}, "You have been whitelisted for judge, rank: " .. rank)
          else
            user.setActiveCharacterData("judgeRank", 0)
            user.setActiveCharacterData("job", "civ")
            RconPrint("DEBUG: " .. playerId .. " un-whitelisted as judge.")
          end
        end
      end)
    elseif wl_type == "corrections" then
    	if not GetPlayerName(playerId) or not tonumber(rank) then
    		RconPrint("Error: bad format!")
    		return
    	end
      local target_ident = GetPlayerIdentifiers(playerId)[1]
    	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
    		GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , target_ident, function(result)

          local target = exports["essentialmode"]:getPlayerFromId(tonumber(playerId))
          local employee = {
            identifier = target_ident,
            name = target.getActiveCharacterData("fullName"),
            rank = tonumber(rank)
          }

    			if type(result) ~= "boolean" then -- exists (table)
            GetDoc.updateDocument("correctionaldepartment", result._id, {rank = employee.rank}, function()
              RconPrint("Rank updated to: " .. employee.rank)
              RconPrint("\nEmployee " .. employee.name .. "updated, rank: " .. employee.rank .. "!")
              --loadDOCEmployees()
              TriggerEvent("doc:refreshEmployees") -- TODO: CREATE HANDLER FOR THIS EVENT in prisonfive/server.lua
            end)
    			else -- did not exist already, create doc
            GetDoc.createDocument("correctionaldepartment", employee, function()
              print("employee created!")
              -- notify:
              RconPrint("Employee " .. employee.name .. "created, rank: " .. employee.rank .. "!")
              -- refresh employees:
              --loadDOCEmployees()
              TriggerEvent("doc:refreshEmployees")
            end)
          end
        end)
    	end)
    end
    CancelEvent()
  end
end)

TriggerEvent('es:addCommand', 'whitelist', function(source, args, user)
  local user_group = user.getGroup()
  local user_rank = 0
  --if user_group ~= "admin" and user_group ~= "superadmin" and user_group ~= "owner" then return end
  local playerId = tonumber(args[2])
  local type = string.lower(args[3])
  local rank = tonumber(args[4])
  local playerName = GetPlayerName(playerId)
  if type == "ems" then
    user_rank = tonumber(user.getActiveCharacterData("emsRank"))
  elseif type == "police" then
    user_rank = tonumber(user.getActiveCharacterData("policeRank"))
  end

  if user_group == "admin" or user_group == "superadmin" or user_group == "owner" then
    user_rank = 999999 -- so admins can use /whitelist
  end

  if user_rank < 5 then
    TriggerClientEvent("usa:notify", source, "Error: must be ranked as Sergeant or above to set permissions!")
    return
  elseif rank > user_rank then
    print("Error: can't set a person's rank to something higher than your own!")
    TriggerClientEvent("usa:notify", source, "Error: can't set a person's rank to something higher than your own!")
    return
  elseif not playerName then
    print("Error: player with id #" .. playerId .. " does not exist!")
    TriggerClientEvent("usa:notify", source, "Error: player with id #" .. playerId .. " does not exist!")
    return
  elseif not type then
    print("You must enter a whitelist type: police or  ems")
    TriggerClientEvent("usa:notify", source, "You must enter a whitelist type: police or ems")
    return
  elseif not rank then
    print("You must enter a whitelist status for that player: true or false")
    TriggerClientEvent("usa:notify", source, "You must enter a rank for that player: 0 to un-whitelist. 1 is probationary deputy, 7 is max.")
    return
  end
  TriggerEvent('es:getPlayerFromId', playerId, function(targetUser)
    if targetUser then
      if rank > 0 then
        if type == "police" then
          targetUser.setActiveCharacterData("policeRank", rank)
        elseif type == "ems" then
          targetUser.setActiveCharacterData("emsRank", rank)
        end
        TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been whitelisted for " .. type .. ", rank: " .. rank)
      else
        if type == "police" then
          targetUser.setActiveCharacterData("policeRank", 0)
        elseif type == "ems" then
          targetUser.setActiveCharacterData("emsRank", 0)
        end
        local user_job = targetUser.getActiveCharacterData("job")
        if user_job == "ems" or user_job == "fire" or user_job == "sheriff" then
          targetUser.setActiveCharacterData("job", "civ")
        end
        TriggerClientEvent("usa:notify", source, "Player " .. playerName .. " has been un-whitelisted for " .. type)
      end
    end
  end)
end, {
  help = "Set a person's police or EMS rank.",
  params = {
    { name = "id", help = "The player's server ID #" },
    { name = "type", help = "'police' or 'ems'" },
    { name = "rank", help = "0 to remove whitelist, 1 for probationary, 7 is max permissions" }
  }
})

RegisterServerEvent("policestation2:checkWhitelist")
AddEventHandler("policestation2:checkWhitelist", function(clientevent)
  local playerIdentifiers = GetPlayerIdentifiers(source)
  local playerGameLicense = ""
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  if user.getActiveCharacterData("policeRank") > 0 then
    if clientevent == "policestation2:showArmoury" then
      local user_job = user.getActiveCharacterData("job")
      if user_job == "sheriff" or user_job == "cop" then
        TriggerClientEvent(clientevent, userSource)
      else
        TriggerClientEvent("usa:notify", userSource, "You must be on-duty to access the armory.")
      end
    else
        user.setActiveCharacterData("job", "sheriff")
        TriggerClientEvent(clientevent, userSource)
    end
  else
    TriggerClientEvent("usa:notify", userSource, "~y~You are not whitelisted for POLICE. Apply at https://www.usarrp.net.")
  end

end)

RegisterServerEvent("policestation2:requestPurchase")
AddEventHandler("policestation2:requestPurchase", function(index)
  local usource = source
  print("Person wants to buy: " .. armoryItems[index].name)
  local weapon = armoryItems[index]
  local user = exports["essentialmode"]:getPlayerFromId(source)
  local permit_status = checkPermit(user)
  if permit_status == "valid" then
    local user_money = user.getActiveCharacterData("money")
    if user_money - armoryItems[index].price >= 0 then
    local user_weapons = user.getActiveCharacterData("weapons")
    local timestamp = os.date("*t", os.time())
      local letters = {}
      for i = 65,  90 do table.insert(letters, string.char(i)) end -- add capital letters
      local serialEnding = math.random(100000, 999999)
      local serialLetter = letters[math.random(#letters)]
      weapon.serialNumber = serialLetter .. serialEnding
    local weaponDB = {}
      weaponDB.name = weapon.name
      weaponDB.serialNumber = serialLetter .. serialEnding
      weaponDB.ownerName = user.getActiveCharacterData('fullName')
      weaponDB.ownerDOB = user.getActiveCharacterData('dateOfBirth')
      weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
      TriggerEvent("usa:insertItem", weapon, 1, usource, function(success)
        if success then
          user.setActiveCharacterData("money", user_money - armoryItems[index].price)
          TriggerClientEvent("mini:equipWeapon", usource, usource, armoryItems[index].hash) -- equip
          TriggerClientEvent('gunShop:addRecentlyPurchased', usource)
          TriggerClientEvent('usa:notify', usource, 'Purchased: ~y~'..weapon.name..'\n~s~Serial Number: ~y~'..weapon.serialNumber..'\n~s~Price: ~y~$'..armoryItems[index].price)
          TriggerEvent('es:exposeDBFunctions', function(couchdb)
            couchdb.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
                if success then
                    print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
                else
                    print("* Error: Weapon failed to be created!! *")
                end
            end)
          end)
        end
      end)
    else
      TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
  elseif permit_status == "suspended" then
    TriggerClientEvent("usa:notify", usource, "Your permit is suspended!")
  elseif permit_status == "none" then
    TriggerClientEvent("usa:notify", usource, "You do not have a valid ~y~Firearm Permit~s~!")
  end
end)

RegisterServerEvent("policestation2:saveOutfit")
AddEventHandler("policestation2:saveOutfit", function(character, slot)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  local policeCharacter = user.getPoliceCharacter()
  policeCharacter[slot] = character
  if user_job == "sheriff" or user_job == "cop" then
    user.setPoliceCharacter(policeCharacter)
    TriggerClientEvent("usa:notify", userSource, "Outfit in slot "..slot.." has been saved.")
  else
    TriggerClientEvent("usa:notify", userSource, "You must be on-duty to save a uniform.")
  end
end)

RegisterServerEvent("policestation2:loadOutfit")
AddEventHandler("policestation2:loadOutfit", function(slot)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  if user.getActiveCharacterData("policeRank") > 0 then
    character = user.getPoliceCharacter()
    TriggerClientEvent("policestation2:setCharacter", userSource, character[slot])
    if user.getActiveCharacterData('job') ~= 'sheriff' then
      user.setActiveCharacterData("job", "sheriff")
      TriggerEvent('job:sendNewLog', userSource, 'sheriff', true)
    end
    TriggerClientEvent('interaction:setPlayersJob', userSource, 'sheriff')
    TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 3}, true)
  else
    DropPlayer(userSource, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
  end
end)

RegisterServerEvent("policestation2:onduty")
AddEventHandler("policestation2:onduty", function()
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job ~= "sheriff" or user_job ~= "cop" or user_job ~= "police" and user.getActiveCharacterData("policeRank") > 0 then
    user.setActiveCharacterData("job", "sheriff")
    TriggerEvent('job:sendNewLog', source, 'sheriff', true)
    TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 3}, true)
  end
end)

RegisterServerEvent("policestation2:offduty")
AddEventHandler("policestation2:offduty", function()
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local playerWeapons = user.getActiveCharacterData("weapons")
  local chars = user.getCharacters()
  for i = 1, #chars do
    if chars[i].active == true then
      TriggerClientEvent('interaction:setPlayersJob', source, 'civ')
      TriggerClientEvent("policestation2:setciv", userSource, chars[i].appearance, playerWeapons)
      break
    end
  end
  user.setActiveCharacterData("job", "civ")
  TriggerEvent('job:sendNewLog', source, 'sheriff', false)
  TriggerEvent("eblips:remove", userSource)
end)

function checkPermit(player)
  local licenses = player.getActiveCharacterData("licenses")
  for i = 1, #licenses do
    local item = licenses[i]
    if item.name == "Firearm Permit" then
      return item.status
    end
  end
  return "none"
  --TriggerClientEvent("gunShop:showNoPermitMenu", userSource)
end

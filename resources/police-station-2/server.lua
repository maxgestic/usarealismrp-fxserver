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
    --TriggerClientEvent("policestation2:isWhitelisted", userSource)
    if clientevent == "policestation2:showArmoury" then
      local user_job = user.getActiveCharacterData("job")
      if user_job == "sheriff" or user_job == "cop" then
        TriggerClientEvent(clientevent, userSource)
      else
        TriggerClientEvent("usa:notify", userSource, "You need to be ~r~10-8 ~w~ to access LSPD armoury.")
      end
    else
        user.setActiveCharacterData("job", "sheriff")
        TriggerClientEvent(clientevent, userSource)
    end
  else
    TriggerClientEvent("usa:notify", userSource, "~y~You are not whitelisted for POLICE. Apply at ~b~https://www.usarrp.net~w~.")
  end

end)

RegisterServerEvent("policestation2:saveasdefault")
AddEventHandler("policestation2:saveasdefault", function(character)
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job == "sheriff" or user_job == "cop" then
    user.setPoliceCharacter(character)
    TriggerClientEvent("usa:notify", userSource, "Default ~b~SASP~w~ uniform saved.")
  else
    TriggerClientEvent("usa:notify", userSource, "You need to be ~r~10-8~w~ to save default uniform.")
  end
end)

RegisterServerEvent("policestation2:loadDefaultUniform")
AddEventHandler("policestation2:loadDefaultUniform", function()
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  character = user.getPoliceCharacter()
  TriggerClientEvent("policestation2:setCharacter", userSource, character)
  --TriggerClientEvent("policestation2:giveDefaultLoadout", userSource)
  user.setActiveCharacterData("job", "sheriff")
  TriggerEvent("eblips:add", {name = user.getActiveCharacterData("fullName"), src = userSource, color = 3}, true)
  --end)
end)

RegisterServerEvent("policestation2:onduty")
AddEventHandler("policestation2:onduty", function()
  local userSource = tonumber(source)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_job = user.getActiveCharacterData("job")
  if user_job ~= "sheriff" or user_job ~= "cop" or user_job ~= "police" then
    user.setActiveCharacterData("job", "sheriff")
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
      TriggerClientEvent("policestation2:setciv", userSource, chars[i].appearance, playerWeapons)
      break
    end
  end
  user.setActiveCharacterData("job", "civ")
  TriggerEvent("eblips:remove", userSource)
end)

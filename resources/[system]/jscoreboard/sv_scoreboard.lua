-- Gets called when a player is fully loaded.
AddEventHandler('es:playerLoaded', function(source)
  --print("INSIDE JSCOREBOARD PLAYER LOADED!")
  local userSource = tonumber(source)
  print("userSource = " .. userSource)
  --TriggerEvent("es:getPlayerFromId", userSource, function(user)
  local user = exports["essentialmode"]:getPlayerFromId(userSource)
  local user_group = user.getGroup()
  print("scoreboard user group = " .. user_group)
  TriggerClientEvent("jscoreboard:setUserGroup", userSource, user_group)
  --end)
end)

-- used to load active players for scoreboard list
RegisterServerEvent("jscoreboard:getPlayers")
AddEventHandler("jscoreboard:getPlayers", function()
  local userSource = tonumber(source)
  --print("gettin players for scoreboard...")
  TriggerEvent("es:getPlayers", function(players)
    if players then
      local players_to_send = {}
      for id, player in pairs(players) do
        if id and player then
          --print("id: " .. id)
          --print("player: " .. player.getActiveCharacterData("fullName"))
          --local name = player.getActiveCharacterData("firstName") .. " " .. player.getActiveCharacterData("middleName") .. " " .. player.getActiveCharacterData("lastName")
          local first_name = player.getActiveCharacterData("firstName")
          local middle_name = player.getActiveCharacterData("middleName")
          local last_name = player.getActiveCharacterData("lastName")
          local final_name = first_name
          if middle_name then if middle_name ~= " " then final_name = final_name .. " " .. middle_name end end
          if last_name then final_name = final_name .. " " .. last_name end
          local ping = GetPlayerPing(id)
          if ping ~= 0 then
            table.insert(players_to_send, {id, final_name, ping, player.getActiveCharacterData("job")})
          end
        end
      end
      TriggerClientEvent("jscoreboard:gotPlayers", userSource, players_to_send)
    end
  end)
end)

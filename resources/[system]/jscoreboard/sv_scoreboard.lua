-- Gets called when a player is fully loaded.
AddEventHandler('es:playerLoaded', function(source)
    print("INSIDE JSCOREBOARD PLAYER LOADED!")
    local userSource = tonumber(source)
    print("userSource = " .. userSource)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_group = user.getGroup()
        print("scoreboard user group = " .. user_group)
        TriggerClientEvent("jscoreboard:setUserGroup", userSource, user_group)
    end)
end)

-- used to load active players for scoreboard list
RegisterServerEvent("jscoreboard:getPlayers")
AddEventHandler("jscoreboard:getPlayers", function()
  local userSource = tonumber(source)
  print("gettin players for scoreboard...")
  TriggerEvent("es:getPlayers", function(players)
    if players then
      local players_to_send = {}
      for id, player in pairs(players) do
        if id and player then
          --print("id: " .. id)
          --print("player: " .. player.getActiveCharacterData("fullName"))
          table.insert(players_to_send, {id, player.getActiveCharacterData("fullName"), GetPlayerPing(id)})
        end
      end
      TriggerClientEvent("jscoreboard:gotPlayers", userSource, players_to_send)
    end
  end)
end)

local SETTINGS = {
  ["tie"] = {
    required_item_name = "Sturdy Rope",
    quantity_to_remove_per_use = 1
  }
}

-- bound a player's wrists with rope
TriggerEvent('es:addCommand','tie', function(source, args, user)
  print("inside /tie command!")
  if type(tonumber(args[2])) == "number" then
    -- see if target player has their hands in the air before tying up
    local target_player_id = tonumber(args[2])
    TriggerClientEvent("crim:areHandsUp", target_player_id, source, target_player_id)
    -- play animation:
    local anim = {
      dict = "anim@move_m@trash",
      name = "pickup"
    }
    TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
  end
end)

-- untie the player
TriggerEvent('es:addCommand','untie', function(source, args, user)
  if type(tonumber(args[2])) == "number" then
    local target_player_id = tonumber(args[2])
    if target_player_id ~= tonumber(source) then
      -- untie target's hands, assuming their range has already been confirmed
      TriggerClientEvent("crim:untieHands", target_player_id, tonumber(source))
      -- play animation:
      local anim = {
        dict = "anim@move_m@trash",
        name = "pickup"
      }
      TriggerClientEvent("usa:playAnimation", tonumber(source), anim.name, anim.dict, 3)
    else
      print("can't untie yourself!")
    end
  end
end)

RegisterServerEvent("crim:continueBounding")
AddEventHandler("crim:continueBounding", function(bound, from_id, target_player_id)
  print("inside crim:continueBounding with from id = " .. from_id .. ", target id = " .. target_player_id)
  local source = tonumber(from_id)
  if bound then
    print("bound was not nil or false!")
    TriggerEvent("usa:getPlayerItem", source, SETTINGS["tie"].required_item_name, function(item)
      if item then
        print("player had item to tie person up!")
        -- remove item:
        TriggerEvent("usa:removeItem", item, SETTINGS["tie"].quantity_to_remove_per_use, source)
        -- bound target:
        print("tying id #" .. target_player_id .. "'s hands!'")
        TriggerClientEvent("crim:tieHands", target_player_id)
        -- notify player
        TriggerClientEvent("usa:notify", source, "You have tied that person's hands together.")
      else
        print("player did not have required item for action!")
        TriggerClientEvent("usa:notify", source, "You need rope to do that!")
      end
    end)
  else
    TriggerClientEvent("usa:notify", source, "Person does not have their hands up or is too far away!")
  end
end)

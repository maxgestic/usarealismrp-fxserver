local civSkins = {
    "a_m_m_beach_01",
    "a_m_m_bevhills_01",
    "a_m_m_bevhills_02",
    "a_m_m_business_01",
    "a_m_m_eastsa_01",
    "a_m_m_eastsa_02",
    "a_m_m_farmer_01",
    "a_m_m_genfat_01",
    "a_m_m_golfer_01",
    "a_m_m_hillbilly_01",
    "a_m_m_indian_01",
    "a_m_m_mexcntry_01",
    "a_m_m_paparazzi_01",
    "a_m_m_tramp_01",
    "a_m_y_hiker_01",
    "a_m_y_genstreet_01",
    "a_m_m_socenlat_01",
    "a_m_m_og_boss_01",
    "a_f_y_tourist_02",
    "a_f_y_tourist_01",
    "a_f_y_soucent_01",
    "a_f_y_scdressy_01",
    "a_m_y_cyclist_01",
    "a_m_y_golfer_01",
    "S_M_M_Linecook",
    "S_M_Y_Barman_01",
    "S_M_Y_BusBoy_01",
    "S_M_Y_Waiter_01",
    "A_M_Y_StBla_01",
    "A_M_M_Tennis_01",
    "A_M_Y_BreakDance_01",
    "A_M_Y_SouCent_03",
    "S_M_M_Bouncer_01",
    "S_M_Y_Doorman_01",
    "A_F_M_Tramp_01"
}

AddEventHandler('es:playerLoaded', function(source, user)
    local money = user.getActiveCharacterData("money")
    print("Player " .. GetPlayerName(source) .. " has loaded.")
    if money then
        print("Money:" .. money)
        --user.setActiveCharacterData("money", money) -- set money GUI in top right (?)
    else
        print("new player, default money!")
    end
    TriggerClientEvent('usa_rp:playerLoaded', source)
end)

RegisterServerEvent("usa_rp:spawnPlayer")
AddEventHandler("usa_rp:spawnPlayer", function()
    print("inside of usa_rp:spawnPlayer!")
    local userSource = tonumber(source)
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local characters = user.getCharacters()
        local job = user.getActiveCharacterData("job")
        if job then
            print("user.getActiveCharacterData('job') = " .. job)
        end
        local weapons = user.getActiveCharacterData("weapons")
        local model = civSkins[math.random(1,#civSkins)]
        if weapons then
            if #weapons > 0 then
                print("#weapons = " .. #weapons)
            else
                print("user has no weapons")
            end
        end
        user.setActiveCharacterData("job", "civ")
        -- todo: remove unused passed in parameters below??
        TriggerClientEvent("usa_rp:spawn", userSource, model, job, weapons, characters)
    end)
end)

RegisterServerEvent("usa_rp:checkJailedStatusOnPlayerJoin")
AddEventHandler("usa_rp:checkJailedStatusOnPlayerJoin", function(source)
	print("inside of checkJailedStatusOnPlayerJoin event handler...")
	local userSource = tonumber(source)
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		if user then
			if user.getActiveCharacterData("jailtime") > 0 then
				TriggerClientEvent("jail:jail", userSource)
				TriggerClientEvent("jail:removeWeapons", userSource)
				TriggerClientEvent("jail:changeClothes", userSource)
			end
		end
	end)
end)

-- V E H I C L E  C O N T R O L S
TriggerEvent('es:addCommand', 'rollw', function(source, args, user)
	TriggerClientEvent("RollWindow", source)
end)

TriggerEvent('es:addCommand', 'open', function(source, args, user)
    if args[2] then
        print("opening " .. args[2])
        TriggerClientEvent("veh:openDoor", source, args[2])
        --TriggerClientEvent("usa:notify", source, "test")
    end
end)

TriggerEvent('es:addCommand', 'close', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:shutDoor", source, args[2])
    end
end)

TriggerEvent('es:addCommand', 'shut', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:shutDoor", source, args[2])
    end
end)

TriggerEvent('es:addCommand', 'engine', function(source, args, user)
    if args[2] then
            TriggerClientEvent("veh:toggleEngine", source, args[2])
    end
end)

-- R O L L  D I C E
TriggerEvent('es:addCommand', 'roll', function(source, args, user)
  local name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
  local max = tonumber(args[2])
    if max then
      print("rolling " .. max)
      local roll = math.random(1, max)
      TriggerEvent('altchat:localChatMessage', source, "^6* " .. name .. " rolls a " .. roll .. " out of " .. max)
    end
end)

-- U T I L I T Y  F U N C T I O N S
RegisterServerEvent("usa:checkPlayerMoney")
AddEventHandler("usa:checkPlayerMoney", function(activity, amount, callbackEventName, isServerEvent, takeMoney)
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        local user_money = user.getActiveCharacterData("money")
        if user_money >= amount then
            if takeMoney then
                user.setActiveCharacterData("money", user_money - amount)
            end
            if isServerEvent then
                TriggerEvent(callbackEventName)
            else
                TriggerClientEvent(callbackEventName, userSource)
            end
        else
            TriggerClientEvent("usa:notify", userSource, "Sorry, you don't have enough money to " .. activity .. "!")
        end
    end)
end)

RegisterServerEvent("usa:removeItem")
AddEventHandler("usa:removeItem", function(to_remove_item, quantity)
  -- todo implement support for removing more than 1 at a time (aka quantity parameter above)
  print("inside usa:removeItem!")
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    local user_inventory = user.getActiveCharacterData("inventory")
    local user_weapons = user.getActiveCharacterData("weapons")
    local user_licenses = user.getActiveCharacterData("licenses")
    --print("checking inventory items...")
    for a = 1, #user_inventory do
      local item = user_inventory[a]
      --print("checking item: " .. item.name)
      if item.name == to_remove_item.name then
        print("found a matching inventory item for usa:removeItem! removing: " .. item.name)
        if item.quantity == 1 then
          table.remove(user_inventory, a)
          user.setActiveCharacterData("inventory", user_inventory)
        else
          user_inventory[a].quantity = item.quantity - 1
          user.setActiveCharacterData("inventory", user_inventory)
        end
        return
      end
    end
    --print("checking license items...")
    for b = 1, #user_licenses do
      local item = user_licenses[b]
      --print("checking item: " .. item.name)
      if item.name == to_remove_item.name then
        print("found a matching license for usa:removeItem! removing: " .. item.name)
        if item.quantity == 1 then
          table.remove(user_licenses, b)
          user.setActiveCharacterData("licenses", user_licenses)
        else
          user_licenses[b].quantity = item.quantity - 1
          user.setActiveCharacterData("licenses", user_licenses)
        end
        return
      end
    end
    --print("checking weapon items...")
    for c = 1, #user_weapons do
      local item = user_weapons[c]
      --print("checking item: " .. item.name)
      if item.name == to_remove_item.name then
        print("found a matching weapon for usa:removeItem! removing: " .. item.name)
        if item.quantity == 1 then
          table.remove(user_weapons, c)
          user.setActiveCharacterData("weapons", user_weapons)
        else
          user_weapons[c].quantity = item.quantity - 1
          user.setActiveCharacterData("weapons", user_weapons)
        end
        return
      end
    end
  end)
end)

RegisterServerEvent("usa:insertItem")
AddEventHandler("usa:insertItem", function(to_insert_item, quantity)
  -- todo implement support for removing more than 1 at a time (aka quantity parameter above)
  print("inside usa:insertItem!")
  local userSource = tonumber(source)
  TriggerEvent("es:getPlayerFromId", userSource, function(user)
    if not to_insert_item.type or to_insert_item.type == "license" then
      -- insert into licenses
      local user_licenses = user.getActiveCharacterData("licenses")
      for i = 1, #user_licenses do
        local item = user_licenses[i]
        if item.name == to_insert_item.name then
          print("quantity increased for license item!")
          user_licenses[i].quantity = item.quantity + quantity
          user.setActiveCharacterData("licenses", user_licenses)
          return
        end
      end
      print("license inserted!")
      -- not in licenses already. insert:
      table.insert(user_licenses, to_insert_item)
      user.setActiveCharacterData("licenses", user_licenses)
    elseif to_insert_item.type == "weapon" then
      -- insert into weapons, assuming that we've checked that player had < 3 weapons
      local user_weapons = user.getActiveCharacterData("weapons")
      for i = 1, #user_weapons do
        local item = user_weapons[i]
        if item.name == to_insert_item.name then
          print("quantity increased for weapon item!")
          user_weapons[i].quantity = item.quantity + quantity
          user.setActiveCharacterData("weapons", user_weapons)
          return
        end
      end
      print("weapon inserted!")
      -- not in weapons already. insert:
      table.insert(user_weapons, to_insert_item)
      user.setActiveCharacterData("weapons", user_weapons)
      -- TODO: equip the weapon here with a client event with to_insert_item.hash passed to it
    else
      -- insert into inventory
      local user_inventory = user.getActiveCharacterData("inventory")
      for i = 1, #user_inventory do
        local item = user_inventory[i]
        if item.name == to_insert_item.name then
          print("quantity increased for inventory item!")
          user_inventory[i].quantity = item.quantity + quantity
          user.setActiveCharacterData("inventory", user_inventory)
          return
        end
      end
      print("inventory item inserted!")
      -- not in inventory already. insert:
      table.insert(user_inventory, to_insert_item)
      user.setActiveCharacterData("inventory", user_inventory)
    end
  end)
end)

RegisterServerEvent("usa:notifyStaff")
AddEventHandler("usa:notifyStaff", function(msg)
  sendMessageToModsAndAdmins(msg)
end)

function sendMessageToModsAndAdmins(msg)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						TriggerClientEvent("chatMessage", id, "", {}, msg)
					end
				end
			end
		end
	end)
end

RegisterServerEvent("search:searchPlayer")
AddEventHandler("search:searchPlayer", function(source, playerId)
	TriggerEvent('es:getPlayerFromId', tonumber(playerId), function(user)
		if not user then
			TriggerClientEvent("search:notifyNoExist", source, playerId) -- player does not exist
			return
		end
		-- play animation:
		local anim = {
			dict = "anim@move_m@trash",
			name = "pickup"
		}
		TriggerClientEvent("usa:playAnimation", source, anim.name, anim.dict, 4)
		local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
		local items = {}
		local licenses = user.getActiveCharacterData("licenses")
		for index = 1, #licenses do
			--if licenses[index].name == "Driver's License" then
				table.insert(items, licenses[index])
			--end
		end
		local playerInventory = user.getActiveCharacterData("inventory")
		for i = 1, #playerInventory do
			table.insert(items, playerInventory[i])
		end
		local playerWeapons = user.getActiveCharacterData("weapons")
		for j = 1, #playerWeapons do
			table.insert(items, playerWeapons[j])
		end
			TriggerClientEvent("chatMessage", source, "", {255,136,0}, "SEARCH OF " .. user_name .. ":")
			local user_money = user.getActiveCharacterData("money")
			if user_money > 0 then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3CASH:^0 $" .. comma_value(user_money))
			end
			for i = 1, #items do
				local name = items[i].name
				local quantity = items[i].quantity
				local legality = items[i].legality
				if legality == "illegal" then
					TriggerClientEvent("chatMessage", source, "", {255,0,0}, "^1(x" .. quantity .. ") " .. name) -- print inventory (red text)
				else
					TriggerClientEvent("chatMessage", source, "", {0,50,0}, "^0(x" .. quantity .. ") " .. name) -- print inventory
				end
			end
	end)
end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addJobCommand', 'search', { "police", "sheriff" }, function(source, args, user, location)
	if GetPlayerName(tonumber(args[2])) then
			TriggerClientEvent('chatMessageLocation', -1, "", {255, 0, 0}, " ^6" .. user.getActiveCharacterData("fullName") .. " searches person.", location)
	end
	TriggerEvent("search:searchPlayer", source, args[2])
end, {
	help = "Search a suspect.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

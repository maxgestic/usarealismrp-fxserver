RegisterServerEvent("search:searchPlayer")
AddEventHandler("search:searchPlayer", function(source, playerId)
	TriggerEvent('es:getPlayerFromId', tonumber(playerId), function(user)
		if not user then
			TriggerClientEvent("search:notifyNoExist", source, playerId) -- player does not exist
			return
		end
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
			TriggerClientEvent("chatMessage", source, "SYSTEM", {255,136,0}, "SEARCH OF " .. user_name .. ":")
			local user_money = user.getActiveCharacterData("money")
			if user_money > 0 then
				TriggerClientEvent("chatMessage", source, "", {255,136,0}, "CASH: $" .. comma_value(user_money))
			end
			for i = 1, #items do
				local name = items[i].name
				local quantity = items[i].quantity
				local legality = items[i].legality
				if legality == "illegal" then
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1(x" .. quantity .. ") " .. name) -- print inventory (red text)
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "(x" .. quantity .. ") " .. name) -- print inventory
				end
			end
	end)
end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addJobCommand', 'search', { "police", "sheriff" }, function(source, args, user)
	TriggerEvent("altchat:localChatMessage", source, "^6* " .. GetPlayerName(source) .. " searches person.") -- send local me message
	TriggerEvent("search:searchPlayer", source, args[2])
end, {
	help = "Search a suspect",
	params = {
		{ name = "id", help = "Players ID" }
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

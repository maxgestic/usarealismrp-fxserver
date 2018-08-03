RegisterServerEvent("search:searchPlayer")
AddEventHandler("search:searchPlayer", function(playerId, src)
	local usource = source
	if src then usource = src end
	local user = exports["essentialmode"]:getPlayerFromId(playerId)
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
	TriggerClientEvent("chatMessage", usource, "", {255,136,0}, "SEARCH OF " .. user_name .. ":")
	TriggerClientEvent("chatMessage", usource, "", {0,0,0}, "^3CASH:^0 $" .. comma_value(user.getActiveCharacterData("money")))
	for i = 1, #items do
		local name = items[i].name
		local quantity = items[i].quantity
		local legality = items[i].legality
		local color = {0, 50, 0}
		if legality == "illegal" then
			color = {255, 0, 0}
		else
			color = {0, 50, 0}
		end
		TriggerClientEvent("chatMessage", usource, "", color, "^0(x" .. quantity .. ") " .. name) -- print item
		if items[i].components then
			for k = 1, #items[i].components do
				TriggerClientEvent("chatMessage", usource, "", {0, 50, 0}, "^0		+ " .. items[i].components[k])
			end
		end
	end
end)

-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addJobCommand', 'search', { "police", "sheriff", "corrections" }, function(source, args, user, location)
	if not tonumber(args[2]) then
		TriggerClientEvent("search:attemptToSearchNearest", source)
	else
		TriggerEvent("search:searchPlayer", tonumber(args[2]), source)
	end
end, {
	help = "Search the nearest person."
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

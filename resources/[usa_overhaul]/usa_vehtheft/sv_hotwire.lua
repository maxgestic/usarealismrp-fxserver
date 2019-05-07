local vehicleSearchItems = {
	{name = "Cheeseburger", price = 6, type = "food", substance = 30.0, quantity = 1, legality = "legal", weight = 4.0, objectModel = "prop_cs_burger_01"},
	{name = "Flaming Hot Cheetos", price = 2, type = "food", substance = 6.0, quantity = 1, legality = "legal", weight = 1.0, objectModel = "ng_proc_food_chips01c"},
	{name = "Water", price = 3, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 4.0, objectModel = "ba_prop_club_water_bottle"},
	{name = "Arizona Iced Tea", price = 1, type = "drink", substance = 60.0, quantity = 1, legality = "legal", weight = 1.0, objectModel = "ba_prop_club_water_bottle"},
	{name = "Pepsi", price = 4, type = "drink", substance = 9.0, quantity = 1, legality = "legal", weight = 1.0, objectModel = "ng_proc_sodacan_01b"},
	{name = "Everclear Vodka (90%)", price = 35, type = "alcohol", substance = 5.0, quantity = 1, legality = "legal", weight = 4.0, strength = 0.10, objectModel = "prop_vodka_bottle"},
    {name = "Repair Kit", price = 250, type = "vehicle", quantity = 1, legality = "legal", weight = 8.0, objectModel = "imp_prop_tool_box_01a"},
    {name = 'Lockpick', type = 'misc', price = 400, legality = 'legal', quantity = 1, weight = 5.0},
    {name = "First Aid Kit", price = 100, type = "misc", quantity = 1, legality = "legal", weight = 5.0, objectModel = "v_ret_ta_firstaid"},
    {name = "Packaged Weed", quantity = 1, weight = 2.0, type = "drug", legality = "illegal", objectModel = "bkr_prop_weed_bag_01a"}
}

RegisterServerEvent("veh:checkForKey")
AddEventHandler("veh:checkForKey", function(plate, engineOn)
	--print('checking for key with plate: '..plate)
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local inv = user.getActiveCharacterData("inventory")
	for i = 1, #inv do
		local item = inv[i]
		if item then
			if string.find(item.name, "Key") then
				if string.find(plate, item.plate) then
					TriggerClientEvent('veh:toggleEngine', userSource, true, engineOn, false)
					return
				end
			end
		end
	end
	TriggerClientEvent('veh:toggleEngine', userSource, false, engineOn, true)
end)

RegisterServerEvent('veh:removeHotwiringKit')
AddEventHandler('veh:removeHotwiringKit', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local inv = user.getActiveCharacterData("inventory")
	for i = 1, #inv do
		local item = inv[i]
		if item.name == 'Hotwiring Kit' then
			if item.quantity > 1 then
				item.quantity = item.quantity - 1
				user.setActiveCharacterData('inventory', inv)
				return
			else
				table.remove(inv, i)
				user.setActiveCharacterData('inventory', inv)
				return
			end
		end
	end
	print('hotwiring kit not found in user inventory, possible memory editing: '..userSource)
end)

RegisterServerEvent('veh:searchResult')
AddEventHandler('veh:searchResult', function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	local user_money = user.getActiveCharacterData('money')
	if math.random() > 0.8 then
		return
	end
	if math.random() > 0.6 then
		local money_found = math.random(10, 175)
		TriggerClientEvent('usa:notify', userSource, 'You have found $'..money_found..'.0!')
		user.setActiveCharacterData('money', user_money + money_found)
		return
	else
		local item_found = vehicleSearchItems[math.random(#vehicleSearchItems)]
		if user.getCanActiveCharacterHoldItem(item_found) then
			TriggerClientEvent('usa:notify', userSource, 'You have found '..item_found.name..'.')
			local user_inventory = user.getActiveCharacterData('inventory')
			for i = 1, #user_inventory do
				local item = user_inventory[i]
				if item.name == item_found.name then
					item.quantity = item.quantity + 1
					user.setActiveCharacterData('inventory', user_inventory)
					return
				end
			end
			table.insert(user_inventory, item_found)
			user.setActiveCharacterData('inventory', user_inventory)
			return
		else
			TriggerClientEvent('usa:notify', userSource, "Inventory is full!")
			return
		end
	end
end)

TriggerEvent('es:addJobCommand', 'slimjim', { 'sheriff' }, function(source, args, user)
	TriggerClientEvent('veh:slimjimVehInFrontPolice', source)
end, {
	help = "Slimjim the vehicle in front"
})

TriggerEvent('es:addJobCommand', 'hotwire', { 'sheriff' }, function(source, args, user)
	TriggerClientEvent('veh:hotwireVehPolice', source)
end, {
	help = "Hotwire the vehicle you are currently in"
})

TriggerEvent('es:addCommand', 'engine', function(source, args, user)
	TriggerClientEvent("veh:returnPlateToCheck", source)
end, {
	help = "Toggle your vehicle engine"
})
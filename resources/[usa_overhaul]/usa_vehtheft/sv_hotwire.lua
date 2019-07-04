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
	local char = exports["usa-characters"]:GetCharacter(source)
	local key = char.getItemWithField("plate", plate)
	if key then
		TriggerClientEvent('veh:toggleEngine', source, true, engineOn, false)
	else
		TriggerClientEvent('veh:toggleEngine', source, false, engineOn, true)
	end
end)

RegisterServerEvent('veh:removeHotwiringKit')
AddEventHandler('veh:removeHotwiringKit', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local hotwiring_kit = char.getItem("Hotwiring Kit")
	if hotwiring_kit then
		char.removeItem(hotwiring_kit, 1)
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
    	TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit veh:removeHotwiringKit event, please intervene^0!')
  	end
end)

RegisterServerEvent('veh:searchResult')
AddEventHandler('veh:searchResult', function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if math.random() > 0.8 then
		return
	end
	if math.random() > 0.6 then
		local money_found = math.random(10, 175)
		TriggerClientEvent('usa:notify', source, 'You have found $'..money_found..'.0!')
		char.giveMoney(money_found)
		print('VEHTHEFT: Player '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has received money['..money_found..'] from vehicle search!')
		return
	else
		local item_found = vehicleSearchItems[math.random(#vehicleSearchItems)]
		if char.canHoldItem(item_found) then
			TriggerClientEvent('usa:notify', source, 'You have found '..item_found.name..'.')
			print('VEHTHEFT: Player '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] has found item['..item_found.name..'] from vehicle search!')
			char.giveItem(item_found)
			return
		else
			TriggerClientEvent('usa:notify', source, "Inventory is full!")
			return
		end
	end
end)

TriggerEvent('es:addJobCommand', 'slimjim', { 'sheriff', 'dai' }, function(source, args, char)
	TriggerClientEvent('veh:slimjimVehInFrontPolice', source)
end, {
	help = "Slimjim the vehicle in front"
})

TriggerEvent('es:addJobCommand', 'hotwire', { 'sheriff', 'dai' }, function(source, args, char)
	TriggerClientEvent('veh:hotwireVehPolice', source)
end, {
	help = "Hotwire the vehicle you are currently in"
})

TriggerEvent('es:addCommand', 'engine', function(source, args, char)
	TriggerClientEvent("veh:returnPlateToCheck", source)
end, {
	help = "Toggle your vehicle engine"
})

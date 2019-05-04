RegisterServerEvent('usa:removeRepairKit')
AddEventHandler('usa:removeRepairKit', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local inventory = user.getActiveCharacterData("inventory")
	for i = 1, #inventory do
		local item = inventory[i]
		if item.name == 'Repair Kit' then
			if item.quantity > 1 then
				inventory[i].quantity = item.quantity - 1
				user.setActiveCharacterData("inventory", inventory)
				return
			else
				table.remove(inventory, i)
				user.setActiveCharacterData("inventory", inventory)
				return
			end
		end
	end
end)
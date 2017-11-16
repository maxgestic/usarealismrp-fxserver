function setPlayerInventory(source, inventory)
    TriggerEvent('es:getPlayerFromId', source, function(user)
      user.setActiveCharacterData("inventory", inventory)
    end)
end

RegisterServerEvent("inventory:refreshInventory")
AddEventHandler("inventory:refreshInventory", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local inventoryToDisplay = {}
		local inventory = user.getActiveCharacterData("inventory")
		local weapons = user.getActiveCharacterData("weapons")
		local licenses = user.getActiveCharacterData("licenses")
		print("#inventory = " .. #inventory)
		print("#weapons = " .. #weapons)
		print("#licenses = " .. #licenses)
		for i = 1, #inventory do
			print('inserting ' .. inventory[i].name)
			table.insert(inventoryToDisplay, inventory[i])
		end
		for j = 1, #weapons do
			print('inserting ' .. weapons[j].name)
			table.insert(inventoryToDisplay, weapons[j])
		end
		for k = 1, #licenses do
			print('inserting ' .. licenses[k].name)
			table.insert(inventoryToDisplay, licenses[k])
		end
		TriggerClientEvent("inventory:updatePlayerInventory", source, inventoryToDisplay)
	end)
end)

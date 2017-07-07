function setPlayerInventory(source, inventory)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        user.setInventory(inventory)
    end)
end

RegisterServerEvent("inventory:refreshInventory")
AddEventHandler("inventory:refreshInventory", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local inventoryToDisplay = {}
		local inventory = user.getInventory()
		local weapons = user.getWeapons()
		local licenses = user.getLicenses()
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

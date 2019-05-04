RegisterServerEvent("parachute:usedParachute")
AddEventHandler("parachute:usedParachute", function()
	local userSource = tonumber(source)
	local user = exports["essentialmode"]:getPlayerFromId(userSource)
	--TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local inventory = user.getActiveCharacterData("weapons")
		for i = 1, #inventory do
			local item = inventory[i]
			if item.name == "Parachute" then
				if item.quantity > 1 then
					item.quantity = item.quantity - 1
				else
					table.remove(inventory, i)
				end
				user.setActiveCharacterData("weapons", inventory)
				break
			end
		end
	--end)
end)

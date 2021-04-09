local wheelChairItem = {
	name = "Wheelchair",
	price = 200,
	type = "misc",
	quantity = 1,
	legality = "legal",
	weight = 30,
	objectModel = "prop_wheelchair_01",
	invisibleWhenDropped = true
}

RegisterServerEvent("hospital:wheelchair:pickUpIfPlayerHasRoom")
AddEventHandler("hospital:wheelchair:pickUpIfPlayerHasRoom", function()
	local c = exports["usa-characters"]:GetCharacter(source)
	if c.canHoldItem(wheelChairItem) then
		TriggerClientEvent("wheelchair:removeWheelchair", source)
        c.giveItem(wheelChairItem)
	else
		TriggerClientEvent("usa:notify", source, "Inventory full!")
	end
end)

RegisterServerEvent("hospital:giveWheelchair")
AddEventHandler("hospital:giveWheelchair", function()
	local c = exports["usa-characters"]:GetCharacter(source)
	-- give to player
	c.giveItem(wheelChairItem)
end)

RegisterServerEvent("hospital:buyWheelchair")
AddEventHandler("hospital:buyWheelchair", function()
	local c = exports["usa-characters"]:GetCharacter(source)
	-- take money
	if c.get("money") >= wheelChairItem.price then
		if c.canHoldItem(wheelChairItem) then
			-- give to player
			c.removeMoney(wheelChairItem.price)
			c.giveItem(wheelChairItem)
			TriggerClientEvent("usa:notify", source, "~y~Purchased:~w~ Wheelchair")
		else 
			TriggerClientEvent("usa:notify", source, "Inventory full!")
		end
	else
		TriggerClientEvent("usa:notify", source, "Not enough money. Need: $" .. wheelChairItem.price)
	end
end)
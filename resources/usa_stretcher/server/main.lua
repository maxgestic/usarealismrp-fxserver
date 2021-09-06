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

local stretcherItem = {
	name = "Stretcher",
	price = 400,
	type = "misc",
	quantity = 1,
	legality = "legal",
	weight = 40,
	objectModel = "prop_ld_binbag_01",
	invisibleWhenDropped = true
}

RegisterServerEvent("hospital:pushable:pickUpIfPlayerHasRoom")
AddEventHandler("hospital:pushable:pickUpIfPlayerHasRoom", function(pushable)
	local c = exports["usa-characters"]:GetCharacter(source)
	local item = nil
	if pushable.itemName == "Stretcher" then
		item = stretcherItem
	elseif pushable.itemName == "Wheelchair" then
		item = wheelChairItem
	end
	if c.canHoldItem(item) then
		TriggerClientEvent("pushable:remove", source, pushable)
        c.giveItem(item)
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

TriggerEvent('es:addCommand', 'togglestr', function(source, args, char)
	TriggerClientEvent("stretcher:togglestrincar", source)
end, {
	help = "Toggle Stretcher in/out of amulance"
})
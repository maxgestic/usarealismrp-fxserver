local debug = true

-- todo: randomize price based on each purchase instead of once
local SELLABLE_ITEMS = {
	["Hash"] = math.random(190, 260),
	["Meth"] = math.random(300, 400),
	["Weed Bud"] = math.random(100, 190)
}

-- since i think param 2 of usa:getPlayerItems needs to be in table form:
local temp_items_array = {}
for name, price in pairs(SELLABLE_ITEMS) do
	table.insert(temp_items_array, name)
end

-- display randomized street values for the server session:
if debug then
	for name, price in pairs(SELLABLE_ITEMS) do
		print("Today's " .. name .. " street value: $" .. price)
	end
end

-- see if player has any items to sell to NPC
RegisterServerEvent('drug-sell:check')
AddEventHandler('drug-sell:check', function()
	-- does player have item to sell?
	local _source = source
	-- does player have items to sell?:
	TriggerEvent("usa:getPlayerItems", _source, temp_items_array, function(items)
		if items then
			-- player had something to sell 
			TriggerClientEvent('notify', _source)
			if debug then print("had items to sell to NPC!") end
		else
			if debug then print("nothing to sell!!") end
		end
	end)
end)

-- player sold something, remove item + reward with money
RegisterServerEvent('drug-sell:sell')
AddEventHandler('drug-sell:sell', function()
	-- save source
	local _source = source
	-- quantity ped is buying
	local quantity = 1
	-- remove random item to sell + reward player with money
	TriggerEvent("usa:getPlayerItems", _source, temp_items_array, function(items)
		if items then
			if debug then print("had items to sell to NPC!") end
			-- randomize math.random():
			math.randomseed(os.time())
			-- specific item ped is buying:
			local random = items[math.random(#items)]
			if debug then print("selling " .. random.name) end
			-- randomize quantity ped is buying:
			quantity = math.random(1, random.quantity)
			-- restrict to 8 or lower at a time to sell:
			while quantity > 8 do quantity = math.random(random.quantity) end
			-- give proper reward amount:
			local reward = SELLABLE_ITEMS[random.name] * quantity
			-- remove item:
			TriggerEvent("usa:removeItem", random, quantity, _source)
			-- reward with money:
			local player = exports["essentialmode"]:getPlayerFromId(_source)
			player.setActiveCharacterData("money", player.getActiveCharacterData("money") + (reward))
			if debug then print("sold item to NPC for: " .. reward .. "!") end
			-- notify:
			TriggerClientEvent("usa:notify", _source, "You sold (x"..quantity..") " .. random.name .. " for $" .. reward)
			TriggerClientEvent("chatMessage", _source, "", {255, 255, 255}, "You sold (x"..quantity..") " .. random.name .. " for $" .. reward)
			-- finish selling
			TriggerClientEvent('done', _source)
			TriggerClientEvent('cancel', _source)
			return
		else
			if debug then print("nothing to sell!!") end
		end
	end)
end)
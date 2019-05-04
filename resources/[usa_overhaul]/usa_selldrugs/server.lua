local debug = true

-- todo: randomize price based on each purchase instead of once
local SELLABLE_ITEMS = {
	["Packaged Meth"] = {150, 200},
	["Packaged Blue Meth"] = {400, 600},
	["Packaged Weed"] = {50, 125}
}

-- since i think param 2 of usa:getPlayerItems needs to be in table form:
local temp_items_array = {}
for name, price in pairs(SELLABLE_ITEMS) do
	table.insert(temp_items_array, name)
end


-- see if player has any items to sell to NPC
RegisterServerEvent('sellDrugs:checkPlayerHasDrugs')
AddEventHandler('sellDrugs:checkPlayerHasDrugs', function()
	-- does player have item to sell?
	local _source = source
	-- does player have items to sell?:
	TriggerEvent("usa:getPlayerItems", _source, temp_items_array, function(items)
		if items then
			-- player had something to sell
			local policeOnline = 0
			TriggerEvent("es:getPlayers", function(players)
				if players then
					for id, player in pairs(players) do
						if id and player then
							local playerJob = player.getActiveCharacterData("job")
							if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
								policeOnline = policeOnline + 1
							end
						end
					end
				end
			end)

			if policeOnline == 0 then
				TriggerClientEvent('sellDrugs:showHelpText', _source, 0.9)
			elseif policeOnline == 1 then
			 	TriggerClientEvent('sellDrugs:showHelpText', _source, 0.6)
			elseif policeOnline == 2 then
				TriggerClientEvent('sellDrugs:showHelpText', _source, 0.4)
			elseif policeOnline > 2 then
				TriggerClientEvent('sellDrugs:showHelpText', _source, 0.3)
			end
			if debug then print("had items to sell to NPC!") end
		else
			if debug then print("nothing to sell!!") end
		end
	end)
end)

-- player sold something, remove item + reward with money
RegisterServerEvent('sellDrugs:completeSale')
AddEventHandler('sellDrugs:completeSale', function()
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
			if random.name == 'Packaged Weed' then
				TriggerClientEvent('evidence:weedScent', _source)
			end
			-- randomize quantity ped is buying:
			quantity = math.random(1, random.quantity)
			-- restrict to 3 or lower at a time to sell:
			while quantity > 3 do quantity = math.random(random.quantity) end
			-- give proper reward amount:
			local reward = math.random(SELLABLE_ITEMS[random.name][1], SELLABLE_ITEMS[random.name][2]) * quantity
			-- bonus when police are online --
			local policeOnline = 0
			TriggerEvent("es:getPlayers", function(players)
				if players then
					for id, player in pairs(players) do
						if id and player then
							local playerJob = player.getActiveCharacterData("job")
							if playerJob == "sheriff" or playerJob == "police" or playerJob == "cop" then
								policeOnline = policeOnline + 1
							end
						end
					end
				end
			end)

			local bonus = 0
			if policeOnline >= 2 then
				bonus = math.floor((reward * 1.10) - reward)
			end
			----------------------------------
			-- remove item:
			TriggerEvent("usa:removeItem", random, quantity, _source)
			-- reward with money:
			local player = exports["essentialmode"]:getPlayerFromId(_source)
			player.setActiveCharacterData("money", player.getActiveCharacterData("money") + (reward + bonus))
			if debug then print("sold item to NPC for: " .. reward .. "!") end
			-- notify:
			if bonus > 0 then
				TriggerClientEvent("usa:notify", _source, "You sold ~y~(x"..quantity..") " .. random.name .. " ~s~for ~y~$" .. reward..'.00~s~ with a bonus of ~y~$'..bonus..'.00~s~.')
			else
				TriggerClientEvent("usa:notify", _source, "You sold ~y~(x"..quantity..") " .. random.name .. " ~s~for ~y~$" .. reward..'.00~s~.')
			end
			return
		else
			if debug then print("nothing to sell!!") end
		end
	end)
end)

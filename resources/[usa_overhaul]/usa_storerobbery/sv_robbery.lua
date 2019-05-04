local policeNeeded = 2
local policeNeededForBonus = 4
local robberyCooldown = 2100
local rewardRange = {350, 450}
local anyStoreBeingRobbed = false

local stores = {
	["Rob's Liquor (El Rancho Blvd.)"] = {
		position = {1134.21, -979.33, 46.41},
		cameraID = 'store1',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["LTD Gasoline (Ginger St.)"] = {
		position = {-705.89, -911.89, 19.21},
		cameraID = 'store2',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Paleto Bay)"] = {
		position = {1729.37, 6418.29, 35.03},
		cameraID = 'store3',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket - (Innocence Blvd.)"] = {
		position = {24.44, -1343.922, 29.49},
		cameraID = 'store4',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Rob's Liquor - (San Andreas Ave.)"] = {
		position = {-1224.64, -909.504, 12.32},
		cameraID = 'store5',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Alhambra Dr.)"] = {
		position = {1958.38, 3743.11, 32.34},
		cameraID = 'store6',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	['247 Supermarket (Clinton Ave.)'] = {
		position = {373.25, 329.68, 103.56},
		cameraID = 'store7',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["LTD Gasoline (Grove St.)"] = {
		position = {-45.50, -1756.71, 29.42},
		cameraID = 'store8',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Rob's Liquor (Route 68)"] = {
		position = {1168.00, 2711.08, 38.15},
		cameraID = 'store9',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["LTD Gasoline (Grapeseed Main St.)"] = {
		position = {1699.34, 4921.74, 42.06},
		cameraID = 'store10',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Ineseno Rd.)"] = {
		position = {-3041.47, 583.62, 7.90},
		cameraID = 'store11',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Palomino Fwy.)"] = {
		position = {2554.50, 380.78, 108.62},
		cameraID = 'store12',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Senora Fwy.)"] = {
		position = {2675.65, 3280.58, 55.24},
		cameraID = 'store13',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Harmony, Route 68)"] = {
		position = {549.51, 2668.76, 42.15},
		cameraID = 'store14',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["LTD Gasoline (Banham Canyon Dr.)"] = {
		position = {-1821.10, 795.60, 138.09},
		cameraID = 'store15',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["247 Supermarket (Barbareno Rd.)"] = {
		position = {-3244.92, 1000.0, 12.83},
		cameraID = 'store16',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Rob's Liquor (Great Ocean Hwy.)"] = {
		position = {-2966.24, 388.91, 15.04},
		cameraID = 'store17',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Clothing Store (Sinner St.)"] = {
		position = {427.34, -807.00, 29.49},
		cameraID = 'store18',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["LS Customs (La Mesa)"] = {
		position = {725.80, -1070.75, 28.31},
		cameraID = 'store19',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Herr Kutz Barbers (Carson Ave.)"] = {
		position = {134.45, -1707.75, 29.29},
		cameraID = 'store20',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Clothing Store (Innocence Blvd.)"] = {
		position = {73.98, -1392.14, 29.37},
		cameraID = 'store21',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Herr Kutz Barbers (Niland Ave.)"] = {
		position = {1930.57, 3728.08, 32.84},
		cameraID = 'store22',
		isBeingRobbed = false,
		lastRobbedTime = 0
	},
	["Yellow Jack Inn (Panorama Dr.)"] = {
		position = {1984.26, 3049.39, 47.21},
		cameraID = 'store23',
		isBeingRobbed = false,
		lastRobbedTime = 0
	}
}

RegisterServerEvent('storeRobbery:beginRobbery')
AddEventHandler('storeRobbery:beginRobbery', function(storeName, isSuspectMale)
	local _source = source
	if stores[storeName] then
		local store = stores[storeName]
		local x, y, z = table.unpack(store.position)
		local policeOnline = GetPoliceOnline()
		if ((os.time() - store.lastRobbedTime) < robberyCooldown and store.lastRobbedTime ~= 0) or policeOnline < 2  or anyStoreBeingRobbed then
			TriggerClientEvent('usa:notify', _source, 'This store is currently closed!')
			return
		end
		stores[storeName].isBeingRobbed = _source
		store.lastRobbedTime = os.time()
		anyStoreBeingRobbed = true
		TriggerEvent('911:Robbery', x, y, z, storeName, isSuspectMale, store.cameraID)
		TriggerClientEvent('usa:notify', _source, "~y~Robbery has begun~s~, hold the fort for the timer duration and don't leave!")
		TriggerClientEvent('storeRobbery:robStore', _source, storeName)
		print('ROBBERY: Robbery has begun at store['..storeName..'], triggered by '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..']!')
		return
	end
	print('ROBBERY: '..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source)..'] attempted to begin a robbery at store not in table!')
end)

RegisterServerEvent('storeRobbery:finishRobbery')
AddEventHandler('storeRobbery:finishRobbery', function(storeName)
	local _source = source
	if stores[storeName] and stores[storeName].isBeingRobbed == _source then
		local store = stores[storeName]
		if store.isBeingRobbed == _source then
			local user = exports["essentialmode"]:getPlayerFromId(_source)
			if user then
				print("ROBBERY: Robbery has ended at store["..storeName.."], triggered by "..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source).."]!")
				store.isBeingRobbed = false
				anyStoreBeingRobbed = false
				local policeOnline = GetPoliceOnline()
				local reward = math.random(rewardRange[1], rewardRange[2])
				local bonus = 0
				if policeOnline > policeNeededForBonus then
					bonus = math.floor((reward * 0.08) - reward)
				end
				local user_money = user.getActiveCharacterData('money')
				user.setActiveCharacterData("money", user_money + (reward + bonus))
				print("ROBBERY: "..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source).."] has been rewarded reward["..reward.."] with bonus["..bonus.."]!")
				if bonus > 0 then
					TriggerClientEvent('usa:notify', _source, 'You have stolen ~y~$'..reward..'.00~s~ with a bonus of ~y~$'..bonus..'.00~s~!')
				else
					TriggerClientEvent('usa:notify', _source, 'You have stolen ~y~$'..reward..'.00~s~!')
				end
			end
		end
	end
end)

RegisterServerEvent('storeRobbery:cancelRobbery')
AddEventHandler('storeRobbery:cancelRobbery', function(storeName)
	local _source = source
	if stores[storeName] then
		local store = stores[storeName]
		store.isBeingRobbed = false
		anyStoreBeingRobbed = false
		print("ROBBERY: Robbery at store["..storeName.."] has been cancelled! (triggered by "..GetPlayerName(_source)..'['..GetPlayerIdentifier(_source).."])")
	end
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function(reason)
	for store, data in pairs(stores) do
		if data.isBeingRobbed == source then
			anyStoreBeingRobbed = false
			print("ROBBERY: Robbery at store["..store.."] has been cancelled! (triggered by "..GetPlayerName(source)..'['..GetPlayerIdentifier(source).."], has LEFT THE SERVER)")
		end
	end
end)


function GetPoliceOnline()
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
	return policeOnline
end
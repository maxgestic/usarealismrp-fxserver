local anyStoreBeingRobbed = false

RegisterServerEvent('business:beginRobbery')
AddEventHandler('business:beginRobbery', function(storeName, isSuspectMale, players)
	if BUSINESSES[storeName] then
		local store = BUSINESSES[storeName]
		local x, y, z = table.unpack(store.position)
		local policeOnline = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
		if ((os.time() - store.lastRobbedTime) < robberyCooldown and store.lastRobbedTime ~= 0) or policeOnline < POLICE_NEEDED  or anyStoreBeingRobbed or IsInstanced(players) then
			TriggerClientEvent('usa:notify', source, "Couldn't find any money!")
			return
		end
		BUSINESSES[storeName].isBeingRobbed = source
		store.lastRobbedTime = os.time()
		anyStoreBeingRobbed = true
		TriggerEvent('911:Robbery', x, y, z, storeName, isSuspectMale, store.cameraID)
		TriggerClientEvent('usa:notify', source, "~y~Robbery has begun~s~, hold the fort for the timer duration and don't leave!")
		TriggerClientEvent('business:robStore', source, storeName)
		print('ROBBERY: Robbery has begun at store['..storeName..'], triggered by '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..']!')
		return
	else
		print('ROBBERY: '..GetPlayerName(source)..'['..GetPlayerIdentifier(source)..'] attempted to begin a robbery at store not in table!')
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
	    TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit business:beginRobbery event, please intervene^0!')
	end
end)

RegisterServerEvent('business:finishRobbery')
AddEventHandler('business:finishRobbery', function(storeName)
	local char = exports["usa-characters"]:GetCharacter(source)
	if BUSINESSES[storeName] and BUSINESSES[storeName].isBeingRobbed == source then
		local store = BUSINESSES[storeName]
		print("ROBBERY: Robbery has ended at store["..storeName.."], triggered by "..GetPlayerName(source)..'['..GetPlayerIdentifier(source).."]!")
		store.isBeingRobbed = false
		anyStoreBeingRobbed = false
		local policeOnline = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
		local reward = math.random(rewardRange[1], rewardRange[2])
		local bonus = 0
		if policeOnline > policeNeededForBonus then
			bonus = math.floor((reward * 0.08) - reward)
		end
		char.giveMoney((reward + bonus))
		print("ROBBERY: "..GetPlayerName(source)..'['..GetPlayerIdentifier(source).."] has been rewarded reward["..reward.."] with bonus["..bonus.."]!")
		if bonus > 0 then
			TriggerClientEvent('usa:notify', source, 'You have stolen $'..reward..'.00 with a bonus of $'..bonus..'.00!')
		else
			TriggerClientEvent('usa:notify', source, 'You have stolen $'..reward..'.00!')
		end
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
	    TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit business:finishRobbery event, please intervene^0!')
	end
end)

RegisterServerEvent('business:cancelRobbery')
AddEventHandler('business:cancelRobbery', function(storeName)
	if BUSINESSES[storeName] then
		local store = BUSINESSES[storeName]
		store.isBeingRobbed = false
		anyStoreBeingRobbed = false
		print("ROBBERY: Robbery at store["..storeName.."] has been cancelled! (triggered by "..GetPlayerName(source)..'['..GetPlayerIdentifier(source).."])")
	else
		DropPlayer(source, "Exploiting. Your information has been logged and staff has been notified. If you feel this was by mistake, let a staff member know.")
	    TriggerEvent("usa:notifyStaff", '^1^*[ANTICHEAT]^r^0 Player ^1'..GetPlayerName(source)..' ['..GetPlayerIdentifier(source)..'] ^0 has been kicked for attempting to exploit business:cancelRobbery event, please intervene^0!')
	end
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function(reason)
	for store, data in pairs(BUSINESSES) do
		if data.isBeingRobbed == source then
			anyStoreBeingRobbed = false
			print("ROBBERY: Robbery at store["..store.."] has been cancelled! (triggered by "..GetPlayerName(source)..'['..GetPlayerIdentifier(source).."], has LEFT THE SERVER)")
		end
	end
end)

function IsInstanced(playersGiven)
	if #GetPlayers() - playersGiven > 1 then
		return true
	end
	return false
end

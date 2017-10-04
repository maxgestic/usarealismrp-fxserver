-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- restart essentialmode

function CreatePlayer(source, permission_level, money, bank, identifier, group, model, inventory, weapons, vehicles, insurance, job, licenses, criminalHistory, characters, jailtime, policeRank, policeCharacter, EMSRank, securityRank, ingameTime)
	local self = {}

	self.source = source
	self.permission_level = permission_level
	self.money = money
	self.bank = bank
	self.identifier = identifier
	self.group = group
	-- CUSTOM STUFF HERE --
	self.model = model
	self.inventory = inventory
	self.weapons = weapons
	self.vehicles = vehicles
	self.insurance = insurance
	self.job = job
	self.licenses = licenses
	self.criminalHistory = criminalHistory
	self.characters = characters
	self.jailtime = jailtime
	if policeRank == nil then
		self.policeRank = 0
	else
		self.policeRank = policeRank
	end
	if policeCharacter == nil then
		self.policeCharacter = {}
	else
		self.policeCharacter = policeCharacter
	end
	if EMSRank == nil then
		self.EMSRank = 0
	else
		self.EMSRank = EMSRank
	end
    if securityRank == nil then
		self.securityRank = 0
	else
		self.securityRank = securityRank
	end
	if ingameTime == nil then
		self.ingameTime = 0
	else
		self.ingameTime = ingameTime
	end
	-- END --
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = false

	local rTable = {}

	rTable.setJailtime = function(j)
		self.jailtime = j
	end

	rTable.getJailtime = function()
		return self.jailtime
	end

	rTable.setCharacter = function(character, characterNumber)
		if self.characters[characterNumber] then
			self.characters[characterNumber] = character
		else
			print("tried to set a character at an index that did not exist!")
		end
	end

	rTable.setCharacters = function(characters)
		self.characters = characters
	end

	rTable.getCharacters = function()
		return self.characters
	end

	rTable.setMoney = function(m)
		local prevMoney = self.money
		local newMoney = m

		self.money = m

		if((prevMoney - newMoney) < 0)then
			TriggerClientEvent("es:addedMoney", self.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
		else
			TriggerClientEvent("es:removedMoney", self.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
		end

		if not settings.defaultSettings.nativeMoneySystem then
			TriggerClientEvent('es:activateMoney', self.source , self.money)
		end
	end

	-- CUSTOM SETTERS/GETTERS HERE --
	rTable.getIngameTime = function()
		return self.ingameTime
	end

	rTable.setIngameTime = function(time)
		self.ingameTime = self.ingameTime + time
	end
	rTable.getSecurityRank = function()
		return self.securityRank
	end

	rTable.setSecurityRank = function(rank)
		self.securityRank = rank
	end
    
    rTable.getEMSRank = function()
		return self.EMSRank
	end

	rTable.setEMSRank = function(rank)
		self.EMSRank = rank
	end
	
	rTable.getPoliceCharacter = function()
		return self.policeCharacter
	end

	rTable.setPoliceCharacter = function(character)
		self.policeCharacter = character
	end
	
	rTable.getPoliceRank = function()
		return self.policeRank
	end

	rTable.setPoliceRank = function(rank)
		self.policeRank = rank
	end
	
	rTable.getCriminalHistory = function()
		return self.criminalHistory
	end

	rTable.setCriminalHistory = function(history)
		self.criminalHistory = history
	end

	rTable.getLicenses = function()
		return self.licenses
	end

	rTable.setLicenses = function(l)
		self.licenses = l
	end

	rTable.getInsurance = function()
		return self.insurance
	end

	rTable.setInsurance = function(i)
		self.insurance = i
	end

	rTable.getVehicles = function()
		return self.vehicles
	end

	rTable.setVehicles = function(v)
		self.vehicles = v
	end

	rTable.getWeapons = function()
		return self.weapons
	end

	rTable.setWeapons = function(w)
		self.weapons = w
	end

	rTable.getInventory = function()
		return self.inventory
	end

	rTable.setInventory = function(i)
		self.inventory = i
	end

	rTable.getModel = function()
		return self.model
	end

	rTable.setModel = function(m)
		self.model = m
	end

	rTable.getJob = function()
		return self.job
	end

	rTable.setJob = function(m)
		self.job = m
	end

	rTable.getMoney = function()
		return self.money
	end

	rTable.setBankBalance = function(m)
		TriggerEvent("es:setPlayerData", self.source, "bank", m, function(response, success)
			self.bank = m
		end)
	end

	rTable.getBank = function()
		return self.bank
	end

	rTable.getCoords = function()
		return self.coords
	end

	rTable.setCoords = function(x, y, z)
		self.coords = {x = x, y = y, z = z}
	end

	rTable.kick = function(r)
		DropPlayer(self.source, r)
	end

	rTable.addMoney = function(m)
		local newMoney = self.money + m

		self.money = newMoney

		TriggerClientEvent("es:addedMoney", self.source, m, settings.defaultSettings.nativeMoneySystem)
		if not settings.defaultSettings.nativeMoneySystem then
			TriggerClientEvent('es:activateMoney', self.source , self.money)
		end
	end

	rTable.removeMoney = function(m)
		local newMoney = self.money - m

		self.money = newMoney

		TriggerClientEvent("es:removedMoney", self.source, m, settings.defaultSettings.nativeMoneySystem)
		if not settings.defaultSettings.nativeMoneySystem then
			TriggerClientEvent('es:activateMoney', self.source , self.money)
		end
	end

	rTable.addBank = function(m)
		local newBank = self.bank + m
		self.bank = newBank

		TriggerClientEvent("es:addedBank", self.source, m)
	end

	rTable.removeBank = function(m)
		local newBank = self.bank - m
		self.bank = newBank

		TriggerClientEvent("es:removedBank", self.source, m)
	end

	rTable.displayMoney = function(m)
		TriggerClientEvent("es:displayMoney", self.source, math.floor(m))
	end

	rTable.displayBank = function(m)
		if not self.bankDisplayed then
			TriggerClientEvent("es:displayBank", self.source, math.floor(m))
			self.bankDisplayed = true
		end
	end

	rTable.setSessionVar = function(key, value)
		self.session[key] = value
	end

	rTable.getSessionVar = function(k)
		return self.session[k]
	end

	rTable.getPermissions = function()
		return self.permission_level
	end

	rTable.setPermissions = function(p)
		self.permission_level = p
	end

	rTable.getIdentifier = function(i)
		return self.identifier
	end

	rTable.getGroup = function()
		return self.group
	end

	rTable.set = function(k, v)
		self[k] = v
	end

	rTable.get = function(k)
		return self[k]
	end

	rTable.setGlobal = function(g, default)
		self[g] = default or ""

		rTable["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		rTable["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = rTable
	end

	return rTable
end

-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- restart essentialmode

function CreatePlayer(source, permission_level, money, bank, identifier, group, model, inventory, weapons, vehicles, insurance, job, licenses, criminalHistory)
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
	-- END --
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = false

	local rTable = {}

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

function CreatePlayer(source, permission_level, identifier, group, policeCharacter, emsCharacter)
	local self = {}

	self.source = source
	self.permission_level = permission_level
	self.identifier = identifier
	self.group = group
	-- CUSTOM STUFF HERE --
	if policeCharacter == nil then
		self.policeCharacter = {}
	else
		self.policeCharacter = policeCharacter
	end
	if emsCharacter == nil then
		self.emsCharacter = {}
	else
		self.emsCharacter = emsCharacter
	end
	-- END --
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = false

	local rTable = {}

	-- CUSTOM SETTERS/GETTERS HERE --
	rTable.getPoliceCharacter = function()
		return self.policeCharacter
	end

	rTable.setPoliceCharacter = function(character)
		self.policeCharacter = character
	end

	rTable.setEmsCharacter = function(character)
		if not self.emsCharacter then self.emsCharacter = {} end
		self.emsCharacter = character
		print("ems character set! hash: " .. character.hash)
	end

	rTable.getEmsCharacter = function()
		if not self.emsCharacter then print("self.emsCharacter did not exist when loading!") end
		return self.emsCharacter
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

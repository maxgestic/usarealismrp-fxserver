-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- restart essentialmode

function CreatePlayer(source, permission_level, identifier, group, characters, policeCharacter)
	local self = {}

	self.source = source
	self.permission_level = permission_level
	self.identifier = identifier
	self.group = group
	-- CUSTOM STUFF HERE --
	self.characters = characters
	if policeCharacter == nil then
		self.policeCharacter = {}
	else
		self.policeCharacter = policeCharacter
	end
	-- END --
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = false

	local rTable = {}

	rTable.setActiveCharacterData = function(field, data)
		for i = 1, #self.characters do
			local char = self.characters[i]
			if char.active == true then
				--print("found an active character at " .. i .. "!")
				--print("target field to set: " .. field)
				--print("setting data...")
				if self.characters[i][field] then
					-- update the NUI gui
					if field == "money" then
						local new_money = data
						local prev_money = self.characters[i][field]
						if (new_money > prev_money) then
							TriggerClientEvent("es:addedMoney", self.source, math.abs(prev_money - new_money), settings.defaultSettings.nativeMoneySystem)
						else
							TriggerClientEvent("es:removedMoney", self.source, math.abs(prev_money - new_money), settings.defaultSettings.nativeMoneySystem)
						end
						if not settings.defaultSettings.nativeMoneySystem then
							--print("calling es:activeMoney with money = " .. new_money)
							TriggerClientEvent('es:activateMoney', self.source , new_money)
						end
					elseif field == "bank" then
						print("field was bank!")
						--TriggerEvent("es:setPlayerData", self.source, "bank", data, function(response, success)
							--print("bank saved!!")
							--self.bank = data
						--end)
					end
					-- update char
					self.characters[i][field] = data
					print("set!")
				else
					print("Error: field " .. field .. " did not exist on the character! can't set it!")
				end
			end
		end
	end

	rTable.getActiveCharacterData = function(field)
		for i = 1, #self.characters do
			local char = self.characters[i]
			if char.active == true then
				--print("found an active character at " .. i .. "!")
				--print("target field to retrieve: " .. field)
				if self.characters[i][field] then
					return self.characters[i][field]
				else
					print("field " .. field .. " did not exist on the character! can't retrieve it!")
					return nil
				end
			end
		end
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

	rTable.getCharacter = function(index)
		return self.characters[index]
	end

	-- CUSTOM SETTERS/GETTERS HERE --
	rTable.getPoliceCharacter = function()
		return self.policeCharacter
	end

	rTable.setPoliceCharacter = function(character)
		self.policeCharacter = character
	end

	-- unused? remove?
	rTable.setBankBalance = function(m)
		TriggerEvent("es:setPlayerData", self.source, "bank", m, function(response, success)
			self.bank = m
		end)
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

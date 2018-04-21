-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- restart essentialmode

function CreatePlayer(source, permission_level, identifier, group, characters, policeCharacter, emsCharacter)
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

	rTable.getCanActiveCharacterHoldItem = function(item_to_add)
		--print("getting active character inventory weight!")
		local current_weight = 0.0
		for i = 1, #self.characters do
			local char = self.characters[i]
			if char.active == true then
				-----------------------------
				-- ADD UP INVENTORY WEIGHT --
				-----------------------------
				local char_inventory = char.inventory
				for j = 1, #char_inventory do
					local item = char_inventory[j]
					if item then
						if not item.weight then item.weight = 1.0 end -- for players with old items that don't have a weight property yet
						--print("adding item: " .. item.name .. ", weight: " .. item.weight)
						current_weight = current_weight + (item.weight * item.quantity)
					end
				end
				-----------------------------
				-- ADD UP WEAPONS WEIGHT --
				-----------------------------
				local char_weapons = char.weapons
				for j = 1, #char_weapons do
					local item = char_weapons[j]
					if item then
						if not item.weight then item.weight = 5.0 end -- for players with old weapon items that don't have a weight property yet
						--print("adding item: " .. item.name .. ", weight: " .. item.weight)
						current_weight = current_weight + (item.weight * item.quantity)
					end
				end
				---------------------------------------------------------------------------------------
				-- done adding all the inventory item weights, see if player has room for given item --
				---------------------------------------------------------------------------------------
				if not item_to_add.weight then item_to_add.weight = 1.0 end
				if current_weight + (item_to_add.weight * item_to_add.quantity) <= 100.0 then
					return true
				else
					return false
				end
			end
		end
	end

	rTable.getActiveCharacterCurrentInventoryWeight = function()
		--print("getting active character inventory weight!")
		local current_weight = 0.0
		for i = 1, #self.characters do
			local char = self.characters[i]
			if char.active == true then
				-----------------------------
				-- ADD UP INVENTORY WEIGHT --
				-----------------------------
				local char_inventory = char.inventory
				for j = 1, #char_inventory do
					local item = char_inventory[j]
					if item then
						if not item.weight then item.weight = 1.0 end -- for players with old items that don't have a weight property yet
						--print("adding item: " .. item.name .. ", weight: " .. item.weight)
						current_weight = current_weight + (item.weight * item.quantity)
					end
				end
				-----------------------------
				-- ADD UP WEAPONS WEIGHT --
				-----------------------------
				local char_weapons = char.weapons
				for j = 1, #char_weapons do
					local item = char_weapons[j]
					if item then
						if not item.weight then item.weight = 5.0 end -- for players with old weapon items that don't have a weight property yet
						--print("adding item: " .. item.name .. ", weight: " .. item.weight)
						current_weight = current_weight + (item.weight * item.quantity)
					end
				end
				-- done adding all the inventory item weights
				return current_weight
			end
		end
	end

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
					elseif field == "job" then
						TriggerClientEvent('chat:removeSuggestionAll', self.source)
						for k,v in pairs(exports['essentialmode']:getCommands()) do
							if v.job == "everyone" then
								if exports['essentialmode']:CanGroupTarget(self.group, v.group) then
									TriggerClientEvent('chat:addSuggestion', self.source, '/' .. k, v.help, v.params)
								end
							else
								local allowed = 0;
								for k,vc in pairs(v.job) do
									if data == vc then
										allowed = 1
									end
								end

								if allowed == 1 then
									TriggerClientEvent('chat:addSuggestion', self.source, '/' .. k, v.help, v.params)
								end
							end
						end
					end
					-- update char
					self.characters[i][field] = data
					--print("set!")
				else
					--print("Error: field " .. field .. " did not exist on the character! can't set it!")
					print("INFO: field " .. field .. " did not exist on the character! Creating the field...")
					self.characters[i][field] = data
				end
			end
		end
	end

	rTable.getActiveCharacterData = function(field)
		for i = 1, #self.characters do
			local char = self.characters[i]
			if char.active == true then
				if field == "fullName" then
					--print("field was fullName! returning : " .. self.characters[i]["firstName"]  .. " " .. self.characters[i]["lastName"])
					if self.characters[i]["firstName"] and self.characters[i]["lastName"] then
						--print("both first / last existed")
						return self.characters[i]["firstName"] .. " " .. self.characters[i]["lastName"]
					elseif self.characters[i]["firstName"] and not self.characters[i]["lastName"] then
						print("**only first name existed for player**")
						return self.characters[i]["firstName"]
					elseif self.characters[i]["lastName"] and not self.characters[i]["firstName"] then
						print("**only last name existed for player**")
						return self.characters[i]["lastName"]
					end
				end
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

	rTable.setEmsCharacter = function(character)
		if not self.emsCharacter then self.emsCharacter = {} end
		self.emsCharacter = character
		print("ems character set! hash: " .. character.hash)
	end

	rTable.getEmsCharacter = function()
		if not self.emsCharacter then print("self.emsCharacter did not exist when loading!") end
		return self.emsCharacter
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

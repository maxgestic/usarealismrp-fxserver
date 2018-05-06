-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function LoadUser(identifier, source, new)
	db.retrieveUser(identifier, function(user)
		Users[source] = CreatePlayer(source, user.permission_level, user.identifier, user.group, user.characters, user.policeCharacter, user.emsCharacter)
		--print("loaded user " .. GetPlayerName(tonumber(source)) .. "from db...")

		TriggerEvent('es:playerLoaded', source, Users[source])

		TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
		TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)

		if new then
			TriggerEvent('es:newPlayerLoaded', source, Users[source])
		end

		TriggerEvent("chat:sendToLogFile", source, "joined the server! Timestamp: " .. os.date('%m-%d-%Y %H:%M:%S', os.time()))
	end)
end

function getPlayerFromId(id)
	return Users[id]
end

function stringsplit(inputstr, sep)
	if sep == nil then
			sep = "%s"
		end
		local t={} ; i=1
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
		end
	return t
end

AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

function registerUser(identifier, source)
	db.doesUserExist(identifier, function(exists)
		if exists then
			LoadUser(identifier, source, false)
		else
			db.createUser(identifier, function(r, user)
				LoadUser(identifier, source, true)
			end)
		end
	end)
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		-- passed in group field to save? save it on the user, not the user's character(s)
		if(k == "group")then
			Users[user].set(k, v)
			db.updateUser(Users[user].get('identifier'), {group = v}, function(d)
				if d == true then
					cb("Player group data edited", true)
				else
					cb(d, false)
				end
			end)
		else -- not group field, save it on the character
			if(Users[user].getActiveCharacterData(k))then
				if(k ~= "money") then
					Users[user].setActiveCharacterData(k, v)
					db.updateUser(Users[user].get('identifier'), {characters = Users[user].getCharacters()}, function(d)
						if d == true then
							cb("Player data edited", true)
						else
							cb(d, false)
						end
					end)
				end
			else
				cb("Column does not exist!", false)
			end
		end
	else
		cb("User could not be found!", false)
	end
end)

-- todo: update for characters?
AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb("Player data edited.", true)
	end)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)

--[[
-- Function to update player money every 60 seconds.
local function savePlayerMoney()
	SetTimeout(60000, function()
		for k,v in pairs(Users)do
			if Users[k] ~= nil then
				db.updateUser(v.get('identifier'), {characters = v.getCharacters()}, function() end)
			end
		end

		savePlayerMoney()
	end)
end

savePlayerMoney()
--]]

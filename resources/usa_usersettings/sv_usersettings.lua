exports["globals"]:PerformDBCheck("usa_usersettings", "user-settings")
RegisterServerEvent('usaSettings:updateUserSettings')
RegisterServerEvent('usaSettings:returnUserSettings')

local defaultSettings = {
	radioHotkey = 161,
	serverVisuals = true
}

AddEventHandler('usaSettings:updateUserSettings', function(_source, settings)
	local playerSource = _source
	local steamName = GetPlayerIdentifier(playerSource)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.updateDocument("user-settings", steamName, settings, function(success)
        	if success then
        		print("* user settings updated["..steamName.."] *")
        	else
        		print("* Error: user settings failed to update["..steamName.."]! *")
            end
        end)
    end)
end)

AddEventHandler('usaSettings:returnUserSettings', function(_source, cb)
	local playerSource = _source
	GetUserSettings(playerSource, function(settings)
		if settings then
			cb(settings)
		end
	end)
end)

AddEventHandler('playerConnecting', function()
	local playerSource = source
	local steamName = GetPlayerIdentifier(playerSource)
	GetUserSettings(playerSource, function(settings)
		if not settings and string.sub(steamName, 1, 5) == 'steam' then
			Citizen.Wait(5000)
			if GetPlayerIdentifier(playerSource) then
				CreateUserSettings(playerSource)
			end
		end
	end)
end)


function GetUserSettings(source, cb)
	local steamName = GetPlayerIdentifier(source)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.getDocumentById("user-settings", steamName, function(settings)
            if settings then
              cb(settings)
            else
            	cb(false)
            end
        end)
    end)
end

function CreateUserSettings(source)
	local steamName = GetPlayerIdentifier(source)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
	    couchdb.createDocumentWithId("user-settings", defaultSettings, steamName, function(success)
	        if success then
	            print("* user settings created["..steamName.."] *")
	        else
	            print("* Error: user settings failed to create["..steamName.."]! * ")
	        end
	    end)
	end)
end

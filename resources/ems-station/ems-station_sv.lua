function stringSplit(inputstr, sep)
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

RegisterServerEvent("emsStation:toggleDuty")
AddEventHandler("emsStation:toggleDuty", function(params)
    local splitParams = stringSplit(params,":")
    local gender = splitParams[1]
    local type = splitParams[2]
	local userSource = source
    local playerJob
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            playerJob = result.job
            -- give appropriate loadout
            if playerJob ~= ("fire" or "ems") then
                local emsModel
                local newJob
                -- chosen gender for sheriff
                if gender == "male" then
                    if type == "paramedic" then
                        emsModel = "S_M_M_Paramedic_01"
                        newJob = "ems"
                    else
                        emsModel = "S_M_Y_Fireman_01"
                        newJob = "fire"
                    end
                else
                        emsModel = "S_F_Y_Scrubs_01"
                        newJob = "ems"
                end
                TriggerClientEvent("emsStation:giveEmsLoadout", userSource, emsModel)
                usersTable.updateDocument("essentialmode", docid ,{job = newJob},function() end)
            end
        end)
    end)
end)

RegisterServerEvent("emsStation:giveCivStuff")
AddEventHandler("emsStation:giveCivStuff", function()
    -- get player job
    local userSource = source
    local playerModel, playerWeapons, playerJob
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            docid = result._id
            playerJob = result.job
            playerModel = result.model
            playerWeapons = result.weapons
            if playerJob == "sheriff" or playerJob == "fire" or playerJob == "ems" then
                TriggerClientEvent("emsStation:giveCivLoadout", userSource, playerModel, playerWeapons)
                usersTable.updateDocument("essentialmode", docid ,{job = "civ"},function() end)
            end
        end)
    end)
--[[
		TriggerClientEvent("gps:removeAllEMSReq", source)

		TriggerEvent("es:getPlayers", function(pl)
			local users = {}
			for k, v in pairs(pl) do
				TriggerEvent("es:getPlayerFromId", k, function(user)
					if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
						table.insert(users, user.identifier)
					end
				end)
			end
			TriggerClientEvent("gps:removeGov", source, users)
		end)
--]]
end)

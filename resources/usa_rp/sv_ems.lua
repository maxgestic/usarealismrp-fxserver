-- /admit [id] [time] [reason]
TriggerEvent('es:addCommand', 'admit', function(source, args, user)
    local userSource = tonumber(source)
    local userJob = user.getActiveCharacterData("job")
    if userJob == "ems" or userJob == "fire" or userJob == "police" or userJob == "sheriff" then
        local targetPlayerId = tonumber(args[2])
        local targetPlayerAdmissionTime = tonumber(args[3])
        table.remove(args, 1)
        table.remove(args, 1)
        table.remove(args, 1)
        local reasonForAdmission = table.concat(args, " ")
        if not targetPlayerAdmissionTime or not reasonForAdmission or not GetPlayerName(targetPlayerId) then return end
        print("admitting patient to hospital!")
        TriggerClientEvent("ems:admitPatient", targetPlayerId)
        TriggerClientEvent("ems:notifyHospitalized", targetPlayerId, targetPlayerAdmissionTime, reasonForAdmission)
        TriggerClientEvent("ems:notifyHospitalized", userSource, targetPlayerAdmissionTime, reasonForAdmission)
        SetTimeout(targetPlayerAdmissionTime*60000, function()
            TriggerClientEvent("ems:releasePatient", targetPlayerId)
        end)
        -- send to discord #ems-logs
		local url = 'https://discordapp.com/api/webhooks/375425187014770699/i6quT1ZKnFoZgOC4rSpudTc2ucmvfXuAUQJXqDI0oeKoeqLGX0etu-GGMpIKbKuAqk70'
		PerformHttpRequest(url, function(err, text, headers)
			if text then
				print(text)
			end
		end, "POST", json.encode({
			embeds = {
				{
					description = "**Name:** " .. GetPlayerName(targetPlayerId) .. " \n**Time:** " .. targetPlayerAdmissionTime .. " hour(s)" .. " \n**Reason:** " .. reasonForAdmission .. "\n**Responder:** " .. GetPlayerName(userSource) .."\n**Timestamp:** " .. os.date('%m-%d-%Y %H:%M:%S', os.time()),
					color = 263172,
					author = {
						name = "Pillbox Medical"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json' })
    end
end)

RegisterServerEvent("ems:checkPlayerMoney")
AddEventHandler("ems:checkPlayerMoney", function()
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            if user.getActiveCharacterData("money") >= 500 then
                local user_money = user.getActiveCharacterData("money")
                user.setActiveCharacterData("money", user_money - 500)
                TriggerClientEvent("ems:healPlayer", userSource)
            end
        end
    end)
end)

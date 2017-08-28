-- /admit [id] [time] [reason]
TriggerEvent('es:addCommand', 'admit', function(source, args, user)
    local userSource = tonumber(source)
    local userJob = user.getJob()
    if userJob == "ems" or userJob == "fire" then
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
    end
end)

RegisterServerEvent("ems:checkPlayerMoney")
AddEventHandler("ems:checkPlayerMoney", function()
    local userSource = tonumber(source)
    TriggerEvent("es:getPlayerFromId", userSource, function(user)
        if user then
            if user.getMoney() >= 500 then
                user.removeMoney(500)
                TriggerClientEvent("ems:healPlayer", userSource)
            end
        end
    end)
end)

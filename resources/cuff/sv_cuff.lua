TriggerEvent('es:addCommand','cuff', function(source, args, user)
        if args[2] ~= nil then
            local userSource = source
                    playerJob = user.getJob()
                    if playerJob == "sheriff" then
                         local tPID = tonumber(args[2])
                         TriggerClientEvent("Handcuff", tPID)
                    else
                        TriggerClientEvent("cuff:notify", source, "Only ~y~law enforcement~w~ can use /cuff!")
                    end
        end
end)

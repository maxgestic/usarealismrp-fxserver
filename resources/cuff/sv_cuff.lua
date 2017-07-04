TriggerEvent('es:addCommand','cuff', function(source, args, user)
        local playerJob
        if args[2] ~= nil then
            local userSource = source
            local idents = GetPlayerIdentifiers(userSource)
            TriggerEvent('es:exposeDBFunctions', function(usersTable)
                usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                    docid = result._id
                    playerJob = result.job
                    if playerJob == "sheriff" then
                         local tPID = tonumber(args[2])
                         TriggerClientEvent("Handcuff", tPID)
                    else
                        TriggerClientEvent("cuff:notify", source, "Only ~y~law enforcement~w~ can use /cuff!")
                    end
                end)
            end)
        end
end)

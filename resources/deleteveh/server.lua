TriggerEvent('es:addCommand','impound', function(source, args, user)
        local playerJob
            local userSource = source
            local idents = GetPlayerIdentifiers(userSource)
            TriggerEvent('es:exposeDBFunctions', function(usersTable)
                usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
                    docid = result._id
                    playerJob = result.job
                    if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or playerJob == "owner" or playerJob == "admin" or playerJob == "mod" then
                        -- do stuff here
                        TriggerClientEvent( 'impoundVehicle', source )
                    else
                        TriggerClientEvent("impound:notify", source, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
                    end
                end)
            end)
end)


RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
    print("inside of impound:impoundVehicle!")
    local userSource = source
    local idents = GetPlayerIdentifiers(userSource)
    TriggerEvent('es:exposeDBFunctions', function(usersTable)
        usersTable.getDocumentByRow("essentialmode", "identifier", idents[1], function(result)
            print("inside callback for getDocumentByRow")
            print("typeof result = " .. type(result))
            docid = result._id
            if docid then
                print("docid = " .. docid)
            else
                print("docid did not exist!")
            end
            playerJob = result.job
            if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or playerJob == "owner" or playerJob == "admin" or playerJob == "mod" then
                print("user's job was sheriff.. calling userTable.getContentsOfView now...")
                -- basically: go through the vehicle properties on each player's document and see if the plate matches the passed in plate from the client
                -- if they match, then set the impounded property to true on that specific player's vehicle property of their document
                usersTable.getContentsOfView('essentialmode', "test", "test-view", function(rows)
                    for i = 1, #rows do
                        local result = rows[i]
                        if result.value then
                            local playerVehicle = result.value
                            if playerVehicle.plate == plate then
                                print("plates matched! setting player vehicle impound status!")
                                -- TODO: TEST THIS CODE. LOL....
                                playerVehicle.impounded = true
                                usersTable.updateDocument("essentialmode", docid ,{vehicle = playerVehicle},function() end)
                            end
                        end
                    end
                end)
                TriggerClientEvent( 'impoundVehicle', source )
            else
                TriggerClientEvent("impound:notify", source, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
            end
        end)
    end)
    --[[
    if key == "plate" then
        if string.match(plate,val) ~= nil then
            print("found a matching plate to be impounded")
            v.impounded = true
            print("v.impounded = " .. tostring(v.impounded))
            return
        end
    end
    ]]
end)

TriggerEvent('es:addCommand','impound', function(source, args, user)
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerJob = user.getJob()
        if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or playerJob == "owner" or playerJob == "admin" or playerJob == "mod" then
            TriggerClientEvent( 'impoundVehicle', source )
        else
            TriggerClientEvent("impound:notify", source, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
        end
    end)
end)


RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
    print("inside of impound:impoundVehicle!")
    local userSource = source
    TriggerEvent('es:getPlayerFromId', userSource, function(user)
        local playerJob = user.getJob()
        if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or playerJob == "owner" or playerJob == "admin" or playerJob == "mod" then
            TriggerEvent('es:getPlayers', function(players)
                    for x = 1, #players do
                        local player = players[i]
                        local vehicles = player.getVehicles()
                        for i = 1, #vehicles do
                            if vehicles[i].plate == plate then
                                vehicles[i].impounded = true
                                print("just impounded " .. GetPlayerName(userSource) .. "'s vehicle!'")
                                TriggerClientEvent( 'impoundVehicle', userSource )
                                return
                            end
                        end
                    end
            end)
        else
            TriggerClientEvent("impound:notify", userSource, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
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

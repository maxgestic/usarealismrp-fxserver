return function(resource)
    RegisterNetEvent('high_phone:pickupCall', function(number)
        local callee = source
        local caller = getUserByNumber(number)

        if (callee and caller) then
            local player = Config.FrameworkFunctions.getPlayerByIdentifier(caller.citizenid or caller.identifier)

            if (player and player.source) then
                TriggerClientEvent('cs-video-call:custom:setCallee', player.source, callee)
                TriggerClientEvent('cs-video-call:custom:setCallee', callee, player.source)
            end
        end
    end)

    RegisterNetEvent('high_phone:endCall', function()
        local source = source        
        TriggerClientEvent('cs-video-call:custom:clearCallee', source)
    end)
end

local timeout = false

RegisterServerEvent("taxi:setJob")
AddEventHandler("taxi:setJob", function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if user.getJob() == "taxi" then
            print("user " .. GetPlayerName(source) .. " just went off duty for downtown taxi cab co.!")
            user.setJob("civ")
            TriggerClientEvent("taxi:offDuty", source)
        else
            if not timeout then
                print("user " .. GetPlayerName(source) .. " just went on duty for downtown taxi cab co.!")
                user.setJob("taxi")
                TriggerClientEvent("taxi:onDuty", source)
                timeout = true
                SetTimeout(15000, function()
                    timeout = false
                end)
            else
                print("player is on timeout and cannot go on duty for downtown taxi co!")
            end
        end
    end)
end)

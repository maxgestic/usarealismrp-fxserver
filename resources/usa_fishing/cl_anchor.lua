local ANIMATION_TIME_SECONDS = 10

Citizen.CreateThread(function()
    while true do

        if IsControlPressed(0, 187)  then -- down arrow
            local beginTime = GetGameTimer()
            local ped = GetPlayerPed( -1 )
            local fishingBoat = GetVehiclePedIsIn( ped, false )
            local vehicleClass = GetVehicleClass(fishingBoat)
            local speedCheck = GetEntitySpeed(fishingBoat)
            if IsPedSittingInAnyVehicle(ped) and IsEntityInWater(fishingBoat) and vehicleClass == 14  then
                if speedCheck < 1 then
                    while GetGameTimer() - beginTime < ANIMATION_TIME_SECONDS * 1000 do
                        DrawTimer(beginTime, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'Lowering Anchor')
                        Wait(0)
                    end
                    FreezeEntityPosition(fishingBoat ,true)
                else
                    exports.globals:notify('You cannot lower the anchor whilst moving!')
                end
            end
        end

       
        if IsControlPressed(0, 188) then -- up arrow
            local beginTime = GetGameTimer()
            local ped = GetPlayerPed( -1 )
            local fishingBoat = GetVehiclePedIsIn( ped, false )
            local vehicleClass = GetVehicleClass(fishingBoat)
            local speedCheck = GetEntitySpeed(fishingBoat)
            if IsPedSittingInAnyVehicle(ped) and vehicleClass == 14  then -- unable to check if in water as entity is frozen
                while GetGameTimer() - beginTime < ANIMATION_TIME_SECONDS * 1000 do
                    DrawTimer(beginTime, ANIMATION_TIME_SECONDS * 1000, 1.42, 1.475, 'Raising Anchor')
                    Wait(0)
                end
                FreezeEntityPosition(fishingBoat, false)
            end
        end

        Wait(1)
    end
end)
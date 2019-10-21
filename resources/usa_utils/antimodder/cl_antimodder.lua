DecorRegister("testDecor", 3)
DecorRegisterLock()

RegisterCommand("decortest", function()
    print("inside decorTest!")
    local me = PlayerPedId()
    if IsPedInAnyVehicle(me, true) then 
        local veh = GetVehiclePedIsIn(me, true)
        if DecorExistOn(veh, "testDecor") then 
            print("testDecor was set!!")
        else 
            print("testDecor was NOT set!!")
            DeleteVehicle(veh)
        end
    end
end)

RegisterCommand("setdecor", function()
    local me = PlayerPedId()
    if IsPedInAnyVehicle(me, true) then 
        local veh = GetVehiclePedIsIn(me, true)
        DecorSetInt(veh, "testDecor", 1)
    end
end)
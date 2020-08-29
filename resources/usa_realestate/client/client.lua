local SignIn = "[E] - Sign In / Out"
--local SigninCoords = {-148.55, -579.82, 48.24}
local SigninCoords = {-1069.0053710938, -247.00053405762, 44.021144866943}

Citizen.CreateThread(function()
    while true do
        local x,y,z = table.unpack(SigninCoords)
        if nearMarker(x,y,z) then
            promptJob(SigninCoords)
        end
        Wait(0)
    end
end)

function nearMarker(x, y, z)
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    return GetDistanceBetweenCoords(x, y, z, mycoords.x, mycoords.y, mycoords.z, true) < 3
end

function promptJob(location)
    local x,y,z = table.unpack(location)
    DrawText3D(x,y,z, 8, SignIn)
    if IsControlJustPressed(0, 38) then
        TriggerServerEvent('realty:duty')
    end
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 470
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end
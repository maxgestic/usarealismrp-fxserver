print('continuing...')
Citizen.CreateThread(function() -- remove the peds which spawn at PD
    while true do
        ClearAreaOfPeds(469.85, -989.9, 24.91, 30, 0)
        Wait(1000)
    end
end)
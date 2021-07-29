local JOB_TOGGLE_TEXT = "[E] - Toggle Duty (Event Planner)"
local JOB_TOGGLE_KEY = 38

Citizen.CreateThread(function()
    while true do
        local me = PlayerPedId()
        local mycoords = GetEntityCoords(me)
        for i = 1, #JOB_TOGGLE_LOCATIONS do
            local location = JOB_TOGGLE_LOCATIONS[i]
            local dist = Vdist2(location, mycoords)
            if dist < TEXT_3D_DRAW_DIST then
                DrawText3D(location.x, location.y, location.z, JOB_TOGGLE_TEXT)
                if dist < 1.2 then
                    if IsControlJustPressed(0, JOB_TOGGLE_KEY) then
                        TriggerServerEvent("eventPlanner:toggleDuty")
                    end
                end
            end
        end
        Wait(1)
    end
end)
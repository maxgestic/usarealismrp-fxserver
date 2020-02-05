RegisterServerEvent("doormanager:s_openDoor")
AddEventHandler("doormanager:s_openDoor", function(doorId)
    -- Source
    local src = source
    -- Get the status of the door
    local isDoorLocked = GetDoorStatus(doorId)

    if (isDoorLocked == 1) then
        if (playerJob == "cop" ) then
            -- Client Event to open door
            TriggerClientEvent("doormanager:c_openDoor", -1, doorId)
            -- Update door status in DB
            SetDoorStatus(doorId,0)
        else
            -- Client Event, if user has no rights to open door, show notification
            TriggerClientEvent("doormanager:c_noDoorKey", src, doorId)
        end
    end
end)
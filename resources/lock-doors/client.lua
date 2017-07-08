-- Shows a notification on the player's screen
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function lockDoor()

    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

	-- making vehicle lock for all player
    local lockStatus = GetVehicleDoorLockStatus(targetVehicle)

    if lockStatus == 1 or lockStatus == 0 then

        lockStatus = SetVehicleDoorsLocked(targetVehicle, 2)
        SetVehicleDoorsLockedForPlayer(targetVehicle, PlayerId(), false)
		ShowNotification("Door is now ~r~locked~w~.")

    else

        lockStatus = SetVehicleDoorsLocked(targetVehicle, 1)
		ShowNotification("Door is now ~g~unlocked~w~.")
	end

end

RegisterNetEvent("lock:lockDoor")
AddEventHandler("lock:lockDoor", function()
	lockDoor()
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)

        if IsControlPressed(0, 7) then
            locking = true

			lockDoor()

            while locking do
                Wait(0)
                if(IsControlPressed(0, 7) == false) then
                    locking = false
                    break
                end
            end
        end
    end
end)

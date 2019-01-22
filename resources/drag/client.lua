local draggedBy = nil -- source of the PERSON the ped is 'DRAGGED BY'
local isDragged = false

local sourceDragged = nil
local isDragging = false

RegisterNetEvent("drag:attemptToDragNearest")
AddEventHandler('drag:attemptToDragNearest', function()
	local myPed = PlayerPedId()
	local pedInFront = GetPedInFront()
	local sourceInFront = GetPlayerServerId(GetPlayerFromPed(pedInFront))
	if not isDragging and sourceInFront then
		TriggerServerEvent('drag:sendDragPlayer', sourceInFront)
		sourceDragged = sourceInFront
	elseif isDragging and sourceDragged then
		TriggerServerEvent('drag:sendDragPlayer', sourceDragged)
		sourceDragged = nil
	end
end)

DetachEntity(PlayerPedId(), true, false)

-----------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('drag:dragPlayer')
AddEventHandler('drag:dragPlayer', function(playerDraggedBy, forceDrag)
	if draggedBy ~= playerDraggedBy then
		if not isDragged then
			draggedBy = playerDraggedBy
			TriggerServerEvent('drag:toggleDragAction', draggedBy, true)
			AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(draggedBy)), 11816, 0.61, 0.24, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			isDragged = true
			-- dragging
		end
	elseif draggedBy == playerDraggedBy then
		if isDragged then
			TriggerServerEvent('drag:toggleDragAction', draggedBy, false)
			DetachEntity(PlayerPedId(), true, false)
			draggedBy = nil
			isDragged = false
			-- undragging
		end
	end
end)

RegisterNetEvent('drag:toggleDragAction')
AddEventHandler('drag:toggleDragAction', function(toggleOn, _source)
	print('isDragging: '..tostring(toggleOn))
	print('sourceDragged: '..tostring(_source))
	isDragging = toggleOn
	sourceDragged = _source
	ClearPedTasksImmediately(PlayerPedId())
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(0, 19) and IsControlJustPressed(0, 47) then
			local myPed = PlayerPedId()
			local pedInFront = GetPedInFront()
			local sourceInFront = GetPlayerServerId(GetPlayerFromPed(pedInFront))
			if not isDragging and sourceInFront then
				TriggerServerEvent('drag:sendDragPlayer', sourceInFront)
				sourceDragged = sourceInFront
			elseif isDragging and sourceDragged then
				TriggerServerEvent('drag:sendDragPlayer', sourceDragged)
				sourceDragged = nil
			end
		end
		if isDragged then
        	DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(24, 37, true)
            DisableControlAction(0, 25, true)
    	elseif isDragging then
    		DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(PlayerPedId(), true)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if isDragging then
			local dict = "weapons@projectile@"
			local anim = "aim_m"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(100)
			end
			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
			local rx, ry, rz = table.unpack(GetEntityRotation(PlayerPedId()))
			TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
			Citizen.Wait(1800)
		end
	end
end)

function GetPlayerFromPed(ped)
    for a = 0, 64 do
        if GetPlayerPed(a) == ped then
            return a
        end
    end
    return -1
end

function GetPedInFront()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    local plyPos = GetEntityCoords(plyPed, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

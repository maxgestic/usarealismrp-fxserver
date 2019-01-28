local draggedBy = nil -- source of the PERSON the ped is 'DRAGGED BY'
local isDragged = false

local sourceDragged = nil
local isDragging = false

RegisterNetEvent("drag:attemptToDragNearest")
AddEventHandler('drag:attemptToDragNearest', function()
	if not isDragging and not isDragged then
		TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
    		if player then
    			print(GetPlayerPed(GetPlayerFromServerId(player.id)))
    			print(player.id)
	        	local closestPed = GetPlayerPed(GetPlayerFromServerId(player.id))
				if player.id and not IsPedInAnyVehicle(PlayerPedId()) then
					TriggerServerEvent('drag:sendDragPlayer', player.id)
					print('sent??')
					sourceDragged = player.id
				end
			end
        end)
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
		if not isDragged and not IsPedInAnyVehicle(PlayerPedId()) then
			draggedBy = playerDraggedBy
			TriggerServerEvent('drag:toggleDragAction', draggedBy, true)
			isDragged = true
			Citizen.CreateThread(function()
				while isDragged do
					AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(draggedBy)), 11816, 0.61, 0.24, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					Citizen.Wait(1000)
				end
			end)
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
			if not isDragging and not isDragged then
				TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		    		if player then
		    			print(GetPlayerPed(GetPlayerFromServerId(player.id)))
			        	local closestPed = GetPlayerPed(GetPlayerFromServerId(player.id))
						if player.id and not IsPedInAnyVehicle(PlayerPedId()) then
							TriggerServerEvent('drag:sendDragPlayer', player.id)
							sourceDragged = player.id
						end
					end
		        end)
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
		if isDragging and not IsEntityDead(GetPlayerPed(GetPlayerFromServerId(sourceDragged))) then
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

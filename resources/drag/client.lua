local draggedBy = -1
local drag = false
local wasDragged = false
local playDragAnim = false
local draggedPedSource = nil

RegisterNetEvent("drag:attemptToDragNearest")
AddEventHandler('drag:attemptToDragNearest', function()
	TriggerEvent("usa:getClosestPlayer", 1.65, function(player)
		if player.id ~= 0 then
			TriggerServerEvent("dr:dragPlayer", player.id)
			TriggerEvent('police:playDragAnim')
		else
			TriggerEvent("usa:notify", "No player to drag!")
		end
	end)
end)

RegisterNetEvent("dr:drag")
AddEventHandler('dr:drag', function(pl)
	draggedBy = tonumber(pl)
	local ped = GetPlayerPed(GetPlayerFromServerId(draggedBy))
	local myped = GetPlayerPed(-1)
	if ped ~= myped then
		if drag then
			DetachEntity(GetPlayerPed(-1), true, false)
		else
			AttachEntityToEntity(myped, ped, 11816, 0.61, 0.24, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end
		drag = not drag
	end
end)

-----------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('police:playDragAnim')
AddEventHandler('police:playDragAnim', function()
	playDragAnim = not playDragAnim
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent("police:dragtoggle")
AddEventHandler("police:dragtoggle", function(_source)
    draggedBy = _source
    drag = not drag
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if drag then
            wasDragged = true
            AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(draggedBy)), 11816, 0.61, 0.24, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(24, 37, true)
            DisableControlAction(0, 25, true)
        else
            if not IsPedInParachuteFreeFall(PlayerPedId()) and wasDragged then
                wasDragged = false
                DetachEntity(PlayerPedId(), true, false)
            end
        end
    end
end)

DetachEntity(PlayerPedId(), true, false)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pedtoDrag = GetPedInFront()
		local myped = PlayerPedId()
		if IsControlPressed(0, 19) and IsControlJustPressed(0, 47) then
			if draggedPedSource ~= nil then
				print('undragging')
				print('argued as not nil: '.. draggedPedSource)
				ClearPedTasksImmediately(myped)
				TriggerServerEvent('police:drag', draggedPedSource)
				draggedPedSource = nil
				playDragAnim = false
			elseif IsPedAPlayer(pedtoDrag) then
				print('dragging')
				local playerToDrag = GetPlayerFromPed(pedtoDrag)
				local playerSourceToDrag = GetPlayerServerId(playerToDrag)
				TriggerServerEvent('police:drag', playerSourceToDrag)
				draggedPedSource = playerSourceToDrag
				if not IsEntityDead(pedtoDrag) then
					playDragAnim = true
				else
					print('Dragged ped is down and drag animation won\'t play')
				end
			end
		end
		if playDragAnim then
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(myped, true)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if playDragAnim then
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

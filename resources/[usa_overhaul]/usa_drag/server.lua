draggedPlayers = {}

TriggerEvent('es:addCommand', 'drag', function(source, args, char)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if tonumber(args[2]) then
		local job = char.get("job")
		local group = user.getGroup()
		if job == "corrections" or job == "sheriff" or job == "cop" or job == "ems" or job == "fire" or job == "dai" or group == "mod" or group == "admin" or group == "superadmin" or group == "owner" then
			if tonumber(args[2]) ~= usource and not draggedPlayers[source] then
				draggedPlayers[source] = tonumber(args[2])
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source)
			elseif draggedPlayers[source] == tonumber(args[2]) then
				draggedPlayers[source] = nil
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), source)
			else
				TriggerClientEvent('usa:notify', source, 'You cannot drag yourself, or are already dragging a person!')
			end
		else
			TriggerClientEvent('usa:showHelp', source, true, 'You may use /carry to carry another person.')
		end
	else
		TriggerClientEvent("drag:attemptToDragNearest", source)
	end
end, {help = "Drag a tied up or handcuffed player."})

TriggerEvent('es:addCommand', 'carry', function(source, args, char)
	TriggerClientEvent('drag:attemptToCarryNearest', source)
end, {help = "Carry a player."})

RegisterServerEvent('drag:toggleDragAction')
AddEventHandler('drag:toggleDragAction', function(_source, toggleOn)
	local sourceToToggle = _source
	TriggerClientEvent('drag:toggleDragAction', sourceToToggle, toggleOn, source)
end)

RegisterServerEvent('drag:toggleCarryAction')
AddEventHandler('drag:toggleCarryAction', function(_source, toggleOn)
	local sourceToToggle = _source
	TriggerClientEvent('drag:toggleCarryAction', sourceToToggle, toggleOn, source)
end)

RegisterServerEvent('drag:sendDragPlayer')
AddEventHandler('drag:sendDragPlayer', function(sourceBeingDragged)
	if sourceBeingDragged ~= 0 then
		local sourceDragging = source
		if not draggedPlayers[sourceDragging] then
			draggedPlayers[sourceDragging] = sourceBeingDragged
		else
			draggedPlayers[sourceDragging] = nil
		end
		TriggerClientEvent('drag:dragPlayer', sourceBeingDragged, sourceDragging)
	end
end)

RegisterServerEvent('drag:sendCarryPlayer')
AddEventHandler('drag:sendCarryPlayer', function(sourceBeingCarried)
	local sourceCarrying = source
	if not draggedPlayers[sourceCarrying] then
		draggedPlayers[sourceCarrying] = sourceBeingCarried
	else
		draggedPlayers[sourceCarrying] = nil
	end
	TriggerClientEvent('drag:carryPlayer', sourceBeingCarried, sourceCarrying)
end)

RegisterServerEvent('drag:passTable')
AddEventHandler('drag:passTable', function(eventName, cb)
	TriggerEvent(eventName, draggedPlayers)
	cb()
end)

RegisterServerEvent('place:returnUpdatedTable')
AddEventHandler('place:returnUpdatedTable', function(table)
	draggedPlayers = table
end)

AddEventHandler('playerDropped', function()
	if draggedPlayers[source] then
		draggedPlayers[source] = nil
	end
end)

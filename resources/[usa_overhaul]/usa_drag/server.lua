draggedPlayers = {}

TriggerEvent('es:addCommand', 'drag', function(source, args, user)
	local usource = source
	if tonumber(args[2]) then
		local userJob = user.getActiveCharacterData("job")
		local userGroup = user.getGroup()
		if userJob == "corrections" or userJob == "sheriff" or userJob == "cop" or userJob == "ems" or userJob == "fire" or userJob == "dai" or userGroup == "mod" or userGroup == "admin" or userGroup == "superadmin" or userGroup == "owner" then
			if tonumber(args[2]) ~= usource and not draggedPlayers[usource] then
				draggedPlayers[usource] = tonumber(args[2])
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource)
			elseif draggedPlayers[usource] == tonumber(args[2]) then
				draggedPlayers[usource] = nil
				TriggerClientEvent('drag:dragPlayer', tonumber(args[2]), usource)
			else
				TriggerClientEvent('usa:notify', usource, 'You cannot drag yourself, or are already dragging a person!')
			end
		else
			TriggerClientEvent('usa:showHelp', source, true, 'You may use /carry to carry another person.')
		end
	else
		TriggerClientEvent("drag:attemptToDragNearest", usource)
	end
end, {help = "Drag a tied up or handcuffed player."})

TriggerEvent('es:addCommand', 'carry', function(source, args, user)
	local usource = source
	TriggerClientEvent('drag:attemptToCarryNearest', usource)
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


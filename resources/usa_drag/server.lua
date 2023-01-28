--# TODO: crashes game if you try to drag yourself

draggedPlayers = {}

TriggerEvent('es:addCommand', 'drag', function(source, args, char)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local targetID = tonumber(args[2])
	if targetID == source then
		TriggerClientEvent("usa:notify", source, "Can't drag yourself!")
	end
	if char.get("jailTime") > 0 then
		TriggerClientEvent('usa:notify', source, "You can not use this here!")
		return
	end
	if targetID then
		local job = char.get("job")
		local group = user.getGroup()
		if job == "corrections" or job == "bcso" or job == "sasp" or job == "ems" or group == "mod" or group == "admin" or group == "superadmin" or group == "owner" then
			if targetID ~= source and not draggedPlayers[source] then
				draggedPlayers[source] = targetID
				TriggerClientEvent('drag:dragPlayer', targetID, source)
			elseif draggedPlayers[source] == targetID then
				draggedPlayers[source] = nil
				TriggerClientEvent('drag:dragPlayer', targetID, source)
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
	if char.get("jailTime") > 0 then
		TriggerClientEvent('usa:notify', source, "You can not use this here!")
		return
	end
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

RegisterServerEvent('drag:getTable')
AddEventHandler('drag:getTable', function(cb)
	cb(draggedPlayers)
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
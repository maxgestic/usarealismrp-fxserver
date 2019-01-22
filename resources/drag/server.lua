draggedPlayers = {}

TriggerEvent('es:addCommand', 'drag', function(source, args, user)
	local usource = source
		if tonumber(args[2]) then
			local userJob = user.getActiveCharacterData("job")
			local userGroup = user.getGroup()
			if userJob == "corrections" or userJob == "sheriff" or userJob == "cop" or userJob == "ems" or userJob == "fire" or userGroup == "mod" or userGroup == "admin" or userGroup == "superadmin" or userGroup == "owner" then
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
				TriggerClientEvent("drag:attemptToDragNearest", usource)
			end
		else
			TriggerClientEvent("drag:attemptToDragNearest", usource)
		end
	--else
		--TriggerClientEvent("drag:attemptToDragNearest", usource)
		--TriggerClientEvent("crim:areHandsTied", tonumber(argument), source, tonumber(argument), "drag")
	--end
end, {help = "Drag a tied up or handcuffed player."})

RegisterServerEvent('drag:toggleDragAction')
AddEventHandler('drag:toggleDragAction', function(_source, toggleOn)
	local sourceToToggle = _source	
	TriggerClientEvent('drag:toggleDragAction', sourceToToggle, toggleOn, source)
end)

RegisterServerEvent('drag:sendDragPlayer')
AddEventHandler('drag:sendDragPlayer', function(sourceBeingDragged)
	local sourceDragging = source
	if not draggedPlayers[sourceDragging] then
		draggedPlayers[sourceDragging] = sourceBeingDragged
	else
		draggedPlayers[sourceDragging] = nil
	end
	TriggerClientEvent('drag:dragPlayer', sourceBeingDragged, sourceDragging)
end)

RegisterServerEvent('drag:passTable')
AddEventHandler('drag:passTable', function(eventName)
	TriggerEvent(eventName, draggedPlayers)
end)

RegisterServerEvent('place:returnUpdatedTable')
AddEventHandler('place:returnUpdatedTable', function(table)
	draggedPlayers = table
end)
TriggerEvent('es:addCommand', 'drag', function(source, args, user)
	local usource = source
		if tonumber(args[2]) and tonumber(args[2]) ~= usource then
			local userJob = user.getActiveCharacterData("job")
			local userGroup = user.getGroup()
			if userJob == "corrections" or userJob == "sheriff" or userJob == "cop" or userJob == "ems" or userJob == "fire" or userGroup == "mod" or userGroup == "admin" or userGroup == "superadmin" or userGroup == "owner" then
				TriggerClientEvent("dr:drag", tonumber(args[2]), usource)
				TriggerClientEvent('police:playDragAnim', usource)
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

RegisterServerEvent("dr:dragPlayer")
AddEventHandler("dr:dragPlayer", function(id)
	TriggerClientEvent("dr:drag", tonumber(id), source)
end)

RegisterServerEvent('police:drag')
AddEventHandler('police:drag', function(playerSourceToDrag)
	psource = source
	TriggerClientEvent('police:dragtoggle', playerSourceToDrag, psource)
end)
TriggerEvent('es:addJobCommand', 'impound', { "police", "sheriff", "ems" }, function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "Impound a vehicle." })

TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, args, user)
	TriggerClientEvent('impoundVehicle', source)
end, { help = "(Delete) Impound a vehicle." })

RegisterServerEvent("impound:impoundVehicle")
AddEventHandler("impound:impoundVehicle", function(vehicle, plate)
	print("inside of impound:impoundVehicle!")
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local playerJob = user.getActiveCharacterData("job")
		local userGroup = user.getGroup()
		if playerJob == "sheriff" or playerJob == "ems" or playerJob == "fire" or userGroup == "owner" or userGroup == "admin" or userGroup == "mod" or userGroup == "superadmin" then
			TriggerEvent('es:getPlayers', function(players)
					for k,v in pairs(players) do
						local player = v
						local vehicles = player.getActiveCharacterData("vehicles")
						if vehicles then
							--print("about to check all player vehicles : " .. #vehicles)
							for i = 1, #vehicles do
								--print("checking vehicle.model = " .. vehicles[i].model)
								if vehicles[i].impounded then
									--print("checking vehicle.impounded = " .. tostring(vehicles[i].impounded))
								else
									--print("vehicle did not have impound property")
								end
								--print("vehicles[i].plate = " .. type(vehicles[i].plate))
								--print("plate = " .. type(plate))
								if tonumber(plate) == tonumber(vehicles[i].plate) then
									--print("found matching plate = " .. plate)
									--print("setting vehicle.impounded = true!")
									vehicles[i].impounded = true
									v.setActiveCharacterData("vehicles", vehicles)
									--print("just impounded " .. GetPlayerName(k) .. "'s vehicle!'")
									TriggerClientEvent( 'impoundVehicle', userSource )
									return
								end
							end
						end
					end
			end)
		else
			TriggerClientEvent("impound:notify", userSource, "Only ~y~law enforcement~w~,~y~medics~w~, and ~y~admins~w~ can use /impound!")
		end
	end)
end)
--[[
if key == "plate" then
if string.match(plate,val) ~= nil then
print("found a matching plate to be impounded")
v.impounded = true
print("v.impounded = " .. tostring(v.impounded))
return
end
end
]]

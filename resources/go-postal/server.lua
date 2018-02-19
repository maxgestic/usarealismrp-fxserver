local activeJobs = {}

RegisterServerEvent("go-postal:checkLicense")
AddEventHandler("go-postal:checkLicense", function()
	local userSource = source
	TriggerEvent("es:getPlayerFromId", userSource, function(user)
		local user_licenses = user.getActiveCharacterData("licenses")
		for i = 1, #user_licenses do
          local item = user_licenses[i]
          if string.find(item.name, "Driver") then
            print("DL found! checking validity")
            if item.status == "valid" then
				TriggerClientEvent("go-postal:hadDL", userSource)
              return
            else 
				TriggerClientEvent("usa:notify", userSource, "Your license is suspended!")
				return
			end
          end
        end
	end)
end)

RegisterServerEvent("transport:giveMoney")
AddEventHandler("transport:giveMoney", function(amount, job)
	local userSource = tonumber(source)
	TriggerEvent('es:getPlayerFromId', userSource, function(user)
		local user_money = user.getActiveCharacterData("money")
		user.setActiveCharacterData("money", user_money + amount)
		if job.name == "Cannabis Transport" then
			local inventory = user.getActiveCharacterData("inventory")
			for i = 1, #inventory do
				local item = inventory[i]
				if item then
					if item.name == "20g of concentrated cannabis" then
						table.remove(inventory, i)
						user.setActiveCharacterData("inventory", inventory)
						return
					end
				end
			end
		end
	end)
end)

RegisterServerEvent("transport:addJob")
AddEventHandler("transport:addJob", function(job)
	activeJobs[source] = job
	if job.name == "Cannabis Transport" then
		TriggerEvent('es:getPlayerFromId', tonumber(source), function(user)
			local inventory = user.getActiveCharacterData("inventory")
			for i = 1, #inventory do
				local item = inventory[i]
				if item.name == "20g of concentrated cannabis" then
					print("job " .. job.name .. " started by player " .. GetPlayerName(tonumber(source)))
					return
				end
			end
			-- no weed in inventory at this point, so add it
			local weedPackage = {
				name = "20g of concentrated cannabis",
				quantity = 1,
				type = "drug",
				legality = "illegal"
			}
			table.insert(inventory, weedPackage)
			user.setActiveCharacterData("inventory", inventory)
		end)
	end
end)

RegisterServerEvent("go_postal:setActiveJob")
AddEventHandler("go_postal:setActiveJob", function(source, coords, name)
	if not activeJobs[source] then
		activeJobs[source] = {name = name, x = coords.x, y = coords.y}
	end
end)

RegisterServerEvent("go_postal:removeActiveJob")
AddEventHandler("go_postal:removeActiveJob", function(source)
	if activeJobs[source] then
		activeJobs[source] = nil
	end
end)

TriggerEvent('es:addCommand', 'waypoint', function(source, args, user)
	print("/waypoint called!")
	if activeJobs[source] == nil then
		TriggerClientEvent('chatMessage', source, "", {}, "You do not currently have any waypoints set!")
	else
		TriggerClientEvent('chatMessage', source, "", {}, "Your waypoint has been added to the map again!")
		TriggerClientEvent('chatMessage', source, "x", {255,0,0}, activeJobs[source].x)
		TriggerClientEvent('chatMessage', source, "y", {255,0,0}, activeJobs[source].y)
		TriggerClientEvent('placeMarker', source, activeJobs[source].x, activeJobs[source].y)
	end
end, {help = "Reset a transport job waypoint"})

AddEventHandler('playerDropped', function()
	if activeJobs[source] then
		print("player dropped, setting activeJob of " .. activeJobs[source].name .. " to nil")
		activeJobs[source] = nil
	end
end)

TriggerEvent('es:addCommand', 'quitjob', function(source, args, user)
	if activeJobs[source] then
		activeJobs[source] = nil
		TriggerClientEvent("transport:quitJob", source)
		TriggerClientEvent('chatMessage', source, "", {}, "^3You have quit your active transport job!")
		print("player used /quitjob, setting activeJob to nil")
	end
end, {help = "Quit current transport job"})

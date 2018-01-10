function playerHasValidAutoInsurance(playerInsurance)
	local timestamp = os.date("*t", os.time())
		if playerInsurance.type == "auto" then
			local reference = playerInsurance.purchaseTime
			local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60) -- seconds in a day
			local wholedays = math.floor(daysfrom)
			print(wholedays) -- today it prints "1"
			if wholedays < 32 then
				return true -- valid insurance, it was purchased 31 or less days ago
			else
				--TriggerClientEvent("garage:notify", source, "~r~T. ENDS INSURANCE: ~w~Sorry! Your insurance coverage expired. We won't be able to help you.")
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

RegisterServerEvent("license:searchForLicense")
AddEventHandler("license:searchForLicense", function(source, playerId)
	TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " opens MDT.")
	    TriggerEvent('es:getPlayerFromId', tonumber(playerId), function(user)
			if not user then
				TriggerClientEvent("license:notifyNoExist", source, playerId) -- player not in game with that id
				return
			end
			local vehicles = user.getActiveCharacterData("vehicles")
	    local licenses = user.getActiveCharacterData("licenses")
			local insurancePlans = user.getActiveCharacterData("insurance")
			local criminalHistory = user.getActiveCharacterData("criminalHistory")
			local hasFirearmsPermit = false
			local hasDL = false
			print("#inventory = " .. #licenses)
			for i = 1, #licenses do
				print("found item " .. licenses[i].name)
					if licenses[i].name == "Driver's License" then
						local license =licenses[i]
						TriggerClientEvent("chatMessage", source, "", {0, 141, 155}, "^3Driver's License:")
						TriggerClientEvent("chatMessage", source, "DL", {169, 44, 98}, license.number)
						TriggerClientEvent("chatMessage", source, "FULL NAME", {169, 44, 98}, license.ownerName)
						TriggerClientEvent("chatMessage", source, "EXPIRES", {169, 44, 98}, license.expire)
						TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, license.status)
						hasDL = true
					elseif licenses[i].name == "Firearm Permit" then
						TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^2Firearm Permit^0.")
						hasFirearmsPermit = true
					end
			end
			if not hasDL then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No driver's license.")
			end
			if not hasFirearmsPermit then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No firearm permit on record.")
			end
			--print("checking #insurancePlans: " .. #insurancePlans)
			if insurancePlans then
				if playerHasValidAutoInsurance(insurancePlans) then
					TriggerClientEvent("chatMessage", source, "", {0,141,155}, "^3Auto Insurance:")
					TriggerClientEvent("chatMessage", source, "INSURER", {0,255,0}, insurancePlans.planName)
					TriggerClientEvent("chatMessage", source, "BUY DATE", {0,255,0}, insurancePlans.purchaseDate)
				end
			else
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "No auto insurance on record.")
			end
			TriggerClientEvent("chatMessage", source, "", {0,141,155}, "^3Criminal History:")
			local ticket_history = {}
			if #criminalHistory > 0 then
				for i = 1, #criminalHistory do
					if i == 15 then break end --  TODO: only shows first 15 charges (should show the MOST RECENT charges instead)
					local crime = criminalHistory[i]
					if not crime.type then -- not a ticket
						print("crime.type did not exist!")
						local color = {187,94,187}
						TriggerClientEvent("chatMessage", source, "DATE", color, crime.timestamp)
						TriggerClientEvent("chatMessage", source, "CHARGE(S)", color, crime.charges)
						TriggerClientEvent("chatMessage", source, "SENTENCE", color, crime.sentence .. " months")
						TriggerClientEvent("chatMessage", source, "OFFICER", color, crime.arrestingOfficer)
					else
						print("inserting ticket! crime.type: " .. crime.type)
						table.insert(ticket_history, crime)
					end
				end
				TriggerClientEvent("chatMessage", source, "", {0,141,155}, "^3Ticket History:")
				-- display ticket history:
				if #ticket_history > 0 then
					for i = 1, #ticket_history do
						local crime = ticket_history[i]
						print("#tickets: " .. #ticket_history)
						print("crime fine: " .. crime.fine)
						local color = {149,149,184}
						TriggerClientEvent("chatMessage", source, "DATE", color, crime.timestamp)
						TriggerClientEvent("chatMessage", source, "FINE", color, "$" .. tostring(crime.fine))
						TriggerClientEvent("chatMessage", source, "REASON", color, crime.reason)
					end
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "No ticket history.")
				end
			else
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "No criminal history.")
			end
	    end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end


-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addCommand', 'mdt', function(source, args, user)
	local playerJob = user.getActiveCharacterData("job")
	local argument = args[2] -- player id to check license
	if argument == nil or type(tonumber(argument)) == nil then
		TriggerClientEvent("license:help", source)
	elseif playerJob ~= "cop" and playerJob ~= "sheriff" and playerJob ~= "highwaypatrol" then
		TriggerClientEvent("license:failureNotJurisdiction", source)
	else -- player is a cop, so allow check and perform check with argument = player id to check license
		--TriggerEvent('altchat:localChatMessage', source, "^6* " .. GetPlayerName(source) .. " opens MDT.") -- need to update name
		TriggerEvent("license:searchForLicense", source, argument)
	end
end)

-- license plate checking
function fetchAllRegisteredVehicles(callback)
	print("fetching all registered vehicles...")
	PerformHttpRequest("http://127.0.0.1:5984/dmv/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		local registeredVehicles = {}
		print("finished getting registered vehicles...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			print("#(response.rows) = " .. #(response.rows))
			-- insert all registered vehicles from 'registered vehicles' db into lua table
			for i = 1, #(response.rows) do
				table.insert(registeredVehicles, response.rows[i].doc)
			end
			print("finished loading registered vehicles...")
			print("# of registered vehicles: " .. #registeredVehicles)
			callback(registeredVehicles)
		else
			print("response.rows was either nil or 0 or somethin!")
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

-- running vehicle plates
TriggerEvent('es:addCommand', '28', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	if user_job == "sheriff" or user_job == "police" then
		local userSource = tonumber(source)
		local plateNumber = args[2]
		if plateNumber then
			TriggerEvent('altchat:localChatMessage', source, "^6* " .. user_name .. " runs plate.")
			TriggerEvent("es:getPlayers", function(players)
				for id, player in pairs(players) do
					--print("id = " .. id)
					--print("player.job = " .. player.job)
					local vehicles = player.getActiveCharacterData("vehicles")
					for i = 1, #vehicles do
						local vehicle = vehicles[i]
						if tostring(vehicle.plate) == tostring(plateNumber) then
							print("found matching plate number! triggering client event")
							local message = "~y~PLATE: ~w~" .. vehicle.plate .. "\n"
							message = message .. "~y~RO: ~w~"
							message = message .. vehicle.owner .. "\n"
							message = message .. "~y~MODEL: ~w~"
							message = message .. vehicle.model
							TriggerClientEvent("licenseCheck:notify", userSource, message)
							return
						end
					end
					-- player not in game with that plate number or plate number owned by a local!
					TriggerClientEvent("licenseCheck:notify", userSource, "This plate is not on file.")
				end
			end)
		else
			print("player did not enter a plate #")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^1Invalid /runplate command format!")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^3Usage: ^0/runplate <plate_number_here>")
		end
	end
end)

TriggerEvent('es:addCommand', 'runplate', function(source, args, user)
	local user_job = user.getActiveCharacterData("job")
	local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	if user_job == "sheriff" or user_job == "police" then
		local userSource = tonumber(source)
		local plateNumber = args[2]
		if plateNumber then
			TriggerEvent('altchat:localChatMessage', source, "^6* " .. user_name .. " runs plate.")
			TriggerEvent("es:getPlayers", function(players)
				for id, player in pairs(players) do
					--print("id = " .. id)
					--print("player.job = " .. player.job)
					local vehicles = player.getActiveCharacterData("vehicles")
					if vehicles then
						for i = 1, #vehicles do
							local vehicle = vehicles[i]
							if tostring(vehicle.plate) == tostring(plateNumber) then
								print("found matching plate number! triggering client event")
								local message = "~y~PLATE: ~w~" .. vehicle.plate .. "\n"
								message = message .. "~y~RO: ~w~"
								message = message .. vehicle.owner .. "\n"
								message = message .. "~y~MODEL: ~w~"
								message = message .. vehicle.model
								TriggerClientEvent("licenseCheck:notify", userSource, message)
								return
							end
						end
					end
					-- player not in game with that plate number or plate number owned by a local!
					TriggerClientEvent("licenseCheck:notify", userSource, "This plate is not on file.")
				end
			end)
		else
			print("player did not enter a plate #")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^1Invalid /runplate command format!")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^3Usage: ^0/runplate <plate_number_here>")
		end
	end
end)

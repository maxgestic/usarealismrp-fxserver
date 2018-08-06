-- random names for when a local owns the car after doing /runplate or /28 on it
random_names = {
	"Jim Karen",
	"Michael Phelps",
	"Michael Jackson",
	"Tanner Phillips",
	"Mohammed Algierzran",
	"Sarah Kennedy",
	"Sierra Jones",
	"Cassandra Pike",
	"Larry McNab",
	"Guy Fieri",
	"Jamie Gonzalez",
	"Denzel Adams",
	"Hollis Pracht",
	"Harvey Fudge",
	"Rhonda Gentle",
	"Gwyneth Dyson",
	"Marvel Calo",
	"Aimee Pettengill",
	"Selma Behm",
	"Coleen Kiesel",
	"Hilton Fuhr",
	"Maegan Gose"
}

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
						TriggerClientEvent("chatMessage", source, "DOB", {169, 44, 98}, license.ownerDob)
						TriggerClientEvent("chatMessage", source, "EXPIRES", {169, 44, 98}, license.expire)
						if license.status == "valid" then
							TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, license.status)
						else
							TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, "^1" .. license.status)
							TriggerClientEvent("chatMessage", source, "DAYS", {169, 44, 98}, license.suspension_days)
							TriggerClientEvent("chatMessage", source, "START DAY", {169, 44, 98}, license.suspension_start_date)
						end
						hasDL = true
					elseif licenses[i].name == "Firearm Permit" then
						TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^3Firearm Permit:")
						if licenses[i].status == "suspended" then
							TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, "^1" .. licenses[i].status)
							TriggerClientEvent("chatMessage", source, "DAYS", {169, 44, 98}, licenses[i].suspension_days)
							TriggerClientEvent("chatMessage", source, "START DAY", {169, 44, 98}, licenses[i].suspension_start_date)
						else
							TriggerClientEvent("chatMessage", source, "STATUS", {169, 44, 98}, "^0" .. licenses[i].status)
						end
						hasFirearmsPermit = true
					end
			end
			if not hasDL then
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^1No driver's license.")
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
					local crime = criminalHistory[i]
					if not crime.type then -- not a ticket
						local color = {187,94,187}
						TriggerClientEvent("chatMessage", source, "DATE", color, "^0" .. crime.timestamp)
						TriggerClientEvent("chatMessage", source, "CHARGE(S)", color, "^0" .. crime.charges)
						TriggerClientEvent("chatMessage", source, "SENTENCE", color, "^0" .. crime.sentence .. " months")
						TriggerClientEvent("chatMessage", source, "OFFICER", color, "^0" .. crime.arrestingOfficer)
					else
						print("inserting ticket!")
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
						TriggerClientEvent("chatMessage", source, "DATE", color, "^0" .. crime.timestamp)
						TriggerClientEvent("chatMessage", source, "FINE", color, "^0$" .. tostring(crime.fine))
						TriggerClientEvent("chatMessage", source, "REASON", color, "^0" .. crime.reason)
					end
				else
					TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No ticket history.")
				end
			else
				TriggerClientEvent("chatMessage", source, "", {0,0,0}, "^0No criminal history.")
			end
	    end)
end)

-- function to format expiration month correctly
function padzero(s, count)
    return string.rep("0", count-string.len(s)) .. s
end


-- Add a command everyone is able to run. Args is a table with all the arguments, and the user is the user object, containing all the user data.
TriggerEvent('es:addJobCommand', 'mdt', { "police", "sheriff", "judge", "corrections" }, function(source, args, user, location)
	if GetPlayerName(tonumber(args[2])) then
		local msg = user.getActiveCharacterData("fullName") .. " opens MDT."
		exports["globals"]:sendLocalActionMessage(msg, location)
	end
	TriggerEvent("license:searchForLicense", source, args[2])
end, {
	help = "Run a person's information through the police database.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

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
TriggerEvent('es:addCommand', '28', function(source, args, user, location)
	local user_job = user.getActiveCharacterData("job")
	local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	if user_job == "sheriff" or user_job == "police" then
		local userSource = tonumber(source)
		local plateNumber = args[2]
		if plateNumber then
			if string.len(plateNumber) < 7 or string.len(plateNumber) > 8 then TriggerClientEvent("usa:notify", source, "Invalid license plate format.") return end
			TriggerEvent("es:getPlayers", function(players)
				for id, player in pairs(players) do
					--print("id = " .. id)
					--print("player.job = " .. player.job)
					local vehicles = player.getActiveCharacterData("vehicles")
					if vehicles then
						for i = 1, #vehicles do
							local vehicle = vehicles[i]
							if string.lower(tostring(vehicle.plate)) == string.lower(tostring(plateNumber)) then
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
				end
					local message = "~y~PLATE: ~w~" .. string.upper(plateNumber) .. "\n"
					message = message .. "~y~RO: ~w~"
					message = message .. random_names[math.random(#random_names)] .. "\n"
					message = message .. "~y~MODEL: ~w~"
					message = message .. "Unknown"
					-- player not in game with that plate number or plate number owned by a local!
					TriggerClientEvent("licenseCheck:notify", userSource, message)
			end)
		else
			print("player did not enter a plate #")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^1Invalid /runplate command format!")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^3Usage: ^0/runplate <plate_number_here>")
		end
	end
end, {
	help = "Run a license plate.",
	params = {
		{ name = "plate", help = "Plate number to run" }
	}
})

TriggerEvent('es:addCommand', 'runplate', function(source, args, user, location)
	local user_job = user.getActiveCharacterData("job")
	local user_name = user.getActiveCharacterData("firstName") .. " " .. user.getActiveCharacterData("lastName")
	if user_job == "sheriff" or user_job == "police" then
		local userSource = tonumber(source)
		local plateNumber = args[2]
		if plateNumber then
			if string.len(plateNumber) < 7 or string.len(plateNumber) > 8 then TriggerClientEvent("usa:notify", source, "Invalid license plate format.") return end
			TriggerEvent("es:getPlayers", function(players)
				for id, player in pairs(players) do
					--print("id = " .. id)
					--print("player.job = " .. player.job)
					local vehicles = player.getActiveCharacterData("vehicles")
					if vehicles then
						for i = 1, #vehicles do
							local vehicle = vehicles[i]
							if string.lower(tostring(vehicle.plate)) == string.lower(tostring(plateNumber)) then
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
				end
					local message = "~y~PLATE: ~w~" .. string.upper(plateNumber) .. "\n"
					message = message .. "~y~RO: ~w~"
					message = message .. random_names[math.random(#random_names)] .. "\n"
					message = message .. "~y~MODEL: ~w~"
					message = message .. "Unknown"
					-- player not in game with that plate number or plate number owned by a local!
					TriggerClientEvent("licenseCheck:notify", userSource, message)
			end)
		else
			print("player did not enter a plate #")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^1Invalid /runplate command format!")
			TriggerClientEvent("chatMessage", userSource, "", {}, "^3Usage: ^0/runplate <plate_number_here>")
		end
	end
end, {
	help = "Run a license plate.",
	params = {
		{ name = "plate", help = "Plate number to run" }
	}
})

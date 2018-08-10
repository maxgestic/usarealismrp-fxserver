local random_names = {
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

TriggerEvent('es:addJobCommand', 'mdt', { "sheriff", "judge", "corrections" }, function(source, args, user)
	TriggerClientEvent('mdt:toggleVisibilty', source)
end, { help = "Open MDT" })

RegisterServerEvent("mdt:performPersonCheck")
AddEventHandler("mdt:performPersonCheck", function(ssn)
    local person = exports["essentialmode"]:getPlayerFromId(ssn)
    if not person then
        local msg = {
            type = "error",
            message  = "No person found with that SSN!"
        }
        TriggerClientEvent("mdt:sendNUIMessage", source, msg)
        return
    end
    -- values have to be false by default to work with UI --
    local person_info  = {
        ssn = ssn,
        name = person.getActiveCharacterData("fullName"),
        drivers_license = false,
        firearm_permit = false,
        insurance = false,
        criminal_history = {
            crimes = {},
            tickets = {}
        }
    }
    --------------------
    -- get licenses --
    --------------------
    local licenses = person.getActiveCharacterData("licenses")
    if #licenses > 0 then
        for i = 1, #licenses do
            local license = licenses[i]
                if license.name == "Driver's License" then
                    person_info.drivers_license = license
                elseif license.name == "Firearm Permit" then
                    person_info.firearm_permit = license
                end
        end
    end
    ---------------------
    -- get insurance --
    ---------------------
    local insurance = person.getActiveCharacterData("insurance")
    if insurance.planName then
        person_info.insurance = insurance
    end
    -----------------------------
    -- get criminal history --
    -----------------------------
    local criminal_history = person.getActiveCharacterData("criminalHistory")
    if #criminal_history > 0 then
        for i = 1, #criminal_history do
            local crime = criminal_history[i]
                if not crime.type then -- not a ticket
                    print("inserted crime")
                    table.insert(person_info.criminal_history.crimes, crime)
                else
                    print("inserted ticket")
                    table.insert(person_info.criminal_history.tickets, crime)
                end
        end
        if #person_info.criminal_history.crimes <= 0 then
            person_info.criminal_history.crimes = false
        end
        if #person_info.criminal_history.tickets <= 0 then
            person_info.criminal_history.tickets = false
        end
    end

    TriggerClientEvent("mdt:performPersonCheck", source, person_info)

end)

RegisterServerEvent("mdt:performPlateCheck")
AddEventHandler("mdt:performPlateCheck", function(plateNumber)
	-- check format --
	if not plateNumber or string.len(plateNumber) < 7 or string.len(plateNumber) > 8 then
		local msg = {
			type = "error",
			message  = "Invalid plate format!"
		}
		TriggerClientEvent("mdt:sendNUIMessage", source, msg)
		return
	end
	-- look for any player with vehicle --
	TriggerEvent("es:getPlayers", function(players)
		for id, player in pairs(players) do
			local vehicles = player.getActiveCharacterData("vehicles")
			if vehicles then
				for i = 1, #vehicles do
					local vehicle = vehicles[i]
					if string.lower(tostring(vehicle.plate)) == string.lower(tostring(plateNumber)) then
						vehicle.veh_name = vehicle.make .. " " .. vehicle.model
						vehicle.registered_owner = player.getActiveCharacterData("fullName")
						vehicle.plate = vehicle.plate
						TriggerClientEvent("mdt:performPlateCheck", source, vehicle)
						return
					end
				end
			end
		end
		-- make a random registration for the vehicle --
		local vehicle = {}
		vehicle.veh_name = "Unknown"
		vehicle.registered_owner = random_names[math.random(#random_names)]
		vehicle.plate = plateNumber
		TriggerClientEvent("mdt:performPlateCheck", source, vehicle)
	end)
end)

RegisterServerEvent("mdt:fetchWarrants")
AddEventHandler("mdt:fetchWarrants", function()
	local usource = source
	local warrants = exports["warrants"]:getWarrants()
	print("finished fething warrants! #: " .. #warrants)
	TriggerClientEvent("mdt:fetchWarrants", usource, warrants)
end)

RegisterServerEvent("mdt:createWarrant")
AddEventHandler("mdt:createWarrant", function(warrant)
	print("DEBUG: warrant.police_report_number: " .. warrant.police_report_number)
	local usource = source
	local author = exports["essentialmode"]:getPlayerFromId(usource)
	warrant.created_by = author.getActiveCharacterData("fullName")
	warrant.notes = warrant.charges .. " | " .. warrant.suspect_description
	warrant.timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports["warrants"]:createWarrant(usource, warrant, true)
end)

RegisterServerEvent("mdt:deleteWarrant")
AddEventHandler("mdt:deleteWarrant", function(id, rev)
	exports["warrants"]:deleteWarrant("warrants", id, rev)
end)

RegisterServerEvent("mdt:createBOLO")
AddEventHandler("mdt:createBOLO", function(bolo)
	local usource = source
	local author = exports["essentialmode"]:getPlayerFromId(usource)
	bolo.author = author.getActiveCharacterData("fullName")
	bolo.timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		-- insert into db
		couchdb.createDocument("bolos", bolo, function()
			print("bolo saved!")

			exports["globals"]:notifyPlayersWithJob("sheriff", "^0INFO: A new BOLO was just created!")

			local msg = {
		           type = "bolo_created"
		       }
			TriggerClientEvent("mdt:sendNUIMessage", usource, msg)

		end)
	end)
end)

RegisterServerEvent("mdt:fetchBOLOs")
AddEventHandler("mdt:fetchBOLOs", function()
	print("Fetching BOLOs!!!")
	fetchBOLOs(source)
end)

RegisterServerEvent("mdt:deleteBOLO")
AddEventHandler("mdt:deleteBOLO", function(id, rev)
	deleteBOLO("bolos", id, rev)
end)

RegisterServerEvent("mdt:fetchPoliceReports")
AddEventHandler("mdt:fetchPoliceReports", function()
	print("Fetching police reports!!!")
	fetchPoliceReports(source)
end)

RegisterServerEvent("mdt:createPoliceReport")
AddEventHandler("mdt:createPoliceReport", function(report)
	if type(report) == "table" then
		print("report was table")
	else
		print("report was string: " .. report)
	end
	local usource = source
	local author = exports["essentialmode"]:getPlayerFromId(usource)
	report.author = author.getActiveCharacterData("fullName")
	report.timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		------------------------------
		-- Insert into database  --
		------------------------------
		couchdb.createDocument("policereports", report, function(doc)
			local msg = {
		           type = "police_report_created"
		       }
			TriggerClientEvent("mdt:sendNUIMessage", usource, msg)
		end)
	end)
end)

RegisterServerEvent("mdt:deletePoliceReport")
AddEventHandler("mdt:deletePoliceReport", function(id, rev)
	deletePoliceReport("policereports", id, rev)
end)

RegisterServerEvent("mdt:fetchEmployee")
AddEventHandler("mdt:fetchEmployee", function()
	local usource = source
	local user = exports["essentialmode"]:getPlayerFromId(usource)
	local employee = {
		fname = user.getActiveCharacterData("firstName"),
		lname = user.getActiveCharacterData("lastName"),
		rank = GetRankDisplayName(user.getActiveCharacterData("policeRank"))
	}
	local msg = {
		   type = "employeeLoaded",
		   employee = employee
	   }
	TriggerClientEvent("mdt:sendNUIMessage", usource, msg)
end)

function GetRankDisplayName(rank)
	if rank == 1 then
		return "Pr. Deputy"
	elseif rank == 2 then
		return "Deputy"
	elseif rank == 3 then
		return "Sr. Deputy"
	elseif rank == 4 then
		return "Pr. Sgt."
	elseif rank == 5 then
		return "Sgt."
	elseif rank == 6 then
		return "Lt."
	elseif rank == 7 then
		return "Capt."
	elseif rank == 8 then
		return "Undersheriff"
	elseif rank == 9 then
		return "Sheriff"
	elseif rank == 10 then
		return "Director"
	end
end

function deleteBOLO(db, id, rev)
	-- send DELETE http request
	PerformHttpRequest("http://127.0.0.1:5984/"..db.."/"..id.."?rev="..rev, function(err, rText, headers)
		if err == 0 then
			RconPrint("\nrText = " .. rText)
			RconPrint("\nerr = " .. err)
		end
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

function fetchBOLOs(src)
	local BOLOs = {}
	print("fetching all BOLOs...")
	PerformHttpRequest("http://127.0.0.1:5984/bolos/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting BOLOs...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			BOLOs = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all warrants from 'bolos' db into lua table
			for i = 1, #(response.rows) do
				table.insert(BOLOs, response.rows[i].doc)
			end
			print("finished loading BOLOs...")
			print("# of BOLOs: " .. #BOLOs)
			local msg = {
				type = "bolosLoaded",
				bolos = BOLOs
			}
			TriggerClientEvent("mdt:sendNUIMessage", src, msg)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

function deletePoliceReport(db, id, rev)
	-- send DELETE http request
	PerformHttpRequest("http://127.0.0.1:5984/"..db.."/"..id.."?rev="..rev, function(err, rText, headers)
		if err == 0 then
			RconPrint("\nrText = " .. rText)
			RconPrint("\nerr = " .. err)
		end
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

function fetchPoliceReports(src)
	local police_reports = {}
	print("fetching all police reports...")
	PerformHttpRequest("http://127.0.0.1:5984/policereports/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting police reports...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			police_reports = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all warrants from 'bolos' db into lua table
			for i = 1, #(response.rows) do
				table.insert(police_reports, response.rows[i].doc)
			end
			print("finished loading police reports...")
			print("# of police reports: " .. #police_reports)
			local msg = {
				type = "policeReportsLoaded",
				police_reports = police_reports
			}
			TriggerClientEvent("mdt:sendNUIMessage", src, msg)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

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
				return false
			end
		else
			-- no insurance at all
			return false
		end
end

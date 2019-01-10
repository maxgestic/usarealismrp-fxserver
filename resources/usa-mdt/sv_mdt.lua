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
	"Maegan Gose",
	"Kurt Angle",
	"Jame Mcginley",
	"Julianna Mixer",
	"Aletha Pizzo",
	"Danika Rebello",
	"Mandy Sanzone",
	"Leilani Cureton",
	"Sherlyn Snelling",
	"Vernetta Klann",
	"Machelle Pauli"
}

TriggerEvent('es:addJobCommand', 'mdt', { "sheriff", "judge", "corrections"}, function(source, args, user)
	TriggerClientEvent('mdt:toggleVisibilty', source)
end, { help = "Open MDT" })

RegisterServerEvent("mdt:updatePhoto")
AddEventHandler("mdt:updatePhoto", function(url, fname, lname, dob)
	print("Saving mugshot photo for " .. fname ..  " " .. lname .. "(" .. dob .. ") with url: " .. url)
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		local query = {
			["characters"] = {
				["$elemMatch"] = {
					--["firstName"] = data.fname,
					--["lastName"] = data.lname
					["firstName"] = {
						["$regex"] = "(?i)" .. fname
					},
					["lastName"] = {
						["$regex"] = "(?i)" .. lname
					},
					["dateOfBirth"] = dob
				}
			}
		}
		local fields = {
			"_id",
			"characters"
		}
		couchdb.getSpecificFieldFromDocumentByRows("essentialmode", query, fields, function(doc)
			if doc then
				print(fname .. " " .. lname .. " found in DB search!")
				for i = 1, #doc.characters do
					if doc.characters[i].firstName and doc.characters[i].lastName and fname and lname then
						if string.lower(doc.characters[i].firstName) == string.lower(fname) and string.lower(doc.characters[i].lastName) == string.lower(lname) then
							doc.characters[i].mugshot = url
							-- update DB --
						    couchdb.updateDocument("essentialmode", doc._id, {characters = doc.characters}, function()
								print("Mugshot updated in DB!")
							end)
							--------------------------------------------------
							-- update any online players user object --
							--------------------------------------------------
							TriggerEvent("es:getPlayers", function(players)
								if players then
									for id, user in pairs(players) do
										if id and user then
											if user.getActiveCharacterData("fullName") == (doc.characters[i].firstName .. " " .. doc.characters[i].lastName) then
												user.setActiveCharacterData("mugshot", url)
												print("Online player's mugshot updated!")
												break
											end
										end
									end
								end
							end)
							break
						end
					end
				end
			else
				print("person NOT found!")
				local msg = {
					type = "error",
					message  = "No person found matching name " .. data.fname .. " " .. data.lname .. "!"
				}
				TriggerClientEvent("mdt:sendNUIMessage", usource, msg)
				return
			end
		end)
	end)
end)

RegisterServerEvent("mdt:PerformPersonCheckBySSN")
AddEventHandler("mdt:PerformPersonCheckBySSN", function(ssn)
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
        --name = person.getActiveCharacterData("fullName"),
		fname = firstToUpper(person.getActiveCharacterData("firstName")),
		lname = firstToUpper(person.getActiveCharacterData("lastName")),
		dob = person.getActiveCharacterData("dateOfBirth"),
        drivers_license = false,
        firearm_permit = false,
        insurance = false,
        criminal_history = {
            crimes = {},
            tickets = {}
        },
		mugshot = "https://cpyu.org/wp-content/uploads/2016/09/mugshot.jpg" -- generic place holder img
    }
	--------------------
	-- get mugshot --
	--------------------
	if person.getActiveCharacterData("mugshot") then
		person_info.mugshot = person.getActiveCharacterData("mugshot")
	end
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
                    --print("inserted crime")
                    table.insert(person_info.criminal_history.crimes, crime)
                else
                    --print("inserted ticket")
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

RegisterServerEvent("mdt:PerformPersonCheckByName")
AddEventHandler("mdt:PerformPersonCheckByName", function(data)
	local usource = source
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		local query = {
			["characters"] = {
				["$elemMatch"] = {
					--["firstName"] = data.fname,
					--["lastName"] = data.lname
					["firstName"] = {
						["$regex"] = "(?i)" .. data.fname
					},
					["lastName"] = {
						["$regex"] = "(?i)" .. data.lname
					}
				}
			}
		}
		local fields = {
			"characters"
		}
		couchdb.getSpecificFieldFromDocumentByRows("essentialmode", query, fields, function(doc)
			if doc then
				print(data.fname .. " " .. data.lname .. " found in DB search!")
				for i = 1, #doc.characters do
					if doc.characters[i].firstName and doc.characters[i].lastName and data.fname and data.lname then
						if string.lower(doc.characters[i].firstName) == string.lower(data.fname) and string.lower(doc.characters[i].lastName) == string.lower(data.lname) then
							local person = doc.characters[i]
						    -- values have to be false by default to work with UI --
						    local person_info  = {
						        ssn = ssn,
						        --name = firstToUpper(person.firstName) .. " " .. firstToUpper(person.lastName),
								fname = firstToUpper(person.firstName),
								lname = firstToUpper(person.lastName),
								dob = person.dateOfBirth,
						        drivers_license = false,
						        firearm_permit = false,
						        insurance = false,
						        criminal_history = {
						            crimes = {},
						            tickets = {}
						        },
								mugshot = "https://cpyu.org/wp-content/uploads/2016/09/mugshot.jpg" -- generic placeholder img
						    }
							---------------------
							-- get mug shot --
							---------------------
							if person.mugshot then
								person_info.mugshot = person.mugshot
							end
							--------------------
						    -- get licenses --
						    --------------------
						    local licenses = person.licenses
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
						    local insurance = person.insurance
						    if insurance.planName then
						        person_info.insurance = insurance
						    end
						    -----------------------------
						    -- get criminal history --
						    -----------------------------
						    local criminal_history = person.criminalHistory
						    if #criminal_history > 0 then
						        for i = 1, #criminal_history do
						            local crime = criminal_history[i]
						                if not crime.type then -- not a ticket
						                    table.insert(person_info.criminal_history.crimes, crime)
						                else
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

						    TriggerClientEvent("mdt:performPersonCheck", usource, person_info)
						end
					end
				end
			else
				print("person NOT found!")
				local msg = {
					type = "error",
					message  = "No person found matching name " .. data.fname .. " " .. data.lname .. "!"
				}
				TriggerClientEvent("mdt:sendNUIMessage", usource, msg)
				return
			end
		end)
	end)
end)

RegisterServerEvent("mdt:performPlateCheck")
AddEventHandler("mdt:performPlateCheck", function(plateNumber)
	local usource = source
	plateNumber = string.upper(plateNumber)
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
	GetMakeModelOwner({ plateNumber }, function(vehs)
		if vehs[1] then
			local vehicle = {}
			vehicle.veh_name = vehs[1].make .. " " .. vehs[1].model
			vehicle.registered_owner = vehs[1].owner
			vehicle.plate = plateNumber
			TriggerClientEvent("mdt:performPlateCheck", usource, vehicle)
		else
			-- make a random registration for the vehicle --
			local vehicle = {}
			vehicle.veh_name = "Undefined"
			vehicle.registered_owner = random_names[math.random(#random_names)]
			vehicle.plate = plateNumber
			TriggerClientEvent("mdt:performPlateCheck", usource, vehicle)
		end
	end)
end)

RegisterServerEvent("mdt:fetchWarrants")
AddEventHandler("mdt:fetchWarrants", function()
	local usource = source
	local warrants = exports["usa-warrants"]:getWarrants()
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
	exports["usa-warrants"]:createWarrant(usource, warrant, true)
end)

RegisterServerEvent("mdt:deleteWarrant")
AddEventHandler("mdt:deleteWarrant", function(id, rev)
	exports["usa-warrants"]:deleteWarrant("warrants", id, rev)
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
	fetchBOLOs(source)
end)

RegisterServerEvent("mdt:deleteBOLO")
AddEventHandler("mdt:deleteBOLO", function(id, rev)
	deleteBOLO("bolos", id, rev)
end)

RegisterServerEvent("mdt:fetchPoliceReports")
AddEventHandler("mdt:fetchPoliceReports", function()
	fetchPoliceReports(source)
end)

RegisterServerEvent("mdt:fetchPoliceReportDetails")
AddEventHandler("mdt:fetchPoliceReportDetails", function(id)
	local usource = source
	PerformHttpRequest("http://127.0.0.1:5984/policereports/" .. id, function(err, text, headers)
		--print("finished getting police report details for id: " .. id)
		--print("error code: " .. err)
		local response = json.decode(text)
		if response.incident then
			local msg = {
				type = "police_report_details_loaded",
				report = response
			}
			TriggerClientEvent("mdt:sendNUIMessage", usource, msg)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end)

RegisterServerEvent("mdt:createPoliceReport")
AddEventHandler("mdt:createPoliceReport", function(report)
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
		return "Cadet"
	elseif rank == 2 then
		return "Trooper"
	elseif rank == 3 then
		return "Sr. Trooper"
	elseif rank == 4 then
		return "Pr. Sgt."
	elseif rank == 5 then
		return "Sgt."
	elseif rank == 6 then
		return "Lt."
	elseif rank == 7 then
		return "Capt."
	elseif rank == 8 then
		return "Deputy Commissioner"
	elseif rank == 9 then
		return "Commissioner"
	elseif rank == 10 then
		return "Director"
	end
end

function deleteBOLO(db, id, rev)
	-- send DELETE http request
	PerformHttpRequest("http://127.0.0.1:5984/"..db.."/"..id.."?rev="..rev, function(err, rText, headers)
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

function fetchBOLOs(src)
	local BOLOs = {}
	PerformHttpRequest("http://127.0.0.1:5984/bolos/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		local response = json.decode(text)
		if response.rows then
			BOLOs = {} -- reset table
			-- insert all warrants from 'bolos' db into lua table
			for i = 1, #(response.rows) do
				table.insert(BOLOs, response.rows[i].doc)
			end
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
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

function fetchPoliceReports(src)
	local police_reports = {}
	PerformHttpRequest("http://127.0.0.1:5984/policereports/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		local response = json.decode(text)
		if response.rows then
			police_reports = {} -- reset table
			-- insert all warrants from 'bolos' db into lua table
			for i = 1, #(response.rows) do
				local report = {
					_id = response.rows[i].doc._id,
					_rev = response.rows[i].doc._rev,
					timestamp = response.rows[i].doc.timestamp,
					location = response.rows[i].doc.location,
					other_responders = response.rows[i].doc.other_responders,
					author = response.rows[i].doc.author
				}
				table.insert(police_reports, report)
			end
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

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function GetMakeModelOwner(plates, cb) -- test
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getMakeModelOwner"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			--print(responseText)
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						owner = data.rows[i].value[1], -- owner
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3] -- model
					}
					table.insert(responseVehArray, veh)
				end
			end
			-- send vehicles to client for displaying --
			--print("# of vehicles loaded for menu: " .. #responseVehArray)
			cb(responseVehArray)
		end
	end, "POST", json.encode({
		keys = plates
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

-- PERFORM FIRST TIME DB CHECKS --
exports["globals"]:PerformDBCheck("POLICE REPORTS", "policereports")
exports["globals"]:PerformDBCheck("BOLOS", "bolos")

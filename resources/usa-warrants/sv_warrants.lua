function getWarrants(cb)
	local warrants = {}
	PerformHttpRequest("http://127.0.0.1:5984/warrants/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		local response = json.decode(text)
		if response.rows then
			for i = 1, #(response.rows) do
				table.insert(warrants, response.rows[i].doc)
			end
			cb(warrants)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function createWarrant(src, warrant, notify_with_nui)
	-- send warrant to discord:
		-- send discord message
	local desc = "\n**Name:** " .. warrant.first_name .. " " .. warrant.last_name .. "\n**Notes:** " .. warrant.notes ..  "\n**Officer:** " .. warrant.created_by .. "\n**Timestamp:** ".. warrant.timestamp
	local url = 'https://discordapp.com/api/webhooks/618097403521925130/lt-EU8yOBWrC8lBTYvDQUYnLUKzuj1Ahy7Nt_iXg4koBn8RprgvJV4s4IOm2J7zWhKid'
			PerformHttpRequest(url, function(err, text, headers)
				if text then
					print(text)
				end
			end, "POST", json.encode({
				embeds = {
					{
						description = desc,
						color = 524288,
						author = {
							name = "BLAINE COUNTY WARRANT"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
	-- add warrant to warrant list
	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
		-- insert into db
		GetDoc.createDocument("warrants", warrant, function()
			--print("warrant saved!")
			if not notify_with_nui then
				-- notify:
				TriggerClientEvent('chatMessage', src, "", {255, 255, 255}, "^3Warrant created for:^0 " .. first_name .. " " .. last_name .. "! ^3Notes:^0 " .. notes)
			else
				local msg = {
		            type = "warrantInfo",
		            message  = "Warrant successfully created for: " .. warrant.first_name .. " " .. warrant.last_name
		        }
				TriggerClientEvent("mdt:sendNUIMessage", src, msg)
			end
		end)
	end)
end

function deleteWarrant(db, id, rev)
	-- send DELETE http request
	PerformHttpRequest("http://127.0.0.1:5984/"..db.."/"..id.."?rev="..rev, function(err, rText, headers)
		if err == 0 then
			RconPrint("\nrText = " .. rText)
			RconPrint("\nerr = " .. err)
		end
	end, "DELETE", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end

function GetWarrantsForPerson(name, dob, cb)
	local query = {
		["first_name"] = name.first,
		["last_name"] = name.last,
		["dob"] = dob
	}
	TriggerEvent("es:exposeDBFunctions", function(db)
		db.getDocumentsByRows("warrants", query, function(docs)
			cb(docs)
		end)
	end)
end

RegisterServerEvent("warrants:removeAnyActiveWarrants")
AddEventHandler("warrants:removeAnyActiveWarrants", function(name, dob)
	TriggerEvent("es:exposeDBFunctions", function(db)
		local query = {
			["first_name"] = {
				["$regex"] = "(?i)" .. name.first	
			},
			["last_name"] = {
				["$regex"] = "(?i)" .. name.last
			},
			["dob"] = dob
		}
		db.getDocumentsByRows("warrants", query, function(docs)
			if docs then
				for i = 1, #docs do
					deleteWarrant("warrants", docs[i]._id, docs[i]._rev)
				end
			end
		end)
	end)
end)

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("usa-warrants", "warrants")

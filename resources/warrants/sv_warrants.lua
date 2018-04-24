local WARRANTS = {}

--[[
	first_name,
	last_name,
	dob,
	description,
	reason,
	isFelony,
	notes,
	timestamp,
	author
]]

---------------------------
-- LOAD WARRANTS FROM DB --
---------------------------
function loadWarrants()
	print("fetching all warrants...")
	PerformHttpRequest("http://127.0.0.1:5984/warrants/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		print("finished getting warrants...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			WARRANTS = {} -- reset table
			print("#(response.rows) = " .. #(response.rows))
			-- insert all warrants from 'warrants' db into lua table
			for i = 1, #(response.rows) do
				table.insert(WARRANTS, response.rows[i].doc)
			end
			print("finished loading warrants...")
			print("# of warrants: " .. #WARRANTS)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

loadWarrants()

--------------------
-- CREATE WARRANT --
--------------------
TriggerEvent('es:addJobCommand', 'createwarrant', { "police", "sheriff", "judge" }, function(source, args, user)
	if args[2] and args[3] and args[4] then
		local userSource = tonumber(source)
		local officer_name = user.getActiveCharacterData("fullName")
		-- get warrant details from user input:
		local first_name = args[2]
		local last_name = args[3]
		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)
		local notes = table.concat(args, " ")
		-- create warrant:
		local warrant = {
			first_name = first_name,
			last_name = last_name,
			notes = notes,
			created_by = officer_name,
			timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
		}
		--- save warrant
		table.insert(WARRANTS, warrant)
		-- send warrant to discord:
			-- send discord message
			local desc = "\n**Name:** " .. first_name .. " " .. last_name .. "\n**Notes:** " .. notes ..  "\n**Officer:** " .. officer_name .. "\n**Timestamp:** ".. warrant.timestamp
			local url = 'https://discordapp.com/api/webhooks/409961124780310528/mjiYli8X1jr9Uhwtf_QdbrkvWLcwRtuiphmCGfdVUoqAtZghi2FNOMe6dfNbaYZnr0yu'
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
				}), { ["Content-Type"] = 'application/json' })
		-- add player to ban list
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- insert into db
			GetDoc.createDocument("warrants", warrant, function()
				print("warrant saved!")
				-- notify:
				TriggerClientEvent('chatMessage', userSource, "", {255, 255, 255}, "^3Warrant created for:^0 " .. first_name .. " " .. last_name .. "! ^3Notes:^0 " .. notes)
				-- refresh warrants:
				loadWarrants()
			end)
		end)
	else
		TriggerClientEvent("usa:notify", source, "Invalid warrant format.")
	end
end, {
	help = "createwarrant",
	params = {
		{ name = "first name", help = "Person's first name" },
		{ name = "last name", help = "Person's first name" },
		{ name = "charges and description", help = "Charges & Notes" }
	}
})

------------------------
-- SEARCH FOR WARRANT --
------------------------
TriggerEvent('es:addJobCommand', '29', { "police", "sheriff", "judge" }, function(source, args, user)
	local had_results = false
	table.remove(args,1)
	local name_to_check = table.concat(args, " ")
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3CHECKING WARRANTS MATCHING:^0 " .. name_to_check .. "...")
	for i = 1, #WARRANTS do
		local warrant = WARRANTS[i]
		if string.find(string.lower(warrant.first_name .. " " .. warrant.last_name), string.lower(name_to_check)) then
			print("found an outstanding warrant for " .. name_to_check .. "!")
			-- notify:
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3Warrant found for: ^0" .. warrant.first_name .. " " .. warrant.last_name .. "")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3NOTES:^0 " .. warrant.notes)
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3CREATED:^0 " .. warrant.timestamp)
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3AUTHOR^0 " .. warrant.created_by)
			had_results = true
		end
	end
	if not had_results then TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3No warrants found matching:^0 " .. name_to_check) end
end, {
	help = "Run a wants/warrants check on a person.",
	params = {
		{ name = "name", help = "The name of the person to check for wants/warrants." }
	}
})

----------------------
-- DELETE A WARRANT --
----------------------
TriggerEvent('es:addJobCommand', 'deletewarrant', { "police", "sheriff", "judge" }, function(source, args, user)
	if args[2] and args[3] then
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3CHECKING WARRANTS MATCHING:^0 " .. args[2] .. " " .. args[3] .. "...")
		for i = 1, #WARRANTS do
			local warrant = WARRANTS[i]
			if string.lower(warrant.first_name) == string.lower(args[2]) and string.lower(warrant.last_name) == string.lower(args[3]) then
				print("found an outstanding warrant for " .. args[2] .. " " .. args[3] .. "!")
				-- notify:
				TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3Deleting warrant for: ^0" .. warrant.first_name .. " " .. warrant.last_name .. "")
				TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3Notes:^0 " .. warrant.notes)
				TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3CREATED:^0 " .. warrant.timestamp)
				-- remove from DB:
				delete_document("warrants", warrant._id, warrant._rev)
				table.remove(WARRANTS, i)
				return
			end
		end
	else
		TriggerClientEvent("usa:notify", source, "Invalid command format.")
	end
end, {
	help = "",
	params = {
		{ name = "first name", help = "The first name on the warrant to delete." },
		{ name = "last name", help = "The last name on the warrant to delete." }
	}
})

-----------------------------------
-- SHOW ALL OUTSTANDING WARRANTS --
-----------------------------------
TriggerEvent('es:addJobCommand', 'warrants', { "police", "sheriff", "judge" }, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3ACTIVE WARRANTS:")
	for i = 1, #WARRANTS do
		local warrant = WARRANTS[i]
		-- display warrant:
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "--------------------------------------------")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3WANTED: ^0" .. warrant.first_name .. " " .. warrant.last_name .. "")
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3NOTES:^0 " .. warrant.notes)
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3TIME:^0 " .. warrant.timestamp)
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "^3AUTHOR^0 " .. warrant.created_by)
		TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "--------------------------------------------")
	end
end, { help = "Show all active warrants." })

--------------------------------------------------------------------
-- REMOVE ALL OUTSTANDING WARRANTS (when being booked into prison) --
---------------------------------------------------------------------
RegisterServerEvent("warrants:removeAnyActiveWarrants")
AddEventHandler("warrants:removeAnyActiveWarrants", function(name)
	name = string.lower(name)
	for i = #WARRANTS, 1, -1 do
		local warrant = WARRANTS[i]
		local warrant_name = string.lower(warrant.first_name .. " " .. warrant.last_name)
		if string.find(warrant_name, name) then
			-- match found, remove warrant
			-- remove from DB:
			delete_document("warrants", warrant._id, warrant._rev)
			table.remove(WARRANTS, i)
		end
	end
end)


function delete_document(db, id, rev)
	-- send DELETE http request
	PerformHttpRequest("http://127.0.0.1:5984/"..db.."/"..id.."?rev="..rev, function(err, rText, headers)
		if err == 0 then
			RconPrint("\nrText = " .. rText)
			RconPrint("\nerr = " .. err)
		else
			loadWarrants() -- refresh warrants
		end
	end, "DELETE", "", {["Content-Type"] = 'application/json'})
end

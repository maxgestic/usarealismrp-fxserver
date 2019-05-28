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
	PerformHttpRequest("http://127.0.0.1:5984/warrants/_all_docs?include_docs=true" --[[ string ]], function(err, text, headers)
		--print("finished getting warrants...")
		--print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			WARRANTS = {} -- reset table
			--print("#(response.rows) = " .. #(response.rows))
			-- insert all warrants from 'warrants' db into lua table
			for i = 1, #(response.rows) do
				table.insert(WARRANTS, response.rows[i].doc)
			end
			--print("finished loading warrants...")
			--print("# of warrants: " .. #WARRANTS)
		end
	end, "GET", "", { ["Content-Type"] = 'application/json' })
end

-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("usa-warrants", "warrants", loadWarrants)

function getWarrants()
	return WARRANTS
end

function createWarrant(src, warrant, notify_with_nui)
	--- save warrant
	table.insert(WARRANTS, warrant)
	-- send warrant to discord:
		-- send discord message
		local desc = "\n**Name:** " .. warrant.first_name .. " " .. warrant.last_name .. "\n**Notes:** " .. warrant.notes ..  "\n**Officer:** " .. warrant.created_by .. "\n**Timestamp:** ".. warrant.timestamp
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
			-- refresh warrants:
			loadWarrants()
		end)
	end)
end

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
			deleteWarrant("warrants", warrant._id, warrant._rev)
			table.remove(WARRANTS, i)
		end
	end
end)


function deleteWarrant(db, id, rev)
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

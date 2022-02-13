exports["globals"]:PerformDBCheck("usa_motiontext", "motiontext")

local TEXT_PERSIST_DAYS = 7

local allText = {}

local WORD_BLACKLIST = {
    "nigger",
    "faggot",
    "fuck",
    "shit",
    "bitch",
    "cunt",
    "whore",
    "cock",
    "ERP",
    "server"
}

function containsBlacklistedWord(content)
    for i = 1, #WORD_BLACKLIST do
        if content:find(WORD_BLACKLIST[i]) then
            return true
        end
    end
    return false
end

RegisterServerEvent("motiontext:submit")
AddEventHandler("motiontext:submit", function(info)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(src)
    if not char.hasItem("Sign Kit") then
        TriggerClientEvent("usa:notify", src, "You need a sign kit!")
        return
    end
    if containsBlacklistedWord(info.text.content) then
        TriggerClientEvent("usa:notify", src, "Blacklisted word found!")
        return
    end
    char.removeItem("Sign Kit", 1)
    TriggerEvent('es:exposeDBFunctions', function(db)
        local newTextDoc = info
        newTextDoc.created = {}
        newTextDoc.created.time = os.time()
        newTextDoc.created.author = GetPlayerIdentifiers(src)[1]
        db.createDocument("motiontext", newTextDoc, function(ok)
            if ok then 
                print("* New motiontext doc created! *")
                TriggerClientEvent("motiontext:new", -1, info)
                table.insert(allText, info)
            else 
                print("* Error creating new motiontext doc in DB *")
            end
        end)
    end)
end)

RegisterServerEvent("motiontext:delete")
AddEventHandler("motiontext:delete", function(index)
    local src = source
    TriggerEvent('es:exposeDBFunctions', function(db)
        TriggerClientEvent("motiontext:remove", -1, index)
        db.deleteDocument("motiontext", allText[index]._id, function(ok)
            TriggerClientEvent("usa:notify", src, "Sign deleted!")
        end)
        table.remove(allText, index)
    end)
end)

RegisterServerEvent("motiontext:playerSpawned")
AddEventHandler("motiontext:playerSpawned", function()
    TriggerClientEvent("motiontext:set", source, allText)
end)

Citizen.CreateThread(function()
    -- get all docs and populate the allText collection, also delete ones at least TEXT_PERSIST_DAYS old:
    PerformHttpRequest("http://127.0.0.1:5984/motiontext/_all_docs?include_docs=true", function(err, text, headers)
		print("finished getting motiontext docs...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			print("#(response.rows) = " .. #(response.rows))
			for i = 1, #(response.rows) do
				if response.rows[i] then
					if response.rows[i].doc then
                        local doc = response.rows[i].doc
                        if os.difftime(os.time(), (doc.created.time or 0)) > TEXT_PERSIST_DAYS * 24 * 60 * 60 then
                            print("text was old enough! deleting!")
                            TriggerEvent('es:exposeDBFunctions', function(db)
                                db.deleteDocument("motiontext", doc._id, function(ok) end)
                            end)
                        else
                            table.insert(allText, doc)
                        end
                    else
						print("Error loading text document at index #" .. i)
					end
				else
					print("Error loading text at index #" .. i)
				end
			end
			print("finished loading motiontext...")
		end
	end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
end)

TriggerEvent('es:addCommand', 'sign', function(source, args, char)
    TriggerClientEvent("motiontext:toggleMenu", source)
end, { help = "Create a sign!" })

TriggerEvent('es:addCommand', 'deletesign', function(source, args, char)
    TriggerClientEvent("motiontext:delete", source)
end, { help = "Delete a sign" })
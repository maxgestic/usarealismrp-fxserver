TriggerEvent('es:addCommand', 'notepad', function(source, args, char, location)
    TriggerClientEvent("notepad:toggle", source)
end, { help = "Open your notepad to write things in"})

RegisterServerEvent("notepad:getSaved")
AddEventHandler("notepad:getSaved", function()
    local usource = source
    local ident = GetPlayerIdentifiers(usource)[1]
    GetSavedNote(ident, function(notes)
        TriggerClientEvent("notepad:gotSaved", usource, notes)
    end)
end)

RegisterServerEvent("notepad:save")
AddEventHandler("notepad:save", function(notes)
    SaveNote(source, notes)
end)

function SaveNote(src, notes)
    TriggerEvent('es:exposeDBFunctions', function(db)
        local ident = GetPlayerIdentifiers(src)[1]
        db.updateDocument("notes", ident, { content = notes }, function(doc, err, rText)
            if doc then
                print("* Note updated in DB! *")
            else
                local newNote = {
                    content = notes,
                    writtenTimeMs = os.time()
                }
                db.createDocumentWithId("notes", newNote, ident, function(okay)
                    if okay then 
                        print("* New note created! *")
                    else 
                        print("* Error creating new note *")
                    end
                end)
            end
		end)
	end)
end

function GetSavedNote(ident, cb)
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocumentById("notes", ident, function(doc)
            if doc then
                cb(doc.content)
            else
                cb("")
            end
        end)
    end)
end

exports["globals"]:PerformDBCheck("_notepad", "notes", nil)
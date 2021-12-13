exports["globals"]:PerformDBCheck("rcore_spray", "sprays", nil)

if Framework.ESX then
    ESX = nil

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

SPRAYS = {}

FastBlacklist = {}

Citizen.CreateThread(function()
    if Config.Blacklist then
        for _, word in pairs(Config.Blacklist) do
            FastBlacklist[word] = word
        end
    end
end)

function GetSprayAtCoords(pos)
    for _, spray in pairs(SPRAYS) do
        if spray.location == pos then
            return spray
        end
    end
end

function AddSpray(Source, spray)
    local i = 1
    while true do
        if not SPRAYS[i] then
            SPRAYS[i] = spray
            break
        else
            i = i + 1
        end
    end

    PersistSpray(spray)
    TriggerEvent('rcore_sprays:addSpray', Source, spray.text, spray.location)
    TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)
end

function StartSpraying(args, source)
    local sprayText = args[2]

    if FastBlacklist[sprayText] then
        TriggerClientEvent("usa:notify", source, Config.Text.BLACKLISTED)
    else
        if sprayText then
            if sprayText:len() <= 9 then
                TriggerClientEvent('rcore_spray:spray', source, sprayText)
            else
                TriggerClientEvent("usa:notify", source, Config.Text.WORD_LONG)
            end
        else
            TriggerClientEvent("usa:notify", source, Config.Text.USAGE)
        end
    end
end

function RemoveSprayAtPosition(Source, pos)
    local sprayAtCoords = GetSprayAtCoords(pos)

    local query = {
        x = pos.x,
        y = pos.y,
        z = pos.z,
        text = sprayAtCoords.text,
        font = sprayAtCoords.font,
        color = sprayAtCoords.originalColor
    }

    -- get and delete doc found with above query
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocumentByRows("sprays", query, function(doc)
            print("found doc with ID: " .. doc._id)
            db.deleteDocument("sprays", doc._id, function(ok) print("deleted, ok status: " .. tostring(ok)) end)
        end)
    end)

    for idx, s in pairs(SPRAYS) do
        if s.location.x == pos.x and s.location.y == pos.y and s.location.z == pos.z then
            SPRAYS[idx] = nil
        end
    end
    TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)

    local sprayAtCoordsAfterRemoval = GetSprayAtCoords(pos)

    -- ensure someone doesnt bug it so its trying to remove other tags
    -- while deducting loyalty from not-deleted-but-at-coords tag
    if sprayAtCoords and not sprayAtCoordsAfterRemoval then
        TriggerEvent('rcore_sprays:removeSpray', Source, sprayAtCoords.text, sprayAtCoords.location)
    end
end

RegisterNetEvent('rcore_spray:addSpray')
AddEventHandler('rcore_spray:addSpray', function(spray)
    local Source = source
    AddSpray(Source, spray)
    local c = exports["usa-characters"]:GetCharacter(Source)
    local sprayCanItem = c.getItem("Spray Paint")
    c.modifyItemByUUID(sprayCanItem.uuid, {remainingUses = sprayCanItem.remainingUses - 1})
    TriggerClientEvent("usa:notify", Source, "Remaining uses: " .. sprayCanItem.remainingUses - 1)
end)

function PersistSpray(spray)
    TriggerEvent('es:exposeDBFunctions', function(db)
        local newSprayDoc = {
            x = spray.location.x,
            y = spray.location.y,
            z = spray.location.z,
            rx = spray.realRotation.x,
            ry = spray.realRotation.y,
            rz = spray.realRotation.z,
            scale = spray.scale,
            text = spray.text,
            font = spray.font,
            color = spray.originalColor,
            interior = spray.interior,
            identifier = spray.identifier,
            created_at = os.time()
        }
        db.createDocument("sprays", newSprayDoc, function(ok)
            if ok then 
                print("* New spray created! *")
            else 
                print("* Error creating new spray in DB *")
            end
        end)
    end)
end

Citizen.CreateThread(function()

    -- get all docs and populate the SPRAYS collection, also delete ones at least Config.SPRAY_PERSIST_DAYS old:
    PerformHttpRequest("http://127.0.0.1:5984/sprays/_all_docs?include_docs=true", function(err, text, headers)
		print("finished getting sprays...")
		print("error code: " .. err)
		local response = json.decode(text)
		if response.rows then
			print("#(response.rows) = " .. #(response.rows))
			for i = 1, #(response.rows) do
				if response.rows[i] then
					if response.rows[i].doc then
                        local s = response.rows[i].doc
                        if os.difftime(os.time(), (s.created_at or 0)) > Config.SPRAY_PERSIST_DAYS * 24 * 60 * 60 then
                            print("spray was old enough! deleting!")
                            TriggerEvent('es:exposeDBFunctions', function(db)
                                db.deleteDocument("sprays", s._id, function(ok) end)
                            end)
                        else
                            table.insert(SPRAYS, {
                                location = vector3(s.x + 0.0, s.y + 0.0, s.z + 0.0),
                                realRotation = vector3(s.rx + 0.0, s.ry + 0.0, s.rz + 0.0),
                                scale = tonumber(s.scale) + 0.0,
                                text = s.text,
                                font = s.font,
                                originalColor = s.color,
                                interior = (s.interior == 1) and true or false,
                            })
                        end
                    else
						print("Error loading spray document at index #" .. i)
					end
				else
					print("Error loading spray at index #" .. i)
				end
			end
			print("finished loading sprays...")
		end
	end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })

    TriggerClientEvent('rcore_spray:setSprays', -1, SPRAYS)
end)

RegisterNetEvent('rcore_spray:playerSpawned')
AddEventHandler('rcore_spray:playerSpawned', function()
    local Source = source
    TriggerClientEvent('rcore_spray:setSprays', Source, SPRAYS)
end)

TriggerEvent('es:addCommand', 'spray', function(source, args, char)
    if not args[2] or args[2] == " " then
        TriggerClientEvent("usa:notify", source, "Usage: /spray [word]")
        return
    end
    local sprayCanItem = char.getItem("Spray Paint")
    if sprayCanItem then
        if sprayCanItem.remainingUses > 0 then
            StartSpraying(args, source)
        else
            TriggerClientEvent("usa:notify", source, "Can is empty!")
        end
    else
        TriggerClientEvent("usa:notify", source, "Need a spray can!")
    end
end, {
    help = "Spray paint",
    params = {
        { name = "word", help = "9 character max" },
    }
})

TriggerEvent('es:addCommand', 'removespray', function(source, args, char)
    local rag = char.getItem("Rag")
    local sprayPaintRemoverItem = char.getItem("Paint Remover")
    if rag and sprayPaintRemoverItem then
        if sprayPaintRemoverItem.remainingUses > 0 then
            TriggerClientEvent("rcore_spray:removeNearestSpray", source)
        else
            TriggerClientEvent("usa:notify", source, "Paint remover is empty!")
        end
    else
        TriggerClientEvent("usa:notify", source, "Need a rag and paint remover!")
    end
end, { help = "Remove spray paint" })

function HasSpray(serverId, cb)
    local xPlayer = ESX.GetPlayerFromId(serverId)
    local item = xPlayer.getInventoryItem("spray")

    cb(item.count > 0)
end
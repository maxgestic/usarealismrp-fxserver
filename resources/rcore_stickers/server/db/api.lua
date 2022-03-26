CreateThread(function()
    FetchVehicle = function(plate, model)
        if Config.EnableESX then
            local vehicle = DB.fetchAll([[
                SELECT
                    owner,
                    REPLACE(plate, ' ', ''),
                    vehicle AS model
                FROM owned_vehicles
                WHERE
                    REPLACE(plate, ' ', '') = @plate
                AND
                    vehicle LIKE '%"model":@model%'
            ]], {
                ['plate'] = plate,
                ['model'] = model
            })[1]

            if vehicle then
                vehicle.model = json.decode(vehicle.model)['model']
            end

            return vehicle
        end

        if Config.EnableQBCore then
            return DB.fetchAll([[
                SELECT
                    license AS owner,
                    plate,
                    hash AS model
                FROM player_vehicles
                WHERE
                    plate = @plate
                AND
                    hash = @model
            ]], {
                ['plate'] = plate,
                ['model'] = model
            })[1]
        end

        if Config.EnableCustomEvents then
            local promise = promise:new()
            TriggerEvent('rcore_stickers:getVehicleInfo', plate, model, function(vehicle)
                promise:resolve(vehicle)
            end)

            return Citizen.Await(promise)
        end
    end

    FetchAllStickers = function()
        local stickers = {}
        local doneFetching = false
        PerformHttpRequest("http://127.0.0.1:5984/car-stickers/_all_docs?include_docs=true", function(err, text, headers)
            local response = json.decode(text)
            if response.rows then
                for i = 1, #(response.rows) do
                    table.insert(stickers, response.rows[i].doc)
                end
            end
            doneFetching = true
        end, "GET", "", { ["Content-Type"] = 'application/json', ['Authorization'] = "Basic " .. exports["essentialmode"]:getAuth() })
        while not doneFetching do
            Wait(1)
        end
        return stickers
    end

    FetchStickers = function(vehicleHash, vehiclePlate)
        local stickers = {}
        local doneFetching = false
        TriggerEvent('es:exposeDBFunctions', function(db)
            local query = {
                plate = vehiclePlate,
                model = vehicleHash
            }
            db.getDocumentsByRows("car-stickers", query, function(docs)
                if not docs then docs = {} end
                stickers = docs
                doneFetching = true
            end)
        end)
        while not doneFetching do
            Wait(1)
        end
        return stickers
    end

    InsertSticker = function(sticker, vehicleHash, vehiclePlate)
        local stickerDoc = sticker
        local id = exports.globals:generateID(12):lower()
        stickerDoc.id = id
        stickerDoc.model = vehicleHash
        stickerDoc.plate = vehiclePlate
        stickerDoc.rotation = sticker.rot
        stickerDoc.rFromX = sticker.rFrom.x
        stickerDoc.rFromY = sticker.rFrom.y
        stickerDoc.rFromZ = sticker.rFrom.z
        stickerDoc.rToX = sticker.rTo.x
        stickerDoc.rToY = sticker.rTo.y
        stickerDoc.rToZ = sticker.rTo.z
        ray_from_x = stickerDoc.rFromX
        ray_from_y = stickerDoc.rFromY
        ray_from_z = stickerDoc.rFromZ
        ray_to_x = stickerDoc.rToX
        ray_to_y = stickerDoc.rToY
        ray_to_z = stickerDoc.rToZ
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.createDocumentWithId("car-stickers", stickerDoc, id, function(ok) end)
        end)
        return id
    end

    EditSticker = function(sticker)
        sticker.rotation = sticker.rot
        sticker.ray_from_x = sticker.rFrom.x
        sticker.ray_from_y = sticker.rFrom.y
        sticker.ray_from_z = sticker.rFrom.z
        sticker.ray_to_x = sticker.rTo.x
        sticker.ray_to_y = sticker.rTo.y
        sticker.ray_to_z = sticker.rTo.z
        local waiting = true
        local ret = nil
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.updateDocument("car-stickers", sticker.id, sticker, function(doc, err, rtext)
                ret = doc
                waiting = false
            end)
            while waiting do
                Wait(1)
            end
            return ret
        end)
    end

    DeleteSticker = function(sticker)
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.deleteDocument("car-stickers", sticker.id, function(ok) end)
        end)
    end

    if Config.EnableMySQL or Config.EnableOxMySQL or Config.EnableGhMattiMySQL then
        DB.execute([[
            CREATE TABLE IF NOT EXISTS stickers (
                id INT AUTO_INCREMENT,
                name VARCHAR(255) NOT NULL,
                vehicle_hash VARCHAR(50) NOT NULL,
                vehicle_plate VARCHAR(50) NOT NULL,
                scale FLOAT NOT NULL,
                rotation FLOAT NOT NULL,
                ray_from_x FLOAT NOT NULL,
                ray_from_y FLOAT NOT NULL,
                ray_from_z FLOAT NOT NULL,
                ray_to_x FLOAT NOT NULL,
                ray_to_y FLOAT NOT NULL,
                ray_to_z FLOAT NOT NULL,
                CONSTRAINT stickers_primary_key PRIMARY KEY (id)
            );
        ]])
    end
end)
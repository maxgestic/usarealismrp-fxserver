local KARTS = {
    {
        MODEL = "kart",
        HASH = GetHashKey("kart"),
        COORDS = vector3(-65.50290222168, -1826.6392822266, 25.503315505981),
        HEADING = 227.0,
        PRICE = 10000
    },
    {
        MODEL = "kart3",
        HASH = GetHashKey("kart3"),
        COORDS = vector3(-67.355209350586, -1828.2266357422, 25.942804336548),
        HEADING = 227.0,
        PRICE = 17500
    },
    {
        MODEL = "kart20",
        HASH = GetHashKey("kart20"),
        COORDS = vector3(-68.73802947998, -1829.9088378906, 25.942209243774),
        HEADING = 227.0,
        PRICE = 20000
    },
    {
        MODEL = "Shifter_kart",
        HASH = GetHashKey("Shifter_kart"),
        COORDS = vector3(-70.300369262695, -1831.78515625, 25.941976547241),
        HEADING = 231.0,
        PRICE = 30000
    }
}

RegisterServerEvent("gokarts:loadKarts")
AddEventHandler("gokarts:loadKarts", function()
    TriggerClientEvent("gokarts:loadKarts", source, KARTS)
end)

RegisterServerEvent("gokarts:buy")
AddEventHandler("gokarts:buy", function(index)
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.get("money") >= KARTS[index].PRICE then
        char.removeMoney(KARTS[index].PRICE)
        local vehicles = char.get("vehicles")
        local owner_name = char.getFullName()
        local plate = generate_random_number_plate()
        local vehicle = {
            owner = owner_name,
            make = "",
            model = KARTS[index].MODEL,
            hash = GetHashKey(KARTS[index].MODEL),
            plate = plate,
            stored = false,
            price = KARTS[index].PRICE,
            inventory = {},
            storage_capacity = 5.0
        }
        table.insert(vehicles, vehicle.plate)
        char.set("vehicles", vehicles)
        -- add to database --
        AddVehicleToDB(vehicle)
        local key = {
            name = "Key -- " .. plate,
            quantity = 1,
            type = "key",
            owner = owner_name,
            make = "Kart Co.",
            model = KARTS[index].MODEL,
            plate = plate
        }
        TriggerEvent("garage:giveKey", key, source)
        KARTS[index].plate = plate
        TriggerClientEvent("gokarts:spawn", source, KARTS[index])
        local chatSentence1 = "Purchased a " .. KARTS[index].MODEL .. " for $" .. exports.globals:comma_value(KARTS[index].PRICE)
        local chatSentence2 = "Remember, these are ^3not legal to drive on the streets^0! We receommend having them towed to their final destination."
        TriggerClientEvent("usa:notify", source, chatSentence1, "^3INFO:^0 " .. chatSentence1)
        TriggerClientEvent("chatMessage", source, "", {}, "^3INFO:^0 " .. chatSentence2)
    else 
        TriggerClientEvent("usa:notify", source, "Need: $" .. exports.globals:comma_value(KARTS[index].PRICE), "^3INFO:^0 Need: $" .. exports.globals:comma_value(KARTS[index].PRICE))
    end
end)

function generate_random_number_plate()
    local charset = {
      numbers = {},
      letters = {}
    }
    -- QWERTYUIOPASDFGHJKLZXCVBNM1234567890
    for i = 48,  57 do table.insert(charset.numbers, string.char(i)) end -- add numbers 1 - 9
    for i = 65,  90 do table.insert(charset.letters, string.char(i)) end -- add capital letters
    local number_plate = ""
    number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
    number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
    number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
    number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
    number_plate = number_plate .. charset.letters[math.random(#charset.letters)] -- letter
    number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
    number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
    number_plate = number_plate .. charset.numbers[math.random(#charset.numbers)] -- number
    return number_plate
end

-- Insert new vehicle into DB --
function AddVehicleToDB(vehicle)
    TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.createDocumentWithId("vehicles", vehicle, vehicle.plate, function(success)
        if success then
            --print("* Vehicle created in DB!! *")
        else
            --print("* Error: vehicle was not created in DB!! *")
        end
        end)
    end)
end
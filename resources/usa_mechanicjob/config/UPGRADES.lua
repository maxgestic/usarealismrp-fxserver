UPGRADES = {
    --[[
    ["topspeed1"] = {
        id = "topspeed1",
        displayName = "Top Speed 1",
        cost = 5000,
        increaseAmount = 5.0,
        doSync = true,
        requiresItem = "Top Speed Tune 1"
    },
    ["topspeed2"] = {
        id = "topspeed2",
        displayName = "Top Speed 2",
        cost = 10000,
        increaseAmount = 10.0,
        doSync = true,
        requiresItem = "Top Speed Tune 2"
    },
    ["topspeed3"] = {
        id = "topspeed3",
        displayName = "Top Speed 3",
        cost = 15000,
        increaseAmount = 15.0,
        doSync = true,
        requiresItem = "Top Speed Tune 3"
    },
    --]]
    ["topspeed4"] = {
        id = "topspeed4",
        displayName = "Top Speed Tune",
        increaseAmount = 20.0,
        doSync = true,
        requiresItem = "Top Speed Tune"
    },
    ["nitrokit"] = {
        id = "nitrokit",
        displayName = "NOS Install Kit",
        requiresItem = "NOS Install Kit"
    },
    ["nitrobottle1"] = {
        id = "nitrobottle1",
        displayName = "NOS Bottle (Stage 1)",
        requiresItem = "NOS Bottle (Stage 1)",
        requiresUpgrades = {
            "nitrokit"
        },
        maxCapacity = 4000,
        postInstall = function(vehPlate)
            local done = false
            MechanicHelper.db.getDocumentById("vehicle-nitro-fuel", vehPlate, function(doc)
                if doc then
                    MechanicHelper.db.updateDocument("vehicle-nitro-fuel", vehPlate, {nitroFuelLevel = UPGRADES["nitrobottle1"].maxCapacity}, function(ok) done = true end)
                else
                    MechanicHelper.db.createDocumentWithId("vehicle-nitro-fuel", {nitroFuelLevel = UPGRADES["nitrobottle1"].maxCapacity, maxCapacity = UPGRADES["nitrobottle1"].maxCapacity}, vehPlate, function(ok) done = true end)
                end
            end)
            while not done do
                Wait(1)
            end
        end
    },
    ["nitrobottle2"] = {
        id = "nitrobottle2",
        displayName = "NOS Bottle (Stage 2)",
        requiresItem = "NOS Bottle (Stage 2)",
        requiresUpgrades = {
            "nitrokit"
        },
        maxCapacity = 8000,
        postInstall = function(vehPlate)
            local done = false
            MechanicHelper.db.getDocumentById("vehicle-nitro-fuel", vehPlate, function(doc)
                if doc then
                    MechanicHelper.db.updateDocument("vehicle-nitro-fuel", vehPlate, {nitroFuelLevel = UPGRADES["nitrobottle2"].maxCapacity}, function(ok) done = true end)
                else
                    MechanicHelper.db.createDocumentWithId("vehicle-nitro-fuel", {nitroFuelLevel = UPGRADES["nitrobottle2"].maxCapacity, maxCapacity = UPGRADES["nitrobottle2"].maxCapacity}, vehPlate, function(ok) done = true end)
                end
            end)
            while not done do
                Wait(1)
            end
        end
    },
    ["nitrobottle3"] = {
        id = "nitrobottle3",
        displayName = "NOS Bottle (Stage 3)",
        requiresItem = "NOS Bottle (Stage 3)",
        requiresUpgrades = {
            "nitrokit"
        },
        maxCapacity = 16000,
        postInstall = function(vehPlate)
            local done = false
            MechanicHelper.db.getDocumentById("vehicle-nitro-fuel", vehPlate, function(doc)
                if doc then
                    MechanicHelper.db.updateDocument("vehicle-nitro-fuel", vehPlate, {nitroFuelLevel = UPGRADES["nitrobottle3"].maxCapacity}, function(ok) done = true end)
                else
                    MechanicHelper.db.createDocumentWithId("vehicle-nitro-fuel", {nitroFuelLevel = UPGRADES["nitrobottle3"].maxCapacity, maxCapacity = UPGRADES["nitrobottle3"].maxCapacity}, vehPlate, function(ok) done = true end)
                end
            end)
            while not done do
                Wait(1)
            end
        end
    },
    ["nitroguage"] = {
        id = "nitroguage",
        displayName = "NOS Gauge",
        requiresItem = "NOS Gauge",
        requiresUpgrades = {
            "nitrokit"
        }
    }
}
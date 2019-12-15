PRODUCTS = {
    ["cannabis"] = {
        buyLocation = { x = 413.22399902344,y = 6539.4467773438, z = 27.734628677368 }, -- Paleto
        item = {
            name = "Small Weed Plant",
            quantity = 1,
            weight = 20.0,
            legality = "legal"
        },
        harvestItem = {
            name = "Weed Bud",
            quantity = 1,
            weight = 4.0,
            type = "drug",
            legality = "legal",
            objectModel = "bkr_prop_weed_bud_01a"
        },
        rewardQuantity = {
            min = 10,
            max = 30
        },
        cost = 200,
        stages = {
            { name = "vegetative", lengthInHours = 48, objectModels = { "bkr_prop_weed_01_small_01a", "bkr_prop_weed_01_small_01b", "bkr_prop_weed_01_small_01c" } },
            { name = "flower", lengthInHours = 96, objectModels = { "bkr_prop_weed_med_01a", "bkr_prop_weed_med_01b" } },
            { name = "harvest", lengthInHours = 168, objectModels = { "bkr_prop_weed_lrg_01b" } }
        }
    }
}

PLANTED = {} -- global table of all currently planted plants (sort of an in-memory cache between DB and server)

STAGE_CHECK_INTERVAL_MINUTES = 30
SAVE_INTERVAL_MINUTES = 35

WATER_DECREMENT_VAL = 1.2
FOOD_DECREMENT_VAL = 0.85

LOW_THRESHOLD = 70.0
MED_THRESHOLD = 45.0
HIGH_THRESHOLD = 30.0
DIE_THRESHOLD = 15.0 -- no longer harvestable if below this threshold

RegisterServerEvent("cultivation:load")
AddEventHandler("cultivation:load", function()
    TriggerClientEvent("cultivation:load", source, PRODUCTS, PLANTED)
end)

--[[
    for testing:
    
    local testobj = {}
    testobj["_id"] = "1994a81632cf65f5d39e4c3c5727031a"
    testobj["_rev"] = "1-2f6e02937023cd858f7ed387eccdf317"
    testobj["waterLevel"] = {
            ["val"] = 85.0,
            ["asString"] = "~r~Very Thirsty~w~"
        }
    testobj["stage"] = {
            ["objectModels"] = {
                "bkr_prop_weed_lrg_01b"
            },
            ["name"] = "harvest",
            ["lengthInHours"] = 96
        }
    testobj["type"] = "cannabis"
    testobj["foodLevel"] = {
        ["val"] = 16.25,
        ["asString"] = "~g~Slighty Hungry~w~"
    }
    testobj["plantedAt"] = 1575570530
    testobj["coords"] = {
        ["x"] = -1071.6051025391,
        ["y"] = -1673.951171875,
        ["z"] = 3.4894876480103
    }
    testobj["owner"] = {
        ["name"] = {
            ["last"] = "LenneyIII",
            ["middle"] = "",
            ["first"] = "William"
        }
    }
    testobj["steam"] = "steam:1100001177bdebd"
    testobj["id"] = "64bb494a96ba8b98ad0e5ee23d13f835"

    table.insert(PLANTED, testobj)
]]
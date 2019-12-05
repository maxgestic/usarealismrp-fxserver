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

WATER_DECREMENT_VAL = 2.5
FOOD_DECREMENT_VAL = 1.25

LOW_THRESHOLD = 70.0
MED_THRESHOLD = 45.0
HIGH_THRESHOLD = 30.0
DIE_THRESHOLD = 15.0 -- no longer harvestable if below this threshold

RegisterServerEvent("cultivation:load")
AddEventHandler("cultivation:load", function()
    TriggerClientEvent("cultivation:load", source, PRODUCTS, PLANTED)
end)
local SCUBA_GEAR_PRICE = 5000

local SCUBA_GEAR_ITEM = {
    name = "Scuba Gear",
    legality = "legal",
    weight = 45.0,
    quantity = 1,
    type = "misc",
    price = 5000,
    objectModel = "p_michael_scuba_tank_s"
}

RegisterServerEvent("scuba:buyGear")
AddEventHandler("scuba:buyGear", function()
    local c = exports["usa-characters"]:GetCharacter(source)
    if c.get("money") >= SCUBA_GEAR_PRICE then
        if c.canHoldItem(SCUBA_GEAR_ITEM) then
            c.removeMoney(SCUBA_GEAR_PRICE)
            c.giveItem(SCUBA_GEAR_ITEM)
        else
            TriggerClientEvent("usa:notify", source, "Inventory full!")    
        end
    else
        TriggerClientEvent("usa:notify", source, "Need $5,000")
    end
end)
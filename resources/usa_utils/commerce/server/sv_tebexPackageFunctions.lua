local BRONZE_PACKAGE_REWARD_PAY = 10000
local SILVER_PACKAGE_REWARD_PAY = 25000
local GOLD_PACKAGE_REWARD_PAY = 40000

TEBEX_PACKAGE_FUNCTIONS = {
    bronze = function(src)
        local c = exports["usa-characters"]:GetCharacter(src)
        if c then
            c.giveBank(BRONZE_PACKAGE_REWARD_PAY)
            TriggerClientEvent("usa:notify", c.get("source"), "~g~Deposited: ~w~" .. exports.globals:comma_value(BRONZE_PACKAGE_REWARD_PAY))
            return true
        else
            return false
        end
    end,
    silver = function(src)
        local c = exports["usa-characters"]:GetCharacter(src)
        if c then
            c.giveBank(SILVER_PACKAGE_REWARD_PAY)
            TriggerClientEvent("usa:notify", c.get("source"), "~g~Deposited: ~w~" .. exports.globals:comma_value(SILVER_PACKAGE_REWARD_PAY))
            return true
        else
            return false
        end
    end,
    gold = function(src)
        local c = exports["usa-characters"]:GetCharacter(src)
        if c then
            c.giveBank(GOLD_PACKAGE_REWARD_PAY)
            TriggerClientEvent("usa:notify", c.get("source"), "~g~Deposited: ~w~" .. exports.globals:comma_value(GOLD_PACKAGE_REWARD_PAY))
            return true
        else
            return false
        end
    end
}
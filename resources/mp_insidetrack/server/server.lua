-- Don't edit this file
local neededGameBuild = 2060
local currentGameBuild = GetConvarInt('sv_enforceGameBuild', 1604)

Citizen.CreateThread(function()
    if (currentGameBuild < neededGameBuild) then
        print('^3['..GetCurrentResourceName()..']^0: You need to use ^3' .. neededGameBuild .. '^0 game build (or above) to use this resource.')
    end
end)

RegisterServerEvent("horse-racing:winMoney")
AddEventHandler("horse-racing:winMoney", function(amount, securityToken)
    if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
    print("horse race bet won money: $" .. amount)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.giveMoney(amount)
end)

RegisterServerCallback { 
    eventName = "horse-racing:doesHaveEnoughMoney",
    eventCallback = function(source, betAmount, doTake)
        local char = exports["usa-characters"]:GetCharacter(source)
        local hasEnough = char.get("money") >= betAmount
        if hasEnough and doTake then
            char.removeMoney(betAmount)
        end
        return hasEnough
    end
}

RegisterServerCallback { 
    eventName = "horse-racing:getCurrentChipBalance",
    eventCallback = function(source)
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.get("money")
    end
}
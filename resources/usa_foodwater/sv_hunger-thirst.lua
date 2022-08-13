local SAVE_INTERVAL = 1

local lastCheckedTime = 0

local FOOD_EXPIRE_DAYS = 7

RegisterServerEvent("foodwater:save")
AddEventHandler("foodwater:save", function(person)
    local char = exports["usa-characters"]:GetCharacter(source)
    if char then
        char.set("hunger", person.hunger_level)
        char.set("thirst", person.thirst_level)
    end
end)

AddEventHandler("character:loaded", function(char)
    local src = char.get("source")
    TriggerClientEvent("foodwater:loaded", src, char.get("hunger") or 100.0, char.get("thirst") or 100.0)
end)

Citizen.CreateThread(function()
    Wait(15000)
    while true do
        if GetMinutesFromTime(lastCheckedTime) >= SAVE_INTERVAL then
            lastCheckedTime = os.time()
            exports["usa-characters"]:GetCharacters(function(characters)
                for src, char in pairs(characters) do
                    TriggerClientEvent("foodwater:save", src)
                end
            end)
        end
		Wait(10000)
	end
end)

function GetMinutesFromTime(t)
	local minutesfrom = os.difftime(os.time(), t) / 60
    local minutes = math.floor(minutesfrom)
	return minutes
end

RegisterServerEvent("foodwater:checkItemAge")
AddEventHandler("foodwater:checkItemAge", function(item)
    local char = exports["usa-characters"]:GetCharacter(source)
    local invItem = char.getItemByUUID(item.uuid)
    if invItem then
        if not invItem.createdTime then
            invItem.createdTime = os.time()
        end 
        local numDaysSinceCreation = exports.globals:GetHoursFromTime(invItem.createdTime) / 24
        if numDaysSinceCreation > FOOD_EXPIRE_DAYS then
            TriggerClientEvent("usa:notify", source, "That has gone bad!", "INFO: That food or drink item has gone bad!")
        else
            if invItem.type == "food" then
                TriggerClientEvent("hungerAndThirst:replenish", source, "hunger", invItem)
            elseif invItem.type == "drink" then
                TriggerClientEvent("hungerAndThirst:replenish", source, "drink", invItem)
            end

        end
        if invItem.quantity > 1 then -- for backwards compatibility just in case people have stacked food items rn
            char.removeItemByUUID(invItem.uuid, 1)
        else 
            char.removeItemByUUID(invItem.uuid)
        end
    end
end)
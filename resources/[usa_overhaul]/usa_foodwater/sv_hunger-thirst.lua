local CHECK_TIME = 2
local SAVE_TIME = 5
local lastSaved = {}

RegisterServerEvent("foodwater:save")
AddEventHandler("foodwater:save", function(person)
    local char = exports["usa-characters"]:GetCharacter(source)
    char.set("hunger", person.hunger_level)
    char.set("thirst", person.thirst_level)
end)

AddEventHandler("character:loaded", function(char)
    local src = char.get("source")
    TriggerClientEvent("foodwater:loaded", src, char.get("hunger") or 100.0, char.get("thirst") or 100.0)
    lastSaved[src] = os.time()
end)

AddEventHandler("playerDropped", function(reason)
    if lastSaved[source] then 
        lastSaved[source] = nil 
    end
end)

Citizen.CreateThread(function()
    while true do
        exports["usa-characters"]:GetCharacters(function(characters)
            for src, char in pairs(characters) do
                if lastSaved[src] then
                    if GetMinutesFromTime(lastSaved[src]) >= SAVE_TIME then
                        TriggerClientEvent("foodwater:save", -1)
                    end
                end
            end
        end)
		Wait(CHECK_TIME * 60 * 1000)
	end
end)

function GetMinutesFromTime(t)
	local minutesfrom = os.difftime(os.time(), t) / 60
    local minutes = math.floor(minutesfrom)
	return minutes
end
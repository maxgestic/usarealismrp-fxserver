local CHECK_TIME_MINUTES = 1
local lastSaved = {}

local lastCheckedtime = 0

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
    lastSaved[src] = os.time()
end)

AddEventHandler("playerDropped", function(reason)
    if lastSaved[source] then 
        lastSaved[source] = nil 
    end
end)

Citizen.CreateThread(function()
    Wait(15000)
    while true do
        --print("time since last check: " .. GetMinutesFromTime(lastCheckedtime))
        if GetMinutesFromTime(lastCheckedtime) >= CHECK_TIME_MINUTES then
            --print("saving all players' hunger/thirst!")
            lastCheckedtime = os.time()
            exports["usa-characters"]:GetCharacters(function(characters)
                for src, char in pairs(characters) do
                    if not lastSaved[src] then
                        lastSaved[src] = os.time()
                    end
                    TriggerClientEvent("foodwater:save", -1)
                    --print("saving for player " .. src)
                end
            end)
        end
		Wait(2000)
	end
end)

function GetMinutesFromTime(t)
	local minutesfrom = os.difftime(os.time(), t) / 60
    local minutes = math.floor(minutesfrom)
	return minutes
end
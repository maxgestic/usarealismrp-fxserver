local DURATION_UPPER_BOUND_IN_MINUTES = 100
local DURATION_LOWER_BOUND_IN_MINUTES = 60
local TIMEOUT = false
local CMD_TIMEOUT_IN_SECONDS = 20  -- /setweather command timeout in seconds
local currentWeatherString = "CLEAR"   -- Starting Weather Type.
local updateWeatherFlag = false
local RAIN_PREVENT_CHANCE = 0.60

-- weather types that must be invoked manually by an admin
manualWeathers = {
	"SNOW",  -- no visibility
	"XMAS",  -- blankets entire map with snow
	"BLIZZARD",  -- no visibility
	"HALLOWEEN",  -- no clue what this is so...
	"NEUTRAL",  -- apparent issue where it sometimes turns the sky green
}

-- Format is { ["Current Weather"] = { {"Weather Type", weight}, ... } ... }
-- All weights in a "Current Weather" dictionary should add up to 100 or less
-- If the weights are < 100 then the remaining weight is attributed to the current weather
weatherTree = {
	["EXTRASUNNY"] = {
		{"CLEAR", 37},
		{"SMOG", 10},
	},
	["SMOG"] = {
		{"FOGGY", 20},
		{"CLEAR", 20},
		{"CLEARING", 2},
		{"OVERCAST", 7},
		{"CLOUDS", 13},
		{"EXTRASUNNY", 15},
	},
	["CLEAR"] = {
		{"CLOUDS", 14},
		{"EXTRASUNNY", 14},
		{"CLEARING", 2},
		{"SMOG", 8},
		{"FOGGY", 8},
		{"OVERCAST", 9},
	},
	["CLOUDS"] = {
		{"CLEAR", 12},
		{"SMOG", 10},
		{"FOGGY", 10},
		{"CLEARING", 2},
		{"OVERCAST", 10},
		{"SNOWLIGHT", 0},
	},
	["FOGGY"] = {
		{"CLEAR", 15},
		{"CLOUDS", 20},
		{"SMOG", 10},
		{"OVERCAST", 8},
	},
	["OVERCAST"] = {
		{"CLEAR", 10},
		{"CLOUDS", 15},
		{"SNOWLIGHT", 0},
		{"FOGGY", 10},
		{"RAIN", 0},
		{"CLEARING", 3},
	},
	["RAIN"] = {
		{"THUNDER", 15},
		{"CLEARING", 20},
		{"OVERCAST", 40},
	},
	["THUNDER"] = {
		{"RAIN", 20},
		{"CLEARING", 70},
	},
	["CLEARING"] = {
		{"CLEAR", 30},
		{"CLOUDS", 14},
		{"OVERCAST", 10},
		{"FOGGY", 12},
		{"SMOG", 10},
		{"RAIN", 0},
		{"SNOWLIGHT", 0},
	},
	["SNOWLIGHT"] = {
		{"CLOUDS", 40},
		{"OVERCAST", 30},
		{"CLEARING", 5},
	},
}

windWeathers = {
	["OVERCAST"] = true,
	["RAIN"] = true,
	["THUNDER"] = true,
	["CLOUDS"] = true
}

currentWeatherData = {
	["weatherString"] = currentWeatherString,
	["windEnabled"] = false,
	["windHeading"] = 0
}

function getRandomWeatherDuration(weatherName)
	if weatherName == "RAIN" or weatherName == "THUNDER" then
		return math.random(5, 30) * 60000
	else
		return math.random(DURATION_LOWER_BOUND_IN_MINUTES, DURATION_UPPER_BOUND_IN_MINUTES) * 60000
	end
end

function isStaffMember(src)
	local player = exports["essentialmode"]:getPlayerFromId(src)
	if player.getGroup() ~= "user" then
		return true
	else
		return false
	end
end

function handleAdminCheck(from)
	if not isStaffMember(from) then
		TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "You must be an admin to use this command.")
		return false
	end
	return true
end

function getTableKeys(T)
	local keys = {}
	for k,v in pairs(T) do
		table.insert(keys,k)
	end
	return keys
end

function getTableLength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function updateWeather()
	local newWeatherString = nil
	local windEnabled = false
	local windHeading = 0
	local curWeather = currentWeatherData["weatherString"]

	if curWeather == nil then
		local count = getTableLength(weatherTree)
		local tableKeys = getTableKeys(weatherTree)
		newWeatherString = tableKeys[math.random(1, count)]
	else
		local target = math.random(1, 100)
		local runningTotal = 0
		local targetHit = false
		local currentOptions = weatherTree[curWeather]
		if not currentOptions then
			-- If an admin forces a weather that is disabled for auto updating, this will trigger
			-- An admin must manually update the weather to a value that is allowed to reenable dynamic weather
			print("ERROR: Current weather is not in weatherTree")
			return
		end

		-- select new weather --
		for _, wTable in pairs(currentOptions) do
			local weight = wTable[2]
			if runningTotal < target and target <= weight + runningTotal then
				targetHit = true
				newWeatherString = wTable[1]
				if newWeatherString == "RAIN" then 
					if math.random() <= RAIN_PREVENT_CHANCE then -- chance to stop rain when selected
						while newWeatherString == "RAIN" or newWeatherString == "CLEARING" do 
							newWeatherString = wTable[math.random(#wTable)] -- choose random weather that's not RAIN
						end
					end
				end
				break
			else
				runningTotal = runningTotal + weight
			end
		end

		if not targetHit then  -- keep weather the same
			return
		end
	end

	if not newWeatherString then
		print("ERROR: newWeatherString was nil")
		return
	end

	-- 50% Chance to enable wind at a random heading for the specified weathers.
	if windWeathers[newWeatherString] and (math.random(0,1) == 1) then
		windEnabled = true
		windHeading = math.random(0,360)
	end

	currentWeatherData = {
		["weatherString"] = newWeatherString,
		["windEnabled"] = windEnabled,
		["windHeading"] = windHeading
	}

	print("Updating Weather to " .. newWeatherString .. " for all players.")
	TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
end

function getNextWeatherPossibilities()
	local nextWeathers = {}
	local curWeather = currentWeatherData["weatherString"]
	local nextOptions = weatherTree[curWeather]
	if not nextOptions then  -- not in weatherTree
		for _, w in pairs(manualWeathers) do
			if curWeather ~= w then
				table.insert(nextWeathers, w)
			end
		end
		for _, w in pairs(getTableKeys(weatherTree)) do
			if curWeather ~= w then
				table.insert(nextWeathers, w)
			end
		end
		return nextWeathers
	end
	for _, wTable in pairs(nextOptions) do
		table.insert(nextWeathers, wTable[1])
	end
	return nextWeathers
end

function isWeatherType(weather)
	for _, w in pairs(getTableKeys(weatherTree)) do
		if weather == w then
			return true
		end
	end
	for _, w in pairs(manualWeathers) do
		if weather == w then
			return true
		end
	end
	return false
end

function isWeatherChangeValid(nextWeather)
	local nextWeathers = getNextWeatherPossibilities()
	for _, weather in pairs(nextWeathers) do
		if nextWeather == weather then
			return true
		end
	end
	for _, weather in pairs(manualWeathers) do
		if nextWeather == weather then
			return true
		end
	end
	return false
end

-- Sync Weather once player joins.
RegisterServerEvent("smartweather:syncWeather")
AddEventHandler("smartweather:syncWeather",function()
	print("Syncing weather for: " .. GetPlayerName(source))
	TriggerClientEvent("smartweather:updateWeather", source, currentWeatherData)
end)

TriggerEvent('es:addGroupCommand', 'updatetime', "owner", function(source, args, user)
	-- NOTE: only changes for the client who used the command --
	TriggerClientEvent("smartweather:updateTime", source, tonumber(args[2]), tonumber(args[3]))
end)

TriggerEvent('es:addGroupCommand', 'setweather', "admin", function(source, args, user)
	local userSource = source
	if TIMEOUT then
		TriggerClientEvent('usa:notify', userSource, "Changing weather too fast, please wait!")
		return
	end

	local wtype = string.upper(tostring(args[2]))
	if currentWeatherData["weatherString"] == wtype then
		TriggerClientEvent('usa:notify', userSource, "Weather is already set to "..wtype.."!")
		return
	end

	CancelEvent() -- whatever this does...

	if wtype == nil then
		TriggerClientEvent('usa:notify', userSource, "USAGE: /setweather <wtype>")
		return
	end
	if not isWeatherType(wtype) then
		TriggerClientEvent('usa:notify', userSource, "Invalid weather type!")
		return
	end

	if isWeatherChangeValid(wtype) then
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has set the weather to ^2'..wtype..'^0.')
		currentWeatherData["weatherString"] = wtype

		-- 50% Chance to enable wind at a random heading for the specified weathers.
		if windWeathers[newWeatherString] and (math.random(0,1) == 1) then
			windEnabled = true
			windHeading = math.random(0,360)
		end

		TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData) -- Sync weather for all players

		TIMEOUT = true
		SetTimeout(CMD_TIMEOUT_IN_SECONDS * 1000, function()
			TIMEOUT = false
		end)
	else
		TriggerClientEvent('chatMessage', userSource, "", {200,0,0}, "^2^*[STAFF]^r^0 Too abrupt! From " .. currentWeatherData["weatherString"] .. ", you can change to: " .. table.concat(getNextWeatherPossibilities()," | "))
	end
end,
	{
		help = "Initiate a weather change",
		params = {
			{ name = "weather name", help = table.concat(getTableKeys(weatherTree),", ") }
		}
	}
)

-- kickoff weather auto update
SetTimeout(getRandomWeatherDuration(currentWeatherData["weatherString"]), function()
	math.randomseed(GetGameTimer())
	updateWeatherFlag = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		if updateWeatherFlag then
			updateWeatherFlag = false
			updateWeather()
			SetTimeout(getRandomWeatherDuration(currentWeatherData["weatherString"]), function()
				updateWeatherFlag = true
			end)
		end
	end
end)

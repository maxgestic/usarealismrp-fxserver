TotalFires = 0
CurrentFireID = 0
AllFires = {}

local WEBHOOK_URL = GetConvar("firescript-webhook", "")

--[[Essential Events]]--
RegisterServerEvent("FireScript:FirePutOut")
AddEventHandler("FireScript:FirePutOut", function(id)
	StopFire(id)
end)

RegisterServerEvent("FireScript:StartFire")
AddEventHandler("FireScript:StartFire", function(id, x, y, z, street, road)
	if not AllFires[id]["position"] then
		AllFires[id]["position"] = vector3(x, y, z)
		AllFires[id]["street"] = street
		AllFires[id]["road"] = road
		TriggerEvent("FireScript:FireStarted", id)

		local toSend = {
			["position"] = {
				x = x, y = y, z = z
			},
			["flames"] = AllFires[id].flames,
			["spread"] = AllFires[id].spread,
			["info"] = AllFires[id].info
		}
		TriggerClientEvent('FireScript:SyncFire', -1, id, toSend)
	end
end)

RegisterServerEvent("FireScript:RequestFire")
AddEventHandler("FireScript:RequestFire", function()
	for id, data in ipairs(AllFires) do
		if data.position then
			local toSend = {
				["position"] = {
					x = data.position.x, y = data.position.y, z = data.position.z
				},
				["flames"] = data.flames,
				["spread"] = data.spread,
				["info"] = data.info
			}
			TriggerClientEvent('FireScript:SyncFire', source, id, toSend)
			TriggerClientEvent("FireScript:FireStarted", source, id, AllFires[id]["position"], false)
		end
	end
end)

RegisterServerEvent("FireScript:StopFire")
AddEventHandler("FireScript:StopFire", function(id)
	StopFire(id)
end)

RegisterServerEvent('FireScript:RequestPermissions')
AddEventHandler('FireScript:RequestPermissions', function()
    TriggerClientEvent('FireScript:RequestPermissions', source, IsJobWhitelisted(source))
end)

--[[Commands]]--

--[[Functions]]--
function StartFire(source, data)
	local toSend = {
		["id"] = data.id
	}
	TriggerClientEvent('FireScript:StartFire', source, data)
	AllFires[data.id] = data
end

function StopFire(id)
	if AllFires[id] then
		TriggerClientEvent('FireScript:StopFire', -1, id)
		TriggerEvent("FireScript:FireEnded", id)
		TotalFires = TotalFires - 1
		if TotalFires < 0 then
			TotalFires = 0
		end
	end
end

function IsJobWhitelisted(source)
	local job = exports["usa-characters"]:GetCharacterField(source, "job")
  	if job == "ems" or job == "fire" then
		return true
	end
    return false
end

--[[Important Events]]--
AddEventHandler('FireScript:FireStarted', function(id)
	local msg1 = "Fire Started" .. " [" .. id .. "]", "Creator: " .. AllFires[id].creator .. "\nLocation: " .. AllFires[id]["street"] .. " | " .. AllFires[id]["road"]
	local msg2 = "Random Fire Started [" .. id .. "]", "Location: " .. AllFires[id]["location"]
	if AllFires[id].creator then
		exports.globals:SendDiscordLog(WEBHOOK_URL, msg1)
	else--Random Fire
		exports.globals:SendDiscordLog(WEBHOOK_URL, msg2)
	end
	TriggerClientEvent("FireScript:FireStarted", -1, id, AllFires[id]["position"], true)
end)

AddEventHandler('FireScript:FireEnded', function(data, id)
	local msg1 = "All Fires Stopped By ".. GetPlayerName(id)
	local msg2 = "Fire Stopped [" .. data .. "]", "Creator: " .. AllFires[data].creator .. "\n" .. "Location: " .. AllFires[data]["street"] .. " | " .. AllFires[data]["road"] .. "\nRemaining Fires " .. (TotalFires - 1)
	local msg3 = "Random Fire Stopped [" .. data .. "]", "Location: " .. AllFires[data]["location"]
	if not data then
		exports.globals:SendDiscordLog(WEBHOOK_URL, msg1)
		AllFires = {}
		TriggerClientEvent("FireScript:FireStopped", -1)
	else
		if AllFires[data].creator then
			exports.globals:SendDiscordLog(WEBHOOK_URL, msg2)
		else--Random Fire
			exports.globals:SendDiscordLog(WEBHOOK_URL, msg3)
		end
		TriggerClientEvent("FireScript:FireStopped", -1, data, AllFires[data].position)
		AllFires[data] = nil
	end
end)

print("FIRESCRIPT ^1Has Authenticated ^2Successfully! ^0By ^1ToxicScripts! ^7")
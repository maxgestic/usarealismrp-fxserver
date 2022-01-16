local BLACKLISTED_SIT_LOCATIONS = {
	{
		coords = vector3(4982.228515625, -5710.6870117188, 19.886962890625),
		distance = 100
	},
	{
		coords = vector3(257.16165161133, 220.75233459473, 106.28523254395),
		distance = 100
	}
}

local function isAtBlacklistedLocation(coords)
	for i = 1, #BLACKLISTED_SIT_LOCATIONS do
		if #(coords - BLACKLISTED_SIT_LOCATIONS[i].coords) < BLACKLISTED_SIT_LOCATIONS[i].distance then
			return true
		end
	end
	return false
end

TriggerEvent('es:addCommand', 'sit', function(src, args, char)
	if char.get("jailTime") > 0 then return end
	if isAtBlacklistedLocation(GetEntityCoords(GetPlayerPed(src))) then
		TriggerClientEvent("usa:notify", src, "Can't sit here")
		return
	end
	TriggerClientEvent('sit:sitOnNearest', src)
end, { help = "Sit on the nearest chair, seat, or bench" })

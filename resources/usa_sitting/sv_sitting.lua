local BLACKLISTED_SIT_LOCATIONS = {
	{
		coords = vector3(4982.228515625, -5710.6870117188, 19.886962890625),
		distance = 100
	},
	{
		coords = vector3(257.16165161133, 220.75233459473, 106.28523254395),
		distance = 100
	},
	{
		coords = vector3(-104.23067474365, 6467.9448242188, 31.63631439209), -- Paleto Bank Vault
		distance = 5
	},
	{
		coords = vector3(1616.5336914063, 2530.3994140625, 45.858158111572), -- Prison Yard 1
		distance = 25
	},
	{
		coords = vector3(1619.6966552734, 2574.3732910156, 45.564842224121), -- Prison Yard 2
		distance = 25
	},
	{
		coords = vector3(1661.6617431641, 2487.9362792969, 45.564914703369), -- Prison Yard 3
		distance = 25
	},
	{
		coords = vector3(1717.2875976563, 2494.1206054688, 45.564872741699), -- Prison Yard 4
		distance = 25
	},
	{
		coords = vector3(1761.3337402344, 2525.3137207031, 45.565055847168), -- Prison Yard 5
		distance = 5
	},
	{
		coords = vector3(1740.0490722656, 2562.8288574219, 45.565071105957), -- Prison Yard 6
		distance = 5
	},
	{
		coords = vector3(1704.1507568359, 2564.9987792969, 45.564849853516), -- Prison Yard 7
		distance = 5
	},
	{
		coords = vector3(1677.0544433594, 2564.9880371094, 45.564846038818), -- Prison Yard 8
		distance = 5
	},
	{
		coords = vector3(1772.3193359375, 2535.220703125, 45.56506729126), -- Prison Yard 10
		distance = 10
	},
	{
		coords = vector3(1791.0913085938, 2547.814453125, 45.673126220703), -- Prison Cafe 1
		distance = 2
	},
	{
		coords = vector3(1791.0640869141, 2555.8559570313, 45.673080444336), -- Prison Cafe 2
		distance = 2
	},
	{
		coords = vector3(1791.2034912109, 2552.0615234375, 45.673080444336), -- Prison Cafe 3
		distance = 2
	},
	{
		coords = vector3(1845.2885742188, 2608.5454101563, 45.590347290039), -- Prison Front Gate
		distance = 20
	},
	{
		coords = vector3(1818.9332275391, 2608.4833984375, 45.593780517578), -- Prison Front Gate 2
		distance = 20
	},
	{
		coords = vector3(1796.9038085938, 2596.880859375, 45.62133026123), -- Prison Visitation Gates
		distance = 20
	},
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

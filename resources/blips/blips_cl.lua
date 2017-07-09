local blips = {
	{ title="Clothing Store", colour=67, id=73, x= 1.09696, y=6511.75, z=31.8778 }, -- paleto
	{ title="Clothing Store", colour=67, id=73, x= 1692.16, y=4817.22, z=42.0631 }, -- grape seed
	{ title="Clothing Store", colour=67, id=73, x= 1202.18, y=2707.79, z=38.2226 }, -- sandy shores 1
	{ title="Clothing Store", colour=67, id=73, x= 612.971, y=2762.73, z=42.0881 }, -- sandy shores 2
	{ title="Clothing Store", colour=67, id=73, x= -1095.84, y=2712.23, z=19.1078 }, -- route 68
	{ title="Clothing Store", colour=67, id=73, x= -3170.52, y=1043.97, z=20.8632 }, -- chumash, great ocean hwy
	{ title="Clothing Store", colour=67, id=73, x= -1448.61, y= -237.858, z= 49.8136 }, -- vinewood 1
	{ title="Clothing Store", colour=67, id=73, x= -709.059, y=-151.475, z=37.4151 }, -- vinewood 2
	{ title="Clothing Store", colour=67, id=73, x= -1193.81, y=-766.964, z=17.3163 }, -- vinewood 3
	{ title="Clothing Store", colour=67, id=73, x= -165.07, y=-303.251, z=39.7333 }, -- vinewood 4
	{ title="Clothing Store", colour=67, id=73, x= 127.174, y=-224.259, z=54.5578 }, -- vinewood 5
	{ title="Clothing Store", colour=67, id=73, x= 422.92, y=-811.772, z=29.4911 }, -- vinewood 6
	{ title="Clothing Store", colour=67, id=73, x= -816.335, y=-1072.93, z=11.3281 }, -- vinewood 7
	{ title="Clothing Store", colour=67, id=73, x= 78.0717, y=-1387.25, z=29.3761 }, -- vinewood 8
	{ title="Drug Dealer", colour=25, id=140, x=31.1395, y=-1928.05, z=21.7875 },
	{ title="Drug Buyer", colour=27, id=280, x=1435.595, y=6355.136, z=23.150 },
	{ title="Ammu-Nation", colour=41, id=110, x=-330.184, y=6083.23, z=31.4548 },
	{ title="Ammu-Nation", colour=41, id=110, x=1701.292, y=3750.450, z=34.365 },
    { title="Ammu-Nation", colour=41, id=110, x=237.428, y=-43.655, z=69.698 },
    { title="Ammu-Nation", colour=41, id=110, x=843.604, y=-1017.784, z=27.546 },
    { title="Ammu-Nation", colour=41, id=110, x=-663.8073, y=-947.5537, z=21.509 },
    { title="Ammu-Nation", colour=41, id=110, x=-1320.983, y=-389.260, z=36.483 },
    { title="Ammu-Nation", colour=41, id=110, x=-1109.053, y=2686.300, z=18.775 },
    { title="Ammu-Nation", colour=41, id=110, x=2568.379, y=309.629, z=108.461 },
    { title="Ammu-Nation", colour=41, id=110, x=-3157.450, y=1079.633, z=20.692 },
    { title="Ammu-Nation", colour=41, id=110, x=16.6405, y=-1116.9636, z=29.7911 },
    { title="Ammu-Nation", colour=41, id=110, x=812.4276, y=-2145.2118, z=29.3063 },
	--{ title="Car Dealership", colour=71, id=56, x=119.634, y=6626.24, z=31.957 },
	{ title="Car Dealership", colour=76, id=225, x=-43.2616, y=-1097.37, z=26.4223 },
	{ title="DMV", colour=4, id=355, x=-447.723, y=6013.65, z=30.700 },
	{ title="DMV", colour=4, id=355, x=441.301, y=-981.434, z=29.689 },
	{ title="DMV", colour=4, id=355, x=1853.616, y=3687.966, z=33.267 },
	--{ title="Vehicle Impound", colour=64, id=68, x=-460.847, y=5978.19, z=31.3063 },
	{ title="Vehicle Impound", colour=64, id=68, x=401.492, y=-1632.016, z=29.291 },
	{ title="Black Market Dealer", colour = 59, id = 52, x = 129.345, y = -1920.89, z = 20.0187 },
	{ title="General Store", colour = 24 , id = 52, x=1729.59, y=6415.49, z=34.0 },
	{ title="General Store", colour = 24 , id = 52, x=81.6779, y=-219.006, z=54.6367 },
	{ title="General Store", colour = 24 , id = 52, x=373.794, y=326.504, z=103.566	 },
	{ title="General Store", colour = 24 , id = 52, x=1135.6, y=-981.327, z=46.5269	 },
	{ title="General Store", colour = 24 , id = 52, x=-1223.69, y=-907.691, z=12.3264 },
	{ title="General Store", colour = 24 , id = 52, x=25.746, y=-1345.59, z=29.497 },
	{ title="Sheriff's Office", colour = 38 , id = 60, x=451.255, y=-992.41, z=30.6896 },
	{ title="Fire Department", colour = 59, id = 60, x=207.106, y=-1641.45, z=28.5 },
	{ title="Strip Club", colour = 48, id = 121, x=129.607, y=-1299.83, z=29.2327 },
	{ title="FTF", colour = 47, id = 88, x=140.577, y=-768.375, z=45.752 },
	{ title="Airport", colour = 30, id = 307, x=-1329.32, y=-3045.92, z=13.944 },
	{ title="Bar", colour = 83, id = 93, x=-564.778, y=274.195, z=83.0197 },
	{ title="Downtown Taxi", colour = 60, id = 198, x=895.563, y=-179.536, z=74.7003 }
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
    end
end)

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(1000)
	-- 	TriggerServerEvent("gps:pingPlayers")
	-- end
end)

local GovBlips = {}
RegisterNetEvent("gps:showGov")
AddEventHandler("gps:showGov", function(ptable)
	for _, user in ipairs(ptable) do
		if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" or user.job == "ems" or user.job == "fire" then
			if GovBlips[user.identifier] then
				RemoveBlip(GovBlips[user.identifier])
			end
			GovBlips[user.identifier] = AddBlipForCoord(user.coords.x, user.coords.y, user.coords.z)
			SetBlipDisplay(GovBlips[user.identifier], 4)
			SetBlipScale(GovBlips[user.identifier], 0.9)
			SetBlipAsShortRange(GovBlips[user.identifier], true)
			BeginTextCommandSetBlipName("STRING")
			if user.job == "cop" or user.job == "sheriff" or user.job == "highwaypatrol" then
				SetBlipSprite(GovBlips[user.identifier], 60)
				SetBlipColour(GovBlips[user.identifier], 67)
				AddTextComponentString("Government Employee: Officer")
			elseif user.job == "ems" then
				SetBlipSprite(GovBlips[user.identifier], 61)
				SetBlipColour(GovBlips[user.identifier], 32)
				AddTextComponentString("Government Employee: EMS")
			elseif user.job == "fire" then
				SetBlipSprite(GovBlips[user.identifier], 461)
				SetBlipColour(GovBlips[user.identifier], 17)
				AddTextComponentString("Government Employee: Fire")
			end
			EndTextCommandSetBlipName(GovBlips[user.identifier])
		end
	end
end)

RegisterNetEvent("gps:removeGov")
AddEventHandler("gps:removeGov", function(users)
	for _, user in ipairs(users) do
		RemoveBlip(GovBlips[user])
	end
end)

local EMSReq = {}
RegisterNetEvent("gps:addEMSReq")
AddEventHandler("gps:addEMSReq", function(user)
	if EMSReq[user.identifier] then
		RemoveBlip(EMSReq[user.identifier])
	end
	EMSReq[user.identifier] = AddBlipForCoord(user.coords.x, user.coords.y, user.coords.z)
	SetBlipDisplay(EMSReq[user.identifier], 4)
	SetBlipScale(EMSReq[user.identifier], 0.9)
	SetBlipAsShortRange(EMSReq[user.identifier], true)
	BeginTextCommandSetBlipName("STRING")
	SetBlipSprite(EMSReq[user.identifier], 153)
	SetBlipColour(EMSReq[user.identifier], 75)
	AddTextComponentString("Incapacitated person")
	EndTextCommandSetBlipName(EMSReq[user.identifier])
end)

RegisterNetEvent("gps:removeEMSReq")
AddEventHandler("gps:removeEMSReq", function(user)
	if EMSReq then
		if EMSReq[user.identifier] then
			RemoveBlip(EMSReq[user.identifier])
		end
	end
end)

RegisterNetEvent("gps:removeAllEMSReq")
AddEventHandler("gps:removeAllEMSReq", function()
	for _, user in ipairs(EMSReq) do
		RemoveBlip(EMSReq[user])
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
			-- table.insert(meta, GetEntityCoords(GetPlayerPed(GetPlayerServerId(i))))
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end

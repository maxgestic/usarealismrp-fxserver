-- This collection is to prevent this script from detecting our custom warp points that teleport far distances (like the paleto jail cells into mission row pd) --
-- todo: instead of duplicating the coordinates from warppoints resource, just make them gloabl or exports or something and use them so we don't have to worry about updating both resources manually
local COORDS_TO_ALLOW_TELEPORTATION_FROM = {
	{ x = -299.48, y = 6255.23, z = 30.53 }, -- Hen house entrance
	{ x = -1387.47, y = -588.195, z = 29.3195 }, -- Hen house exit
	{ x = -447.414, y = 6000.88, z = 30.7 }, -- jail interior
	{ x = 450.957, y = -986.462, z = 25.9 }, -- jail exit
	{ x = 317.283, y = -1631.1505, z = 31.59 }, -- courthouse entrance
	{ x = 234.547, y = -413.567, z = -119.365 }, -- courthouse exit
	{ x = -240.81, y = 6325.3, z = 32.43 },
	{ x = 1819.9, y = 3688.5, z = 34.22 },
	{ x  = 353.5, y = -588.9, z = 43.3 },
	{ x = 177.6, y = 6646.2, z = 31.6 }, -- LS Customs parking lot spawn point
	{ x = 751.3, y = 6454.3, z = 31.9}, -- character selection menu (prevent /swap from triggering)
	{ x = 1714.893, y = 2542.678, z = 45.565 }, -- jail 1
	{ x = 1847.086, y = 2585.990, z = 45.672 }, -- jail 2
	{ x = 1723.7, y = 2630.4, z = 45.6 }, -- jail 3
	{ x = 1738.3, y = 2644.7, z = 45.6 },  -- jail 4
	{ x = -145.09, y = 6304.72, z = 31.55 },  -- Movies entrance
	{ x = 320.21, y = 263.80, z = 82.97 },  -- Movie room
	{ x = 256.459, y = -1347.748, z = 24.538 },  -- Morgue
	{ x = 1770.7, y = 2515.5, z = 45.6 }, -- prison entrance
	{ x = 1617.3, y = 2530.5, z = 45.7 }, -- prison yard exit 1
	{ x = 1636.6, y = 2564.2, z = 45.6 }, -- hallway entrance 1
	{ x = 1633.4, y = 2576.5 , z = 45.6 }, -- hallway, inside 1
	{ x = 1655.9, y = 2576.6, z = 45.5 }, -- laundry room entrance
	{ x = 1775.4, y = 2509.1, z = 45.6 }, -- prison yard entrance 1
	{ x = 1658.8, y = 2575.9, z = 45.6 }, -- hallway exit 1
	{ x = 1725.2, y = 2584.3, z = 45.6 }, -- meal room entrance from hallway
	{ x = 1729.1, y = 2591.4, z = 45.6 }, -- meal room entrance to cell block
	{ x = 1748.0, y = 2581.8, z = 45.6 }, -- visitor area entrance from meal room
	{ x = 1835.4, y = 2570.9, z = 45.8 }, -- visitor area exit to meal room
	{ x = 1840.5, y = 2578.9, z = 45.8 }, -- visitory area exit to front
	{ x = 1725.6, y = 2566.9, z = 49.6 }, -- prison office entrance
	{ x = 1691.1, y = 2539.2, z = 50.0 }, -- prison office exit
	{ x = 1745.5, y = 2625.3, z = 45.6 }, -- prison cell block exit to meal room
	-- begin tunnels --
	{ x = 496.30267333984, y = -3222.6359863282, z = 6.0695104599 },
	{ x = 514.29266357422, y = 4885.8706054688, z = -62.589862823486 },
	{ x = 2482.9174804688, y = -405.25631713868, z = 93.735389709472 },
	{ x = 2158.1184082032, y = 2920.9382324218, z = -81.075386047364 },
	{ x = 2053.8020019532, y = 2953.4047851562, z = 47.664855957032 },
	{ x = 2151.1369628906, y = 2921.3303222656, z = -61.901874542236 },
	{ x = 1267.4091796875, y = 2830.9741210938, z = 48.444499969482 },
	{ x = 483.2006225586, y = 4810.5405273438, z = -58.919288635254 },
	{ x = 602.27032470704, y = 5546.9267578125, z = 716.38928222656},
	{ x = -355.9, y = 4823.3, z = 142.9 },
	{ x = 1259.5418701172, y = 4812.1196289062, z = -39.77448272705},
	{ x = 0.0, y = 0.0, z = 0.8}, -- hospital
	{ x = 360.3, y = -548.89, z = 28.74}, -- respawn in Pillbox
	{ x = 1508.97, y = 3769.1, z = 34.14}, -- spawn in sandy
	{ x = 307.48, y = -1435.36, z = 29.81}, -- respawn in Davis
	{ x = 354.03, y = -589.41, z = 43.42}, -- hospital
	{ x = 614.69, y = 2784.20, z = 43.48} -- cocaine processing exit
}

local PROPERTY_COORDS = {
	{-1493.75, -668.33, 29.02},
	{-1498.18, -664.69, 29.02},
	{-1495.33, -661.57, 29.02},
	{-1490.72, -658.23, 29.02},
	{-1486.77, -655.44, 29.58},
	{-1482.22, -652.07, 29.58},
	{-1478.19, -649.10, 29.58},
	{-1473.60, -645.81, 29.58},
	{-1469.73, -642.97, 29.58},
	{-1465.07, -639.59, 29.58},
	{-1461.23, -640.87, 29.58},
	{-1452.40, -653.21, 29.58},
	{-1454.44, -655.91, 29.58},
	{-1458.95, -659.32, 29.58},
	{-1462.92, -662.17, 29.58},
	{-1467.47, -665.49, 29.58},
	{-1471.44, -668.38, 29.58},
	{-1461.31, -640.84, 33.38},
	{-1457.87, -645.48, 33.38},
	{-1455.66, -648.52, 33.38},
	{-1452.40, -653.20, 33.38},
	{-1454.36, -655.97, 33.38},
	{-1458.90, -659.26, 33.38},
	{-1462.92, -662.20, 33.38},
	{-1467.55, -665.52, 33.38},
	{-1471.48, -668.40, 33.38},
	{-1476.09, -671.77, 33.38},
	{-1465.08, -639.60, 33.38},
	{-1469.66, -642.91, 33.38},
	{-1473.55, -645.79, 33.38},
	{-1478.26, -649.15, 33.38},
	{-1482.22, -652.06, 33.38},
	{1142.40, 2654.65, 38.15},
	{1142.38, 2651.04, 38.14},
	{1142.34, 2643.60, 38.14},
	{1141.15, 2641.64, 38.14},
	{1136.34, 2641.68, 38.14},
	{1132.73, 2641.65, 38.14},
	{1125.22, 2641.66, 38.14},
	{1121.45, 2641.64, 38.14},
	{1114.75, 2641.64, 38.14},
	{1107.21, 2641.68, 38.14},
	{1106.01, 2649.09, 38.14},
	{1106.02, 2652.88, 38.14},
	{341.70, 2614.93, 44.67},
	{347.02, 2618.11, 44.67},
	{354.42, 2619.79, 44.67},
	{359.80, 2622.86, 44.67},
	{367.12, 2624.55, 44.67},
	{372.48, 2627.60, 44.67},
	{379.91, 2629.26, 44.67},
	{385.31, 2632.37, 44.67},
	{392.59, 2634.10, 44.67},
	{397.98, 2637.14, 44.67},
	{-85.95, -281.97, 45.55},
	{-617.00, 37.94, 43.59},
	{-775.05, 313.14, 85.69},
	{151.39, -1007.74, -99.0},
	{266.14, -1007.61, -101.00},
	{346.47, -1013.05, -99.19},
	{-781.77, 322.00, 211.99}

}

local COORDS_THAT_ALLOW_INVISIBILITY = {
	{x = -337.3863,y = -136.9247,z = 38.5737},  -- LSC 1
	{x = 733.69,y = -1088.74, z = 21.733},  -- LSC 2
	{x = -1155.077,y = -2006.61, z = 12.465},  -- LSC 3
	{x = 1174.823,y = 2637.807, z = 37.045},  -- LSC 4
	{x = 108.842,y = 6628.447, z = 31.072},  -- LSC 5
	{x = -212.368,y = -1325.486, z = 30.176},  -- LSC 6
}

BlacklistedWeapons = { -- weapons that will get people banned
	GetHashKey("WEAPON_RAILGUN"),
	 -1813897027, -- grenade
	 741814745, -- sticky bomb
	 -1420407917, -- prox. mine
	 -1169823560, -- pipe bomb
	 -1568386805, -- grenade launcher
	 -1312131151, -- RPG
	 1119849093, -- minigun
	 1834241177, -- railgun
	 1672152130, -- homing launcher
	 1305664598, -- smoke grenade launcher
	 125959754, -- compact launcher
	 205991906, -- heavy sniper
	 -952879014, -- marksman sniper rifle
	 -1660422300, -- heavy machine gun
	 GetHashKey("WEAPON_BALL"),
}

--[[ CURR. DISABLED BELOW
CageObjs = {
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
}
--]]

--[[ DISABLED FOR NOW UNTIL SPEEDHACK BECOMES A MORE NOTICABLE PROBLEM
Citizen.CreateThread(function()
	while true do
		Wait(30000)
		TriggerServerEvent("anticheese:timer")
	end
end)
--]]

Citizen.CreateThread(function()
	local Seconds = 7
	local MaxRunSpeed = 10
	local MaxVehSpeed = 135
	local MaxFlySpeed = 150
	local MinTriggerDistance = 300

	Citizen.Wait(60000)
	while true do
		local ped = PlayerPedId()
		local posx, posy, posz = table.unpack(GetEntityCoords(ped,true))

		local veh = IsPedInAnyVehicle(ped, true)
		local para = GetPedParachuteState(ped)
		local flyveh = IsPedInFlyingVehicle(ped)
		local rag = IsPedRagdoll(ped)
		local fall = IsPedFalling(ped)
		local parafall = IsPedInParachuteFreeFall(ped)

		Citizen.Wait(Seconds * 1000) -- wait X seconds and check again

		local newx, newy, newz = table.unpack(GetEntityCoords(ped,true))
		local newPed = PlayerPedId() -- used to make sure the peds are still the same, otherwise the player probably respawned
		local speedhack = false
		if ped == newPed and (para == -1 or para == 0) and not fall and not parafall and not rag then
			local dist = GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz, true)

			if not isAtAWarpPoint(newx, newy, newz) then
				if GetEntitySpeed(GetPlayerPed(-1)) == 0 then
					if dist > (MaxRunSpeed * Seconds) and dist > MinTriggerDistance then
						if not exports["usa_hidetrunk"]:IsInTrunk() then
							TriggerServerEvent("AntiCheese:NoclipFlag", dist, posx,posy,posz, newx,newy,newz)
						end
					end
				else
					if flyveh then
						if dist > MaxFlySpeed * Seconds then
							state = "in an aircraft"
							speedhack = true
						end
					elseif veh then
						if dist > MaxVehSpeed * Seconds then
							state = "in a vehicle"
							speedhack = true
						end
					elseif dist > MaxRunSpeed * Seconds then
						state = "on foot"
						speedhack = true
					end

					if speedhack and dist > MinTriggerDistance then
						if not exports["usa_hidetrunk"]:IsInTrunk() then
							TriggerServerEvent("AntiCheese:SpeedFlag", state, dist, posx,posy,posz, newx,newy,newz)
						end
					end
				end
			end
		end
	end
end)

function isAtAWarpPoint(x, y, z)
	for i = 1, #COORDS_TO_ALLOW_TELEPORTATION_FROM do
		local warp_to_check_against = COORDS_TO_ALLOW_TELEPORTATION_FROM[i]
		if Vdist(x, y, z, warp_to_check_against.x, warp_to_check_against.y, warp_to_check_against.z) < 15.0 then
			return true
		end
	end
	for i = 1, #PROPERTY_COORDS do
		local warp = PROPERTY_COORDS[i]
		local _x, _y, _z = table.unpack(warp)
		if Vdist(x, y, z, _x, _y, _z) < 15.0 then
			return true
		end
	end
	return false
end

function isAtAnLSC()
	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(),true))
	for i = 1, #COORDS_THAT_ALLOW_INVISIBILITY do
		local warp_to_check_against = COORDS_THAT_ALLOW_INVISIBILITY[i]
		if Vdist(x, y, z, warp_to_check_against.x, warp_to_check_against.y, warp_to_check_against.z) < 20.0 then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(40000)
		local curPed = PlayerPedId()
		local curHealth = GetEntityHealth( curPed )
		TriggerEvent('injuries:triggerGrace', function()
			local curWait = math.random(10,150)
			SetEntityHealth(curPed, curHealth - 2)
			-- this will substract 2hp from the current player, wait between 10 & 150ms and then add it back, this is to check for hacks that force HP at 200
			Citizen.Wait(curWait)

			if not IsPlayerDead(PlayerId()) then
				if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
					TriggerServerEvent("AntiCheese:HealthFlag", false, curHealth - 2, GetEntityHealth(curPed), curWait)
				elseif GetEntityHealth(curPed) == curHealth - 2 then
					SetEntityHealth(curPed, GetEntityHealth(curPed) + 2)
				end
			end
			if GetEntityHealth(curPed) > 400 then
				TriggerServerEvent("AntiCheese:HealthFlag", false, GetEntityHealth(curPed) - 200, GetEntityHealth(curPed), curWait)
			end

			if GetPlayerInvincible(PlayerId()) and not isAtAnLSC() then  -- if the player is invincible, flag him as a cheater and then disable their invincibility
				TriggerServerEvent("AntiCheese:HealthFlag", true, curHealth - 2, GetEntityHealth(curPed), curWait)
				SetPlayerInvincible(PlayerId(), false)
			end
		end)
	end
end)

-- prevent infinite ammo, godmode, and ped speed hacks
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		local fallin = IsPedFalling(PlayerPedId())
		local ragg = IsPedRagdoll(PlayerPedId())
		local parac = GetPedParachuteState(PlayerPedId())
		if parac >= 0 or ragg or fallin then
			SetEntityMaxSpeed(PlayerPedId(), 80.0)
		else
			SetEntityMaxSpeed(PlayerPedId(), 7.1)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if not IsEntityVisible(PlayerPedId()) then
			if not isAtAnLSC() then
				TriggerServerEvent("AntiCheese:InvisibilityFlag")
				SetEntityVisible(PlayerPedId(), true, 0)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8000)
		for _, theWeapon in ipairs(BlacklistedWeapons) do
			Wait(1)
			if HasPedGotWeapon(PlayerPedId(), theWeapon, false) == 1 then
				TriggerServerEvent("AntiCheese:WeaponFlag", theWeapon)
				RemoveAllPedWeapons(PlayerPedId(), false)
			end
		end
	end
end)

--[[ DISABLED FOR NOW BECAUSE IT MIGHT NOT BE VERY HELPFUL TO US
function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local handle, object = FindFirstObject()
		local finished = false
		repeat
			Wait(1)
			if IsEntityAttached(object) and DoesEntityExist(object) then
				if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
					ReqAndDelete(object, true)
				end
			end
			for i=1,#CageObjs do
				if GetEntityModel(object) == GetHashKey(CageObjs[i]) then
					ReqAndDelete(object, false)
				end
			end
			finished, object = FindNextObject(handle)
		until not finished
		EndFindObject(handle)
	end
end)
--]]

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if IsPedJumping(PlayerPedId()) then
			local jumplength = 0
			repeat
				Wait(0)
				jumplength=jumplength+1
				local isStillJumping = IsPedJumping(PlayerPedId())
			until not isStillJumping
			if jumplength > 250 then
				TriggerServerEvent("AntiCheese:JumpFlag", jumplength )
			end
		end
	end
end)

--[[
Citizen.CreateThread(function()
	while true do
		TriggerServerEvent("AntiCheese:LifeCheck")
		Citizen.Wait(30000)
	end
end)
--]]

RegisterNetEvent("makepedskillable")
AddEventHandler("makepedskillable", function()
    Citizen.CreateThread(function()
        for ped in exports.globals:EnumeratePeds() do
            SetEntityCanBeDamaged(ped, true)
            Wait(5)
        end
        print("Made all peds killable!")
    end)
end)

RegisterNetEvent("deletenearestobjects")
AddEventHandler("deletenearestobjects", function()
    Citizen.CreateThread(function()
        for object in exports.globals:EnumerateObjects() do
    		local objcoords = GetEntityCoords(object)
			local mycoords = GetEntityCoords(GetPlayerPed(-1))
			if Vdist(mycoords.x, mycoords.y, mycoords.z, objcoords.x, objcoords.y, objcoords.z) < 20.0 then
				DeleteEntity(object)
			end
            Wait(5)
        end
        print("Made all peds killable!")
    end)
end)

RegisterNetEvent("deletenearestvehicles")
AddEventHandler("deletenearestvehicles", function()
    Citizen.CreateThread(function()
        for veh in exports.globals:EnumerateVehicles() do
    		local vehcoords = GetEntityCoords(veh)
			local mycoords = GetEntityCoords(GetPlayerPed(-1))
			if Vdist(mycoords.x, mycoords.y, mycoords.z, vehcoords.x, vehcoords.y, vehcoords.z) < 20.0 then
				DeleteEntity(veh)
			end
            Wait(5)
        end
        print("** Deleted all vehicles! **")
    end)
end)

Citizen.CreateThread(function()
	Wait(30000)
	while true do
		TriggerServerEvent('usa:ConfirmSession', GetNumberOfPlayers())
		Wait(60000)
	end
end)

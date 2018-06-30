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
	{ x = 1847.086, y = 2585.990, z = 45.672 } -- jail 2
}


BlacklistedWeapons = { -- weapons that will get people banned
	"WEAPON_RAILGUN",
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
	 -1660422300 -- heavy machine gun
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
	Citizen.Wait(60000)
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
		local still = IsPedStill(ped)
		local vel = GetEntitySpeed(ped)
		local veh = IsPedInAnyVehicle(ped, true)
		local speed = GetEntitySpeed(ped)
		local para = GetPedParachuteState(ped)
		local flyveh = IsPedInFlyingVehicle(ped)
		local rag = IsPedRagdoll(ped)
		local fall = IsPedFalling(ped)
		local parafall = IsPedInParachuteFreeFall(ped)
		SetEntityVisible(PlayerPedId(), true) -- make sure player is visible
		Wait(3000) -- wait 10 seconds and check again

		local more = speed - 9.0 -- avarage running speed is 7.06 so just incase someone runs a bit faster it wont trigger

		local rounds = tonumber(string.format("%.2f", speed))
		local roundm = tonumber(string.format("%.2f", more))


		--[[ DISABLED JUST IN CASE PEOPLE GO INVISIBLE ACCIDENTLY SOME HOW? MAYBE CLOTHING STORE?
		if not IsEntityVisible(PlayerPedId()) then
			SetEntityHealth(PlayerPedId(), -100) -- if player is invisible kill him!
		end
		--]]

		newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
		newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
		--if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 200 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
		if  ped == newPed and (para == -1 or para == 0) and not flyveh and not fall and not parafall and not rag then
			if not isAtAWarpPoint(newx, newy, newz) then
				if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 450 and veh then
					--print("** Noclip detected! **")
					TriggerServerEvent("AntiCheese:NoclipFlag", GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
				elseif GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 170 and not veh then
					TriggerServerEvent("AntiCheese:NoclipFlag", GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
				end
			end
		else
		--	print(GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
			--print(tostring(still == IsPedStill(ped)))
			--print(tostring(vel == GetEntitySpeed(ped)))
			--print(tostring(ped == newPed))
		end

		--[[
		if speed > 9.0 and not veh and (para == -1 or para == 0) and not flyveh and not fall and not parafall and not rag then
			--dont activate this, its broken!
			--TriggerServerEvent("AntiCheese:SpeedFlag", rounds, roundm) -- send alert along with the rounded speed and how much faster they are
		end
		--]]
	end
end)

function isAtAWarpPoint(x, y, z)
	--print("checking warp points...")
	for i = 1, #COORDS_TO_ALLOW_TELEPORTATION_FROM do
		local warp_to_check_against = COORDS_TO_ALLOW_TELEPORTATION_FROM[i]
		--print(Vdist(x, y, z, warp_to_check_against.x, warp_to_check_against.y, warp_to_check_against.z))
		if Vdist(x, y, z, warp_to_check_against.x, warp_to_check_against.y, warp_to_check_against.z) < 30.0 then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		local curPed = PlayerPedId()
		local curHealth = GetEntityHealth( curPed )
		SetEntityHealth( curPed, curHealth-2)
		local curWait = math.random(10,150)
		-- this will substract 2hp from the current player, wait 50ms and then add it back, this is to check for hacks that force HP at 200
		Citizen.Wait(curWait)

		--[[
		print(tostring(PlayerPedId() == curPed))
		print(tostring(GetEntityHealth(curPed) == curHealth))
		print("1: " .. curHealth)
		print("2: " .. GetEntityHealth(curPed))
		print(tostring(GetEntityHealth(curPed) ~= 0))
		print("invincible: " .. tostring(GetPlayerInvincible(PlayerId())))
		--]]

		if not IsPlayerDead(PlayerId()) then
			if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
				TriggerServerEvent("AntiCheese:HealthFlag", false, curHealth-2, GetEntityHealth( curPed ),curWait )
			elseif GetEntityHealth(curPed) == curHealth-2 then
				SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
			end
		end
		if GetEntityHealth(curPed) > 400 then
			TriggerServerEvent("AntiCheese:HealthFlag", false, GetEntityHealth( curPed )-200, GetEntityHealth( curPed ),curWait )
		end

		if GetPlayerInvincible( PlayerId() ) then -- if the player is invincible, flag him as a cheater and then disable their invincibility
			TriggerServerEvent("AntiCheese:HealthFlag", true, curHealth-2, GetEntityHealth( curPed ),curWait )
			SetPlayerInvincible( PlayerId(), false )
		end
	end
end)

-- prevent infinite ammo, godmode, invisibility and ped speed hacks
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		--SetEntityInvincible(PlayerPedId(), false)
		--SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
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
		Citizen.Wait(3000)
		for _,theWeapon in ipairs(BlacklistedWeapons) do
			Wait(1)
			if not tonumber(theWeapon) then
				theWeapon = GetHashKey(theWeapon)
			end
			if HasPedGotWeapon(PlayerPedId(), theWeapon, false) == 1 then
					RemoveAllPedWeapons(PlayerPedId(),false)
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

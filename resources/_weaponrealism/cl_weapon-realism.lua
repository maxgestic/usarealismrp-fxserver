-- Script by Lyrad for LEFR

local scopedWeapons = 
{
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    3342088282, -- WEAPON_MARKSMANRIFLE
	177293209,   -- WEAPON_HEAVYSNIPER MKII
	1785463520  -- WEAPON_MARKSMANRIFLE_MK2
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do 
        if ( hash == v ) then 
            return true 
        end 
    end 

    return false 
end 

function ManageReticle()
    local ped = GetPlayerPed( -1 )
    local _, hash = GetCurrentPedWeapon( ped, true )
        if not HashInTable( hash ) then 
            HideHudComponentThisFrame( 14 )
		end 
end 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed( -1 )
		local weapon = GetSelectedPedWeapon(ped)
		--print(weapon) -- To get the weapon hash by pressing F8 in game
		
		-- Disable reticle
		
		ManageReticle()
		
		-- Disable melee while aiming (may be not working)
		
		if IsPedArmed(ped, 6) then
        	DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
		
		-- Disable ammo HUD
		
		DisplayAmmoThisFrame(false)
		
		-- Shakycam
		
		-- Pistol
		if weapon == GetHashKey("WEAPON_STUNGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
			end
		end
		
		if weapon == GetHashKey("WEAPON_FLAREGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.01)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SNSPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SNSPISTOL_MK2") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end
		
		if weapon == GetHashKey("WEAPON_PISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end
		
		if weapon == GetHashKey("WEAPON_PISTOL_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end
		
		if weapon == GetHashKey("WEAPON_APPISTOL") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMBATPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end
		
		if weapon == GetHashKey("WEAPON_PISTOL50") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		if weapon == GetHashKey("WEAPON_HEAVYPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end
		
		if weapon == GetHashKey("WEAPON_VINTAGEPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MARKSMANPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.03)
			end
		end
		
		if weapon == GetHashKey("WEAPON_REVOLVER") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end
		
		if weapon == GetHashKey("WEAPON_REVOLVER_MK2") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.055)
			end
		end
		
		if weapon == GetHashKey("WEAPON_DOUBLEACTION") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.025)
			end
		end
		-- SMG
		
		if weapon == GetHashKey("WEAPON_MICROSMG") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMBATPDW") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.045)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SMG_MK2") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.055)
			end
		end
		
		if weapon == GetHashKey("WEAPON_ASSAULTSMG") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.050)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MACHINEPISTOL") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MINISMG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.035)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMBATMG") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMBATMG_MK2") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.085)
			end
		end
		
		-- Rifles
		
		if weapon == GetHashKey("WEAPON_ASSAULTRIFLE") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end
		
		if weapon == GetHashKey("WEAPON_ASSAULTRIFLE_MK2") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.075)
			end
		end
		
		if weapon == GetHashKey("WEAPON_CARBINERIFLE") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end
		
		if weapon == GetHashKey("WEAPON_CARBINERIFLE_MK2") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.065)
			end
		end
		
		if weapon == GetHashKey("WEAPON_ADVANCEDRIFLE") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end
		
		if weapon == GetHashKey("WEAPON_GUSENBERG") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SPECIALCARBINE") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SPECIALCARBINE_MK2") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.075)
			end
		end
		
		if weapon == GetHashKey("WEAPON_BULLPUPRIFLE") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		if weapon == GetHashKey("WEAPON_BULLPUPRIFLE_MK2") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.065)
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMPACTRIFLE") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		-- Shotgun
		
		if weapon == GetHashKey("WEAPON_PUMPSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			end
		end
		
		if weapon == GetHashKey("WEAPON_PUMPSHOTGUN_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.085)
			end
		end
		
		if weapon == GetHashKey("WEAPON_SAWNOFFSHOTGUN") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.06)
			end
		end
		
		if weapon == GetHashKey("WEAPON_ASSAULTSHOTGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.12)
			end
		end
		
		if weapon == GetHashKey("WEAPON_BULLPUPSHOTGUN") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end
		
		if weapon == GetHashKey("WEAPON_DBSHOTGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end
		
		if weapon == GetHashKey("WEAPON_AUTOSHOTGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MUSKET") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.04)
			end
		end
		
		if weapon == GetHashKey("WEAPON_HEAVYSHOTGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.13)
			end
		end
		
		-- Sniper
		
		if weapon == GetHashKey("WEAPON_SNIPERRIFLE") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
			end
		end
		
		if weapon == GetHashKey("WEAPON_HEAVYSNIPER") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
			end
		end
		
		if weapon == GetHashKey("WEAPON_HEAVYSNIPER_MK2") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.35)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MARKSMANRIFLE") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MARKSMANRIFLE_MK2") then			
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			end
		end
		
		-- Launcher
		
		if weapon == GetHashKey("WEAPON_GRENADELAUNCHER") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end
		
		if weapon == GetHashKey("WEAPON_RPG") then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.9)
			end
		end
		
		if weapon == GetHashKey("WEAPON_HOMINGLAUNCHER") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.9)
			end
		end
		
		if weapon == GetHashKey("WEAPON_MINIGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.20)
			end
		end
		
		if weapon == GetHashKey("WEAPON_RAILGUN") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.0)
				
			end
		end
		
		if weapon == GetHashKey("WEAPON_COMPACTLAUNCHER") then		
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
			end
		end
		
		if weapon == GetHashKey("WEAPON_FIREWORK") then	
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.5)
			end
		end
		
		-- Infinite FireExtinguisher
		
		if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then		
			if IsPedShooting(ped) then
				SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
			end
		end
	end
end)

-- custom (more noticable) weapon recoil --
local RECOILS = {
	[GetHashKey("WEAPON_PISTOL")] = 1.5, -- PISTOL
	[GetHashKey("WEAPON_PISTOL_MK2")] = 1.5, -- PISTOL MK2
	[GetHashKey("WEAPON_COMBATPISTOL")] = 1.5, -- COMBAT PISTOL
	[GetHashKey("WEAPON_APPISTOL")] = 1.5, -- AP PISTOL
	[GetHashKey("WEAPON_PISTOL50")] = 2.2, -- PISTOL .50
	[GetHashKey("WEAPON_MICROSMG")] = 1.7, -- MICRO SMG
	[GetHashKey("WEAPON_SMG")] = 1.5, -- SMG
	[GetHashKey("WEAPON_SMG_MK2")] = 1.5, -- SMG MK2
	[GetHashKey("WEAPON_ASSAULTSMG")] = 1.5, -- ASSAULT SMG
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = 1.7, -- ASSAULT RIFLE
	[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = 1.7, -- ASSAULT RIFLE MK2
	[GetHashKey("WEAPON_CARBINERIFLE")] = 1.7, -- CARBINE RIFLE
	[GetHashKey("WEAPON_CARBINERIFLE_MK2")] = 1.7, -- CARBINE RIFLE MK2
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = 1.7, -- ADVANCED RIFLE
	[GetHashKey("WEAPON_MG")] = 2.0, -- MG
	[GetHashKey("WEAPON_COMBATMG")] = 2.0, -- COMBAT MG
	[GetHashKey("WEAPON_COMBATMG_MK2")] = 2.0, -- COMBAT MG MK2
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = 2.5, -- PUMP SHOTGUN
	[GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = 2.5, -- PUMP SHOTGUN MK2
	[GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = 2.8, -- SAWNOFF SHOTGUN
	[GetHashKey("WEAPON_ASSAULTSHOTGUN")] = 2.5, -- ASSAULT SHOTGUN
	[GetHashKey("WEAPON_BULLPUPSHOTGUN")] = 2.5, -- BULLPUP SHOTGUN
	[GetHashKey("WEAPON_STUNGUN")] = 0.0, -- STUN GUN
	[GetHashKey("WEAPON_SNIPERRIFLE")] = 2.5, -- SNIPER RIFLE
	[GetHashKey("WEAPON_HEAVYSNIPER")] = 3.5, -- HEAVY SNIPER
	[GetHashKey("WEAPON_HEAVYSNIPER_MK2")] = 3.5, -- HEAVY SNIPER MK2
	[GetHashKey("WEAPON_REMOTESNIPER")] = 2.0, -- REMOTE SNIPER
	[GetHashKey("WEAPON_GRENADELAUNCHER")] = 5.0, -- GRENADE LAUNCHER
	[GetHashKey("WEAPON_GRENADERLAUNCHER_SMOKE")] = 5.0, -- GRENADE LAUNCHER SMOKE
	[GetHashKey("WEAPON_RPG")] = 10.0, -- RPG
	[GetHashKey("WEAPON_STINGER")] = 15.0, -- STINGER
	[GetHashKey("WEAPON_MINIGUN")] = 1.0, -- MINIGUN
	[GetHashKey("WEAPON_SNSPISTOL")] = 1.3, -- SNS PISTOL
	[GetHashKey("WEAPON_SNSPISTOL_MK2")] = 1.3, -- SNS PISTOL MK2
	[GetHashKey("WEAPON_GUSENBERG")] = 1.55, -- GUSENBERG
	[GetHashKey("WEAPON_SPECIALCARBINE")] = 1.7, -- SPECIAL CARBINE
	[GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = 1.7, -- SPECIAL CARBINE MK2
	[GetHashKey("WEAPON_HEAVYPISTOL")] = 1.8, -- HEAVY PISTOL
	[GetHashKey("WEAPON_BULLPUPRIFLE")] = 2.0, -- BULLPUP RIFLE
	[GetHashKey("WEAPON_BULLPUPRIFLE_MK2")] = 2.0, -- BULLPUP RIFLE MK2
	[GetHashKey("WEAPON_VINTAGEPISTOL")] = 2.8, -- VINTAGE PISTOL
	[GetHashKey("WEAPON_DOUBLEACTION")] = 2.2, -- DOUBLE ACTION REVOLVER
	[GetHashKey("WEAPON_MUSKET")] = 2.1, -- MUSKET
	[GetHashKey("WEAPON_HEAVYSHOTGUN")] = 1.9, -- HEAVY SHOTGUN
	[GetHashKey("WEAPON_MARKSMANRIFLE")] = 2.0, -- MARKSMAN RIFLE
	[GetHashKey("WEAPON_MARKSMANRIFLE_MK2")] = 2.0, -- MARKSMAN RIFLE MK2
	[GetHashKey("WEAPON_HOMINGLAUNCHER")] = 0, -- HOMING LAUNCHER
	[GetHashKey("WEAPON_FLAREGUN")] = 0.9, -- FLARE GUN
	[GetHashKey("WEAPON_COMBATPDW")] = 0.2, -- COMBAT PDW
	[GetHashKey("WEAPON_MARKSMANPISTOL")] = 2.0, -- MARKSMAN PISTOL
	[GetHashKey("WEAPON_RAILGUN")] = 2.4, -- RAILGUN
	[GetHashKey("WEAPON_MACHINEPISTOL")] = 1.6, -- MACHINE PISTOL
	[GetHashKey("WEAPON_REVOLVER")] = 2.1, -- REVOLVER
	[GetHashKey("WEAPON_REVOLVER_MK2")] = 2.1, -- REVOLVER MK2
	[GetHashKey("WEAPON_DBSHOTGUN")] = 2.5, -- DOUBLE BARREL SHOTGUN
	[GetHashKey("WEAPON_COMPACTRIFLE")] = 1.9, -- COMPACT RIFLE
	[GetHashKey("WEAPON_AUTOSHOTGUN")] = 1.8, -- AUTO SHOTGUN
	[GetHashKey("WEAPON_COMPACTLAUNCHER")] = 0.5, -- COMPACT LAUNCHER
	[GetHashKey("WEAPON_MINISMG")] = 1.7, -- MINI SMG		
}

local CAR_INNACURACY_PITCH = 3.0

Citizen.CreateThread(function()
	while true do
		local me = PlayerPedId()
		if IsPedShooting(me) then
			local _,wepHash = GetCurrentPedWeapon(me)
			if RECOILS[wepHash] then
				local p = GetGameplayCamRelativePitch()
				if not IsPedInAnyVehicle(me, false) then
					SetGameplayCamRelativePitch(p + RECOILS[wepHash], 1.0)
				else
					SetGameplayCamRelativePitch(p + RECOILS[wepHash] + CAR_INNACURACY_PITCH, 1.0)
				end
			else
				print("no recoil value for wep hash: " .. wepHash)
			end
		end
		Wait(1)
	end
end)
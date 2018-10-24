-- Created by Deziel0495 and IllusiveTea, and modified by minipunch --

-- NOTICE
-- This script is licensed under "No License". https://choosealicense.com/no-license/
-- You are allowed to: Download, Use and Edit the Script.
-- You are not allowed to: Copy, re-release, re-distribute it without our written permission.

local IS_COP = false

RegisterNetEvent("ptt:isEmergency")
AddEventHandler("ptt:isEmergency", function(status)
	IS_COP = status
end)

--- DO NOT EDIT THIS
local holstered = true

-- RESTRICTED PEDS --
-- I've only listed peds that have a remote speaker mic, but any ped listed here will do the animations.
local skins = {
	"s_m_y_cop_01",
	"s_f_y_cop_01",
	"S_M_Y_HwayCop_01",
	"S_M_Y_SWAT_01",
	"S_M_Y_Sheriff_01",
	"S_F_Y_Sheriff_01",
	"ig_trafficwarden",
	"mp_m_fibsec_01",
	"ig_stevehains",
	"ig_andreas",
	"s_m_m_fiboffice_01"
	,"s_m_m_ciasec_01",
	"ig_karen_daniels",
	"S_M_M_PrisGuard_01",
	"S_M_Y_Ranger_01",
	"S_F_Y_Ranger_01",
	"s_m_y_blackops_01",
	"s_m_m_pilot_02"
}

-- Add/remove weapon hashes here to be added for holster checks.
local weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_HAMMER",
	"WEAPON_WRENCH",
	"WEAPON_HATCHET",
	-1075685676,
	-619010992
}

local control = nil

RegisterNetEvent("ptt:radio")
AddEventHandler("ptt:radio", function(key)
	print("radio key set!")
	control = key
end)

-- RADIO ANIMATIONS --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if control ~= nil and GetPedParachuteState(ped) == -1 then
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
				if not IsPauseMenuActive() then
					loadAnimDict( "random@arrests" )
					if IsControlJustReleased( 0, control ) then
						--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
					else
						if IsControlJustPressed( 0, control ) and not IsPlayerFreeAiming(PlayerId()) then
							--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						elseif IsControlJustPressed( 0, control ) and IsPlayerFreeAiming(PlayerId()) then
							--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						end
						if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
							DisableActions(ped)
						elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
							DisableActions(ped)
						end
					end
				end
			end
		end
	end
end )

-- HOLD WEAPON HOLSTER ANIMATION --

Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if GetPedParachuteState(ped) == -1 then
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
				DisableControlAction( 0, 20, true ) -- INPUT_MULTIPLAYER_INFO (Z)
				if not IsPauseMenuActive() then
					loadAnimDict( "reaction@intimidation@cop@unarmed" )
					if IsDisabledControlJustReleased( 0, 20 ) then -- INPUT_MULTIPLAYER_INFO (Z)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
						SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
					else
						if IsDisabledControlJustPressed( 0, 20 ) then -- INPUT_MULTIPLAYER_INFO (Z)
							SetEnableHandcuffs(ped, true)
							SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
							TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						end
						if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "reaction@intimidation@cop@unarmed", "intro", 3) then
							DisableActions(ped)
						end
					end
				end
			end
		end
	end
end )

local UNHOLSTERED_WEAPON = nil
-- HOLSTER/UNHOLSTER PISTOL --
 Citizen.CreateThread(function()
	while true do
		Wait(0)
		local ped = PlayerPedId()
		if GetPedParachuteState(ped) == -1 then
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
				loadAnimDict( "reaction@intimidation@1h" )
				--loadAnimDict( "weapons@pistol@" )
				loadAnimDict(  "rcmjosh4" )
				if CheckWeapon(ped) then
					if holstered then
						if not IS_COP and GetPedDrawableVariation(ped, 8) ~= 122 and GetPedDrawableVariation(ped, 8) ~= 130 then
							local togive = GetSelectedPedWeapon(ped) -- to prevent gun from coming out too early for animation, remove the gun when it starts and only give at right time
							SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Wait(1400)
							SetCurrentPedWeapon(ped, togive, true)
							Wait(1500)
							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, togive, true)
							UNHOLSTERED_WEAPON = togive
						else
							TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Citizen.Wait(600)
							ClearPedTasks(ped)
						end
						holstered = false
					end
				elseif not CheckWeapon(ped) then
					if not holstered then
						if not IS_COP and GetPedDrawableVariation(ped, 8) ~= 122 and GetPedDrawableVariation(ped, 8) ~= 130 then
							SetCurrentPedWeapon(ped, UNHOLSTERED_WEAPON, true)
							TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Citizen.Wait(1350)
							ClearPedTasks(ped)
							SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
						else
							TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Citizen.Wait(500)
							ClearPedTasks(ped)
						end
						holstered = true
					end
				end
			end
		end
	end
end)

-- DO NOT REMOVE THESE! --
function CheckWeapon(ped)
	for i = 1, #weapons do
		--print("Checking against: " .. weapons[i])
		if type(weapons[i]) ~= "number" then
			if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
				return true
			end
		else
			if weapons[i] == GetSelectedPedWeapon(ped) then
				return true
			end
		end
	end
	return false
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

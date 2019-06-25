local onDuty = false
local unholsteredWeapon = nil
local smallHolstered = true
local largeHolstered = true
local playingAnim = false
local togive
local control = nil

TriggerServerEvent('ptt:getHotkey')

RegisterNetEvent("interaction:setPlayersJob")
AddEventHandler("interaction:setPlayersJob", function(job)
	if job == 'sheriff' or job == 'police' or job == 'corrections' then
		onDuty = true
	else
		onDuty = false
	end
end)

RegisterNetEvent("ptt:returnHotkey")
AddEventHandler("ptt:returnHotkey", function(key)
	control = key
end)

local smallWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_HEAVYREVOLVER",
	"WEAPON_KNIFE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_KNUCKLE",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_WRENCH",
	"WEAPON_POOLCUE",
	"WEAPON_BATTLEAXE",
	"WEAPON_SWITCHBLADE"
}

local largeWeapons = {
	'WEAPON_CARBINERIFLE',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_SMG',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_REMOTESNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_BAT',
	'WEAPON_MUSKET'
}

-- HOLD WEAPON HOLSTER ANIMATION --

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if GetPedParachuteState(playerPed) == -1 then
			if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not IsPedInAnyVehicle(playerPed, true)
				and onDuty or GetPedDrawableVariation(playerPed, 7) == 8 or GetPedDrawableVariation(playerPed, 7) == 6 then
				DisableControlAction( 0, 20, true ) -- INPUT_MULTIPLAYER_INFO (Z)
				if not IsPauseMenuActive() then
					loadAnimDict( "reaction@intimidation@cop@unarmed" )
					if IsDisabledControlJustReleased(0, 20) then -- INPUT_MULTIPLAYER_INFO (Z)
						ClearPedTasks(playerPed)
						SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
					else
						if IsDisabledControlJustPressed(0, 20) then -- INPUT_MULTIPLAYER_INFO (Z)
							SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
							TaskPlayAnim(playerPed, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						end
						if IsEntityPlayingAnim(playerPed, "reaction@intimidation@cop@unarmed", "intro", 3) then
							DisableActions(playerPed)
						end
					end
				end
			end
		end
	end
end )

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local ped = GetPlayerPed(-1)
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
			loadAnimDict( "reaction@intimidation@1h" )
			loadAnimDict( "rcmjosh4" )
			loadAnimDict( "timetable@jimmy@ig_2@ig_2_p2" )
			if CheckSmallWeapon(ped) then
				if smallHolstered and not IsPedInMeleeCombat(ped) and not IsPlayerTargettingAnything(ped) and not IsPedInCombat(ped) then
					if not onDuty and GetPedDrawableVariation(ped, 7) ~= 8 and GetPedDrawableVariation(ped, 7) ~= 6 and GetPedDrawableVariation(ped, 7) ~= 1 then
						local togive = GetSelectedPedWeapon(ped) -- to prevent gun from coming out too early for animation, remove the gun when it starts and only give at right time
						SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
						playingAnim = true
						TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
						Wait(1400)
		                SetCurrentPedWeapon(ped, togive, true)
		                Wait(1500)
						ClearPedTasks(ped)
			            SetCurrentPedWeapon(ped, togive, true)
			            playingAnim = false
			            UNHOLSTERED_WEAPON = togive
					else
		                playingAnim = true
		                TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		                Citizen.Wait(600)
		                ClearPedTasks(ped)
		                playingAnim = false
		            end
		            smallHolstered = false
		        end
			elseif not CheckSmallWeapon(ped) and not smallHolstered and not playingAnim then
				if not onDuty and GetPedDrawableVariation(ped, 7) ~= 8 and GetPedDrawableVariation(ped, 7) ~= 6 and GetPedDrawableVariation(ped, 7) ~= 1 then
					playingAnim = true
					SetCurrentPedWeapon(ped, UNHOLSTERED_WEAPON, true)
					TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(1350)
            		ClearPedTasks(ped)
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            		playingAnim = false
				else
					playingAnim = true
	                TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
	                Citizen.Wait(500)
	                ClearPedTasks(ped)
	                playingAnim = false
	            end
	            smallHolstered = true


			elseif CheckLargeWeapon(ped) then
				if largeHolstered and not IsPedInMeleeCombat(ped) and not IsPlayerTargettingAnything(ped) and not IsPedInCombat(ped) then
					local togive = GetSelectedPedWeapon(ped) -- to prevent gun from coming out too early for animation, remove the gun when it starts and only give at right time
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
					playingAnim = true
					TaskPlayAnim(ped, "timetable@jimmy@ig_2@ig_2_p2", "ig_2_exit", 8.0, 1.0, -1, 48, 0.0, 0, 0, 0 )
					Wait(1400)
	                SetCurrentPedWeapon(ped, togive, true)
					ClearPedTasks(ped)
		            playingAnim = false
		            UNHOLSTERED_WEAPON = togive
		            largeHolstered = false
		        end
		    elseif not CheckLargeWeapon(ped) and not largeHolstered and not playingAnim then
		    	playingAnim = true
				SetCurrentPedWeapon(ped, UNHOLSTERED_WEAPON, true)
				TaskPlayAnim(ped, "timetable@jimmy@ig_2@ig_2_p2", "ig_2_exit", 8.0, 1.0, -1, 48, 0.0, 0, 0, 0 )
				Citizen.Wait(1350)
        		ClearPedTasks(ped)
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        		playingAnim = false
        		largeHolstered = true
        	end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if playingAnim then
			DisablePlayerFiring(ped, true)
			DisableControlAction(0, 21, false)
			DisableControlAction(1, 323, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 22, true)
		end
		if (not largeHolstered or not smallHolstered) or playingAnim then
			DisableControlAction(24, 37, true)
			if IsDisabledControlJustPressed(24, 37) and not playingAnim and not IsPedShooting(ped) and not IsAimCamActive(ped) then
				RemoveWeaponFromPed(ped, -1569615261)
				GiveWeaponToPed(ped, -1569615261, 0, false, true)
			end
		end
	end
end)

-- RADIO ANIMATIONS --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if control ~= nil and GetPedParachuteState(ped) == -1 and onDuty then
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
				if not IsPauseMenuActive() then
					loadAnimDict( "random@arrests" )
					if IsControlJustReleased( 0, control ) then
						--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
						ClearPedTasks(ped)
					else
						if IsControlJustPressed( 0, control ) and not IsPlayerFreeAiming(PlayerId()) then
							--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						elseif IsControlJustPressed( 0, control ) and IsPlayerFreeAiming(PlayerId()) then
							--TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
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

function CheckSmallWeapon(ped)
	for i = 1, #smallWeapons do
		if GetHashKey(smallWeapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function CheckLargeWeapon(ped)
	for i = 1, #largeWeapons do
		if GetHashKey(largeWeapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

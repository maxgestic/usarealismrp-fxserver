RegisterNetEvent('RPD:allowRespawn')
RegisterNetEvent('RPD:allowRevive')

local allowRespawn = true
local allowRevive = true
local RPDeathEnabled = true
local dead = false
local jailed = false

--TriggerServerEvent('RPD:addPlayer')

RegisterNetEvent("RPD:toggleJailed")
AddEventHandler("RPD:toggleJailed", function (toggle)
	jailed = toggle
end)

RegisterNetEvent("RPD:toggle")
AddEventHandler("RPD:toggle", function (toggle)
	RPDeathEnabled = toggle
end)

RegisterNetEvent("RPD:revivePerson")
AddEventHandler("RPD:revivePerson", function()
	allowRevive = true
	TriggerEvent("crim:blindfold", false, true)
end)

local timer = 180000
AddEventHandler('RPD:startTimer', function()
	if not jailed then
		while timer > 0 do
			raw_seconds = timer/1000
			raw_minutes = raw_seconds/60
			minutes = stringSplit(raw_minutes, ".")[1]
			seconds = stringSplit(raw_seconds-(minutes*60), ".")[1]

			SetTextFont(7)
			SetTextProportional(0)
			SetTextScale(0.0, 0.4)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Waiting ~g~" .. minutes .. " minutes " .. seconds .. " seconds ~w~to respawn.")
			SetTextCentre(true)
			DrawText(0.5, 0.1)
			timer = timer - 15
			Citizen.Wait(0)
		end
		local pressed = false
		while dead do
			Citizen.Wait(0)
			SetTextFont(0)
			SetTextProportional(0)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("Press [ ~g~Enter~w~ ] to respawn")
			SetTextCentre(true)
			DrawText(0.5, 0.45)

			if IsControlPressed(0, 176) then
				if not pressed then
					pressed = true
					TriggerEvent('chatMessage', "Death", {200,0,0}, "Respawned")
					allowRespawn = true
					TriggerEvent("crim:blindfold", false, true)
					while pressed do
						Wait(0)
						if(IsControlPressed(0, 176) == false) then
							pressed = false
							break
						end
					end
				end
			end
		end
	else
		TriggerEvent('chatMessage', "", {0,0,0}, "^0You've passed out. Wait until you are released or a correctional officer helps you.")
	end
end)

AddEventHandler('RPD:allowRespawn', function(from)
	if timer <= 0 then
		TriggerEvent('chatMessage', "Death", {200,0,0}, "Respawned")
		allowRespawn = true
	else
		TriggerEvent('chatMessage', "Death", {200,0,0}, "You can't respawn yet")
	end
end)

AddEventHandler('RPD:allowRevive', function(from, group, size)
	if GetPlayerPed(GetPlayerFromServerId(from)) ~= GetPlayerPed(-1) then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(from))), GetEntityCoords(GetPlayerPed(-1)), true) <= size then
			allowRevive = true
		end
	elseif group == "admin" or group == "superadmin" or group == "owner" or group == "mod" then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(from))), GetEntityCoords(GetPlayerPed(-1)), true) <= size then
			allowRevive = true
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Trace("INSIDE OF RPDEATH CREATED THREAD")
	local respawnCount = 0
	local spawnPoints = {}
	local playerIndex = NetworkGetPlayerIndex(-1)

	math.randomseed(playerIndex)

	function createSpawnPoint(x1,x2,y1,y2,z,heading)
		--local xValue = math.random(x1,x2) + 0.0001
		--local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = -240.10,
			y = 6324.22,
			z = 32.43+ 0.0001,
			heading = 0 + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	--createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah
	--createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
	createSpawnPoint(-240, -245, 6324, 6319, 32.43, 0) -- Central Los Santos x = -240.10, y = 6324.22, z = 32.43
	--createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
	--createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto
	--createSpawnPoint(360.31, -590.445, 28.6563) -- LS hospital

	-- TODO:
	-- 1) if inmate dies in prison, leave them dead until a CO helps them or prison sentence ends
	-- 2) if an inmate is dead and they get released from prison, make sure to revive them if dead (should also fix old glitch when timer would get stuck on screen)
		-- NOTE: possibly easiest to just disable RPDeath when in prison? enable when they get released?

	function respawnPed(ped,coords)
		SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
		--SetPlayerInvincible(ped, false)
		TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
		ClearPedBloodDamage(ped)
		RemoveAllPedWeapons(GetPlayerPed(-1), true) -- strip weapons
		-- remove player weapons from db
		TriggerServerEvent("RPD:removeWeapons")
	end

	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		if (RPDeathEnabled) then
			if (IsEntityDead(ped)) then

				--SetPlayerInvincible(ped, true)
				SetEntityHealth(ped, 1)
				if not dead then

					-- send death log
					local deathLog = {
						deadPlayerId = GetPlayerServerId(PlayerId()),
						deadPlayerName = GetPlayerName(PlayerId()),
						cause = GetPedCauseOfDeath(ped),
						killer = GetPedKiller(ped),
						--killer_source = GetPedSourceOfDeath(ped),
						tod = GetPedTimeOfDeath(ped),
						lastDeath = GetTimeSinceLastDeath(),
						killerName = "",
						killerId = 0
					}

					for id = 0, 64 do
						if NetworkIsPlayerActive(id) then
							if GetPlayerPed(id) == deathLog.killer then -- save killer details
								deathLog.killerId = GetPlayerServerId(id)
								deathLog.killerName = GetPlayerName(id)
							end
						end
					end

					if deathLog.killerId == 0 then
						--print("killer ID was 0!")
						--print("killer: " .. deathLog.killer)
						--print("cause: " .. deathLog.cause)
						if deathLog.killer and deathLog.cause then
							local killer_entity_type = GetEntityType(deathLog.killer)
							local cause_entity_type = GetEntityType(deathLog.cause)
							local ped_in_veh_seat = GetPedInVehicleSeat(deathLog.killer, -1)
							for id = 0, 64 do
								if NetworkIsPlayerActive(id) then
									if GetPlayerPed(id) == ped_in_veh_seat then -- save vdm'r details
										deathLog.killerId = GetPlayerServerId(id)
										deathLog.killerName = GetPlayerName(id)
									end
								end
							end
						else
							--print("deathLog.killer or deathLog.cause or both were nil")
						end
						--print("ped in veh seat: " .. ped_in_veh_seat)
						--print("killer entity type = " .. killer_entity_type)
						--print("cause entity type = " .. cause_entity_type)
					else
						--print("killer ID was NOT 0!")
					end

					TriggerServerEvent("RPD:newDeathLog", deathLog)

					dead = true
					local playerPos = GetEntityCoords( GetPlayerPed( -1 ), true )
					local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
					local street = {}

					if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
						-- Ignores the switcharoo while doing circles on intersections
						lastStreetA = streetA
						lastStreetB = streetB
					end

					if lastStreetA ~= 0 then
						table.insert( street, GetStreetNameFromHashKey( lastStreetA ) )
					end

					if lastStreetB ~= 0 then
						table.insert( street, GetStreetNameFromHashKey( lastStreetB ) )
					end
					--TriggerServerEvent("RPD:userDead", GetPlayerName(PlayerId()), table.concat( street, " & " ))
					TriggerEvent("RPD:startTimer")
				end

				if (allowRespawn) then
					local coords = spawnPoints[math.random(1,#spawnPoints)]

					respawnPed(ped, coords)

			  		allowRespawn = false
					dead = false
					timer = 0
					respawnCount = respawnCount + 1
					math.randomseed( playerIndex * respawnCount )

					--TriggerServerEvent("gps:removeEMSReqLookup")
				elseif (allowRevive) then
					local playerPos = GetEntityCoords(ped, true)

					NetworkResurrectLocalPlayer(playerPos, true, true, false)
					--SetPlayerInvincible(ped, false)
					ClearPedBloodDamage(ped)

					allowRevive = false
					dead = false
					timer = 0
					Wait(0)

					--TriggerServerEvent("gps:removeEMSReqLookup")
				else
		  			Wait(0)
				end
			else
		  		allowRespawn = false
		  		allowRevive = false
				timer = 180000
				Wait(0)
			end


		else
			if IsEntityDead(ped) then
				Wait(3000)

				local coords = spawnPoints[math.random(1,#spawnPoints)]

				respawnPed(ped,coords)

				respawnCount = respawnCount + 1
				math.randomseed( playerIndex * respawnCount )

			end
		end

	end
end)

function stringSplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

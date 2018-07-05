--=================================================================
--= Drug Script- Onlyserenity / slight modifications by minipunch =
--=================================================================

local selling = false
local secondsRemaining = 0
local rejected = false

local interacted_with_peds = {}

Citizen.CreateThread(function()
	while true do
		if selling then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
		Citizen.Wait(0)
	end
end)

currentped = nil
local has = false
Citizen.CreateThread(function()

	while true do
		Wait(0)
		local player = GetPlayerPed(-1)
  		local playerloc = GetEntityCoords(player, 0)
		local handle, ped = FindFirstPed()
		local success
		repeat
		    success, ped = FindNextPed(handle)
		   	local pos = GetEntityCoords(ped)
	 		local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
	 		if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
		 		if DoesEntityExist(ped)then
		 			if IsPedDeadOrDying(ped) == false then
			 			if IsPedInAnyVehicle(ped) == false then
			 				local pedType = GetPedType(ped)
			 				if pedType ~= 28 and IsPedAPlayer(ped) == false then
				 				currentped = pos
							 	if distance <= 2.0 and ped  ~= GetPlayerPed(-1) then
									if not HasInteractedWithPedRecently(ped) then
										--print("have not interacted with ped: " .. ped)
										if IsControlJustPressed(1, 38) then
											TriggerServerEvent('drug-sell:check') -- check for item to sell
											if has then -- has item to sell
												oldped = ped
												interacted_with_peds[ped] = true
												SetEntityAsMissionEntity(ped)
												ClearPedTasks(ped)
												FreezeEntityPosition(ped,true)
												local random = math.random(1, 12)
												if random == 3 or random == 7 or random == 11 or random == 5 or random == 9 or random == 1  or random == 2 then
													-- notify of rejection
													TriggerEvent("usa:notify", "Person has rejected your offer!")
													selling = false
													SetEntityAsMissionEntity(ped)
													SetPedAsNoLongerNeeded(ped)
													-- send 911 call --
													local randomReport = math.random(1, 3)
														if randomReport == 2 then
															local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
															local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
															local street1 = GetStreetNameFromHashKey(s1)
															local street2 = GetStreetNameFromHashKey(s2)
															local loc = street1
															if street2 ~= "" and street2 ~= " " and street2 then loc = loc .. " & " .. street2 end
															-- dispatch to police:
															Wait(10000) -- wait 10 seconds to make more realistic
															TriggerServerEvent("phone:send911Message", {message = "Civilian report of a person(s) selling narcotics.", location = loc, pos = {x = pos.x, y = pos.y, z = pos.z}}, true, true, "sheriff")
														end
												else
													-- sell
													TaskStandStill(ped, 9.0)
													pos1 = GetEntityCoords(ped)
													TriggerEvent("currentlySelling")
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		until not success

		EndFindPed(handle)
	end
end)

local blah = false
Citizen.CreateThread(function()

	while true do
		Wait(0)
		local player = GetPlayerPed(-1)

		if selling then
				local player = GetPlayerPed(-1)
  				local playerloc = GetEntityCoords(player, 0)
				drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Selling Drug: ~b~" .. secondsRemaining .. "~w~ seconds remaining", 255, 255, 255, 255)
				local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

				if distance > 6 then
					TriggerEvent("usa:notify", "You went out of range!")
				    selling = false

				    SetEntityAsMissionEntity(oldped)
					SetPedAsNoLongerNeeded(oldped)
				end
				if secondsRemaining == 0 then
					blah = true
					local pid = PlayerPedId()

					SetEntityAsMissionEntity(oldped)
					RequestAnimDict("amb@prop_human_bum_bin@idle_b")
					while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
					TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
					Wait(750)
					StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
					SetPedAsNoLongerNeeded(oldped)

				end
		end

		if rejected then
			drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Person ~r~rejected ~w~your offer ~r~", 255, 255, 255, 255)

		end


	end
end)

Citizen.CreateThread(function()

	while true do
		Wait(0)

		if blah then
			-- remove item + give player money:
			TriggerServerEvent('drug-sell:sell')
			blah = false
			selling = false
		end

	end
end)

local call_blips = {}

RegisterNetEvent('drug-sell:createBlip')
AddEventHandler('drug-sell:createBlip', function(coordsx, coordsy, coordsz)
	Citizen.CreateThread(function()
		local blip = AddBlipForCoord(coordsx, coordsy, coordsz)
		table.insert(call_blips, blip)
		SetBlipAsFriendly(blip, true)
		SetBlipSprite(blip, 161)
		BeginTextCommandSetBlipName("STRING");
		AddTextComponentString(tostring("911 Call"))
		EndTextCommandSetBlipName(blip)
		-- remove after x seconds
		local seconds = 20
		while seconds > 0 do
			Wait(1000)
			seconds = seconds - 1
		end
		RemoveBlip(blip)
		print("removed blip!")
	end)
end)

RegisterNetEvent('currentlySelling')
AddEventHandler('currentlySelling', function()
	selling = true
	secondsRemaining = 10

end)

RegisterNetEvent('cancel')
AddEventHandler('cancel', function()
	blah = false

end)

RegisterNetEvent('done')
AddEventHandler('done', function()
	selling = false
	secondsRemaining = 0
	has = false
end)

RegisterNetEvent('notify')
AddEventHandler('notify', function()
	DisplayHelpText("Press ~INPUT_PICKUP~ to start selling ~b~")
	has = true
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawSpecialText(m_text)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('nomore')
AddEventHandler('nomore', function()
	has = false
end)

function HasInteractedWithPedRecently(ped)
	if interacted_with_peds[ped] == true then return true
	else return false end
end

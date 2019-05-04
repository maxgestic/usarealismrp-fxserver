--=================================================================
--= Drug Script- Onlyserenity / slight modifications by minipunch =
--=================================================================

local isSelling = false -- whether the player is currently selling
local secondsRemaining = 0 -- amount of seconds remaining during selling
local hasDrugsToSell = false
local notRejectedChance = 0.0

local interacted_with_peds = {}

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		if IsControlJustPressed(1, 311) and not IsPedInAnyVehicle(playerPed, true) and not IsPedDeadOrDying(playerPed) and not isSelling then
			local playerCoords = GetEntityCoords(playerPed)
			local handle, localPed = FindFirstPed()
			local success
			repeat
				success, localPed = FindNextPed(handle)
				local pedCoords = GetEntityCoords(localPed)
				local distFromPlayerToPed = Vdist(pedCoords, playerCoords)

				if DoesEntityExist(localPed) and not IsPedDeadOrDying(localPed) 
				and not IsPedInAnyVehicle(localPed) and GetPedType(localPed) ~= (28 and 27 and 6 and 29 and 21 and 20) 
				and not IsPedAPlayer(localPed) and not HasInteractedWithPedRecently(localPed) then

					if distFromPlayerToPed <= 1.8 and localPed ~= playerPed then
						--print("have not interacted with ped: " .. ped)
						TriggerServerEvent('sellDrugs:checkPlayerHasDrugs') -- check for item to sell
						if hasDrugsToSell then -- has item to sell
							interacted_with_peds[localPed] = true
							SetEntityAsMissionEntity(localPed)
							local rejectProbability = math.random()
							if rejectProbability < notRejectedChance then
								print(notRejectedChance)
								TriggerEvent("usa:notify", "Person has rejected your offer!")
								isSelling = false
								SetPedAsNoLongerNeeded(localPed)
								local reportProbability = math.random()
								if reportProbability < 0.8 then
									local x, y, z = table.unpack(playerCoords)
									local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
									local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
									-- dispatch to police:
									--Wait(10000) -- (this will be done within a random range of 4 - 10 secs after event is triggered)
									TriggerServerEvent("911:Narcotics", x, y, z, lastStreetNAME, IsPedMale(playerPed))
								end
							else
								SellDrugsToPed(localPed)
							end
						end
						break
					end
				end
			until not success
			EndFindPed(handle)
		end
	end
end)

function SellDrugsToPed(buyerPed)
	isSelling = true
	local beginTime = GetGameTimer()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		while GetGameTimer() - beginTime < 10000 and isSelling do
			Citizen.Wait(0)
			local playerCoords = GetEntityCoords(playerPed)
			local buyerCoords = GetEntityCoords(buyerPed)
			if Vdist(playerCoords, buyerCoords) > 2 then
				isSelling = false
				SetEntityAsNoLongerNeeded(buyerPed)
				TriggerEvent('usa:notify', 'You walked away too far!')
			end
			DrawTimer(beginTime, 10000, 1.42, 1.475, 'SELLING')
		end
		if isSelling then
			isSelling = false
			RequestAnimDict("amb@prop_human_bum_bin@idle_b")
			while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do Citizen.Wait(100) end
			local drugBag = CreateObject(GetHashKey('prop_coke_block_01'), 0.0, 0.0, 0.0, true, false, true)
			AttachEntityToEntity(drugBag, playerPed, GetPedBoneIndex(playerPed, 57005), 0.0, 0.0, -0.1, 0, 90.0, 60.0, true, true, false, true, 1, true)
			TaskPlayAnim(playerPed,"amb@prop_human_bum_bin@idle_b","idle_d", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Wait(4000)
       		StopAnimTask(playerPed, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
       		DeleteEntity(drugBag)
       		hasDrugsToSell = false
       		TriggerServerEvent('sellDrugs:completeSale')
       		SetEntityAsNoLongerNeeded(buyerPed)
       	end
	end)
end

RegisterNetEvent('sellDrugs:showHelpText')
AddEventHandler('sellDrugs:showHelpText', function(_notRejectedChance)
	DisplayHelpText("Press ~INPUT_REPLAY_SHOWHOTKEY~ to sell drugs")
	notRejectedChance = _notRejectedChance
	hasDrugsToSell = true
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function HasInteractedWithPedRecently(ped)
	if interacted_with_peds[ped] == true then return true
	else return false end
end


function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end
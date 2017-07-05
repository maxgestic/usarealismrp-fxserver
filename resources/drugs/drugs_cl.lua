Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

--local growerX,growerY, growerZ = -1005.654, 4848.056, 275.007 -- grower paleto
--local markerX, markerY, markerZ = -1005.817, 4846.102, 274.000 -- grower marker paleto
local growerX, growerY, growerZ = 31.1395, -1928.05, 20.4
local markerX, markerY, markerZ = 30.0478, -1927.07, 20.4

local buyerMarkerX, buyerMarkerY, buyerMarkerZ = 1435.595, 6355.136, 23.150 -- buyer
local cannabisGrowerPed

function getPlayerDistanceFromCoords(x,y,z)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1) --[[Ped]], false)
	return GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,x,y,z,false)
end

-- spawn cannabis distributer npc
RegisterNetEvent("mini:spawnCannabisGrower")
AddEventHandler("mini:spawnCannabisGrower", function()

	local created = false
	local hash = GetHashKey("A_M_M_Polynesian_01")

	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(hash)

		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		-- Model loaded, continue

		if not created then
			-- Spawn the ped
			local ped = CreatePed(4,hash, growerX, growerY, growerZ, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
			created = true
			cannabisGrowerPed = ped
		end

		if cannabisGrowerPed then
			SetEntityCanBeDamaged(cannabisGrowerPed,false)
			SetPedCanRagdollFromPlayerImpact(cannabisGrowerPed,false)
			TaskSetBlockingOfNonTemporaryEvents(cannabisGrowerPed,true)
			SetPedFleeAttributes(cannabisGrowerPed,0,0)
			SetPedCombatAttributes(cannabisGrowerPed,17,1)
			SetEntityInvincible(cannabisGrowerPed)
			-- still need to figure out how to disable collision
		end

	end)

end)

-- spawn cannabis dealer npc
RegisterNetEvent("mini:spawnCannabisDealer")
AddEventHandler("mini:spawnCannabisDealer", function()

	local created = false
	local hash = GetHashKey("A_M_M_Polynesian_01")

	-- thread code stuff below was taken from an example on the wiki
	-- Create a thread so that we don't 'wait' the entire game
	Citizen.CreateThread(function()
		-- Request the model so that it can be spawned
		RequestModel(hash)

		-- Check if it's loaded, if not then wait and re-request it.
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end
		-- Model loaded, continue

		if not created then
			-- Spawn the ped
			local ped = CreatePed(4,hash, 1435.595, 6355.136, 23.985, 175.189 --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
			created = true
		end

		if ped then
			SetEntityCanBeDamaged(ped,false)
			SetPedCanRagdollFromPlayerImpact(ped,false)
			TaskSetBlockingOfNonTemporaryEvents(ped,true)
			SetPedFleeAttributes(ped,0,0)
			SetPedCombatAttributes(ped,17,1)
			SetModelAsNoLongerNeeded(hash)
			SetEntityInvincible(ped)
			-- still need to figure out how to disable collision
		end

	end)

end)

RegisterNetEvent("drugs:growerWalkBack")
AddEventHandler("drugs:growerWalkBack", function()
	if cannabisGrowerPed then
		TaskGoStraightToCoord(cannabisGrowerPed, growerX, growerY, growerZ, 2, -1)
	end
end)

RegisterNetEvent("drugs:checkDistance")
AddEventHandler("drugs:checkDistance", function()

	if getPlayerDistanceFromCoords(growerX,growerY,growerZ) < 3 then

		TriggerEvent("chatMessage", "Grower", { 0, 141, 155 }, "^0Hang on a minute while I get your stuff...")

		if  cannabisGrowerPed then

			TaskGoStraightToCoord(cannabisGrowerPed, 30.7372, -1923.6, 21.9519, 2, -1)
			SetBlockingOfNonTemporaryEvents(cannabisGrowerPed, false)

		end

    end

    TriggerServerEvent("drugs:inRange") -- sets busy = no

end)

RegisterNetEvent("drugs:isPlayerStillWithinRange")
AddEventHandler("drugs:isPlayerStillWithinRange", function()

	if getPlayerDistanceFromCoords(growerX,growerY,growerZ) < 8 then
        TriggerEvent("chatMessage", "GROWER", {0, 141, 155 }, "^0Here you go, homie! ^320 grams ^0of concentrated cannabis. Don't get pulled over.")
        TriggerEvent("chatMessage", "GROWER", {0, 141, 155 }, "^0Take it to the guys near Great Ocean Hwy and they will hook you up with some cash!")
        TriggerServerEvent("drugs:giveCannabis")
    else
		TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^0You went out of range and ^1did not ^0get the product!")
        TriggerServerEvent("drugs:outOfRange")
    end

end)

RegisterNetEvent("drugs:notifyFailureNpcBusy")
AddEventHandler("drugs:notifyFailureNpcBusy", function()

	TriggerEvent("chatMessage", "Grower", { 0, 141, 155 }, "^0Hang on a sec'. I am busy!")

end)

RegisterNetEvent("drugs:invalidSell")
AddEventHandler("drugs:invalidSell", function()

	TriggerEvent("chatMessage", "SYSTEM", { 0, 141, 155 }, "^0Come back when you have something to sell...")

end)

RegisterNetEvent("drugs:sellDrug")
AddEventHandler("drugs:sellDrug", function(playerDrug)
		TriggerServerEvent("drugs:giveMoney", 8000)
end)

RegisterNetEvent("drugs:thanksMessage")
AddEventHandler("drugs:thanksMessage", function()

	TriggerEvent("chatMessage", "Dealer", { 0, 141, 155 }, "^0Thanks, dude! Here is ^2$8,00^0. See you next time, bro!")

end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		DrawMarker(1, markerX, markerY, markerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0) -- grower marker
		DrawMarker(1, buyerMarkerX, buyerMarkerY, buyerMarkerZ, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0) -- dealer marker
	end

end)

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		if getPlayerDistanceFromCoords(growerX,growerY,growerZ) < 4 then
			DrawSpecialText("Press [ ~g~E~w~ ] to pick up cannabis!")
            if IsControlJustPressed(1,Keys["E"]) then
                TriggerServerEvent("drugs:checkBusy") -- see if NPC is already busy getting drugs
				Citizen.Wait(5000) -- prevent sql pam
            end
		end

		if getPlayerDistanceFromCoords(buyerMarkerX, buyerMarkerY, buyerMarkerZ) < 4  then
			DrawSpecialText("Press [ ~g~E~w~ ] to sell your cannabis!")
			if IsControlJustPressed(1,Keys["E"]) then
				TriggerServerEvent("drugs:sellDrugs") -- see if NPC is already busy getting drugs
				Citizen.Wait(5000) -- prevent sql spam
			end
        end
	end

end)

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

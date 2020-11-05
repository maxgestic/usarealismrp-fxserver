local bankCoords = {
	{ coords = { x = 252.95, y = 228.60, z = 102.00 }, name = "Pacific Standard", camID = "bank1", timeToTapSeconds = 5 }, -- pacific standard
}

local clerkCoords = {x = 253.57, y = 221.05, z = 106.28}

local currentlyHacking = nil
local mainHacking = nil
local VaultDoor = nil

local startedFinalHack = false

local KEY_K = 311
local drilling_spots = {}
local openVault = false

local mainHackLocation = {x = 265.06, y = 213.79, z = 101.68}

local shouldBePlayingAnim = false
local clearedAnim = false
local dictLoaded = false
local DRILLING = {
	ANIM = {
		DICT = "anim@heists@fleeca_bank@drilling",
		NAME = "drill_straight_idle"
	},
	OBJECT = {
		NAME = "hei_prop_heist_drill",
		handle = nil
	}
}

local shouldBeShowingHelpText = false

RegisterNetEvent('bank:loadDrillingSpots')
AddEventHandler('bank:loadDrillingSpots', function(spots)
	drilling_spots = spots
end)

TriggerServerEvent('bank:loadDrillingSpots')


local hacked = false
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		for i = 1, #bankCoords do
			local dist = Vdist(playerCoords, bankCoords[i].coords.x, bankCoords[i].coords.y, bankCoords[i].coords.z)
			if dist < 50.0 then
				if not VaultDoor or not DoesEntityExist(VaultDoor) then
					VaultDoor = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 100.0, 961976194, 0, 0, 0)
					if DoesEntityExist(VaultDoor) then
						FreezeEntityPosition(VaultDoor, true)
					end
				end
				if dist < 5.0 then
					DrawText3D(bankCoords[i].coords.x, bankCoords[i].coords.y, bankCoords[i].coords.z, '[HOLD K] - Rob Bank')
					if IsControlJustPressed(0, 311) then
						Citizen.CreateThread(function()
							Wait(500)
							if IsControlPressed(0, 311) then
								TriggerServerEvent('bank:beginRobbery', bankCoords[i])
							end
						end)
					end
				end
			end
		end

		local clerkDist = Vdist(playerCoords, clerkCoords.x, clerkCoords.y, clerkCoords.z)
		if clerkDist < 5.0 then
			DrawText3D(clerkCoords.x, clerkCoords.y, clerkCoords.z, '[E] - Bank Clerk')
			if IsControlJustPressed(0, 38) and clerkDist < 2.0 then
				TriggerServerEvent('bank:clerkTip')
			end
		end

		for i = 1, #drilling_spots do
			local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, drilling_spots[i].x, drilling_spots[i].y, drilling_spots[i].z)
			if dist < 1 then
				exports.globals:DrawText3D(drilling_spots[i].x, drilling_spots[i].y, drilling_spots[i].z, '[K] - Drill Deposit Box')
				if IsControlJustPressed(0, KEY_K) then
					TriggerServerEvent('bank:doesUserHaveDrill', i)
				end
			end
		end

		local dist2 = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, mainHackLocation.x, mainHackLocation.y, mainHackLocation.z)
		if dist2 < 3 then
			exports.globals:DrawText3D(mainHackLocation.x, mainHackLocation.y, mainHackLocation.z, '[E] - Hack Main System')
			if IsControlJustPressed(0, 86) and not hacked and not startedFinalHack then
				startedFinalHack = true
				TriggerEvent("utk_fingerprint:Start", 4, 1, 1, function(outcome)
					if outcome == true then
						TriggerServerEvent('bank:hackComplete')
					elseif outcome == false then
						exports.globals:notify("You failed to access the mainframe!")
					end
					hacked = true
					startedFinalHack = false
				end)
			end
		end
		Wait(0)
	end
end)

---------------
-- mini game --
---------------
RegisterNetEvent("bank:startHacking")
AddEventHandler("bank:startHacking", function(bank)
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(playerPed))
	local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
	local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
	TriggerServerEvent("911:BankRobbery", x, y, z, lastStreetNAME, IsPedMale(playerPed), bank.name, bank.camID)
	TriggerEvent("usa:playScenario", "WORLD_HUMAN_STAND_MOBILE")
	local beginTime = GetGameTimer()
	while GetGameTimer() - beginTime < bank.timeToTapSeconds * 1000 do
		Citizen.Wait(0)
		x, y, z = table.unpack(GetEntityCoords(playerPed))
		DrawTimer(beginTime, bank.timeToTapSeconds * 1000, 1.42, 1.475, 'TAPPING')
		if Vdist(x, y, z, bank.coords.x, bank.coords.y, bank.coords.z) > 5.0 then
			TriggerEvent('usa:notify', 'You went too far away, signal lost!')
			return
		end
	end
	TriggerEvent("mhacking:seqstart", {3, 2, 1}, 60, mycb)
	currentlyHacking = bank
end)

local failed  = false
function mycb(success, timeremaining, finish)
	local playerPed = PlayerPedId()
	if success and timeremaining >= 0.5 then
		print('Success with '..timeremaining..'s remaining.')
		if finish then
			if not failed then
				if Vdist(GetEntityCoords(playerPed), currentlyHacking.coords.x, currentlyHacking.coords.y, currentlyHacking.coords.z) < 3.0 then
					TriggerServerEvent('bank:vaultDoorHacked', currentlyHacking.name)
					TriggerEvent("usa:notify", "You successfully hacked the vault door!")
				else
					TriggerEvent('usa:notify', 'You went out of range!')
				end
			else
				TriggerEvent("usa:notify", "You failed to hacked the vault door!")
			end
			currentlyHacking = nil
		end
	else
		failed = true
		TriggerEvent("usa:notify", "You failed to hacked the vault door!")
	end
	if finish or failed then
		ClearPedTasks(playerPed)
	end
end

-- vault stuff --
RegisterNetEvent('bank:openVaultDoor')
AddEventHandler('bank:openVaultDoor', function()
	openVault =  true
end)

RegisterNetEvent('bank:resetVault')
AddEventHandler('bank:resetVault', function()
	local playerCoords = GetEntityCoords(PlayerPedId())
	VaultDoor = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 100.0, 961976194, 0, 0, 0)
	if DoesEntityExist(VaultDoor) then
		SetEntityHeading(VaultDoor, 160.0)
		FreezeEntityPosition(VaultDoor, true)
	end
	openVault =  false
end)

Citizen.CreateThread(function()
	while true do
		if openVault then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			for i = 1, #bankCoords do
				local dist = Vdist(playerCoords, bankCoords[i].coords.x, bankCoords[i].coords.y, bankCoords[i].coords.z)
				if dist < 30.0 then
					if DoesEntityExist(VaultDoor) then
						local CurrentHeading = GetEntityHeading(VaultDoor)
						if round(CurrentHeading, 1) == 158.7 then
							CurrentHeading = CurrentHeading - 0.1
						end

						while round(CurrentHeading, 1) ~= 0.0 do -- slowly open door
							Wait(0)
							SetEntityHeading(VaultDoor, round(CurrentHeading, 1) - 0.4)
							CurrentHeading = GetEntityHeading(VaultDoor)
						end

						FreezeEntityPosition(VaultDoor, true)
					else
						VaultDoor = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 100.0, 961976194, 0, 0, 0)
					end
				end
			end
		end
		Wait(0)
	end
end)

-- functions --
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
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

function DisplayHelpText(Text)
	SetTextComponentFormat('STRING')
    AddTextComponentString(Text)
    DisplayHelpTextFromStringLabel(0, 0, true, -1)
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function GetIsControlPressed(Control)
	if IsControlPressed(1, Control) or IsDisabledControlPressed(1, Control) then
		return true
	end
	return false
end

RegisterNetEvent('bank:startDrilling')
AddEventHandler('bank:startDrilling', function(boxIndex)
	local box = drilling_spots[boxIndex]
	TaskTurnPedToFaceCoord(PlayerPedId(), box.x, box.y, box.z, 2000)
	Wait(2000)
	shouldBePlayingAnim = true
	TriggerEvent("Drilling:Start", function(success)
		if success then
			TriggerServerEvent('bank:drilledGoods')
		else
			exports.globals:notify("The drill bit is too hot!")
		end
		shouldBePlayingAnim = false
	end)
	shouldBeShowingHelpText = true
	TriggerEvent('InteractSound_CL:PlayWithinDistance', PlayerId(), 10.0, "drill", 0.5)
end)

Citizen.CreateThread(function()
	while true do
		if shouldBePlayingAnim then
			if not dictLoaded then
				exports.globals:loadAnimDict(DRILLING.ANIM.DICT)
				dictLoaded = true
			end
			local myped = PlayerPedId()
			if not IsEntityPlayingAnim(myped, DRILLING.ANIM.DICT, DRILLING.ANIM.NAME, 3) then
				TaskPlayAnim(myped, DRILLING.ANIM.DICT, DRILLING.ANIM.NAME, 2.0, 2.0, -1, 51, 0, false, false, false)
				clearedAnim = false
			end
			if not DRILLING.OBJECT.handle then
				giveDrillObject(myped)
			end
		else
			if not clearedAnim then
				local myped = PlayerPedId()
				ClearPedTasksImmediately(myped)
				clearedAnim = true
			end
			if DRILLING.OBJECT.handle then
				DeleteObject(DRILLING.OBJECT.handle)
				DRILLING.OBJECT.handle = nil
			end
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if shouldBeShowingHelpText and shouldBePlayingAnim then
			DisplayHelpText('Tap ~INPUT_CELLPHONE_LEFT~ to Slow Down the Drill, ~INPUT_CELLPHONE_RIGHT~ to speed up the drill')
			Wait(8000)
			if not shouldBePlayingAnim then return end
			DisplayHelpText('Tap ~INPUT_CELLPHONE_UP~ to drill the locks, ~INPUT_CELLPHONE_DOWN~ to pull the drill out')
			Wait(8000)
			if not shouldBePlayingAnim then return end
			DisplayHelpText('Cool down the drill by pulling the drill out for a few seconds.')
			Wait(8000)
			if not shouldBePlayingAnim then return end
			shouldBeShowingHelpText = false
		end
		Wait(1)
	end
end)

function giveDrillObject(ped)
	local rightHandBoneId = 57005
	local pedCoords = GetEntityCoords(ped, false)
	local drillObjectHash = GetHashKey(DRILLING.OBJECT.NAME)
	RequestModel(drillObjectHash)
	while not HasModelLoaded(drillObjectHash) do
		Wait(100)
	end
	DRILLING.OBJECT.handle = CreateObject(drillObjectHash, pedCoords.x, pedCoords.y, pedCoords.z+0.2,  true,  true, true)
	SetEntityAsMissionEntity(DRILLING.OBJECT.handle, true, true)
	AttachEntityToEntity(DRILLING.OBJECT.handle, ped, GetPedBoneIndex(ped, rightHandBoneId), 0.15, 0.0, -0.05, 100.0, -90.0, 150.0, true, true, false, true, 1, true)
end
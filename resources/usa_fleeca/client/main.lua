local KEY_K = 311
local NPC = 's_m_y_construct_01'
local drill_location = {73.01, -341.71, 55.51}
local alertPolice = true

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

local drilling_spots = {}
TriggerServerEvent('fleeca:loadDrillingSpots')

RegisterNetEvent('fleeca:loadDrillingSpots')
AddEventHandler('fleeca:loadDrillingSpots', function(spots)
    drilling_spots = spots
end)

local NPCHandle = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z = table.unpack(drill_location)
        if Vdist(playerCoords, x, y, z) < 90 then
            if not NPCHandle then
                RequestModel(GetHashKey(NPC))
                while not HasModelLoaded(NPC) do
                    RequestModel(NPC)
                    Wait(1)
                end
                NPCHandle = CreatePed(0, NPC, x, y, z, 0.1, false, false) -- need to add distance culling
                SetPedDesiredHeading(NPCHandle, 191.58)
                SetEntityCanBeDamaged(NPCHandle,false)
                SetPedCanRagdollFromPlayerImpact(NPCHandle,false)
                SetBlockingOfNonTemporaryEvents(NPCHandle,true)
                SetPedFleeAttributes(NPCHandle,0,0)
                SetPedCombatAttributes(NPCHandle,17,1)

                exports.globals:loadAnimDict("missheist_jewel@first_person")
                if not IsEntityPlayingAnim(NPCHandle, "missheist_jewel@first_person", "smash_case_e", 3) then
                    TaskPlayAnim(NPCHandle, "missheist_jewel@first_person", "smash_case_e", 8.0, 1.0, -1, 11, 1.0, false, false, false)
                end
            end

            if Vdist(playerCoords, x, y, z) <= 3 then
                exports.globals:DrawText3D(x, y, z, '[E] - Drill [$1,500]')
                if IsControlJustPressed(0, 86) then
                    TriggerServerEvent('fleeca:purchaseDrill')
                end
            end
        else
            if NPCHandle then
                DeletePed(NPCHandle)
                NPCHandle = nil
            end
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        for i = 1, #drilling_spots do
            local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, drilling_spots[i].x, drilling_spots[i].y, drilling_spots[i].z)
            if dist < 1 then
                exports.globals:DrawText3D(drilling_spots[i].x, drilling_spots[i].y, drilling_spots[i].z, '[K] - Drill Deposit Box')
                if IsControlJustPressed(0, KEY_K) then
                    TriggerServerEvent('fleeca:doesUserHaveDrill', i)
                end
            end
        end
    end
end)

RegisterNetEvent('fleeca:startDrilling')
AddEventHandler('fleeca:startDrilling', function()
    local myped = PlayerPedId()
    local playerCoords = GetEntityCoords(myped)
    local x, y, z = table.unpack(playerCoords)
    local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
    local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
    local isMale = true
    if myped == GetHashKey("mp_f_freemode_01") then
      isMale = false
    elseif myped == GetHashKey("mp_m_freemode_01") then 
      isMale = true
    else
      isMale = IsPedMale(myped)
    end
    if alertPolice == true then
        TriggerServerEvent('911:FleecaRobbery', x, y, z, lastStreetNAME, isMale)
        alertPolice = false
    end

    TriggerEvent('chatMessage', "", {}, "^0Use ^3Left Arrow ^0key to slow drill down, ^3Right Arrow ^0key to speed drill up.")
    TriggerEvent('chatMessage', "", {}, "^0Use ^3Up Arrow ^0key to drill deposit box, ^3Down Arrow ^0key to cool drill down")
    TriggerEvent('chatMessage', "", {}, "^0Dont drill too fast!")

    shouldBePlayingAnim = true
    TriggerEvent("Drilling:Start", function(success)
        if success then
            while securityToken == nil do
                Wait(1)
            end
            TriggerServerEvent('fleeca:drilledGoods', securityToken)
        else
            exports.globals:notify("The drill bit is too hot!")
        end
        shouldBePlayingAnim = false
    end)
    
    Wait(1000)

    TriggerEvent('InteractSound_CL:PlayWithinDistance', PlayerId(), 10.0, "drill", 0.5)
end)

function nearMarker(x, y, z)
    local mycoords = GetEntityCoords(GetPlayerPed(-1))
    return GetDistanceBetweenCoords(x, y, z, mycoords.x, mycoords.y, mycoords.z, true) < JOB_START_TEXT_DIST
end

RegisterNetEvent('fleeca:reset911')
AddEventHandler('fleeca:reset911', function()
    alertPolice = true
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
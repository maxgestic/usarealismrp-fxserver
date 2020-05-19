local ALUMINUM_LOC = {x = 1111.49, y = -2006.51, z = 30.91}
local ALUMINUM_NPC = 's_m_y_construct_02'
local PROCESS_CHEM_DURATION = 60000

local COMBINE_SUBSTANCES = {x = 141.09, y = -2204.24, z = 4.69}

local NPCHandle = nil
Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        if Vdist(playerCoords, ALUMINUM_LOC.x, ALUMINUM_LOC.y, ALUMINUM_LOC.z) < 40 then
            if not NPCHandle then
                RequestModel(GetHashKey(ALUMINUM_NPC))
                while not HasModelLoaded(ALUMINUM_NPC) do
                    RequestModel(ALUMINUM_NPC)
                    Wait(1)
                end
                NPCHandle = CreatePed(0, ALUMINUM_NPC, ALUMINUM_LOC.x, ALUMINUM_LOC.y, ALUMINUM_LOC.z, 0.1, false, false) -- need to add distance culling
                SetEntityCanBeDamaged(NPCHandle,false)
                SetEntityHeading(NPCHandle, 95.15)
                SetPedCanRagdollFromPlayerImpact(NPCHandle,false)
                SetBlockingOfNonTemporaryEvents(NPCHandle,true)
                SetPedFleeAttributes(NPCHandle,0,0)
                SetPedCombatAttributes(NPCHandle,17,1)
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
        if nearMarker(ALUMINUM_LOC.x, ALUMINUM_LOC.y, ALUMINUM_LOC.z) then
            exports.globals:DrawText3D(ALUMINUM_LOC.x, ALUMINUM_LOC.y, ALUMINUM_LOC.z, '[E] - Aluminum Powder [$1,500]')
            if IsControlJustPressed(0, 86) then
                TriggerServerEvent('chems:buyAluminum')
            end
        end

        if nearMarker(COMBINE_SUBSTANCES.x, COMBINE_SUBSTANCES.y, COMBINE_SUBSTANCES.z) then
            exports.globals:DrawText3D(COMBINE_SUBSTANCES.x, COMBINE_SUBSTANCES.y, COMBINE_SUBSTANCES.z, '[E] - Combine Chemicals')
            if IsControlJustPressed(0, 86) then
                TriggerServerEvent('chems:checkForAllChems')
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent("chems:performChemicalMixing")
AddEventHandler("chems:performChemicalMixing", function()
    local myped = PlayerPedId()
    local start = GetGameTimer()
    local mycoords = GetEntityCoords(myped, false)
    exports.globals:loadAnimDict("anim@move_m@trash")
    while GetGameTimer() - start < PROCESS_CHEM_DURATION do
        exports.globals:DrawTimerBar(start, PROCESS_CHEM_DURATION, 1.42, 1.475, 'Creating Thermite')
        if not IsEntityPlayingAnim(myped, "anim@move_m@trash", "pickup", 3) then
            TaskPlayAnim(myped, "anim@move_m@trash", "pickup", 8.0, 1.0, -1, 11, 1.0, false, false, false)
        end
        Wait(1)
    end
    if math.random() <= 0.4 then
        StartEntityFire(PlayerPedId())
        local x, y, z = table.unpack(mycoords)
        local lastStreetHASH = GetStreetNameAtCoord(x, y, z)
        local lastStreetNAME = GetStreetNameFromHashKey(lastStreetHASH)
        TriggerServerEvent("911:UncontrolledFire", x, y, z, lastStreetNAME)
    else
        TriggerServerEvent('chems:successCheck')
    end
    ClearPedTasksImmediately(myped)
end)


function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    return Vdist(x, y, z, p.x, p.y, p.z) < 3
end